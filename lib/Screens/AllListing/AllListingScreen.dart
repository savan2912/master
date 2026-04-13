import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gotilo_new/Screens/AllListing/AllListingDetailScreen.dart';

class AllListingScreen extends StatefulWidget {
  const AllListingScreen({super.key});

  @override
  State<AllListingScreen> createState() => _AllListingScreenState();
}

class _AllListingScreenState extends State<AllListingScreen> {
  bool isSearching = false;
  final TextEditingController searchController = TextEditingController();

  final List<Map<String, dynamic>> allListings = [
    {
      "name": "UFO - Fries and Corn",
      "address": "150 Feet Ring Road, Rajkot",
      "rating": "3.5",
      "city": "Rajkot",
      "img": "assets/travel.png",
      "category": "Fast Food"
    },
    {
      "name": "Green Leaf Garden",
      "address": "Kalawad Road, Rajkot",
      "rating": "4.2",
      "city": "Rajkot",
      "img": "assets/dry.png",
      "category": "Garden Restaurant"
    },
    {
      "name": "Nature Velly Restaurant",
      "address": "Beside Big Bazaar, Rajkot",
      "rating": "4.5",
      "city": "Rajkot",
      "img": "assets/dry.png",
      "category": "Food & Dining"
    },
    {
      "name": "The Mad Pizza Scientist",
      "address": "Near Raiya Circle, Rajkot",
      "rating": "4.8",
      "city": "Rajkot",
      "img": "assets/masala.png",
      "category": "Pizza & Burger"
    },
    {
      "name": "UFO - Fries and Corn",
      "address": "150 Feet Ring Road, Rajkot",
      "rating": "3.5",
      "city": "Rajkot",
      "img": "assets/travel.png",
      "category": "Fast Food"
    },
    {
      "name": "Green Leaf Garden",
      "address": "Kalawad Road, Rajkot",
      "rating": "4.2",
      "city": "Rajkot",
      "img": "assets/dry.png",
      "category": "Garden Restaurant"
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F8FB),
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverAppBar(
            expandedHeight: 130,
            collapsedHeight: 80,
            toolbarHeight: 75,
            pinned: true,
            backgroundColor: const Color(0xFFF6F8FB),
            elevation: 0,
            scrolledUnderElevation: 0,
            surfaceTintColor: Colors.transparent,

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

            centerTitle: true,
            flexibleSpace: FlexibleSpaceBar(
              centerTitle: true,
              expandedTitleScale: 1.0,
              titlePadding: EdgeInsets.only(
                bottom: isSearching ? 15 : 20, // Search vakhte thodu niche set karyu
                left: 0,
                right: 0,
              ),
              title: AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: isSearching
                    ? AnimatedContainer( // ⭐ Dynamic width mate AnimatedContainer vapryu
                  duration: const Duration(milliseconds: 200),
                  key: const ValueKey("SearchBar"),
                  height: 42,
                  // ⭐ Search active hoy tyare right side actions mate 100 padding muki didhi
                  margin: const EdgeInsets.only(left: 55, right: 100),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(color: const Color(0xFFE9ECEF), width: 1.2),
                  ),
                  child: TextField(
                    controller: searchController,
                    autofocus: true,
                    textAlignVertical: TextAlignVertical.center,
                    style: GoogleFonts.montserrat(fontSize: 13, fontWeight: FontWeight.w600),
                    decoration: InputDecoration(
                      hintText: "Search...",
                      hintStyle: GoogleFonts.montserrat(fontSize: 12, color: Colors.grey),
                      border: InputBorder.none,
                      prefixIcon: const Icon(Icons.search_rounded, size: 18, color: Color(0xFF0D1B1E)),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 10), // Padding barabar kari
                      isDense: true,
                    ),
                  ),
                )
                    : Text(
                  "EXPLORE ALL",
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

            actions: [
              // --- Search Toggle Button ---
              IconButton(
                padding: EdgeInsets.zero, // Extra padding kadhi nakhi
                constraints: const BoxConstraints(),
                icon: Icon(
                  isSearching ? Icons.close_rounded : Icons.search_rounded,
                  color: const Color(0xFF0D1B1E),
                ),
                onPressed: () {
                  setState(() {
                    isSearching = !isSearching;
                    if (!isSearching) searchController.clear();
                  });
                },
              ),
              // --- Filter Button ---
              IconButton(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                constraints: const BoxConstraints(),
                icon: const Icon(Icons.filter_list_rounded, color: Color(0xFF0D1B1E)),
                onPressed: () => _showFilterBottomSheet(context),
              ),
              const SizedBox(width: 5),
            ],
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(25, 10, 25, 5),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Discover Places",
                    style: GoogleFonts.montserrat(
                      fontSize: 28,
                      fontWeight: FontWeight.w900,
                      color: const Color(0xFF0D1B1E),
                      letterSpacing: -1,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Row(
                    children: [
                      Text(
                        "Showing ",
                        style: GoogleFonts.montserrat(
                          color: Colors.grey[600],
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        "${allListings.length} results",
                        style: GoogleFonts.montserrat(
                          color: const Color(0xFF6C63FF),
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 25),
            sliver: SliverGrid(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 18,
                crossAxisSpacing: 18,
                mainAxisExtent: 260,
              ),
              delegate: SliverChildBuilderDelegate(
                    (context, index) => _buildBentoListingCard(allListings[index]),
                childCount: allListings.length,
              ),
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 50)),
        ],
      ),
    );
  }

  void _showFilterBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.7,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
          ),
          padding: const EdgeInsets.all(25),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 50,
                  height: 5,
                  decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(10)),
                ),
              ),
              const SizedBox(height: 25),
              Text("Filters", style: GoogleFonts.montserrat(fontSize: 22, fontWeight: FontWeight.w900)),
              const SizedBox(height: 25),

              _buildFilterLabel("Location"),
              _buildFilterDropdown("Select City", Icons.location_on_outlined),

              const SizedBox(height: 20),

              _buildFilterLabel("Categories"),
              _buildFilterDropdown("Select Category", Icons.category_outlined),

              const SizedBox(height: 20),

              _buildFilterLabel("Sub Categories"),
              _buildFilterDropdown("Select Sub Category", Icons.layers_outlined),

              const Spacer(),

              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0D1B1E),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                  ),
                  onPressed: () => Navigator.pop(context),
                  child: Text("APPLY FILTERS", style: GoogleFonts.montserrat(color: Colors.white, fontWeight: FontWeight.w800, letterSpacing: 1.2)),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildFilterLabel(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Text(title, style: GoogleFonts.montserrat(fontSize: 15, fontWeight: FontWeight.w700, color: Colors.grey[800])),
    );
  }

  Widget _buildFilterDropdown(String hint, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFF6F8FB),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          Icon(icon, size: 20, color: const Color(0xFF0D1B1E)),
          const SizedBox(width: 12),
          Text(hint, style: GoogleFonts.montserrat(color: Colors.grey[600], fontSize: 14, fontWeight: FontWeight.w500)),
          const Spacer(),
          const Icon(Icons.keyboard_arrow_down_rounded, color: Colors.grey),
        ],
      ),
    );
  }

  Widget _buildBentoListingCard(Map<String, dynamic> item) {
    return GestureDetector(
      onTap: () {
        Get.to(()=>const AllListingDetailScreen());
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(25),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF0D1B1E).withOpacity(0.04),
              blurRadius: 15,
              offset: const Offset(0, 8),
            )
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 5,
              child: Container(
                margin: const EdgeInsets.all(8),
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Image.asset(
                          item["img"],
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              Container(color: Colors.grey[100], child: const Icon(Icons.image)),
                        ),
                      ),
                    ),
                    Positioned(
                      top: 8,
                      right: 8,
                      child: Column(
                        children: [
                          _buildGlassActionButton(icon: Icons.favorite_border_rounded, onTap: () {}),
                          const SizedBox(height: 8),
                          _buildGlassActionButton(icon: Icons.share_outlined, onTap: () {}),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              flex: 4,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(15, 2, 15, 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item["category"].toString().toUpperCase(),
                          style: GoogleFonts.montserrat(
                            fontSize: 9,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF6C63FF),
                            letterSpacing: 1.2,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          item["name"],
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.montserrat(
                            fontWeight: FontWeight.w800,
                            fontSize: 13,
                            color: const Color(0xFF0D1B1E),
                            height: 1.2,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.star_rounded, color: Colors.orange, size: 16),
                            const SizedBox(width: 2),
                            Text(item["rating"], style: GoogleFonts.montserrat(fontWeight: FontWeight.w800, fontSize: 12)),
                          ],
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFFEBF2),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            item["city"],
                            style: GoogleFonts.montserrat(
                              color: const Color(0xFFFF4081),
                              fontWeight: FontWeight.w900,
                              fontSize: 10,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGlassActionButton({required IconData icon, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.3),
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white.withOpacity(0.2), width: 0.5),
        ),
        child: Icon(icon, color: Colors.white, size: 16),
      ),
    );
  }
}