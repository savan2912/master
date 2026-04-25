import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gotilo_new/Constant/AppPref.dart';
import 'package:gotilo_new/Screens/Login/view/LoginScreen.dart';

class CustomDrawer extends StatefulWidget {
  final String initialRoute;

  const CustomDrawer({super.key, required this.initialRoute});

  @override
  State<CustomDrawer> createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  late String activeRoute;

  // --- PREMIUM MATERIAL DARK PALETTE ---
  final Color drawerBG = const Color(0xFF1E2124);     // Deep Slate Grey (Not Black)
  final Color surfaceColor = const Color(0xFF2F3136); // Lighter Grey for Items
  final Color accentCyan = const Color(0xFF00E5FF);   // Electric Cyan
  final Color textMuted = const Color(0xFFB9BBBE);    // Muted Grey for non-active

  @override
  void initState() {
    super.initState();
    activeRoute = widget.initialRoute;
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: drawerBG, // Main Background
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
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 15),
              physics: const BouncingScrollPhysics(),
              children: [
                _buildDrawerItem(icon: Icons.dashboard_rounded, title: "Dashboard", routeName: "dashboard"),
                _buildDrawerItem(icon: Icons.notifications_none_rounded, title: "Notification", routeName: "notification"),
                _buildDrawerItem(icon: Icons.shopping_bag_outlined, title: "My Orders", routeName: "myorders"),
                _buildDrawerItem(icon: Icons.local_offer_outlined, title: "Exclusive Deals", routeName: "deals"),
                _buildDrawerItem(icon: Icons.account_balance_wallet_outlined, title: "Billing Details", routeName: "billing"),

                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                  child: Divider(color: Colors.white.withOpacity(0.05), thickness: 1),
                ),

                _buildDrawerItem(icon: Icons.history_rounded, title: "Booking History", routeName: "booking-history"),
                _buildDrawerItem(icon: Icons.hotel_outlined, title: "Hotel Bookings", routeName: "hotel-booking-history"),
                _buildDrawerItem(icon: Icons.stars_rounded, title: "My Reward Points", routeName: "my-points"),
                _buildDrawerItem(icon: Icons.favorite_border_rounded, title: "Favourites", routeName: "favourites"),
              ],
            ),
          ),

          // --- Footer Version ---
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Text(
              "App Version 1.0.24",
              style: GoogleFonts.montserrat(
                  fontSize: 10,
                  color: textMuted.withOpacity(0.4),
                  fontWeight: FontWeight.bold
              ),
            ),
          )
        ],
      ),
    );
  }

  void _handleItemClick(String route) {
    setState(() => activeRoute = route);
    Future.delayed(const Duration(milliseconds: 200), () {
      if (mounted) Navigator.pop(context);
    });
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 60, 20, 30),
      decoration: BoxDecoration(
        color: surfaceColor, // Header thodu light grey
        borderRadius: const BorderRadius.only(bottomRight: Radius.circular(30)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Profile Section
              Container(
                padding: const EdgeInsets.all(2),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: accentCyan, width: 1.5),
                ),
                child: const CircleAvatar(
                  radius: 30,
                  backgroundColor: Color(0xFF36393F),
                  child: Icon(Icons.person_rounded, size: 35, color: Colors.white),
                ),
              ),

              GestureDetector(
                onTap:() {
                  AppPrefs.setUserId("");
                  Get.off(()=>const ModernLoginScreen());
                },
                child: Container(
                  height: 35,
                  width: 35,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.05),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.power_settings_new_rounded, color: accentCyan, size: 18),
                ),
              )
            ],
          ),
          const SizedBox(height: 15),
          Text(
            "Savan Sagpariya",
            style: GoogleFonts.montserrat(color: Colors.white, fontSize: 17, fontWeight: FontWeight.w800),
          ),
          Text(
            "savan.s@bbdpl.in",
            style: GoogleFonts.montserrat(color: textMuted, fontSize: 12, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerItem({required IconData icon, required String title, required String routeName}) {
    bool isSelected = activeRoute == routeName;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      margin: const EdgeInsets.only(bottom: 5),
      decoration: BoxDecoration(
        color: isSelected ? accentCyan.withOpacity(0.1) : Colors.transparent,
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
            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
            color: isSelected ? Colors.white : textMuted,
          ),
        ),
        trailing: isSelected
            ? Icon(Icons.circle, color: accentCyan, size: 8)
            : null,
      ),
    );
  }
}