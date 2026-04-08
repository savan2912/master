import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

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
    {"name": "Food & Dining", "icon": "assets/food_c.svg", "items": "120", "color": const Color(0xFFFF9E80)},
    {"name": "Global Travel", "icon": "assets/travel_c.svg", "items": "85", "color": const Color(0xFF81C784)},
    {"name": "Health Care", "icon": "assets/health_c.svg", "items": "24", "color": const Color(0xFFF06292)},
    {"name": "Education", "icon": "assets/education_c.svg", "items": "56", "color": const Color(0xFF64B5F6)},
    {"name": "Food & Dining", "icon": "assets/food_c.svg", "items": "120", "color": const Color(0xFFFF9E80)},
    {"name": "Global Travel", "icon": "assets/travel_c.svg", "items": "85", "color": const Color(0xFF81C784)},
    {"name": "Health Care", "icon": "assets/health_c.svg", "items": "24", "color": const Color(0xFFF06292)},
    {"name": "Education", "icon": "assets/education_c.svg", "items": "56", "color": const Color(0xFF64B5F6)},
    {"name": "Food & Dining", "icon": "assets/food_c.svg", "items": "120", "color": const Color(0xFFFF9E80)},
    {"name": "Global Travel", "icon": "assets/travel_c.svg", "items": "85", "color": const Color(0xFF81C784)},
    {"name": "Health Care", "icon": "assets/health_c.svg", "items": "24", "color": const Color(0xFFF06292)},
    {"name": "Education", "icon": "assets/education_c.svg", "items": "56", "color": const Color(0xFF64B5F6)},
    {"name": "Food & Dining", "icon": "assets/food_c.svg", "items": "120", "color": const Color(0xFFFF9E80)},
    {"name": "Global Travel", "icon": "assets/travel_c.svg", "items": "85", "color": const Color(0xFF81C784)},
    {"name": "Health Care", "icon": "assets/health_c.svg", "items": "24", "color": const Color(0xFFF06292)},
    {"name": "Education", "icon": "assets/education_c.svg", "items": "56", "color": const Color(0xFF64B5F6)},

    // Copying items for demo (20+ categories)
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDFDFD), // Pure Pearl Light Background
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverAppBar(
            expandedHeight: 140,
            floating: true,
            pinned: true,
            backgroundColor: const Color(0xFFFDFDFD),
            elevation: 0,
            flexibleSpace: FlexibleSpaceBar(
              centerTitle: true,
              title: Text(
                "COLLECTIONS",
                style: GoogleFonts.montserrat(
                  letterSpacing: 3,
                  fontWeight: FontWeight.w900,
                  fontSize: 15,
                  color: const Color(0xFF0D1B1E),
                ),
              ),
            ),
            leading: Padding(
              padding: const EdgeInsets.only(left: 10),
              child: IconButton(
                icon: const Icon(Icons.arrow_back_ios_new, color: Color(0xFF0D1B1E), size: 20),
                onPressed: () => Navigator.pop(context),
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 30),
            sliver: SliverGrid(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 25,
                crossAxisSpacing: 20,
                mainAxisExtent: 240, // Keeping cards slightly taller
              ),
              delegate: SliverChildBuilderDelegate(
                    (context, index) {
                  final cat = categories[index % categories.length];
                  // Design Variation Logic
                  bool isEven = index % 2 == 0;
                  return _buildLuxuryLightCard(cat, isEven);
                },
                childCount: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLuxuryLightCard(Map<String, dynamic> cat, bool isEven) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: const Radius.circular(50),
          bottomRight: const Radius.circular(50),
          topRight: Radius.circular(isEven ? 15 : 50),
          bottomLeft: Radius.circular(isEven ? 50 : 15),
        ),
        boxShadow: [
          BoxShadow(
            // Halko dark shadow jethi depth aave
            color: const Color(0xFF0D1B1E).withOpacity(0.08),
            blurRadius: 25,
            offset: const Offset(0, 15),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.only(
          topLeft: const Radius.circular(50),
          bottomRight: const Radius.circular(50),
          topRight: Radius.circular(isEven ? 15 : 50),
          bottomLeft: Radius.circular(isEven ? 50 : 15),
        ),
        child: Stack(
          children: [
            // Background Gradient Blob (Thodo dark shade)
            Positioned(
              top: -30,
              right: -30,
              child: CircleAvatar(
                radius: 65,
                backgroundColor: cat['color'].withOpacity(0.12),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(22.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Icon Holder - Jema Black Shade vapryo chhe
                  Container(
                    height: 55,
                    width: 55,
                    decoration: BoxDecoration(
                        color: const Color(0xFF1A1A1A), // Deep Black/Dark Grey
                        borderRadius: BorderRadius.circular(22),
                        boxShadow: [
                          BoxShadow(
                            color: cat['color'].withOpacity(0.4),
                            blurRadius: 12,
                            offset: const Offset(0, 5),
                          )
                        ]
                    ),
                    padding: const EdgeInsets.all(14),
                    child: SvgPicture.asset(
                      cat['icon'],
                      // Icon color pastel rakhiye jethi black par khile
                      colorFilter: ColorFilter.mode(cat['color'], BlendMode.srcIn),
                      placeholderBuilder: (_) => Icon(Icons.category, color: cat['color']),
                    ),
                  ),
                  const Spacer(),
                  // Name in Strong Dark Color
                  Text(
                    cat['name'],
                    style: GoogleFonts.montserrat(
                      color: const Color(0xFF0D1B1E),
                      fontSize: 16,
                      fontWeight: FontWeight.w900, // Extra bold
                      letterSpacing: -0.5,
                    ),
                  ),
                  const SizedBox(height: 6),
                  // Item Chip - Black Outline sathe
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: const Color(0xFF1A1A1A).withOpacity(0.1), width: 1.5),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 6,
                          height: 6,
                          decoration: BoxDecoration(
                            color: cat['color'],
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          "${cat['items']} ITEMS",
                          style: GoogleFonts.montserrat(
                            color: const Color(0xFF1A1A1A),
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.5,
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
    );
  }
}