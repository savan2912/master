import 'dart:developer';
import 'dart:ui';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart'; // GetX માટે
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:gotilo_new/Routes/app_pages.dart';
import 'package:gotilo_new/Routes/app_routes.dart';
import 'package:upgrader/upgrader.dart'; // Upgrader Import કરો

import '../Constant/AppPref.dart';
import '../Notifications/PushNotificationService.dart';

Future<void> firebaseMessagingBackgroundHandler(
    RemoteMessage message) async {
  await Firebase.initializeApp();
  log("Background message: ${message.messageId}");
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AppPrefs.init();
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(
      firebaseMessagingBackgroundHandler);
  await PushNotificationService.initialize();
  FlutterError.onError = (FlutterErrorDetails details) {
    FlutterError.dumpErrorToConsole(details);
  };

  PlatformDispatcher.instance.onError = (error, stack) {
    debugPrint("GLOBAL ERROR: $error");
    debugPrintStack(stackTrace: stack);
    return true;
  };
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Gotilo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.white),
        useMaterial3: true,
      ),
      initialRoute: AppRoutes.splash,
      getPages: AppPages.routes,
      builder: (context, child) {
        return UpgradeAlert(
          navigatorKey: Get.key,
          barrierDismissible: false,
          upgrader: Upgrader(
            debugDisplayAlways: false,
            durationUntilAlertAgain: const Duration(seconds: 10),
          ),
          shouldPopScope: () => false,
          child: child ?? const SizedBox(),
        );
      },
    );
  }
}