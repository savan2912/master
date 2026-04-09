import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gotilo_new/Screens/AllListing/AllListingScreen.dart';

class CollectionDetailScreen extends StatefulWidget {
  const CollectionDetailScreen({super.key});

  @override
  State<CollectionDetailScreen> createState() => _CollectionDetailScreenState();
}

class _CollectionDetailScreenState extends State<CollectionDetailScreen> {
  bool isSearching = false;
  final TextEditingController searchController = TextEditingController();

  final List<Map<String, String>> categories = [
    {"name": "ALL LISTING", "img": "assets/banner1.png"},
    {"name": "RESTAURANTS", "img": "assets/travel.png"},
    {"name": "FAST FOODS", "img": "assets/helth.png"},
    {"name": "CAFE", "img": "assets/education.png"},
  ];

  final List<Map<String, String>> popularItems = [
    {"name": "Gujarati Cuisine", "img": "assets/masala.png"},
    {"name": "Dosa", "img": "assets/maska.png"},
    {"name": "Chinese Cuisine", "img": "assets/bread_butter.png"},
    {"name": "Burger", "img": "assets/chesse_masala.png"},
  ];

  final List<Map<String, dynamic>> popularListings = [
    {
      "name": "RK Hotel & Garden Restaurant",
      "address": "Rajkot Hwy, Vartej, Gujarat 364060",
      "rating": "4.9",
      "city": "Rajkot",
      "img": "assets/banner1.png",
      "category": "Food & Dining"
    },
    {
      "name": "Downtown Restro Cafe",
      "address": "Opposite Marwadi Corporate House, Rajkot",
      "rating": "4.0",
      "city": "Rajkot",
      "img": "assets/banner2.png",
      "category": "Cafe"
    },
    {
      "name": "Jassi De Parathe",
      "address": "Ground Floor, Mangal Bhawan, Nirmala Road",
      "rating": "5.0",
      "city": "Rajkot",
      "img": "assets/banner3.png",
      "category": "Food & Dining"
    },
    {
      "name": "Anand Snacks & Fast Food",
      "address": "Dhanrajni Complex, Dr. Yagnik Road",
      "rating": "4.2",
      "city": "Rajkot",
      "img": "assets/banner4.png",
      "category": "Fast Food"
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDFDFD),
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverAppBar(
            expandedHeight: isSearching ? 130 : 150,
            collapsedHeight: 85,
            toolbarHeight: 80,
            pinned: true,
            stretch: true,
            backgroundColor: const Color(0xFFFDFDFD),
            elevation: 0,
            centerTitle: true,

            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new, color: Color(0xFF0D1B1E), size: 18),
              onPressed: () {
                if (isSearching) {
                  setState(() {
                    isSearching = false;
                    searchController.clear();
                  });
                } else {
                  Navigator.pop(context);
                }
              },
            ),

            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 10),
                child: IconButton(
                  icon: Icon(
                    isSearching ? Icons.close_rounded : Icons.search_rounded,
                    color: const Color(0xFF0D1B1E),
                    size: 26,
                  ),
                  onPressed: () {
                    setState(() {
                      isSearching = !isSearching;
                      if (!isSearching) searchController.clear();
                    });
                  },
                ),
              ),
            ],

            flexibleSpace: FlexibleSpaceBar(
              expandedTitleScale: 1.0,
              centerTitle: true,

              titlePadding: EdgeInsets.only(
                bottom: isSearching ? 12 : 20,
                left: 0,
                right: 0,
              ),

              title: SafeArea(
                bottom: false,
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  child: isSearching
                      ? Container(
                    key: const ValueKey("PremiumSearch"),
                    height: 44,
                    margin: const EdgeInsets.symmetric(horizontal: 55),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: const Color(0xFFE9ECEF), width: 1.2),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.04),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: TextField(
                      controller: searchController,
                      autofocus: true,
                      textAlignVertical: TextAlignVertical.center,
                      style: GoogleFonts.montserrat(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF0D1B1E),
                      ),
                      decoration: InputDecoration(
                        hintText: "Search here...",
                        hintStyle: GoogleFonts.montserrat(fontSize: 12, color: Colors.grey),
                        border: InputBorder.none,
                        prefixIcon: const Icon(Icons.search_rounded, size: 18, color: Color(0xFF0D1B1E)),
                        contentPadding: EdgeInsets.zero,
                        isDense: true,
                      ),
                    ),
                  )
                      : Text(
                    "COLLECTION DETAILS",
                    key: const ValueKey("TitleText"),
                    style: GoogleFonts.montserrat(
                      letterSpacing: 2,
                      fontWeight: FontWeight.w900,
                      fontSize: 14,
                      color: const Color(0xFF0D1B1E),
                    ),
                  ),
                ),
              ),
            ),
          ),

          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            sliver: SliverGrid(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 15,
                crossAxisSpacing: 15,
                mainAxisExtent: 180,
              ),
              delegate: SliverChildBuilderDelegate(
                    (context, index) => _buildMinimalCategoryCard(categories[index]),
                childCount: categories.length,
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: _buildSectionHeader("Discover What’s Popular", "Trending products you might like."),
          ),

          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            sliver: SliverGrid(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 15,
                crossAxisSpacing: 15,
                mainAxisExtent: 210,
              ),
              delegate: SliverChildBuilderDelegate(
                    (context, index) => _buildPremiumPopularCard(popularItems[index]),
                childCount: popularItems.length,
              ),
            ),
          ),


          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(25, 45, 25, 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Our Popular Listings",
                          style: GoogleFonts.montserrat(color: const Color(0xFF0D1B1E), fontSize: 20, fontWeight: FontWeight.w900)),
                      Text("Explore the best places in town",
                          style: GoogleFonts.montserrat(color: Colors.grey, fontSize: 12, fontWeight: FontWeight.w500)),
                    ],
                  ),
                  TextButton(
                    onPressed: () {},
                    child: Text("View All", style: GoogleFonts.montserrat(color: const Color(0xFF6C63FF), fontWeight: FontWeight.w700)),
                  )
                ],
              ),
            ),
          ),

          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                    (context, index) => _buildVerticalListingCard(popularListings[index]),
                childCount: popularListings.length,
              ),
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 100)),
        ],
      ),
    );
  }


  Widget _buildVerticalListingCard(Map<String, dynamic> item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 20,
            offset: const Offset(0, 8),
          )
        ],
      ),
      child: Column(
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(25)),
                child: Image.asset(item["img"], height: 210, width: double.infinity, fit: BoxFit.cover),
              ),
              Positioned(
                bottom: 15,
                right: 15,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
                  child: Row(
                    children: [
                      const Icon(Icons.star, color: Colors.orange, size: 16),
                      const SizedBox(width: 4),
                      Text(item["rating"], style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 13)),
                    ],
                  ),
                ),
              ),
              Positioned(
                top: 15,
                left: 15,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(color: Colors.black.withOpacity(0.6), borderRadius: BorderRadius.circular(8)),
                  child: Text(item["category"], style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),

          Padding(
            padding: const EdgeInsets.all(18),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(item["name"], style: GoogleFonts.montserrat(fontWeight: FontWeight.w800, fontSize: 17)),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          const Icon(Icons.location_on_outlined, size: 14, color: Colors.grey),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(item["address"], maxLines: 1, overflow: TextOverflow.ellipsis,
                                style: const TextStyle(color: Colors.grey, fontSize: 12)),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(color: const Color(0xFFFFEBF2), borderRadius: BorderRadius.circular(8)),
                  child: Text(item["city"], style: const TextStyle(color: Color(0xFFFF4081), fontWeight: FontWeight.w900, fontSize: 11)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  Widget _buildSectionHeader(String title, String subtitle) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(25, 40, 25, 15),
      child: Column(
        children: [
          Text(title, textAlign: TextAlign.center,
              style: GoogleFonts.montserrat(color: const Color(0xFF0D1B1E), fontSize: 24, fontWeight: FontWeight.w900, letterSpacing: -0.5)),
          const SizedBox(height: 8),
          Text(subtitle, textAlign: TextAlign.center,
              style: GoogleFonts.montserrat(color: Colors.grey[600], fontSize: 12, fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }

  Widget _buildMinimalCategoryCard(Map<String, String> cat) {
    return GestureDetector(
      onTap: () {
        Get.to(()=>const AllListingScreen());
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10, offset: const Offset(0, 5))],
        ),
        child: Column(
          children: [
            Expanded(child: ClipRRect(borderRadius: const BorderRadius.vertical(top: Radius.circular(20)), child: Image.asset(cat["img"]!, fit: BoxFit.cover, width: double.infinity))),
            Padding(padding: const EdgeInsets.all(12), child: Text(cat["name"]!, style: GoogleFonts.montserrat(fontWeight: FontWeight.w900, fontSize: 11))),
          ],
        ),
      ),
    );
  }

  Widget _buildPremiumPopularCard(Map<String, String> item) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.withOpacity(0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(child: Container(margin: const EdgeInsets.all(8), decoration: BoxDecoration(borderRadius: BorderRadius.circular(15), image: DecorationImage(image: AssetImage(item["img"]!), fit: BoxFit.cover)))),
          Padding(padding: const EdgeInsets.fromLTRB(12, 0, 12, 12), child: Text(item["name"]!, maxLines: 1, overflow: TextOverflow.ellipsis, style: GoogleFonts.montserrat(color: const Color(0xFF1A1A1A), fontSize: 12, fontWeight: FontWeight.w800))),
        ],
      ),
    );
  }
}