import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';

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

}