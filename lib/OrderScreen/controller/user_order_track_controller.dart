import 'dart:async';
import 'dart:convert';
import 'dart:math' as math;
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;

class UserOrderTrackController extends ChangeNotifier {
  final String orderId;
  final String storeSvgAssetPath;
  final String riderImageAssetPath;

  UserOrderTrackController({
    required this.orderId,
    required this.storeSvgAssetPath,
    required this.riderImageAssetPath,
  });

  VoidCallback? onRouteUpdated;

  bool _isInitialized = false;
  bool _isMapReady = false;
  bool _trackingStarted = false;
  bool _hasInitialCameraFitted = false;

  static const LatLng _storeLocation = LatLng(22.287594365815963, 70.7577717592851);
  LatLng _userLocation = const LatLng(22.3039, 70.8022);
  LatLng? _riderLocation;
  double _riderRotation = 0.0;

  final String storeName = "hari krishna dal pakwan";
  final String storeFullAddress = "5, University Rd, Triveni Society, Janak Puri, Yogi Nagar, Rajkot, Gujarat 360005";
  final String userAddressName = "Home";
  final String userFullAddress = "Flat 402, Imperial Heights, Yagnik Road, Rajkot";

  final String _googleApiKey = "YOUR_GOOGLE_MAPS_API_KEY";

  Set<Marker> _markers = {};
  Set<Polyline> _polylines = {};
  List<LatLng> _polylineCoordinates = [];

  Set<Marker> get markers => _markers;
  Set<Polyline> get polylines => _polylines;
  List<LatLng> get polylineCoordinates => _polylineCoordinates;
  LatLng get userLocation => _userLocation;

  BitmapDescriptor? _cachedShopIcon;
  BitmapDescriptor? _cachedRiderIcon;
  Marker? _cachedStoreMarker;

  StreamSubscription? _riderLocationSubscription;
  StreamSubscription<Position>? _userLocationSubscription;
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  bool _hasNotifiedUser = false;
  bool _isFetchingPolyline = false;
  LatLng? _lastPolylineFetchRiderLocation;

  AnimationController? _animationController;
  DateTime _lastMarkerNotify = DateTime.fromMillisecondsSinceEpoch(0);
  static const Duration _markerUpdateInterval = Duration(milliseconds: 100);
  DateTime _lastUserUiUpdate = DateTime.fromMillisecondsSinceEpoch(0);
  DateTime _lastUserFirebaseWrite = DateTime.fromMillisecondsSinceEpoch(0);
  static const Duration _userUiUpdateInterval = Duration(milliseconds: 500);
  static const Duration _userFirebaseWriteInterval = Duration(seconds: 5);
  int _animationGeneration = 0;
  LatLng? _previousRiderLocation;
  LatLng? _targetRiderLocation;

  DatabaseReference? _dbRef;
  DatabaseReference get _database {
    if (_dbRef != null) return _dbRef!;
    final app = Firebase.app();
    _dbRef = FirebaseDatabase.instanceFor(
      app: app,
      databaseURL: 'https://gotilo-5a831-default-rtdb.asia-southeast1.firebasedatabase.app',
    ).ref();
    return _dbRef!;
  }

  bool _isDisposed = false;

  void init(TickerProvider vsync) {
    if (_isInitialized || _isDisposed) return;
    _isInitialized = true;

    _animationController = AnimationController(
      vsync: vsync,
      duration: const Duration(milliseconds: 1200),
    );

    _buildStaticStoreMarker();
    _rebuildMarkers();

    unawaited(_initLocalNotifications());
    unawaited(_preloadIconsAndSetup());
  }

  void onMapReady() {
    if (_isDisposed || _isMapReady) return;
    _isMapReady = true;

    Future<void>.delayed(const Duration(milliseconds: 250), () {
      if (_isDisposed || !_isMapReady || _trackingStarted) return;
      _trackingStarted = true;

      _rebuildMarkers();
      notifyListeners();

      unawaited(_saveStoreLocationToFirebase());
      _listenToRiderLiveLocation();
      unawaited(_startUserLocationTracking());
    });
  }

  @override
  void dispose() {
    _isDisposed = true;
    _animationController?.removeListener(_onRiderAnimationTick);
    _animationController?.dispose();
    _riderLocationSubscription?.cancel();
    _userLocationSubscription?.cancel();
    super.dispose();
  }

  @override
  void notifyListeners() {
    if (!_isDisposed) {
      super.notifyListeners();
    }
  }

  Future<bool> createOrderInFirebase() async {
    try {
      final path = 'orders_new/$orderId';
      final orderData = {
        'orderId': 'ORD-102',
        'current_location': {
          'latitude': _userLocation.latitude,
          'longitude': _userLocation.longitude,
        },
        'restaurant_location': {
          'latitude': _storeLocation.latitude,
          'longitude': _storeLocation.longitude,
        },
        'order_status': 0,
        'timestamp': ServerValue.timestamp,
      };
      await _database.child(path).set(orderData);
      return true;
    } catch (e) {
      debugPrint('❌ Create Order Firebase Error: $e');
      return false;
    }
  }

  Future<void> _preloadIconsAndSetup() async {
    _cachedShopIcon = await _createSvgShopMarker(
      assetPath: storeSvgAssetPath,
      targetSize: 1.3,
    );
    _cachedRiderIcon = await _getRiderBikeIcon();
    _buildStaticStoreMarker();
    _rebuildMarkers();

    if (_isMapReady && !_isDisposed) {
      notifyListeners();
    }
  }

  void _buildStaticStoreMarker() {
    final shopIcon = _cachedShopIcon ?? BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueOrange);
    _cachedStoreMarker = Marker(
      markerId: const MarkerId('store'),
      position: _storeLocation,
      infoWindow: InfoWindow(
        title: '🏪 $storeName',
        snippet: storeFullAddress,
      ),
      icon: shopIcon,
    );
  }

  Future<void> _initLocalNotifications() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings('@mipmap/ic_launcher');

    const DarwinInitializationSettings initializationSettingsIOS =
    DarwinInitializationSettings();

    const InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );

    await _flutterLocalNotificationsPlugin.initialize(
      settings: initializationSettings,
    );

    _flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission();
  }

  Future<void> _showArrivalNotification() async {
    const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      'rider_arrival_channel',
      'Rider Arrival Alerts',
      channelDescription: 'Notifications when rider is nearby',
      importance: Importance.max,
      priority: Priority.high,
      playSound: true,
    );

    const NotificationDetails platformDetails = NotificationDetails(
      android: androidDetails,
      iOS: DarwinNotificationDetails(),
    );

    await _flutterLocalNotificationsPlugin.show(
      id: 0,
      title: '🛵 Rider is nearby!',
      body: 'તમારો delivery partner 100m ની અંદર પહોંચી ગયો છે.',
      notificationDetails: platformDetails,
    );
  }

  Future<void> _saveStoreLocationToFirebase() async {
    try {
      final path = 'restaurants/$orderId/location';
      final storeData = {
        'name': storeName,
        'address': storeFullAddress,
        'latitude': _storeLocation.latitude,
        'longitude': _storeLocation.longitude,
        'timestamp': ServerValue.timestamp,
      };
      await _database.child(path).set(storeData);
    } catch (e) {
      debugPrint('❌ Firebase Store Location Write FAILED: $e');
    }
  }

  Future<void> _startUserLocationTracking() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) return;

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) return;
    }

    if (permission == LocationPermission.deniedForever) return;

    const LocationSettings locationSettings = LocationSettings(
      accuracy: LocationAccuracy.medium,
      distanceFilter: 25,
    );

    try {
      final Position currentPosition = await Geolocator.getCurrentPosition(
        locationSettings: locationSettings,
      );

      if (_isDisposed) return;

      _userLocation = LatLng(currentPosition.latitude, currentPosition.longitude);
      _rebuildMarkers();
      unawaited(_saveUserLocationToFirebase(currentPosition));
      unawaited(_getPolylineWithDirections());
      notifyListeners();
    } catch (e) {
      debugPrint("Get current location error: $e");
    }

    _userLocationSubscription = Geolocator.getPositionStream(
      locationSettings: locationSettings,
    ).listen(
          (Position position) async {
        if (_isDisposed) return;

        final now = DateTime.now();
        if (now.difference(_lastUserFirebaseWrite) >= _userFirebaseWriteInterval) {
          _lastUserFirebaseWrite = now;
          unawaited(_saveUserLocationToFirebase(position));
        }

        if (now.difference(_lastUserUiUpdate) >= _userUiUpdateInterval) {
          _lastUserUiUpdate = now;
          _userLocation = LatLng(position.latitude, position.longitude);
          _rebuildMarkers();
          _checkProximityToUser();
          notifyListeners();
        }
      },
    );
  }

  Future<void> _saveUserLocationToFirebase(Position position) async {
    try {
      final path = 'users/$orderId/userLocation';
      final locationData = {
        'latitude': position.latitude,
        'longitude': position.longitude,
        'timestamp': ServerValue.timestamp,
      };
      await _database.child(path).set(locationData);
    } catch (e) {
      debugPrint('❌ Firebase User Location Write FAILED: $e');
    }
  }

  Future<BitmapDescriptor> _getRiderBikeIcon() async {
    if (_cachedRiderIcon != null) return _cachedRiderIcon!;

    try {
      _cachedRiderIcon = await BitmapDescriptor.asset(
        const ImageConfiguration(size: Size(40, 40)),
        riderImageAssetPath,
      );
      return _cachedRiderIcon!;
    } catch (e) {
      debugPrint("Bike Image Loading Error: $e");
      return BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen);
    }
  }

  double _calculateBearing(LatLng start, LatLng end) {
    double startLat = start.latitude * (math.pi / 180);
    double startLng = start.longitude * (math.pi / 180);
    double endLat = end.latitude * (math.pi / 180);
    double endLng = end.longitude * (math.pi / 180);

    double dLng = endLng - startLng;

    double y = math.sin(dLng) * math.cos(endLat);
    double x = math.cos(startLat) * math.sin(endLat) -
        math.sin(startLat) * math.cos(endLat) * math.cos(dLng);

    double bearing = math.atan2(y, x);
    return (bearing * (180 / math.pi) + 360) % 360;
  }

  void _listenToRiderLiveLocation() {
    _riderLocationSubscription = _database
        .child('orders/$orderId/location')
        .onValue
        .listen((event) {
      if (_isDisposed) return;
      final data = event.snapshot.value as Map<dynamic, dynamic>?;
      if (data != null) {
        double lat = (data['latitude'] as num).toDouble();
        double lng = (data['longitude'] as num).toDouble();

        LatLng newLocation = LatLng(lat, lng);

        if (_riderLocation == null) {
          _riderLocation = newLocation;
          _rebuildMarkers();
          unawaited(_getPolylineWithDirections());
          notifyListeners();
        } else {
          _animateRiderMovement(_riderLocation!, newLocation);
        }
      }
    });
  }

  void _animateRiderMovement(LatLng from, LatLng to) {
    if (_animationController == null || _isDisposed) return;
    _previousRiderLocation = from;
    _targetRiderLocation = to;
    _riderRotation = _calculateBearing(from, to);
    _animationController!.stop();
    _animationController!.reset();
    final generation = ++_animationGeneration;
    _animationController!.removeListener(_onRiderAnimationTick);
    _animationController!.addListener(_onRiderAnimationTick);
    _animationController!.forward().whenCompleteOrCancel(() {
      if (_isDisposed || generation != _animationGeneration) return;
      _animationController?.removeListener(_onRiderAnimationTick);
      _riderLocation = _targetRiderLocation;
      _rebuildMarkers();
      notifyListeners();
      if (_lastPolylineFetchRiderLocation == null ||
          Geolocator.distanceBetween(
            _lastPolylineFetchRiderLocation!.latitude,
            _lastPolylineFetchRiderLocation!.longitude,
            to.latitude,
            to.longitude,
          ) > 150) {
        unawaited(_getPolylineWithDirections());
      }
      _checkProximityToUser();
    });
  }

  void _onRiderAnimationTick() {
    if (_isDisposed || _animationController == null ||
        _previousRiderLocation == null || _targetRiderLocation == null) return;
    final t = _animationController!.value;
    _riderLocation = LatLng(
      _previousRiderLocation!.latitude +
          (_targetRiderLocation!.latitude - _previousRiderLocation!.latitude) * t,
      _previousRiderLocation!.longitude +
          (_targetRiderLocation!.longitude - _previousRiderLocation!.longitude) * t,
    );
    final now = DateTime.now();
    if (now.difference(_lastMarkerNotify) >= _markerUpdateInterval) {
      _lastMarkerNotify = now;
      _rebuildMarkers();
      notifyListeners();
    }
  }

  void _checkProximityToUser() {
    if (_riderLocation == null) return;

    double distanceInMeters = Geolocator.distanceBetween(
      _riderLocation!.latitude,
      _riderLocation!.longitude,
      _userLocation.latitude,
      _userLocation.longitude,
    );

    if (distanceInMeters <= 100 && !_hasNotifiedUser) {
      _hasNotifiedUser = true;
      _showArrivalNotification();
    }
  }

  Future<BitmapDescriptor> _createSvgShopMarker({
    String? assetPath,
    double targetSize = 4.0,
  }) async {
    const String crispStoreSvg = '''
<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 48 48" width="48" height="48">
  <circle cx="24" cy="24" r="22" fill="#FF6D00" stroke="#FFFFFF" stroke-width="4"/>
  <path fill="#FFFFFF" d="M12 16h24l2 5H10l2-5zm1 7h22v13H13V23zm5 3h5v7h-5v-7z"/>
  <path fill="#FFE082" d="M10 21h28v2H10z"/>
</svg>
''';

    try {
      final double screenDpr = ui.PlatformDispatcher.instance.views.first.devicePixelRatio;
      final int imageWidth = (targetSize * screenDpr * 10).toInt();
      final int imageHeight = (targetSize * screenDpr * 10).toInt();

      SvgLoader loader = const SvgStringLoader(crispStoreSvg);

      if (assetPath != null && assetPath.isNotEmpty) {
        try {
          loader = SvgAssetLoader(assetPath);
        } catch (_) {
          loader = const SvgStringLoader(crispStoreSvg);
        }
      }

      PictureInfo pictureInfo = await vg.loadPicture(loader, null);

      final ui.Picture picture = pictureInfo.picture;
      final ui.PictureRecorder pictureRecorder = ui.PictureRecorder();
      final Canvas canvas = Canvas(pictureRecorder);

      final double scaleX = imageWidth / pictureInfo.size.width;
      final double scaleY = imageHeight / pictureInfo.size.height;
      canvas.scale(scaleX, scaleY);
      canvas.drawPicture(picture);

      final ui.Image img = await pictureRecorder.endRecording().toImage(imageWidth, imageHeight);
      final ByteData? byteData = await img.toByteData(format: ui.ImageByteFormat.png);

      if (byteData != null) {
        return BitmapDescriptor.bytes(byteData.buffer.asUint8List());
      }
    } catch (e) {
      debugPrint("SVG Store Marker Loading Error: $e");
    }

    return BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueOrange);
  }

  void _rebuildMarkers() {
    BitmapDescriptor riderIcon = _cachedRiderIcon ?? BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen);

    final Set<Marker> updated = {};

    if (_cachedStoreMarker != null) {
      updated.add(_cachedStoreMarker!);
    }

    updated.add(
      Marker(
        markerId: const MarkerId('user_destination'),
        position: _userLocation,
        infoWindow: InfoWindow(
          title: '🏠 $userAddressName',
          snippet: userFullAddress,
        ),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
      ),
    );

    if (_riderLocation != null) {
      updated.add(
        Marker(
          markerId: const MarkerId('rider_live_marker'),
          position: _riderLocation!,
          rotation: _riderRotation,
          anchor: const Offset(0.5, 0.5),
          infoWindow: const InfoWindow(
            title: '🛵 Delivery Partner',
            snippet: 'On the way to you!',
          ),
          icon: riderIcon,
        ),
      );
    }

    _markers = updated;
  }

  Future<void> _getPolylineWithDirections() async {
    if (_isFetchingPolyline) return;
    _isFetchingPolyline = true;

    bool polylineFetched = false;
    final LatLng origin = _riderLocation ?? _storeLocation;
    final LatLng destination = _userLocation;

    _lastPolylineFetchRiderLocation = origin;

    if (_googleApiKey != "YOUR_GOOGLE_MAPS_API_KEY" && _googleApiKey.isNotEmpty) {
      try {
        final url = Uri.parse(
          'https://maps.googleapis.com/maps/api/directions/json?'
              'origin=${origin.latitude},${origin.longitude}&'
              'destination=${destination.latitude},${destination.longitude}&'
              'key=$_googleApiKey',
        );

        final response = await http.get(url);
        if (response.statusCode == 200) {
          final data = json.decode(response.body);
          if (data['status'] == 'OK' && data['routes'] != null && data['routes'].isNotEmpty) {
            final points = data['routes'][0]['overview_polyline']['points'];
            _decodePolyline(points);
            polylineFetched = true;
          }
        }
      } catch (e) {
        debugPrint("Google Directions API Error: $e");
      }
    }

    if (!polylineFetched) {
      try {
        final osrmUrl = Uri.parse(
          'https://router.project-osrm.org/route/v1/driving/'
              '${origin.longitude},${origin.latitude};'
              '${destination.longitude},${destination.latitude}'
              '?overview=full&geometries=polyline',
        );

        final response = await http.get(osrmUrl);
        if (response.statusCode == 200) {
          final data = json.decode(response.body);
          if (data['routes'] != null && data['routes'].isNotEmpty) {
            final points = data['routes'][0]['geometry'];
            _decodePolyline(points);
            polylineFetched = true;
          }
        }
      } catch (e) {
        debugPrint("OSRM Directions Error: $e");
      }
    }

    if (!polylineFetched) {
      _drawFallbackPolyline(origin, destination);
    }

    _isFetchingPolyline = false;
  }

  void _decodePolyline(String encodedPoints) {
    List<PointLatLng> result = PolylinePoints.decodePolyline(encodedPoints);

    _polylineCoordinates = result.map((p) => LatLng(p.latitude, p.longitude)).toList();
    _updatePolylineState();
  }

  void _drawFallbackPolyline(LatLng origin, LatLng destination) {
    _polylineCoordinates = [origin, destination];
    _updatePolylineState();
  }

  void _updatePolylineState() {
    if (_isDisposed) return;
    _polylines = {
      Polyline(
        polylineId: const PolylineId('route'),
        color: Colors.blueAccent,
        points: _polylineCoordinates,
        width: 5,
      ),
    };
    notifyListeners();

    // Optimize: Camera will only auto-fit on the very first polyline render
    if (!_hasInitialCameraFitted) {
      _hasInitialCameraFitted = true;
      onRouteUpdated?.call();
    }
  }

  LatLngBounds getBounds(List<LatLng> points) {
    double minLat = points.first.latitude;
    double maxLat = points.first.latitude;
    double minLng = points.first.longitude;
    double maxLng = points.first.longitude;

    for (var point in points) {
      if (point.latitude < minLat) minLat = point.latitude;
      if (point.latitude > maxLat) maxLat = point.latitude;
      if (point.longitude < minLng) minLng = point.longitude;
      if (point.longitude > maxLng) maxLng = point.longitude;
    }
    return LatLngBounds(
      southwest: LatLng(minLat, minLng),
      northeast: LatLng(maxLat, maxLng),
    );
  }
}