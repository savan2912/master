
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gotilo_new/Api/Response/Home/ResponseHomeCollection.dart';
import 'package:gotilo_new/Api/Response/Home/ResponseHomeDeal.dart';
import 'package:gotilo_new/Api/Response/Home/ResponseHomeLatestRelease.dart';
import 'package:gotilo_new/Api/Response/Home/ResponseHomeService.dart';
import 'package:gotilo_new/Api/Response/LatestListing/ResponseHomeLatestListing.dart';
import 'package:gotilo_new/Screens/AboutUs/view/AboutUsScreen.dart';
import 'package:gotilo_new/Screens/Blog/view/BlogScreen.dart';
import 'package:gotilo_new/Screens/HomeMain.dart';
import 'package:gotilo_new/Screens/PrisePlan/view/PrisePlanScreen.dart';
import 'dart:ui';
import '../Api/Response/Banner/ResponseBanner.dart';

  class ModernHeritageApp extends StatefulWidget {
    const ModernHeritageApp({super.key});



    static const Color appBg = Color(0xFFF0F4F7);
    static const Color cardColor = Colors.white;
    static const Color primaryCyan = Color(0xFF00ACC1);
    static const Color accentCyan = Color(0xFF26C6DA);
    static const Color textDark = Color(0xFF0D1B1E);
    static const Color subtleGrey = Color(0xFF90A4AE);

  @override
  State<ModernHeritageApp> createState() => _ModernHeritageAppState();
}

class _ModernHeritageAppState extends State<ModernHeritageApp> {
    int _selectedIndex = 0;
     late final List<Widget> _screens;

   @override
   void initState() {
     _screens = [
       const HomeMainScreen(),
       const AboutUsScreen(),
       // aboutUs(),
       const BlogScreen(),
       const PrisePlanScreen()
     ];
    super.initState();
   }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ModernHeritageApp.appBg,
      body: Stack(
        children: [
          IndexedStack(
            index: _selectedIndex,
            children: _screens,
          ),
          Positioned(
            bottom: 25,
            left: 20,
            right: 20,
            child: _buildGlassBottomBar(),
          ),
        ],
      ),
    );
  }

  Widget _buildGlassBottomBar() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(35),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          height: 80,
          decoration: BoxDecoration(
            color: ModernHeritageApp.textDark.withOpacity(0.85),
            borderRadius: BorderRadius.circular(35),
            border: Border.all(color: Colors.white.withOpacity(0.1), width: 1),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _navIcon(Icons.home_filled, "Home", 0),
              _navIcon(Icons.info_outline_rounded, "About", 1),
              _navIcon(Icons.auto_stories_outlined, "Blog", 2),
              _navIcon(Icons.subscriptions_outlined, "Plan", 3),
            ],
          ),
        ),
      ),
    );
  }

  Widget _navIcon(IconData icon, String label, int index) {
    bool active = _selectedIndex == index;
    return InkWell(
      onTap: () => setState(() => _selectedIndex = index),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: active ? ModernHeritageApp.accentCyan : Colors.white.withOpacity(0.4), size: 24),
          const SizedBox(height: 4),
          Text(
            label,
            style: GoogleFonts.montserrat(
              color: active ? ModernHeritageApp.accentCyan : Colors.white.withOpacity(0.4),
              fontSize: 10,
              fontWeight: active ? FontWeight.bold : FontWeight.w500,
            ),
          ),
          if (active) ...[
            const SizedBox(height: 4),
            Container(height: 4, width: 4, decoration: const BoxDecoration(color: ModernHeritageApp.accentCyan, shape: BoxShape.circle)),
          ]
        ],
      ),
    );
  }

  Widget aboutUs()
  {
    return Container(
      color: Colors.white,
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildProfessionalHeader(),
            const SizedBox(height: 30),
            _buildDiscoverySection(),
            const SizedBox(height: 40),
            _buildHowItWorksModern(),
            const SizedBox(height: 50),
            _buildStatsBanner(),
            const SizedBox(height: 50),
            _buildWhyChooseUsModern(),
            const SizedBox(height: 60),
            _buildFinalPromoBanner(),
            const SizedBox(height: 150),
          ],
        ),
      ),
    );
  }

  Widget _buildProfessionalHeader()
  {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 60, horizontal: 20),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFFF0F4F7), Colors.white],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Column(
        children: [
          Text(
            "About Our Legacy",
            style: GoogleFonts.playfairDisplay(
                fontSize: 32,
                fontWeight: FontWeight.w900,
                color: const Color(0xFF0D1B1E)
            ),
          ),
          const SizedBox(height: 12),
          Container(
            height: 3, width: 40,
            decoration: BoxDecoration(color: const Color(0xFF00ACC1), borderRadius: BorderRadius.circular(10)),
          ),
          const SizedBox(height: 15),
          Text("Home / Company / About Us", style: GoogleFonts.montserrat(fontSize: 11, color: Colors.grey[500], letterSpacing: 1.5, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }

  Widget _buildDiscoverySection()
  {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(25),
            child: Image.network(
                'https://images.unsplash.com/photo-1522202176988-66273c2fd55f?q=80&w=2071',
                height: 240, width: double.infinity, fit: BoxFit.cover
            ),
          ),
          const SizedBox(height: 30),
          Text("ABOUT OUR COMPANY", style: GoogleFonts.montserrat(fontSize: 12, fontWeight: FontWeight.bold, color: const Color(0xFF00ACC1), letterSpacing: 1.2)),
          const SizedBox(height: 8),
          Text("Discover Local Services with Gotilo", style: GoogleFonts.playfairDisplay(fontSize: 24, fontWeight: FontWeight.bold, color: const Color(0xFF0D1B1E))),
          const SizedBox(height: 15),
          Text(
            "Gotilo is your premier destination for discovering verified local businesses. We bridge the gap between quality service providers and customers looking for excellence.",
            style: GoogleFonts.montserrat(fontSize: 13, color: Colors.grey[700], height: 1.6),
          ),
        ],
      ),
    );
  }

  Widget _buildHowItWorksModern()
  {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 15),
      padding: const EdgeInsets.symmetric(vertical: 50, horizontal: 25),
      decoration: BoxDecoration(
        color: const Color(0xFF0D1B1E),
        borderRadius: BorderRadius.circular(40),
      ),
      child: Column(
        children: [
          Text("The Process", style: GoogleFonts.montserrat(color: const Color(0xFF26C6DA), fontSize: 12, fontWeight: FontWeight.w800, letterSpacing: 2)),
          const SizedBox(height: 45),
          _buildModernStep("01", "Choose Location", "Enter your location for precision.", Icons.gps_fixed_rounded),
          _buildModernStep("02", "Select Category", "AI-driven suggestions for your needs.", Icons.dashboard_customize_rounded),
          _buildModernStep("03", "Connect & Grow", "Instant results with verified listings.", Icons.bolt_rounded),
        ],
      ),
    );
  }

  Widget _buildModernStep(String num, String title, String desc, IconData icon)
  {
    return Padding(
      padding: const EdgeInsets.only(bottom: 35),
      child: Row(
        children: [
          Text(num, style: GoogleFonts.montserrat(fontSize: 30, fontWeight: FontWeight.w900, color: Colors.white.withOpacity(0.1))),
          const SizedBox(width: 15),
          Icon(icon, color: const Color(0xFF26C6DA), size: 28),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: GoogleFonts.montserrat(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                Text(desc, style: GoogleFonts.montserrat(color: Colors.white60, fontSize: 12)),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildStatsBanner()
  {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.symmetric(vertical: 25),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 20)],
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            _statItem("5K+", "Users"),
            _statItem("3K+", "Partners"),
            _statItem("50+", "Cities"),
            _statItem("4K+", "Reviews"),
          ],
        ),
      ),
    );
  }

  Widget _statItem(String val, String label)
  {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: Column(
        children: [
          Text(val, style: GoogleFonts.montserrat(fontSize: 20, fontWeight: FontWeight.w900, color: const Color(0xFF0D1B1E))),
          Text(label, style: GoogleFonts.montserrat(fontSize: 10, color: const Color(0xFF00ACC1), fontWeight: FontWeight.w700)),
        ],
      ),
    );
  }

  Widget _buildWhyChooseUsModern()
  {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Frequently Asked", style: GoogleFonts.playfairDisplay(fontSize: 26, fontWeight: FontWeight.bold)),
          const SizedBox(height: 25),
          _modernFaqTile("The Gotilo Advantage", "Premium hub for local service discovery."),
          _modernFaqTile("Security & Trust", "Every business is manually verified."),
        ],
      ),
    );
  }

  Widget _modernFaqTile(String title, String desc)
  {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      decoration: BoxDecoration(color: const Color(0xFFF8FAFB), borderRadius: BorderRadius.circular(15)),
      child: ExpansionTile(
        title: Text(title, style: GoogleFonts.montserrat(fontSize: 14, fontWeight: FontWeight.w700)),
        children: [Padding(padding: const EdgeInsets.all(15), child: Text(desc))],
      ),
    );
  }

  Widget _buildFinalPromoBanner()
  {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(30),
      decoration: BoxDecoration(
        color: const Color(0xFF0D1B1E),
        borderRadius: BorderRadius.circular(25),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Your Local Service Partner", style: GoogleFonts.montserrat(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          Text("Join thousands of satisfied users today.", style: GoogleFonts.montserrat(color: Colors.white70, fontSize: 12)),
          const SizedBox(height: 25),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF26C6DA), foregroundColor: Colors.white),
            child: const Text("Get Started Now"),
          )
        ],
      ),
    );
  }








  }