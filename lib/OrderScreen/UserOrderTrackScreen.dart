import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'dart:async'; // Stream subscription mate
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:flutter_svg/flutter_svg.dart';


class UserOrderTrackScreen extends StatefulWidget {
  final String orderId;
  final String storeSvgAssetPath;

  const UserOrderTrackScreen({
    super.key,
    this.orderId = "ORD-98234",
    this.storeSvgAssetPath = "assets/order/store.svg",
  });

  @override
  State<UserOrderTrackScreen> createState() => _UserOrderTrackScreenState();
}

class _UserOrderTrackScreenState extends State<UserOrderTrackScreen> {
  GoogleMapController? _mapController;

  static const LatLng _storeLocation = LatLng(22.3150, 70.8120);
  static const LatLng _userLocation = LatLng(22.3039, 70.8022);
  LatLng? _riderLocation; // Rider nu live location store karva mate

  // Shop & Address Details
  final String _storeName = "The Grand Thakar Restaurant";
  final String _storeFullAddress = "101, Kalawad Road, Near KKV Hall, Rajkot";
  final String _userAddressName = "Home";
  final String _userFullAddress = "Flat 402, Imperial Heights, Yagnik Road, Rajkot";

  final Set<Marker> _markers = {};
  final Set<Polyline> _polylines = {};
  final List<LatLng> _polylineCoordinates = [];

  final String _googleApiKey = "YOUR_GOOGLE_MAPS_API_KEY";

  StreamSubscription? _riderLocationSubscription;

  @override
  void initState() {
    super.initState();
    _setInitialMarkers();
    _getPolylineWithDirections();
    _listenToRiderLiveLocation(); // Firebase mathi rider nu live location track karva
  }

  @override
  void dispose() {
    _riderLocationSubscription?.cancel();
    _mapController?.dispose();
    super.dispose();
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

      PictureInfo pictureInfo;
      try {
        pictureInfo = await vg.loadPicture(loader, null);
      } catch (e) {
        pictureInfo = await vg.loadPicture(const SvgStringLoader(crispStoreSvg), null);
      }

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

  // Firebase Realtime Database mathi Rider nu live location listen karvu
  void _listenToRiderLiveLocation() {
    _riderLocationSubscription = FirebaseDatabase.instance
        .ref('orders/${widget.orderId}/location')
        .onValue
        .listen((event) {
      final data = event.snapshot.value as Map<dynamic, dynamic>?;
      if (data != null) {
        double lat = data['latitude'];
        double lng = data['longitude'];

        setState(() {
          _riderLocation = LatLng(lat, lng);
        });

        // Map par badha markers (Store, User, ane Rider) update karo
        _updateAllMarkers();
      }
    });
  }

  Future<void> _setInitialMarkers() async {
    _updateAllMarkers();
  }

  Future<void> _updateAllMarkers() async {
    BitmapDescriptor shopIcon = await _createSvgShopMarker(
      assetPath: widget.storeSvgAssetPath,
      targetSize: 5.0,
    );

    if (!mounted) return;

    setState(() {
      _markers.clear();

      // 1. Store Marker
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

      // 2. User Destination Marker
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

      // 3. Live Rider Marker (Jo rider location madi gayo hoy to)
      if (_riderLocation != null) {
        _markers.add(
          Marker(
            markerId: const MarkerId('rider_live_marker'),
            position: _riderLocation!,
            infoWindow: const InfoWindow(
              title: '🛵 Delivery Partner',
              snippet: 'On the way to you!',
            ),
            icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
            rotation: 0.0, // Tamare rotation add karvu hoy to kari shako cho
          ),
        );
      }
    });
  }

  Future<void> _getPolylineWithDirections() async {
    bool polylineFetched = false;

    if (_googleApiKey != "YOUR_GOOGLE_MAPS_API_KEY" && _googleApiKey.isNotEmpty) {
      try {
        final url = Uri.parse(
          'https://maps.googleapis.com/maps/api/directions/json?'
              'origin=${_storeLocation.latitude},${_storeLocation.longitude}&'
              'destination=${_userLocation.latitude},${_userLocation.longitude}&'
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
              '${_storeLocation.longitude},${_storeLocation.latitude};'
              '${_userLocation.longitude},${_userLocation.latitude}'
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
      _drawFallbackPolyline();
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

  void _drawFallbackPolyline() {
    _polylineCoordinates.clear();
    _polylineCoordinates.addAll([
      _storeLocation,
      const LatLng(22.3110, 70.8090),
      const LatLng(22.3070, 70.8050),
      _userLocation,
    ]);

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
          // 1. Google Map Canvas
          GoogleMap(
            initialCameraPosition: const CameraPosition(
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

          // 2. Top Floating Navigation Header Bar
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

          // 3. Bottom Tracking Details Sheet
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
                                    'Arriving in 12 Mins',
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
                    // Restaurant Store & Destination details view as per your UI design...
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