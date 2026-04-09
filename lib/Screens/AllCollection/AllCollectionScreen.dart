import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gotilo_new/Screens/AllCollection/CollectionDetailScreen.dart';

class AllCollectionScreen extends StatefulWidget {
  const AllCollectionScreen({super.key});

  @override
  State<AllCollectionScreen> createState() => _AllCollectionScreenState();
}

class _AllCollectionScreenState extends State<AllCollectionScreen> {
  final List<Map<String, dynamic>> categories = [
    {"name": "Food & Dining", "icon": "assets/food_c.svg", "items": "120", "color": const Color(0xFFFF9E80)},
    {"name": "Global Travel", "icon": "assets/travel_c.svg", "items": "85", "color": const Color(0xFF81C784)},
    {"name": "Health Care", "icon": "assets/health_c.svg", "items": "24", "color": const Color(0xFFF06292)},
    {"name": "Education", "icon": "assets/education_c.svg", "items": "56", "color": const Color(0xFF64B5F6)},
    {"name": "Lifestyle", "icon": "assets/food_c.svg", "items": "45", "color": const Color(0xFFBA68C8)},
    {"name": "Tech Gadgets", "icon": "assets/travel_c.svg", "items": "77", "color": const Color(0xFF4DD0E1)},
    {"name": "Finance", "icon": "assets/health_c.svg", "items": "32", "color": const Color(0xFFFFD54F)},
    {"name": "Music", "icon": "assets/education_c.svg", "items": "150", "color": const Color(0xFF90A4AE)},
  ];

  bool isSearching = false;
  TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDFDFD),
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverAppBar(
            expandedHeight: 130,
            collapsedHeight: 80,
            toolbarHeight: 75,
            pinned: true,
            floating: false,
            backgroundColor: const Color(0xFFFDFDFD),
            elevation: 0,
            surfaceTintColor: const Color(0xFFFDFDFD),
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
                    size: 28, // Thodu motu icon
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
              centerTitle: true,
              expandedTitleScale: 1.0,

              titlePadding: EdgeInsets.only(
                bottom: isSearching ? 12 : 20,
                left: 0,
                right: 0,
              ),

              title: AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: isSearching
                    ? Container(
                  key: const ValueKey("PremiumSearch"),
                  height: 45,
                  margin: const EdgeInsets.symmetric(horizontal: 55),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(color: const Color(0xFFE9ECEF), width: 1.5),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: TextField(
                    controller: searchController,
                    autofocus: true,
                    textAlignVertical: TextAlignVertical.center,
                    style: GoogleFonts.montserrat(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF0D1B1E),
                    ),
                    decoration: InputDecoration(
                      hintText: "Search here...",
                      hintStyle: GoogleFonts.montserrat(
                        fontSize: 13,
                        color: Colors.grey.shade400,
                      ),
                      border: InputBorder.none,
                      prefixIcon: const Icon(
                        Icons.search_rounded,
                        size: 20,
                        color: Color(0xFF0D1B1E),
                      ),
                      contentPadding: EdgeInsets.zero,
                      isDense: true,
                    ),
                  ),
                )
                    : Text(
                  "COLLECTIONS",
                  key: const ValueKey("TitleText"),
                  style: GoogleFonts.montserrat(
                    letterSpacing: 3,
                    fontWeight: FontWeight.w900,
                    fontSize: 15,
                    color: const Color(0xFF0D1B1E),
                  ),
                ),
              ),
            ),
          ),


          SliverPadding(
            padding:
            const EdgeInsets.fromLTRB(
                20, 0, 20, 20),
            sliver: SliverGrid(
              gridDelegate:
              const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 15,
                crossAxisSpacing: 15,
                mainAxisExtent: 190,
              ),
              delegate:
              SliverChildBuilderDelegate(
                    (context, index) {
                  final cat = categories[
                  index %
                      categories.length];
                  bool isEven =
                      index % 2 == 0;

                  return _buildLuxuryCompactCard(
                      cat, isEven);
                },
                childCount: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }
  Widget _buildLuxuryCompactCard(Map<String, dynamic> cat, bool isEven) {
    return GestureDetector(
      onTap: () {
          Get.to(()=> const CollectionDetailScreen());
        },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(35),
            bottomRight: const Radius.circular(35),
            topRight: Radius.circular(isEven ? 12 : 35),
            bottomLeft: Radius.circular(isEven ? 35 : 12),
          ),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF0D1B1E).withOpacity(0.06),
              blurRadius: 15,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(35),
            bottomRight: const Radius.circular(35),
            topRight: Radius.circular(isEven ? 12 : 35),
            bottomLeft: Radius.circular(isEven ? 35 : 12),
          ),
          child: Stack(
            children: [
              Positioned(
                top: -20,
                right: -20,
                child: CircleAvatar(
                  radius: 50,
                  backgroundColor: cat['color'].withOpacity(0.1),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 52,
                      width: 52,
                      decoration: BoxDecoration(
                          color: const Color(0xFF1A1A1A),
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: cat['color'].withOpacity(0.3),
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            )
                          ]
                      ),
                      padding: const EdgeInsets.all(10),
                      child: SvgPicture.asset(
                        cat['icon'],
                        colorFilter: ColorFilter.mode(cat['color'], BlendMode.srcIn),
                      ),
                    ),
                    const Spacer(),
                    Text(
                      cat['name'],
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.montserrat(
                        color: const Color(0xFF0D1B1E),
                        fontSize: 14,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: const Color(0xFF1A1A1A).withOpacity(0.08), width: 1.2),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 5,
                            height: 5,
                            decoration: BoxDecoration(
                              color: cat['color'],
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            "${cat['items']} ITEMS",
                            style: GoogleFonts.montserrat(
                              color: const Color(0xFF1A1A1A),
                              fontSize: 8,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}