import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DealsScreen extends StatefulWidget {
  const DealsScreen({super.key});

  @override
  State<DealsScreen> createState() => _DealsScreenState();
}

class _DealsScreenState extends State<DealsScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final List<Map<String, String>> allDeals = [
    {"title": "Royal Heritage Watch", "offer": "FLAT 40% OFF", "expiry": "Ends in 02h 45m", "img": "assets/banner1.png"},
    {"title": "Elite Travels Package", "offer": "SAVE ₹5,000", "expiry": "Limited Slots", "img": "assets/travel.png"},
  ];

  final List<Map<String, String>> nearbyDeals = [
    {"title": "Ahmedabad Dining", "offer": "2-FOR-1 DEAL", "expiry": "Valid Today", "img": "assets/banner2.png"},
    {"title": "Rajkot Spa Retreat", "offer": "FLAT 30% OFF", "expiry": "Ends in 05h", "img": "assets/banner3.png"},
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDFDFD),
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverAppBar(
            expandedHeight: 180,
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
              titlePadding: const EdgeInsets.only(bottom: 75),
              title: Text(
                "EXCLUSIVE DEALS",
                style: GoogleFonts.montserrat(
                  letterSpacing: 2,
                  fontWeight: FontWeight.w900,
                  fontSize: 14,
                  color: const Color(0xFF0D1B1E),
                ),
              ),
            ),
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(70),
              child: Container(
                margin: const EdgeInsets.fromLTRB(25, 0, 25, 15),
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: const Color(0xFFF1F1F1),
                  borderRadius: BorderRadius.circular(25),
                ),
                child: TabBar(
                  controller: _tabController,
                  dividerColor: Colors.transparent,
                  indicatorSize: TabBarIndicatorSize.tab,
                  indicator: BoxDecoration(
                    color: const Color(0xFF1A1A1A),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      )
                    ],
                  ),
                  labelColor: Colors.white,
                  unselectedLabelColor: const Color(0xFF666666),
                  labelStyle: GoogleFonts.montserrat(fontWeight: FontWeight.w800, fontSize: 11),
                  tabs: const [
                    Tab(text: "ALL DEALS"),
                    Tab(text: "NEARBY DEALS"),
                  ],
                ),
              ),
            ),
          ),

          SliverFillRemaining(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildDealsList(allDeals),
                _buildDealsList(nearbyDeals),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDealsList(List<Map<String, String>> data) {
    return ListView.builder(
      padding: const EdgeInsets.only(top: 10, bottom: 30),
      itemCount: data.length,
      physics: const BouncingScrollPhysics(),
      itemBuilder: (context, index) {
        return _buildHighImpactDealCard(data[index]);
      },
    );
  }

  Widget _buildHighImpactDealCard(Map<String, String> deal) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
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
      child: Column(
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(40)),
                child: Image.asset(
                  deal["img"]!,
                  height: 230,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              Positioned(
                top: 20,
                left: 20,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(colors: [Color(0xFFFF5252), Color(0xFFFF1744)]),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [BoxShadow(color: const Color(0xFFFF1744).withOpacity(0.4), blurRadius: 15)],
                  ),
                  child: Text(
                    deal["offer"]!,
                    style: GoogleFonts.montserrat(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w900, letterSpacing: 1),
                  ),
                ),
              ),
            ],
          ),

          Padding(
            padding: const EdgeInsets.all(25),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  deal["title"]!,
                  style: GoogleFonts.montserrat(color: const Color(0xFF0D1B1E), fontSize: 18, fontWeight: FontWeight.w900),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.timer_outlined, color: Colors.orange, size: 16),
                    const SizedBox(width: 6),
                    Text(
                      deal["expiry"]!,
                      style: GoogleFonts.montserrat(color: Colors.orange, fontSize: 12, fontWeight: FontWeight.w700),
                    ),
                  ],
                ),
                const SizedBox(height: 25),
                GestureDetector(
                  onTap: () {},
                  child: Container(
                    width: double.infinity,
                    height: 58,
                    decoration: BoxDecoration(
                      color: const Color(0xFF1A1A1A),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.3),
                          blurRadius: 15,
                          offset: const Offset(0, 8),
                        )
                      ],
                    ),
                    child: Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "CRACK THE DEAL",
                            style: GoogleFonts.montserrat(
                              color: Colors.white,
                              fontSize: 13,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 1.5,
                            ),
                          ),
                          const SizedBox(width: 10),
                          const Icon(Icons.local_fire_department_rounded, color: Colors.orangeAccent, size: 20),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}