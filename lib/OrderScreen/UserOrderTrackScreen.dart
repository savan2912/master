import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'controller/user_order_track_controller.dart';

class UserOrderTrackScreen extends StatefulWidget {
  final String orderId;
  final String storeSvgAssetPath;
  final String riderImageAssetPath;

  const UserOrderTrackScreen({
    super.key,
    this.orderId = "ORD-98234",
    this.storeSvgAssetPath = "assets/order/store.svg",
    this.riderImageAssetPath = "assets/images/bike.png",
  });

  @override
  State<UserOrderTrackScreen> createState() => _UserOrderTrackScreenState();
}

class _UserOrderTrackScreenState extends State<UserOrderTrackScreen>
    with SingleTickerProviderStateMixin {
  GoogleMapController? _mapController;
  late final UserOrderTrackController _controller;

  @override
  void initState() {
    super.initState();
    _controller = UserOrderTrackController(
      orderId: widget.orderId,
      storeSvgAssetPath: widget.storeSvgAssetPath,
      riderImageAssetPath: widget.riderImageAssetPath,
    );
    _controller.onRouteUpdated = _fitMapToPolyline;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _controller.init(this);
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _mapController?.dispose();
    super.dispose();
  }

  void _fitMapToPolyline() {
    if (_mapController != null && _controller.polylineCoordinates.isNotEmpty) {
      _mapController!.animateCamera(
        CameraUpdate.newLatLngBounds(
          _controller.getBounds(_controller.polylineCoordinates),
          70,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      body: Stack(
        children: [
          // Optimize: Map updates dynamically without rebuild lags
          ListenableBuilder(
            listenable: _controller,
            builder: (context, child) {
              return GoogleMap(
                initialCameraPosition: CameraPosition(
                  target: _controller.userLocation,
                  zoom: 14.0,
                ),
                markers: _controller.markers,
                polylines: _controller.polylines,
                myLocationEnabled: false,
                myLocationButtonEnabled: false,
                zoomControlsEnabled: false,
                padding: const EdgeInsets.only(bottom: 280, top: 90),
                onMapCreated: (controller) {
                  _mapController = controller;
                  _controller.onMapReady();
                },
              );
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
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 10,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: IconButton(
                    icon: const Icon(
                      Icons.arrow_back_rounded,
                      color: Colors.black87,
                    ),
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
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 10,
                          offset: const Offset(0, 3),
                        ),
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
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                                color: Colors.black87,
                              ),
                            ),
                            const Text(
                              'Live Tracking • On Time',
                              style: TextStyle(
                                fontSize: 10,
                                color: Color(0xFF2E7D32),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFFE8F5E9),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Row(
                            children: [
                              CircleAvatar(
                                radius: 3,
                                backgroundColor: Color(0xFF2E7D32),
                              ),
                              SizedBox(width: 4),
                              Text(
                                'LIVE',
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w800,
                                  color: Color(0xFF2E7D32),
                                ),
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
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 10,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: IconButton(
                    icon: const Icon(
                      Icons.my_location_rounded,
                      color: Colors.black87,
                    ),
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
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(28),
                ),
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
                            border: Border.all(
                              color: const Color(0xFFA5D6A7),
                              width: 1.5,
                            ),
                          ),
                          child: const Icon(
                            Icons.delivery_dining_rounded,
                            color: Color(0xFF2E7D32),
                            size: 30,
                          ),
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
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 6,
                                      vertical: 2,
                                    ),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFE8F5E9),
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: const Text(
                                      'ON TIME',
                                      style: TextStyle(
                                        color: Color(0xFF2E7D32),
                                        fontSize: 9,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 3),
                              const Text(
                                'Rider is on the way to pick up / deliver',
                                style: TextStyle(
                                  color: Colors.black54,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                ),
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
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
        onPressed: () async {
          bool success = await _controller.createOrderInFirebase();
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  success
                      ? 'Order details saved to Firebase successfully!'
                      : 'Failed to save order details.',
                ),
                backgroundColor: success ? Colors.green : Colors.red,
              ),
            );
          }
        },
        label: const Text(
          'Create Order in Firebase',
          style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
