import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class OurFeaturedServicesScreen extends StatefulWidget {
  const OurFeaturedServicesScreen({super.key});

  @override
  State<OurFeaturedServicesScreen> createState() => _OurFeaturedServicesScreenState();
}

class _OurFeaturedServicesScreenState extends State<OurFeaturedServicesScreen> {
  final List<Map<String, String>> services = [
    {
      "name": "Luxury Concierge",
      "desc": "24/7 personal assistance for your elite lifestyle.",
      "img": "assets/banner1.png"
    },
    {
      "name": "Elite Transport",
      "desc": "Private jets and luxury cars at your fingertips.",
      "img": "assets/banner2.png"
    },
    {
      "name": "Heritage Tours",
      "desc": "Exclusive access to world-renowned heritage sites.",
      "img": "assets/construction.png"
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDFDFD),
      body: CustomScrollView(
        // AA CHANGE: Content ochu hoy to pan scroll thava dese
        physics: const AlwaysScrollableScrollPhysics(
          parent: BouncingScrollPhysics(),
        ),
        slivers: [
          SliverAppBar(
            expandedHeight: 140, // Height thodi vadhari jethi transition vadhare dekhay
            pinned: true,
            stretch: true, // Stretch effect mate
            backgroundColor: const Color(0xFFFDFDFD),
            surfaceTintColor: Colors.transparent, // Scroll thay tyare color na badlay
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new, color: Color(0xFF0D1B1E), size: 18),
              onPressed: () => Navigator.pop(context),
            ),
            flexibleSpace: FlexibleSpaceBar(
              centerTitle: true,
              // Mode set karyo jethi title upar jatu dekhay
              collapseMode: CollapseMode.pin,
              titlePadding: const EdgeInsets.only(bottom: 15),
              title: Text(
                "FEATURED SERVICES",
                style: GoogleFonts.montserrat(
                  letterSpacing: 2,
                  fontWeight: FontWeight.w900,
                  fontSize: 14,
                  color: const Color(0xFF0D1B1E),
                ),
              ),
            ),
          ),

          // Services List
          SliverPadding(
            padding: const EdgeInsets.only(left: 45, right: 20, top: 20),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                    (context, index) {
                  // Testing mate items vadhari didhi chhe
                  final service = services[index % services.length];
                  return _buildModernServiceCard(service);
                },
                childCount: 10, // Items vadhari do scroll test karva mate
              ),
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 50)),
        ],
      ),
    );
  }

  Widget _buildModernServiceCard(Map<String, String> service) {
    return Container(
      margin: const EdgeInsets.only(bottom: 40),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(75, 25, 20, 25),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                bottomLeft: Radius.circular(20),
                topRight: Radius.circular(50),
                bottomRight: Radius.circular(50),
              ),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF0D1B1E).withOpacity(0.06),
                  blurRadius: 30,
                  offset: const Offset(0, 15),
                )
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        service["name"]!.toUpperCase(),
                        style: GoogleFonts.montserrat(
                          color: const Color(0xFF1A1A1A),
                          fontSize: 16,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 0.5,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        service["desc"]!,
                        style: GoogleFonts.montserrat(
                          color: Colors.grey[600],
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          height: 1.5,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 10),
                Container(
                  height: 35,
                  width: 35,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: const Color(0xFF1A1A1A).withOpacity(0.05),
                  ),
                  child: const Icon(Icons.chevron_right_rounded, color: Color(0xFF1A1A1A), size: 22),
                ),
              ],
            ),
          ),
          Positioned(
            left: -35,
            top: 10,
            bottom: 10,
            child: Container(
              width: 90,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF00ACC1).withOpacity(0.25),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  )
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(25),
                child: Image.asset(
                  service["img"]!,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}