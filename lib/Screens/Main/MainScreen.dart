import 'package:flutter/material.dart';

import '../../CustomeWidgets/AppColors.dart';
import '../../CustomeWidgets/SharedWidgets.dart';
import '../AboutUs/view/AboutUsScreen.dart';
import '../Blog/view/BlogScreen.dart';
import '../ContactUs/view/ContactUsScreen.dart';
import '../Home/view/HomeScreen.dart';
import '../PrisePlan/view/PrisePlanScreen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int navIndex = 0;
  int previousIndex = 0;

  final List<String> _svgIcons = [
    'assets/home.svg',
    'assets/about.svg',
    'assets/contact_us.svg',
    'assets/prise.svg',
    'assets/blog.svg',
  ];

  final List<Widget> _screens = [
    const HomeScreen(),
    const AboutUsScreen(),
    ContactUsScreen(),
    const PrisePlanScreen(),
    const BlogScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final isForward = navIndex > previousIndex;

    return Scaffold(
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 420),
        switchInCurve: Curves.easeInOutCubic,
        switchOutCurve: Curves.easeInOutCubic,

        child: Container(key: ValueKey(navIndex), child: _screens[navIndex]),

        transitionBuilder: (child, animation) {
          final beginOffset = isForward
              ? const Offset(1, 0)
              : const Offset(-1, 0);

          final endOffset = isForward
              ? const Offset(-0.3, 0)
              : const Offset(0.3, 0);

          final slideIn = Tween<Offset>(
            begin: beginOffset,
            end: Offset.zero,
          ).animate(animation);

          final slideOut = Tween<Offset>(
            begin: Offset.zero,
            end: endOffset,
          ).animate(animation);

          final scale = Tween<double>(
            begin: 0.96,
            end: 1.0,
          ).animate(CurvedAnimation(parent: animation, curve: Curves.easeOut));

          return SlideTransition(
            position: child.key == ValueKey(navIndex) ? slideIn : slideOut,
            child: FadeTransition(
              opacity: animation,
              child: ScaleTransition(scale: scale, child: child),
            ),
          );
        },
      ),

      bottomNavigationBar: SharedWidgets.customCurvedBottomNavBar(
        gradient: const LinearGradient(
          colors: [
            AppColors.gradientStart, AppColors.gradientEnd,
            // AppColors.gradientStart, AppColors.gradientMid, AppColors.gradientEnd
          ],
        ),
        currentIndex: navIndex,
        svgPaths: _svgIcons,
        labels: ["Home", "About", "Contact", "Prise", "Blog"],
        onTap: (index) {
          setState(() {
            previousIndex = navIndex;
            navIndex = index;
          });
        },
      ),
    );
  }
}
