import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  GoogleMapController? _mapController;

  LatLng _selectedLatLng = const LatLng(22.3039, 70.8022);
  Set<Marker> _markers = {};

  String selectedAddress = "Tap on map to select location";
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    await _getCurrentLocation();
    _setMarker(_selectedLatLng);
    await _getAddress(_selectedLatLng);
  }

  Future<void> _getCurrentLocation() async {
    try {
      LocationPermission permission = await Geolocator.requestPermission();

      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        return;
      }

      Position pos = await Geolocator.getCurrentPosition();

      _selectedLatLng = LatLng(pos.latitude, pos.longitude);
    } catch (e) {
      debugPrint("Location Error: $e");
    }
  }

  void _setMarker(LatLng latLng) {
    _markers = {
      Marker(
        markerId: const MarkerId("selected_location"),
        position: latLng,
      )
    };
    setState(() {});
  }

  Future<void> _getAddress(LatLng latLng) async {
    setState(() => isLoading = true);

    try {
      final url = Uri.parse(
        "https://nominatim.openstreetmap.org/reverse"
            "?format=jsonv2&lat=${latLng.latitude}&lon=${latLng.longitude}",
      );

      final res = await http.get(
        url,
        headers: {"User-Agent": "FlutterApp"},
      );

      final data = json.decode(res.body);

      selectedAddress = data["display_name"] ??
          "Lat: ${latLng.latitude}, Lng: ${latLng.longitude}";
    } catch (e) {
      selectedAddress =
      "Lat: ${latLng.latitude}, Lng: ${latLng.longitude}";
    }

    setState(() => isLoading = false);
  }

  void _onTap(LatLng latLng) async {
    _selectedLatLng = latLng;
    _setMarker(latLng);

    selectedAddress = "Fetching address...";
    setState(() {});

    await _getAddress(latLng);
  }

  void _confirmSelection() {
    Navigator.pop(context, {
      "lat": _selectedLatLng.latitude,
      "lng": _selectedLatLng.longitude,
      "address": selectedAddress,
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        _confirmSelection();
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Select Location"),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: _confirmSelection,
          ),
          actions: [
            TextButton(
              onPressed: _confirmSelection,
              child: const Text(
                "DONE",
                style: TextStyle(color: Colors.white),
              ),
            )
          ],
        ),
        body: Stack(
          children: [
         GoogleMap(
              initialCameraPosition: CameraPosition(
                target: _selectedLatLng,
                zoom: 15,
              ),
              onMapCreated: (controller) => _mapController = controller,
              markers: _markers,
              onTap: _onTap,
              myLocationEnabled: true,
              myLocationButtonEnabled: true,
            ),

            Positioned(
              bottom: 20,
              left: 15,
              right: 15,
              child: Container(
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: const [
                    BoxShadow(blurRadius: 10, color: Colors.black26)
                  ],
                ),
                child: isLoading
                    ? const Row(
                  children: [
                    SizedBox(
                      height: 16,
                      width: 16,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                    SizedBox(width: 10),
                    Text("Fetching address..."),
                  ],
                )
                    : Text(
                  selectedAddress,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}