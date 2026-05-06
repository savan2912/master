import 'dart:developer';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:gotilo_new/Api/ApiCalls.dart';
import 'package:gotilo_new/Api/Request/Logout/RequestLogout.dart';
import 'package:gotilo_new/Api/Response/Logout/ResponseLogout.dart';
import 'package:gotilo_new/Constant/AppPref.dart';
import 'package:gotilo_new/CustomeWidgets/SharedWidgets.dart';
import 'package:gotilo_new/Screens/Login/view/LoginScreen.dart';

import '../Api/Request/User/Profile/RequestProfile.dart';
import '../Api/Response/User/Profile/ResponseProfile.dart';
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

  static Future<void> callLogout({required BuildContext c}) async {
    bool internet = await checkInternet();

    if (internet) {
      try {
        ResponseLogout? response = await ApiCalls.callLogout(RequestLogout(
            userId: int.parse(AppPrefs.userId)
        ));

        if (response != null) {
          if (response.result != null && response.result!.toLowerCase().contains("pass")) {

            AppPrefs.setUserId("");
            if (c.mounted) {
              SharedWidgets.showTopSnackBar(c, message: response.message!);
            }
            Get.off(() => const ModernLoginScreen());
          }
        }
      } on Exception catch (e) {
        log("$e");
      } catch (e) {
        log("$e");
      }
    } else {
      if (c.mounted) {
        SharedWidgets.showTopSnackBar(c, message: "No Internet Available");
      }
    }
  }





}
