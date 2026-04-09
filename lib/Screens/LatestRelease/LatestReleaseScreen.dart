import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LatestReleaseScreen extends StatefulWidget {
  const LatestReleaseScreen({super.key});

  @override
  State<LatestReleaseScreen> createState() => _LatestReleaseScreenState();
}

class _LatestReleaseScreenState extends State<LatestReleaseScreen> {
  final List<Map<String, String>> products = [
    {
      "name": "PATEL DRY FRUIT",
      "sub": "Premium Quality Seeds & Nuts",
      "price": "₹1,200",
      "location": "Kalavad Road, Rajkot",
      "rating": "4.8",
      "img": "assets/dry.png"
    },
    {
      "name": "RAM TRAVELS",
      "sub": "Luxury Comfort & Tours",
      "price": "Starts ₹5,000",
      "location": "Race Course, Rajkot",
      "rating": "4.9",
      "img": "assets/travel.png"
    },
    {
      "name": "SKY HIGH CONSTRUCTION",
      "sub": "Luxury Residential Work",
      "price": "Starts ₹5,000",
      "location": "150ft Ring Road, Rajkot",
      "rating": "4.7",
      "img": "assets/construction.png"
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
            expandedHeight: 120,
            pinned: true,
            backgroundColor: const Color(0xFFFDFDFD),
            surfaceTintColor: const Color(0xFFFDFDFD),
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new, color: Color(0xFF0D1B1E), size: 18),
              onPressed: () => Navigator.pop(context),
            ),
            flexibleSpace: FlexibleSpaceBar(
              centerTitle: true,
              titlePadding: const EdgeInsets.only(bottom: 15),
              title: Text(
                "LATEST RELEASES",
                style: GoogleFonts.montserrat(
                  letterSpacing: 2,
                  fontWeight: FontWeight.w900,
                  fontSize: 14,
                  color: const Color(0xFF0D1B1E),
                ),
              ),
            ),
          ),

          SliverList(
            delegate: SliverChildBuilderDelegate(
                  (context, index) {
                return _buildLuxuryReleaseCard(products[index]);
              },
              childCount: products.length,
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 30)),
        ],
      ),
    );
  }

  Widget _buildLuxuryReleaseCard(Map<String, String> item) {
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 0, 20, 25),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0D1B1E).withOpacity(0.05),
            blurRadius: 20,
            offset: const Offset(0, 10),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              Container(
                height: 200,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
                  color: const Color(0xFFF5F5F5),
                  image: DecorationImage(
                    image: AssetImage(item['img']!),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Positioned(
                top: 15,
                right: 15,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.star_rounded, color: Color(0xFFFFB300), size: 18),
                      const SizedBox(width: 4),
                      Text(
                        item['rating']!,
                        style: GoogleFonts.montserrat(
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                          color: const Color(0xFF0D1B1E),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item['name']!,
                            style: GoogleFonts.montserrat(
                              fontSize: 16,
                              fontWeight: FontWeight.w900,
                              color: const Color(0xFF0D1B1E),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            item['sub']!,
                            style: GoogleFonts.montserrat(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      item['price']!,
                      style: GoogleFonts.montserrat(
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                        color: const Color(0xFF00ACC1),
                      ),
                    ),
                  ],
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 15),
                  child: Divider(height: 1, color: Color(0xFFF0F0F0)),
                ),
                Row(
                  children: [
                    const Icon(Icons.location_on_outlined, color: Color(0xFF0D1B1E), size: 16),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        item['location']!,
                        style: GoogleFonts.montserrat(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF0D1B1E).withOpacity(0.7),
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                      decoration: BoxDecoration(
                        color: const Color(0xFF1A1A1A),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Text(
                        "EXPLORE",
                        style: GoogleFonts.montserrat(
                          fontSize: 10,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                          letterSpacing: 1,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

