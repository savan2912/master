
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../CustomeWidgets/CustomDrawer.dart';
class UserDealsScreen extends StatefulWidget {
  const UserDealsScreen({super.key});

  @override
  State<UserDealsScreen> createState() => _DealsScreenState();
}

class _DealsScreenState extends State<UserDealsScreen> {
  final Color primaryDark = const Color(0xFF0F172A);
  final Color accentCyan = const Color(0xFF00E5FF);
  final Color glassWhite = Colors.white.withOpacity(0.9);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer:  const CustomDrawer(initialRoute: 'user.deals'),
      body:   CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverAppBar(
            expandedHeight: 170.0,
            pinned: true,
            elevation: 0,
            backgroundColor: primaryDark,
            stretch: true,
            centerTitle: true,
            leading: Builder(
              builder: (context) => IconButton(
                icon: const Icon(Icons.align_horizontal_left, color: Colors.white, size: 28),
                onPressed: () => Scaffold.of(context).openDrawer(),
              ),
            ),
            flexibleSpace: FlexibleSpaceBar(
              centerTitle: true,
              titlePadding:  const EdgeInsets.only(bottom: 16),
              title: Text("Deals", style: GoogleFonts.montserrat(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w800, letterSpacing: 2)),
            ),
          ),

        ],
      ),
    );
  }
}
