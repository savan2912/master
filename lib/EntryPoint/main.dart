import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:gotilo_new/Routes/app_pages.dart';
import 'package:gotilo_new/Routes/app_routes.dart';

import '../Constant/AppPref.dart';

 void main()async {
   WidgetsFlutterBinding.ensureInitialized();
   await AppPrefs.init();
  runApp( const MyApp() );
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
      getPages:AppPages.routes
    );
  }
 }
