import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AboutUsScreen extends StatelessWidget {
  const AboutUsScreen({super.key});

  // કલર થીમ
  static const Color appBg = Color(0xFFF0F4F7);
  static const Color textDark = Color(0xFF0D1B1E);
  static const Color primaryCyan = Color(0xFF00ACC1);
  static const Color accentCyan = Color(0xFF26C6DA);
  static const Color subtleGrey = Color(0xFF90A4AE);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appBg,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          // ૧. મસ્ત નાની એપબાર
          SliverAppBar(
            pinned: true,
            backgroundColor: appBg.withOpacity(0.9),
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new_rounded, color: textDark, size: 20),
              onPressed: () => Navigator.pop(context),
            ),
            title: Text("About Us",
                style: GoogleFonts.montserrat(color: textDark, fontWeight: FontWeight.bold, fontSize: 18)),
            centerTitle: true,
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),

                  // ૨. મેઈન બેનર સેક્શન (Image + Title)
                  _buildMainIntro(),

                  const SizedBox(height: 40),

                  // ૩. Stats સેક્શન (5000+ Customers etc.)
                  _buildStatsGrid(),

                  const SizedBox(height: 50),

                  // ૪. How It Works (Dark Theme Box)
                  _buildDarkHowItWorks(),

                  const SizedBox(height: 50),

                  // ૫. Why Choose Us / FAQ Section
                  _buildFaqSection(),

                  const SizedBox(height: 120), // બોટમ બાર માટે જગ્યા
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // --- Intro Section ---
  Widget _buildMainIntro() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(25),
          child: Image.network(
            'https://images.unsplash.com/photo-1522202176988-66273c2fd55f?w=800&q=80', // તમારી ઈમેજ અહીં મુકવી
            height: 200, width: double.infinity, fit: BoxFit.cover,
          ),
        ),
        const SizedBox(height: 25),
        Text("Discover Local Services\nwith Gotilo",
            style: GoogleFonts.playfairDisplay(fontSize: 28, fontWeight: FontWeight.w900, color: textDark, height: 1.2)),
        const SizedBox(height: 15),
        Text(
          "Welcome to Gotilo – your all-in-one platform for finding the best local businesses and service providers across a wide range of categories.",
          style: GoogleFonts.montserrat(color: subtleGrey, fontSize: 14, height: 1.6),
        ),
      ],
    );
  }

  // --- Stats Grid (4 items) ---
  Widget _buildStatsGrid() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _statItem("5000+", "Happy Customers", Icons.people_alt_outlined),
        _statItem("3000+", "Verified Biz", Icons.verified_user_outlined),
        _statItem("50+", "Cities Covered", Icons.location_city_outlined),
      ],
    );
  }

  Widget _statItem(String count, String label, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: primaryCyan, size: 28),
        const SizedBox(height: 10),
        Text(count, style: GoogleFonts.montserrat(fontWeight: FontWeight.w800, fontSize: 18, color: textDark)),
        Text(label, style: GoogleFonts.montserrat(fontSize: 10, color: subtleGrey, fontWeight: FontWeight.w600)),
      ],
    );
  }

  // --- Dark How It Works Section (Based on Image 1) ---
  Widget _buildDarkHowItWorks() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(25),
      decoration: BoxDecoration(
        color: textDark,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [BoxShadow(color: primaryCyan.withOpacity(0.2), blurRadius: 20, offset: const Offset(0, 10))],
      ),
      child: Column(
        children: [
          RichText(
            text: TextSpan(
                style: GoogleFonts.montserrat(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
                children: [
                  const TextSpan(text: "How Gotilo "),
                  TextSpan(text: "Works", style: TextStyle(color: accentCyan)),
                ]
            ),
          ),
          const SizedBox(height: 30),
          _stepRow("01", "Choose Location", "Enter mobile to start."),
          _stepRow("02", "Pick Category", "Select relevant category."),
          _stepRow("03", "Explore Place", "Find your best match."),
        ],
      ),
    );
  }

  Widget _stepRow(String num, String title, String sub) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Row(
        children: [
          Text(num, style: GoogleFonts.montserrat(color: accentCyan.withOpacity(0.3), fontSize: 24, fontWeight: FontWeight.w900)),
          const SizedBox(width: 20),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: GoogleFonts.montserrat(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15)),
              Text(sub, style: GoogleFonts.montserrat(color: Colors.white54, fontSize: 12)),
            ],
          )
        ],
      ),
    );
  }

  // --- FAQ Section ---
  Widget _buildFaqSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Why Choose Gotilo?", style: GoogleFonts.montserrat(fontSize: 18, fontWeight: FontWeight.bold, color: textDark)),
        const SizedBox(height: 20),
        _faqTile("What is Gotilo and how it helps?", "Gotilo is a local search engine designed to connect you with trusted businesses."),
        _faqTile("How does loyalty program work?", "You earn points for every service you book through our platform."),
        _faqTile("Is it free for users?", "Yes, Gotilo is completely free for customers to search and discover."),
      ],
    );
  }

  Widget _faqTile(String question, String answer) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(15)),
      child: ExpansionTile(
        shape: const Border(),
        title: Text(question, style: GoogleFonts.montserrat(fontSize: 14, fontWeight: FontWeight.w600, color: textDark)),
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Text(answer, style: GoogleFonts.montserrat(fontSize: 13, color: subtleGrey)),
          )
        ],
      ),
    );
  }
}