
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../CustomeWidgets/CustomDrawer.dart';
class FavouriteScreen extends StatefulWidget {
  const FavouriteScreen({super.key});

  @override
  State<FavouriteScreen> createState() => _FavouriteScreenState();
}

class _FavouriteScreenState extends State<FavouriteScreen> {
  final Color primaryDark = const Color(0xFF0F172A);
  final Color accentCyan = const Color(0xFF00E5FF);
  final Color glassWhite = Colors.white.withOpacity(0.9);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer:  const CustomDrawer(initialRoute: 'user.favourite'),
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
              title: Text("Favourite", style: GoogleFonts.montserrat(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w800, letterSpacing: 2)),
            ),
          ),

        ],
      ),
    );
  }
}
