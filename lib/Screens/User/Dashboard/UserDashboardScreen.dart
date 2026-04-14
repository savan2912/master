import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../CustomeWidgets/CustomDrawer.dart';

class Userdashboardscreen extends StatefulWidget {
  const Userdashboardscreen({super.key});

  @override
  State<Userdashboardscreen> createState() => _UserdashboardscreenState();
}

class _UserdashboardscreenState extends State<Userdashboardscreen> {
  final Color primaryDark = const Color(0xFF0F172A);
  final Color accentCyan = const Color(0xFF00E5FF);
  final Color glassWhite = Colors.white.withOpacity(0.9);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFF8FAFC), Color(0xFFE2E8F0)],
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        drawer: const CustomDrawer(initialRoute: 'dashboard'),
        body: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [

            SliverAppBar(
              expandedHeight: 170.0,
              pinned: true,
              elevation: 0,
              backgroundColor: primaryDark,
              stretch: true,
              centerTitle: true,
              leading: Builder(
                builder: (context) => IconButton(
                  icon: const Icon(Icons.align_horizontal_left, color: Colors.white, size: 28),
                  onPressed: () => Scaffold.of(context).openDrawer(),
                ),
              ),

              flexibleSpace: FlexibleSpaceBar(
                centerTitle: true,
                titlePadding: const EdgeInsets.only(bottom: 16), // Title ne App Bar ma center ma rakhva
                title: Text(
                  "DASHBOARD",
                  style: GoogleFonts.montserrat(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 2,
                  ),
                ),
                background: Stack(
                  children: [
                    Positioned(
                      right: -50, top: -50,
                      child: CircleAvatar(radius: 100, backgroundColor: accentCyan.withOpacity(0.1)),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 25, top: 80),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Hello, Savan",
                              style: GoogleFonts.montserrat(
                                  color: Colors.white,
                                  fontSize: 24,
                                  fontWeight: FontWeight.w900
                              )),
                          const SizedBox(height: 5),
                          Row(
                            children: [
                              Icon(Icons.verified_user_rounded, color: accentCyan, size: 14),
                              const SizedBox(width: 5),
                              Text("Premium Member",
                                  style: GoogleFonts.montserrat(
                                      color: Colors.white60,
                                      fontSize: 11,
                                      fontWeight: FontWeight.w600
                                  )),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // --- REST OF THE CONTENT ---
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 30, 20, 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSectionHeader("Financial Insights"),
                    const SizedBox(height: 20),
                    SizedBox(
                      height: 170,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        physics: const BouncingScrollPhysics(),
                        children: [
                          _buildStatCard("Total Earned", "20,078", Icons.payments_rounded, const Color(0xFF6366F1)),
                          _buildStatCard("Redeemed", "1,500", Icons.redeem_rounded, const Color(0xFFF59E0B)),
                          _buildStatCard("Available", "18,578", Icons.account_balance_rounded, const Color(0xFF10B981)),
                        ],
                      ),
                    ),
                    const SizedBox(height: 35),
                    _buildSectionHeader("Recent Activities"),
                    const SizedBox(height: 15),
                  ],
                ),
              ),
            ),

            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                      (context, index) => _buildModernTransactionCard(),
                  childCount: 2,
                ),
              ),
            ),

            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: _buildSectionHeader("Live Bookings"),
              ),
            ),

            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                      (context, index) => _buildModernBookingCard(index == 0),
                  childCount: 3,
                ),
              ),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: 40)),
          ],
        ),
      ),
    );
  }

  // --- UI HELPER WIDGETS ---

  Widget _buildSectionHeader(String title) {
    return Text(
      title.toUpperCase(),
      style: GoogleFonts.montserrat(
        fontSize: 13,
        fontWeight: FontWeight.w800,
        color: primaryDark.withOpacity(0.6),
        letterSpacing: 2,
      ),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Container(
      width: 155,
      margin: const EdgeInsets.only(right: 15, bottom: 10),
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(color: color.withOpacity(0.2), blurRadius: 20, offset: const Offset(0, 10))
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(15)),
            child: Icon(icon, color: color, size: 22),
          ),
          const Spacer(),
          Text(title, style: GoogleFonts.montserrat(fontSize: 11, color: Colors.blueGrey[400], fontWeight: FontWeight.w700)),
          const SizedBox(height: 5),
          Text(value, style: GoogleFonts.montserrat(fontSize: 19, fontWeight: FontWeight.w900, color: primaryDark)),
        ],
      ),
    );
  }

  Widget _buildModernTransactionCard() {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: glassWhite,
        borderRadius: BorderRadius.circular(25),
        border: Border.all(color: Colors.white),
      ),
      child: Row(
        children: [
          Container(
            height: 50, width: 50,
            decoration: BoxDecoration(color: primaryDark.withOpacity(0.05), borderRadius: BorderRadius.circular(15)),
            child: Icon(Icons.restaurant_rounded, color: primaryDark, size: 20),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Gotilo Cafe One", style: GoogleFonts.montserrat(fontWeight: FontWeight.w800, fontSize: 14, color: primaryDark)),
                const SizedBox(height: 2),
                Text("Feb 13 • Bill #9921", style: GoogleFonts.montserrat(fontSize: 11, color: Colors.blueGrey[300], fontWeight: FontWeight.w600)),
              ],
            ),
          ),
          Text("₹ 259", style: GoogleFonts.montserrat(fontWeight: FontWeight.w900, color: const Color(0xFF10B981), fontSize: 16)),
        ],
      ),
    );
  }

  Widget _buildModernBookingCard(bool isPending) {
    Color statusColor = isPending ? const Color(0xFFF59E0B) : const Color(0xFF10B981);
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [BoxShadow(color: primaryDark.withOpacity(0.03), blurRadius: 20, offset: const Offset(0, 10))],
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Gotilo Cafe Updated", style: GoogleFonts.montserrat(fontWeight: FontWeight.w800, fontSize: 15, color: primaryDark)),
                      const SizedBox(height: 5),
                      Row(
                        children: [
                          Icon(Icons.calendar_today_rounded, size: 12, color: Colors.blueGrey[200]),
                          const SizedBox(width: 5),
                          Text("Today at 09:30 AM", style: GoogleFonts.montserrat(fontSize: 11, color: Colors.blueGrey[400], fontWeight: FontWeight.w600)),
                        ],
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(color: statusColor.withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
                  child: Text(isPending ? "PENDING" : "CONFIRMED",
                      style: GoogleFonts.montserrat(fontSize: 9, fontWeight: FontWeight.w900, color: statusColor, letterSpacing: 0.5)),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            decoration: BoxDecoration(
              color: primaryDark.withOpacity(0.02),
              borderRadius: const BorderRadius.vertical(bottom: Radius.circular(30)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Total Amount", style: GoogleFonts.montserrat(fontSize: 11, color: Colors.blueGrey[300], fontWeight: FontWeight.w700)),
                Text("₹ 1,500.00", style: GoogleFonts.montserrat(fontWeight: FontWeight.w900, fontSize: 15, color: primaryDark)),
              ],
            ),
          )
        ],
      ),
    );
  }
}