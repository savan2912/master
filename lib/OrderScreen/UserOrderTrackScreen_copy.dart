import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'dart:async';
import 'dart:math' as math;
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class UserOrderTrackScreen extends StatefulWidget {
  final String orderId;
  final String storeSvgAssetPath;
  final String riderImageAssetPath;

  const UserOrderTrackScreen({
    super.key,
    this.orderId = "ORD-98234",
    this.storeSvgAssetPath = "assets/order/store.svg",
    this.riderImageAssetPath = "assets/images/bike.png", // Bike image path
  });

  @override
  State<UserOrderTrackScreen> createState() => _UserOrderTrackScreenState();
}

class _UserOrderTrackScreenState extends State<UserOrderTrackScreen>
    with SingleTickerProviderStateMixin {
  GoogleMapController? _mapController;

  static const LatLng _storeLocation = LatLng(22.287594365815963, 70.7577717592851);
  LatLng _userLocation = const LatLng(22.3039, 70.8022);
  LatLng? _riderLocation;
  double _riderRotation = 0.0; // Bike Rotation Angle

  final String _storeName = "hari krishna dal pakwan";
  final String _storeFullAddress = "5, University Rd, Triveni Society, Janak Puri, Yogi Nagar, Rajkot, Gujarat 360005";
  final String _userAddressName = "Home";
  final String _userFullAddress = "Flat 402, Imperial Heights, Yagnik Road, Rajkot";

  final Set<Marker> _markers = {};
  final Set<Polyline> _polylines = {};
  final List<LatLng> _polylineCoordinates = [];

  final String _googleApiKey = "YOUR_GOOGLE_MAPS_API_KEY";

  StreamSubscription? _riderLocationSubscription;
  StreamSubscription<Position>? _userLocationSubscription;

  BitmapDescriptor? _cachedShopIcon;
  BitmapDescriptor? _cachedRiderIcon;

  // Local Notification plugin & Flag to prevent repeated alerts
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();
  bool _hasNotifiedUser = false;

  // Controller for Smooth Marker Movement
  late AnimationController _animationController;
  Animation<double>? _animation;
  LatLng? _previousRiderLocation;
  LatLng? _targetRiderLocation;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500), // Smooth movement duration
    );

    _initLocalNotifications();
    _saveStoreLocationToFirebase();
    _setInitialMarkers();
    _listenToRiderLiveLocation();
    _startUserLocationTracking();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _riderLocationSubscription?.cancel();
    _userLocationSubscription?.cancel();
    _mapController?.dispose();
    super.dispose();
  }

  /// Initialize Local Notification (Fixed Named Parameter)
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

    // Request permissions for Android 13+
    _flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission();
  }

  /// Trigger local notification
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

  /// Saves the Static Restaurant Location to Firebase Realtime Database
  Future<void> _saveStoreLocationToFirebase() async {
    try {
      final database = FirebaseDatabase.instanceFor(
        app: Firebase.app(),
        databaseURL:
        'https://gotilo-5a831-default-rtdb.asia-southeast1.firebasedatabase.app',
      );

      final path = 'restaurants/${widget.orderId}/location';

      final storeData = {
        'name': _storeName,
        'address': _storeFullAddress,
        'latitude': _storeLocation.latitude,
        'longitude': _storeLocation.longitude,
        'timestamp': ServerValue.timestamp,
      };

      await database.ref(path).set(storeData);
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
      accuracy: LocationAccuracy.high,
      distanceFilter: 10,
    );

    try {
      final Position currentPosition = await Geolocator.getCurrentPosition(
        locationSettings: locationSettings,
      );

      await _saveUserLocationToFirebase(currentPosition);

      if (mounted) {
        setState(() {
          _userLocation = LatLng(
            currentPosition.latitude,
            currentPosition.longitude,
          );
        });
        _updateAllMarkers();
        _getPolylineWithDirections();
      }
    } catch (e) {
      debugPrint("Get current location error: $e");
    }

    _userLocationSubscription = Geolocator.getPositionStream(
      locationSettings: locationSettings,
    ).listen(
          (Position position) async {
        await _saveUserLocationToFirebase(position);

        if (mounted) {
          setState(() {
            _userLocation = LatLng(position.latitude, position.longitude);
          });
          _updateAllMarkers();
          _getPolylineWithDirections();
          _checkProximityToUser();
        }
      },
    );
  }

  Future<void> _saveUserLocationToFirebase(Position position) async {
    try {
      final database = FirebaseDatabase.instanceFor(
        app: Firebase.app(),
        databaseURL:
        'https://gotilo-5a831-default-rtdb.asia-southeast1.firebasedatabase.app',
      );

      final path = 'users/${widget.orderId}/userLocation';

      final locationData = {
        'latitude': position.latitude,
        'longitude': position.longitude,
        'timestamp': ServerValue.timestamp,
      };

      await database.ref(path).set(locationData);
    } catch (e) {
      debugPrint('❌ Firebase User Location Write FAILED: $e');
    }
  }

  /// Custom Bike Icon Converter
  Future<BitmapDescriptor> _getRiderBikeIcon() async {
    if (_cachedRiderIcon != null) return _cachedRiderIcon!;

    try {
      _cachedRiderIcon = await BitmapDescriptor.asset(
        const ImageConfiguration(size: Size(48, 48)),
        widget.riderImageAssetPath,
      );
      return _cachedRiderIcon!;
    } catch (e) {
      debugPrint("Bike Image Loading Error: $e");
      return BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen);
    }
  }

  /// Calculate Bearing Angle for Bike Rotation
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

  /// Listen to live location of rider
  void _listenToRiderLiveLocation() {
    final database = FirebaseDatabase.instanceFor(
      app: Firebase.app(),
      databaseURL:
      'https://gotilo-5a831-default-rtdb.asia-southeast1.firebasedatabase.app',
    );

    _riderLocationSubscription = database
        .ref('orders/${widget.orderId}/location')
        .onValue
        .listen((event) {
      final data = event.snapshot.value as Map<dynamic, dynamic>?;
      if (data != null) {
        double lat = (data['latitude'] as num).toDouble();
        double lng = (data['longitude'] as num).toDouble();

        LatLng newLocation = LatLng(lat, lng);

        if (_riderLocation == null) {
          _riderLocation = newLocation;
          _updateAllMarkers();
          _getPolylineWithDirections();
        } else {
          _animateRiderMovement(_riderLocation!, newLocation);
        }
      }
    });
  }

  /// Smoothly Interpolate Movement between positions
  void _animateRiderMovement(LatLng from, LatLng to) {
    _previousRiderLocation = from;
    _targetRiderLocation = to;

    _riderRotation = _calculateBearing(from, to);

    _animationController.reset();

    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.linear),
    )..addListener(() {
      if (_previousRiderLocation != null && _targetRiderLocation != null) {
        final double t = _animation!.value;

        double currentLat = _previousRiderLocation!.latitude +
            (_targetRiderLocation!.latitude - _previousRiderLocation!.latitude) * t;
        double currentLng = _previousRiderLocation!.longitude +
            (_targetRiderLocation!.longitude - _previousRiderLocation!.longitude) * t;

        setState(() {
          _riderLocation = LatLng(currentLat, currentLng);
        });

        _updateAllMarkers();
      }
    });

    _animationController.forward().then((_) {
      _getPolylineWithDirections();
      _checkProximityToUser();
    });
  }

  /// Calculate distance between Rider and User Location (in meters)
  void _checkProximityToUser() {
    if (_riderLocation == null) return;

    double distanceInMeters = Geolocator.distanceBetween(
      _riderLocation!.latitude,
      _riderLocation!.longitude,
      _userLocation.latitude,
      _userLocation.longitude,
    );

    debugPrint("Distance to User: $distanceInMeters meters");

    if (distanceInMeters <= 100 && !_hasNotifiedUser) {
      _hasNotifiedUser = true;
      _showArrivalNotification();
    }
  }

  Future<BitmapDescriptor> _getShopIcon() async {
    if (_cachedShopIcon != null) return _cachedShopIcon!;

    _cachedShopIcon = await _createSvgShopMarker(
      assetPath: widget.storeSvgAssetPath,
      targetSize: 5.0,
    );
    return _cachedShopIcon!;
  }

  Future<BitmapDescriptor> _createSvgShopMarker({
    String? assetPath,
    double targetSize = 10.0,
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
      final double dpr = screenDpr < 6.0 ? 6.0 : screenDpr;

      final int imageWidth = (targetSize * dpr).toInt();
      final int imageHeight = (targetSize * dpr).toInt();

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

  Future<void> _setInitialMarkers() async {
    _updateAllMarkers();
  }

  Future<void> _updateAllMarkers() async {
    BitmapDescriptor shopIcon = await _getShopIcon();
    BitmapDescriptor riderIcon = await _getRiderBikeIcon();

    if (!mounted) return;

    setState(() {
      _markers.clear();

      _markers.add(
        Marker(
          markerId: const MarkerId('store'),
          position: _storeLocation,
          infoWindow: InfoWindow(
            title: '🏪 $_storeName',
            snippet: _storeFullAddress,
          ),
          icon: shopIcon,
        ),
      );

      _markers.add(
        Marker(
          markerId: const MarkerId('user_destination'),
          position: _userLocation,
          infoWindow: InfoWindow(
            title: '🏠 $_userAddressName',
            snippet: _userFullAddress,
          ),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
        ),
      );

      if (_riderLocation != null) {
        _markers.add(
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
    });
  }

  Future<void> _getPolylineWithDirections() async {
    bool polylineFetched = false;

    final LatLng origin = _riderLocation ?? _storeLocation;
    final LatLng destination = _userLocation;

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
  }

  void _decodePolyline(String encodedPoints) {
    List<PointLatLng> result = PolylinePoints.decodePolyline(encodedPoints);

    _polylineCoordinates.clear();
    if (result.isNotEmpty) {
      for (var point in result) {
        _polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      }
    }

    _updatePolylineState();
  }

  void _drawFallbackPolyline(LatLng origin, LatLng destination) {
    _polylineCoordinates.clear();
    _polylineCoordinates.addAll([origin, destination]);
    _updatePolylineState();
  }

  void _updatePolylineState() {
    setState(() {
      _polylines.clear();
      _polylines.add(
        Polyline(
          polylineId: const PolylineId('route'),
          color: Colors.blueAccent,
          points: _polylineCoordinates,
          width: 5,
        ),
      );
    });

    _fitMapToPolyline();
  }

  void _fitMapToPolyline() {
    if (_mapController != null && _polylineCoordinates.isNotEmpty) {
      _mapController!.animateCamera(
        CameraUpdate.newLatLngBounds(_getBounds(_polylineCoordinates), 70),
      );
    }
  }

  LatLngBounds _getBounds(List<LatLng> points) {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: CameraPosition(
              target: _userLocation,
              zoom: 14.0,
            ),
            markers: _markers,
            polylines: _polylines,
            myLocationEnabled: true,
            myLocationButtonEnabled: false,
            zoomControlsEnabled: false,
            padding: const EdgeInsets.only(bottom: 280, top: 90),
            onMapCreated: (controller) {
              _mapController = controller;
              _fitMapToPolyline();
            },
          ),
          Positioned(
            top: 40,
            left: 14,
            right: 14,
            child: Row(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 10, offset: const Offset(0, 3)),
                    ],
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back_rounded, color: Colors.black87),
                    onPressed: () {
                      if (Navigator.canPop(context)) {
                        Navigator.pop(context);
                      }
                    },
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30),
                      boxShadow: [
                        BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 10, offset: const Offset(0, 3)),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Order #${widget.orderId}',
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.black87),
                            ),
                            const Text(
                              'Live Tracking • On Time',
                              style: TextStyle(fontSize: 10, color: Color(0xFF2E7D32), fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: const Color(0xFFE8F5E9),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Row(
                            children: [
                              CircleAvatar(radius: 3, backgroundColor: Color(0xFF2E7D32)),
                              SizedBox(width: 4),
                              Text(
                                'LIVE',
                                style: TextStyle(fontSize: 10, fontWeight: FontWeight.w800, color: Color(0xFF2E7D32)),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 10, offset: const Offset(0, 3)),
                    ],
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.my_location_rounded, color: Colors.black87),
                    onPressed: _fitMapToPolyline,
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height * 0.58,
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.14),
                    blurRadius: 25,
                    offset: const Offset(0, -6),
                  ),
                ],
              ),
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(18, 12, 18, 24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Container(
                        width: 44,
                        height: 4.5,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade300,
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    const SizedBox(height: 14),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: const Color(0xFFE8F5E9),
                            shape: BoxShape.circle,
                            border: Border.all(color: const Color(0xFFA5D6A7), width: 1.5),
                          ),
                          child: const Icon(Icons.delivery_dining_rounded, color: Color(0xFF2E7D32), size: 30),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  const Text(
                                    'Arriving Soon',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w900,
                                      color: Colors.black,
                                      letterSpacing: -0.3,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFE8F5E9),
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: const Text(
                                      'ON TIME',
                                      style: TextStyle(color: Color(0xFF2E7D32), fontSize: 9, fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 3),
                              const Text(
                                'Rider is on the way to pick up / deliver',
                                style: TextStyle(color: Colors.black54, fontSize: 13, fontWeight: FontWeight.w500),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}