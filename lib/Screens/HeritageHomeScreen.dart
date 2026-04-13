
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gotilo_new/Api/Response/Home/ResponseHomeCollection.dart';
import 'package:gotilo_new/Api/Response/Home/ResponseHomeDeal.dart';
import 'package:gotilo_new/Api/Response/Home/ResponseHomeLatestRelease.dart';
import 'package:gotilo_new/Api/Response/Home/ResponseHomeService.dart';
import 'package:gotilo_new/Api/Response/LatestListing/ResponseHomeLatestListing.dart';
import 'package:gotilo_new/Screens/HomeMain.dart';
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



    ValueNotifier<bool> isApiComplete=ValueNotifier(false);
    ValueNotifier<bool> isDataAvailable=ValueNotifier(false);

    ValueNotifier<bool> isCollectionApiComplete=ValueNotifier(false);
    ValueNotifier<bool> isCollectionDataAvailable=ValueNotifier(false);

    ValueNotifier<bool> isLatestListingDataAvailable=ValueNotifier(false);
    ValueNotifier<bool> isLatestListingApiAvailable=ValueNotifier(false);

    ValueNotifier<bool> isLatestReleaseDataAvailable=ValueNotifier(false);
    ValueNotifier<bool> isLatestReleaseApiAvailable=ValueNotifier(false);

    ValueNotifier<bool> isHomeServiceDataAvailable=ValueNotifier(false);
    ValueNotifier<bool> isHomeServiceApiAvailable=ValueNotifier(false);

    ValueNotifier<bool> isHomeDealDataAvailable=ValueNotifier(false);
    ValueNotifier<bool> isHomeDealApiAvailable=ValueNotifier(false);


    ValueNotifier<bool> isAllApiComplete=ValueNotifier(false);

  List<BannerData>? banner;
  List<HomeCollection>? homeCollection;
  List<HomeNearListing>? homeNearListing;
  List<HomeLatestRelease>? homeLatestRelease;
  List<HomeService>? homeService;
  List<HomeDeal>? homeDeal;
  bool _isSearching = false;
  final TextEditingController _searchController = TextEditingController();
  int _selectedIndex = 0;
  late final List<Widget> _screens;

   @override
   void initState() {
     _screens = [
       HomeMainScreen(),
       aboutUs(),
       blog(),
       planWidget()
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

          if (_isSearching) _buildSearchOverlay(),

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

  Widget _buildSearchOverlay() {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: const Duration(milliseconds: 300),
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10 * value, sigmaY: 10 * value),
            child: Container(
              color: ModernHeritageApp.appBg.withOpacity(0.8),
              padding: EdgeInsets.only(
                  top: MediaQuery.of(context).padding.top + 10,
                  left: 20,
                  right: 20
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          height: 55,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: 20,
                                  offset: const Offset(0, 10)
                              )
                            ],
                          ),
                          child: TextField(
                            controller: _searchController,
                            autofocus: true,
                            style: GoogleFonts.montserrat(
                                color: ModernHeritageApp.textDark,
                                fontWeight: FontWeight.w600
                            ),
                            decoration: InputDecoration(
                              hintText: "Search GOTILO...",
                              hintStyle: GoogleFonts.montserrat(color: Colors.grey),
                              prefixIcon: const Icon(Icons.search_rounded, color: ModernHeritageApp.primaryCyan),
                              border: InputBorder.none,
                              contentPadding: const EdgeInsets.symmetric(vertical: 18),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 15),

                      GestureDetector(
                        onTap: () {
                          setState(() {
                            _isSearching = false;
                            _searchController.clear();
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: const BoxDecoration(
                              color: ModernHeritageApp.textDark,
                              shape: BoxShape.circle
                          ),
                          child: const Icon(Icons.close_rounded, color: Colors.white, size: 24),
                        ),
                      ),
                    ],
                  ),

                ],
              ),
            ),
          ),
        );
      },
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

  Widget blog()
  {
    return Container(
      color: Colors.white,
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            _buildBlogHeader(),

            const SizedBox(height: 20),

            _buildFeaturedBlog(),

            const SizedBox(height: 30),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                "Latest Updates",
                style: GoogleFonts.playfairDisplay(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF0D1B1E),
                ),
              ),
            ),


            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: 5,
              itemBuilder: (context, index) {
                return _buildPremiumBlogCard(index);
              },
            ),

            const SizedBox(height: 120),
          ],
        ),
      ),
    );
  }

  Widget _buildBlogHeader()
  {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 40),
      decoration: BoxDecoration(
        color: const Color(0xFFF0F4F7).withOpacity(0.5),
      ),
      child: Column(
        children: [
          Text(
            "Our Blog",
            style: GoogleFonts.montserrat(
              fontSize: 26,
              fontWeight: FontWeight.w900,
              color: const Color(0xFF0D1B1E),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "Home > Blog",
            style: GoogleFonts.montserrat(
              fontSize: 11,
              color: Colors.grey[600],
              fontWeight: FontWeight.w600,
              letterSpacing: 1,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeaturedBlog()
  {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      height: 380,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        image: const DecorationImage(
          image: NetworkImage('https://images.unsplash.com/photo-1542038784456-1ea8e935640e?q=80&w=2070'),
          fit: BoxFit.cover,
        ),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.transparent, Colors.black.withOpacity(0.8)],
          ),
        ),
        padding: const EdgeInsets.all(25),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: const Color(0xFF00ACC1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                "FEATURED",
                style: GoogleFonts.montserrat(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 15),
            Text(
              "Find the Best Supermarkets Near You with Gotilo",
              style: GoogleFonts.playfairDisplay(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              "12 Mar 2026 • 5 min read",
              style: GoogleFonts.montserrat(color: Colors.white70, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPremiumBlogCard(int index)
  {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 20,
            offset: const Offset(0, 10),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(25)),
            child: Stack(
              children: [
                Image.network(
                  'https://images.unsplash.com/photo-1556742049-0cfed4f6a45d?q=80&w=1974', // તમારી ઈમેજ મુજબ બદલવું
                  height: 200,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
                Positioned(
                  top: 15,
                  right: 15,
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                    child: const Icon(Icons.bookmark_border_rounded, color: Color(0xFF00ACC1), size: 20),
                  ),
                ),
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.calendar_today_outlined, size: 12, color: Color(0xFFFF4081)),
                    const SizedBox(width: 5),
                    Text(
                      "11 Mar 2026",
                      style: GoogleFonts.montserrat(fontSize: 11, fontWeight: FontWeight.w600, color: Colors.grey),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  "Boost Your Business with Gotilo Loyalty Program",
                  style: GoogleFonts.playfairDisplay(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF0D1B1E),
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  "Build stronger relationships with your customers through our unique rewards system...",
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.montserrat(fontSize: 13, color: Colors.grey[600], height: 1.5),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "READ MORE",
                      style: GoogleFonts.montserrat(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF00ACC1),
                        letterSpacing: 1,
                      ),
                    ),
                    const Icon(Icons.arrow_forward_ios_rounded, size: 14, color: Color(0xFF00ACC1)),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget planWidget()
  {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFFF8FAFB), Colors.white],
        ),
      ),
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            const SizedBox(height: 80),

            _buildPlanHeader(),

            const SizedBox(height: 50),

            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              physics: const BouncingScrollPhysics(),
              child: Row(
                children: [
                  _buildPricingCard(
                    title: "Gotilo Introductory",
                    price: "15000.00",
                    tagColor: const Color(0xFF00ACC1),
                    features: ["Listing in up to 1 city", "Search Visibility", "Online Catalogue", "Smart Lead System", "Create Deals", "Autopilot System", "Level 1"],
                  ),
                  _buildPricingCard(
                    title: "City Explorer Package",
                    price: "25000.00",
                    tagColor: const Color(0xFF006064),
                    isFeatured: true,
                    features: ["Listing in up to 5 city", "Search Visibility", "Online Catalogue", "Smart Lead System", "Customer Retention", "WhatsApp Integration", "Level 1"],
                  ),
                  _buildPricingCard(
                    title: "City Pro Package",
                    price: "40000.00",
                    tagColor: const Color(0xFF26C6DA),
                    features: ["Listing in up to 10 city", "Search Visibility", "Priority Support", "Autopilot System", "Text Messages", "Email Notification", "Level 1"],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 150),
          ],
        ),
      ),
    );
  }


  Widget _buildPlanHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: Column(
        children: [
          RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              style: GoogleFonts.montserrat(
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                  color: const Color(0xFF0D1B1E),
                  letterSpacing: -0.5
              ),
              children: [
                const TextSpan(text: "We Have Excellent "),
                TextSpan(
                    text: "Packages For You",
                    style: TextStyle(color: Colors.pinkAccent[400])
                ),
              ],
            ),
          ),
          const SizedBox(height: 15),
          Text(
            "Get the Best Deals with Our Outstanding Packages!",
            textAlign: TextAlign.center,
            style: GoogleFonts.montserrat(
                fontSize: 13,
                color: Colors.grey[500],
                fontWeight: FontWeight.w500,
                height: 1.5
            ),
          ),
        ],
      ),
    );
  }


  Widget _buildPricingCard({
    required String title,
    required String price,
    required Color tagColor,
    required List<String> features,
    bool isFeatured = false,
  })
  {
    return Container(
      width: 320,
      margin: const EdgeInsets.symmetric(horizontal: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(35),
        boxShadow: [
          BoxShadow(
            color: isFeatured ? tagColor.withOpacity(0.15) : Colors.black.withOpacity(0.04),
            blurRadius: 30,
            offset: const Offset(0, 15),
          ),
        ],
        border: isFeatured ? Border.all(color: tagColor.withOpacity(0.3), width: 1.5) : null,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(35),
        child: Stack(
          children: [
            Positioned(
              top: -50,
              right: -50,
              child: Container(
                height: 150,
                width: 150,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [tagColor.withOpacity(0.1), Colors.transparent],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(colors: [tagColor, tagColor.withOpacity(0.8)]),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      title.toUpperCase(),
                      style: GoogleFonts.montserrat(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w800, letterSpacing: 1),
                    ),
                  ),
                  const SizedBox(height: 30),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: [
                      Text("₹ ", style: GoogleFonts.montserrat(fontSize: 20, fontWeight: FontWeight.bold, color: const Color(0xFF0D1B1E))),
                      Text(price, style: GoogleFonts.montserrat(fontSize: 34, fontWeight: FontWeight.w900, color: const Color(0xFF0D1B1E))),
                      Text(" + GST", style: GoogleFonts.montserrat(fontSize: 12, color: Colors.grey[500], fontWeight: FontWeight.w600)),
                    ],
                  ),
                  const SizedBox(height: 20),
                  const Divider(thickness: 0.5),
                  const SizedBox(height: 20),
                  ...features.map((f) => Padding(
                    padding: const EdgeInsets.only(bottom: 18),
                    child: Row(
                      children: [
                        Icon(Icons.verified_rounded, color: tagColor, size: 20),
                        const SizedBox(width: 15),
                        Expanded(child: Text(f, style: GoogleFonts.montserrat(fontSize: 13, color: const Color(0xFF455A64), fontWeight: FontWeight.w500))),
                      ],
                    ),
                  )),
                  const SizedBox(height: 25),
                  Container(
                    width: double.infinity,
                    height: 55,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(18),
                      gradient: LinearGradient(
                        colors: isFeatured
                            ? [tagColor, const Color(0xFF0D1B1E)]
                            : [const Color(0xFF0D1B1E), const Color(0xFF37474F)],
                      ),
                      boxShadow: [
                        BoxShadow(color: tagColor.withOpacity(0.3), blurRadius: 12, offset: const Offset(0, 6))
                      ],
                    ),
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Choose Plan", style: GoogleFonts.montserrat(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 16)),
                          const SizedBox(width: 12),
                          const Icon(Icons.arrow_forward_rounded, color: Colors.white, size: 20),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  }