import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class NewlyAddedListing extends StatefulWidget {
  const NewlyAddedListing({super.key});

  @override
  State<NewlyAddedListing> createState() => _NewlyAddedListingState();
}

class _NewlyAddedListingState extends State<NewlyAddedListing> {
  final List<Map<String, String>> listings = [
    {
      "name": "The Royal Palace",
      "desc": "Experience luxury living with heritage vibes.",
      "loc": "Udaipur, Rajasthan",
      "rate": "4.9",
      "img": "assets/helth.png"
    },
    {
      "name": "Skyline Café",
      "desc": "Best premium coffee with a city view.",
      "loc": "Ahmedabad, Gujarat",
      "rate": "4.7",
      "img": "assets/education.png"
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDFDFD),
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          // Dynamic SliverAppBar
          SliverAppBar(
            expandedHeight: 120, // Height jya sudhi scroll na thay
            pinned: true,        // Scroll thaya pachi bar tya j rahese
            elevation: 0,
            backgroundColor: const Color(0xFFFDFDFD),
            surfaceTintColor: const Color(0xFFFDFDFD),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new, color: Color(0xFF0D1B1E), size: 18),
              onPressed: () => Navigator.pop(context),
            ),
            centerTitle: true,
            flexibleSpace: FlexibleSpaceBar(
              centerTitle: true,
              titlePadding: const EdgeInsets.only(bottom: 15), // Title ne bar ma set karva
              title: Text(
                "NEWLY ADDED",
                style: GoogleFonts.montserrat(
                  color: const Color(0xFF0D1B1E),
                  fontWeight: FontWeight.w900,
                  fontSize: 14,
                  letterSpacing: 2,
                ),
              ),
            ),
          ),

          // Content List
          SliverPadding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                    (context, index) {
                  return _buildOverlappingCard(listings[index]);
                },
                childCount: listings.length,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOverlappingCard(Map<String, String> item) {
    return Container(
      height: 320,
      margin: const EdgeInsets.only(bottom: 30),
      child: Stack(
        children: [
          // Background "Main" Card
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: 180,
              width: double.infinity,
              margin: const EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(40),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF0D1B1E).withOpacity(0.06),
                    blurRadius: 30,
                    offset: const Offset(0, 15),
                  )
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(25, 60, 25, 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      item["name"]!,
                      style: GoogleFonts.montserrat(
                        color: const Color(0xFF0D1B1E),
                        fontSize: 18,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      item["desc"]!,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.montserrat(
                        color: Colors.grey[500],
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 15),
                    Row(
                      children: [
                        const Icon(Icons.location_on_rounded, color: Color(0xFF00ACC1), size: 16),
                        const SizedBox(width: 5),
                        Text(
                          item["loc"]!,
                          style: GoogleFonts.montserrat(
                            color: const Color(0xFF0D1B1E).withOpacity(0.7),
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const Spacer(),
                        const Icon(Icons.arrow_forward_rounded, color: Color(0xFF1A1A1A), size: 20),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Floating Image Card (Top)
          Positioned(
            top: 0,
            left: 40,
            right: 40,
            child: Container(
              height: 200,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(35),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF0D1B1E).withOpacity(0.2),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  )
                ],
                image: DecorationImage(
                  image: AssetImage(item["img"]!),
                  fit: BoxFit.cover,
                ),
              ),
              child: Stack(
                children: [
                  // Glass Rating Tag
                  Positioned(
                    bottom: 15,
                    right: 15,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          color: Colors.white.withOpacity(0.2),
                          child: Row(
                            children: [
                              const Icon(Icons.star_rounded, color: Colors.orangeAccent, size: 16),
                              const SizedBox(width: 4),
                              Text(
                                item["rate"]!,
                                style: GoogleFonts.montserrat(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}