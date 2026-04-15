import 'dart:developer';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:geolocator/geolocator.dart';

import '../Constant/Constants.dart';

class MyApplication {

  static Future<bool> checkInternet() async {
    try {
      final List<ConnectivityResult> results =
      await Connectivity().checkConnectivity();

      bool hasNetwork =
          results.contains(ConnectivityResult.mobile) ||
              results.contains(ConnectivityResult.wifi) ||
              results.contains(ConnectivityResult.ethernet);

      if (!hasNetwork) {
        return false;
      }

      final lookup = await InternetAddress.lookup('google.com');

      if (lookup.isNotEmpty && lookup.first.rawAddress.isNotEmpty) {
        return true;
      }

      return false;

    } on SocketException {
      return false;
    } catch (e) {
      return false;
    }
  }

  static Future<void> determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      log('Location services are disabled.');
      return;
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        log('Location permissions are denied');
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      log('Location permissions are permanently denied.');
      return;
    }
    try {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high
      );
      Constants.userLat = position.latitude;
      Constants.userLong = position.longitude;

      log("Location Stored: ${Constants.userLat}, ${Constants.userLong}");
    } catch (e) {
      log("Error getting location: $e");
    }
  }


}
