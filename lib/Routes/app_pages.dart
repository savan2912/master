import 'package:get/get.dart';
import 'package:gotilo_new/Screens/AboutUs/view/AboutUsScreen.dart';
import 'package:gotilo_new/Screens/AllCategoryScreen/AllCategory.dart';
import 'package:gotilo_new/Screens/Blog/view/BlogScreen.dart';
import 'package:gotilo_new/Screens/ContactUs/view/ContactUsScreen.dart';
import 'package:gotilo_new/Screens/JoinUs/view/JoinUsScreen.dart';
import 'package:gotilo_new/Screens/Main/MainScreen.dart';
import 'package:gotilo_new/Splash/SplashVideoScreen.dart';
import '../Screens/HeritageHomeScreen.dart';
import '../Screens/Login/view/LoginScreen.dart';
import 'app_routes.dart';

class AppPages {
  static final routes = [
    GetPage(name: AppRoutes.splash, page: () => const SplashVideoScreen()),
    GetPage(name: AppRoutes.main, page: () => const MainScreen()),

    GetPage(name: AppRoutes.home, page: () => const ModernHeritageApp()),

    GetPage(name: AppRoutes.allCategory, page: () => const AllCategoryScreen()),

    GetPage(name: AppRoutes.login, page: () => const ModernLoginScreen()),

    GetPage(name: AppRoutes.joinUs, page: () => const RegisterScreen()),

    GetPage(name: AppRoutes.contactUs, page: () => ContactUsScreen()),

    GetPage(name: AppRoutes.aboutUs, page: () => const AboutUsScreen()),

    GetPage(name: AppRoutes.blog, page: () => const BlogScreen()),
  ];
}
