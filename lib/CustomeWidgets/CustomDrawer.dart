
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gotilo_new/Api/Request/User/Menu/RequestMenu.dart';
import 'package:gotilo_new/Api/Response/User/Menu/ResponseMenu.dart';
import 'package:gotilo_new/Constant/AppPref.dart';
import 'package:gotilo_new/CustomeWidgets/SharedWidgets.dart';
import 'package:gotilo_new/MyApplication/MyApplication.dart';
import 'package:gotilo_new/Screens/User/Dashboard/UserDashboardScreen.dart';
import 'package:gotilo_new/Screens/User/MyOrder/MyOrderScreen.dart';

import '../Api/ApiCalls.dart';
import '../Screens/User/Account/AccountScreen.dart';
import '../Screens/User/Billing/BillingScreen.dart';
import '../Screens/User/BookingHistory/BookingHistoryScreen.dart';
import '../Screens/User/Deals/DealsScreen.dart';
import '../Screens/User/Favourite/FavouriteScreen.dart';
import '../Screens/User/HotelBookingHistory/HotelBookingHistoryScreen.dart';
import '../Screens/User/Notification/NotificationScreen.dart';
import '../Screens/User/Points/PointsScreen.dart';

class CustomDrawer extends StatefulWidget {
  final String initialRoute;

  const CustomDrawer({super.key, required this.initialRoute});

  @override
  State<CustomDrawer> createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {

  static List<Menu> menuList = [];

  late String activeRoute;

  final Color drawerBG = const Color(0xFF1E2124);
  final Color surfaceColor = const Color(0xFF2F3136);
  final Color accentCyan = const Color(0xFF00E5FF);
  final Color textMuted = const Color(0xFFB9BBBE);

  @override
  void initState() {
    super.initState();

    activeRoute = widget.initialRoute;

    if (menuList.isEmpty) {
      callMenu();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: drawerBG,
      elevation: 16,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(25),
          bottomRight: Radius.circular(25),
        ),
      ),
      child: Column(
        children: [
          _buildHeader(),
          Expanded(
            child: menuList.isEmpty
                ? const Center(
              child: CircularProgressIndicator(),
            )
                : ListView.builder(
              padding: const EdgeInsets.symmetric(
                  horizontal: 12, vertical: 15),
              physics: const BouncingScrollPhysics(),
              itemCount: menuList.length,
              itemBuilder: (context, index) {
                final menu = menuList[index];

                return _buildDrawerItem(
                  icon: getIconDataByMenuName(menu.menuName),
                  title: menu.menuName ?? "",
                  routeName: menu.routeName ?? "",
                );
              },
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Text(
              "App Version 1.0.24",
              style: GoogleFonts.montserrat(
                fontSize: 10,
                color: textMuted.withOpacity(0.4),
                fontWeight: FontWeight.bold,
              ),
            ),
          )
        ],
      ),
    );
  }

  void _handleItemClick(String route) {
    if (activeRoute == route) {
      Navigator.pop(context);
      return;
    }

    setState(() => activeRoute = route);
    Navigator.pop(context);
    Future.delayed(const Duration(milliseconds: 150), () {

      switch (route) {
        case "user.overview":
          Get.to(() => const Userdashboardscreen());
          break;

        case "all.notifications":
          Get.off(() => const NotificationScreen());
          break;

        case "user.setting":
          Get.off(() => const AccountScreen());
          break;

        case "user.orders":
          Get.off(() => const MyOrderScreen());
          break;

        case "user.deals":
          Get.off(() => const UserDealsScreen());
          break;

        case "user.billing":
          Get.off(() => const BillingScreen());
          break;

        case "booking-history":
          Get.off(() => const BookingHistoryScreen());
          break;

        case "hotel.booking-history":
          Get.off(() => const HotelBookingHistory());
          break;

        case "user.point":
          Get.off(() => const PointsScreen());
          break;

        case "user.favourite":
          Get.off(() => const FavouriteScreen());
          break;

      }

    });
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 60, 20, 30),
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius:
        const BorderRadius.only(bottomRight: Radius.circular(30)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.all(2),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: accentCyan, width: 1.5),
                ),
                child: const CircleAvatar(
                  radius: 30,
                  backgroundColor: Color(0xFF36393F),
                  child: Icon(Icons.person_rounded,
                      size: 35, color: Colors.white),
                ),
              ),

              GestureDetector(
                onTap: () {
                  MyApplication.callLogout(c: context);
                  menuList.clear();
                },
                child: Container(
                  height: 38,
                  width: 38,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.08),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.power_settings_new_rounded,
                    color: accentCyan,
                    size: 20,
                  ),
                ),
              )
            ],
          ),
          const SizedBox(height: 15),
          Text(
            "Savan Sagpariya",
            style: GoogleFonts.montserrat(
              color: Colors.white,
              fontSize: 17,
              fontWeight: FontWeight.w800,
            ),
          ),
          Text(
            "savan.s@bbdpl.in",
            style: GoogleFonts.montserrat(
              color: textMuted,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerItem({
    required IconData icon,
    required String title,
    required String routeName,
  }) {
    bool isSelected = activeRoute == routeName;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      margin: const EdgeInsets.only(bottom: 5),
      decoration: BoxDecoration(
        color: isSelected
            ? accentCyan.withOpacity(0.1)
            : Colors.transparent,
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        onTap: () => _handleItemClick(routeName),
        dense: true,
        leading: Icon(
          icon,
          color: isSelected ? accentCyan : textMuted,
          size: 20,
        ),
        title: Text(
          title,
          style: GoogleFonts.montserrat(
            fontSize: 13,
            fontWeight:
            isSelected ? FontWeight.w700 : FontWeight.w500,
            color: isSelected ? Colors.white : textMuted,
          ),
        ),
        trailing: isSelected
            ? Icon(Icons.circle, color: accentCyan, size: 8)
            : null,
      ),
    );
  }

  Future<void> callMenu() async {
    await _callMenu();
  }

  Future<void> _callMenu() async {
    if (menuList.isNotEmpty) return;

    bool internet = await MyApplication.checkInternet();

    if (!internet) {
      SharedWidgets.showTopSnackBar(
        context,
        message: "No Internet Available",
      );
      return;
    }

    try {
      ResponseMenu? response =
      await ApiCalls.callMenu(
        RequestMenu(
          userId: AppPrefs.userId,
        ),
      );

      if (response != null &&
          response.result?.toLowerCase().contains("pass") == true) {

        menuList = response.data ?? [];
        menuList.sort(
              (a, b) =>
              (a.position ?? 0).compareTo(b.position ?? 0),
        );

        setState(() {});
      }
    } catch (e) {
      log("$e");
    }
  }

  IconData getIconDataByMenuName(String? menuName) {
    if (menuName == null) return Icons.circle;
    String name = menuName.toLowerCase();
    if (name.contains("dashboard")) return Icons.dashboard_rounded;
    if (name.contains("notification")) return Icons.notifications_none_rounded;
    if (name.contains("account")) return Icons.person_outline_rounded;
    if (name.contains("order")) return Icons.shopping_bag_outlined;
    if (name.contains("deal")) return Icons.local_offer_outlined;
    if (name.contains("billing")) return Icons.receipt_long_outlined;
    if (name.contains("booking history")) return Icons.history_rounded;
    if (name.contains("hotel")) return Icons.hotel_outlined;
    if (name.contains("point")) return Icons.stars_rounded;
    if (name.contains("favourite")) return Icons.favorite_border_rounded;
    return Icons.circle;
  }
}



