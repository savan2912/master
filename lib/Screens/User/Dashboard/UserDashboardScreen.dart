import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gotilo_new/CustomeWidgets/CustomLoader.dart';
import 'package:intl/intl.dart';
import 'package:gotilo_new/Api/ApiCalls.dart';
import 'package:gotilo_new/Api/Request/User/Dashboard/RequestUserDashboard.dart';
import 'package:gotilo_new/Api/Response/User/Dashboard/ResponseUserDashboard.dart';
import 'package:gotilo_new/Constant/AppPref.dart';
import 'package:gotilo_new/CustomeWidgets/SharedWidgets.dart';
import 'package:gotilo_new/MyApplication/MyApplication.dart';
import '../../../CustomeWidgets/CustomDrawer.dart';
import '../../../CustomeWidgets/CustomAppbar.dart';

class Userdashboardscreen extends StatefulWidget {
  const Userdashboardscreen({super.key});

  @override
  State<Userdashboardscreen> createState() => _UserdashboardscreenState();
}

class _UserdashboardscreenState extends State<Userdashboardscreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  ValueNotifier<bool> isApiComplete = ValueNotifier(false);

  final Color primaryDark = const Color(0xFF0F172A);
  final Color accentCyan = const Color(0xFF00E5FF);
  final Color bgGray = const Color(0xFFF1F5F9);

  List<Rewards> rewardListingData = [];
  List<Enquiries> enquiryData = [];
  List<RecentBilling> billingData = [];
  List<BookingHistory> bookingData = [];

  @override
  void initState() {
    super.initState();
    callUserDashboard();
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final bool isTablet = screenWidth >= 600;
    final bool isDesktop = screenWidth >= 1024;

    int crossAxisCount = 1;
    if (isDesktop) {
      crossAxisCount = 3;
    } else if (isTablet) {
      crossAxisCount = 2;
    }

    double horizontalPadding = screenWidth * 0.05;
    if (horizontalPadding < 16) horizontalPadding = 16;
    if (horizontalPadding > 60) horizontalPadding = 60;

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: bgGray,
      drawer: const CustomDrawer(initialRoute: 'user.overview'),
      appBar: CustomAppBar(
        title: "Dashboard Overview",
        onMenuTap: () => _scaffoldKey.currentState?.openDrawer(),
        onActionTap: () {},
        showAction: false,
      ),
      body: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 1440),
          child: RefreshIndicator(
            onRefresh: () async => callUserDashboard(),
            color: accentCyan,
            child: ValueListenableBuilder(
              valueListenable: isApiComplete,
              builder: (context, value, child) {
                if (!value) {
                  return const Center(child: CustomLoader(message: "Loading Dashboard..",));
                }

                return SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
                  padding: const EdgeInsets.only(bottom: 30),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (rewardListingData.isNotEmpty) ...[
                        _sectionHeader("My Listing Rewards", Icons.stars_rounded, horizontalPadding),
                        SizedBox(
                          height: 180,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            padding: EdgeInsets.symmetric(horizontal: horizontalPadding - 5),
                            itemCount: rewardListingData.length,
                            itemBuilder: (context, index) => _rewardCard(rewardListingData[index]),
                          ),
                        ),
                      ],

                      _sectionHeader("Recent Enquiries", Icons.chat_bubble_outline_rounded, horizontalPadding),
                      _buildResponsiveGrid(
                        children: enquiryData.map((e) => _enquiryCard(e)).toList(),
                        crossAxisCount: crossAxisCount,
                        horizontalPadding: horizontalPadding,
                        mainAxisExtent: 140,
                      ),

                      _sectionHeader("Recent Billing", Icons.account_balance_wallet_outlined, horizontalPadding),
                      _buildResponsiveGrid(
                        children: billingData.map((e) => _billingCard(e)).toList(),
                        crossAxisCount: crossAxisCount,
                        horizontalPadding: horizontalPadding,
                        mainAxisExtent: 85,
                      ),

                      _sectionHeader("Booking History", Icons.history_rounded, horizontalPadding),
                      _buildResponsiveGrid(
                        children: bookingData.map((e) => _bookingCard(e)).toList(),
                        crossAxisCount: crossAxisCount,
                        horizontalPadding: horizontalPadding,
                        mainAxisExtent: 320,
                      ),

                      const SizedBox(height: 20),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildResponsiveGrid({
    required List<Widget> children,
    required int crossAxisCount,
    required double horizontalPadding,
    double? mainAxisExtent,
  }) {
    if (children.isEmpty) {
      return Padding(
        padding: EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: 10),
        child: Text("No items available", style: GoogleFonts.plusJakartaSans(color: Colors.grey, fontSize: 13)),
      );
    }

    if (crossAxisCount == 1) {
      return Padding(
        padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
        child: Column(children: children),
      );
    }

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: crossAxisCount,
          mainAxisSpacing: 10,
          crossAxisSpacing: 15,
          mainAxisExtent: mainAxisExtent,
          childAspectRatio: mainAxisExtent == null ? 1.5 : 1,
        ),
        itemCount: children.length,
        itemBuilder: (context, index) => children[index],
      ),
    );
  }

  Widget _sectionHeader(String title, IconData icon, double horizontalPadding) {
    return Padding(
      padding: EdgeInsets.fromLTRB(horizontalPadding, 25, horizontalPadding, 12),
      child: Row(
        children: [
          Icon(icon, size: 20, color: primaryDark.withValues(alpha: 0.7)),
          const SizedBox(width: 10),
          Text(
            title,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 16,
              fontWeight: FontWeight.w800,
              color: primaryDark,
            ),
          ),
        ],
      ),
    );
  }
  Widget _rewardCard(Rewards data) {
    return Container(
      width: 280,
      margin: const EdgeInsets.only(right: 15, bottom: 10),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [primaryDark, const Color(0xFF1E293B)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(color: primaryDark.withValues(alpha: 0.2), blurRadius: 10, offset: const Offset(0, 5)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            data.rewardsListings?.listingTitle ?? "Premium Listing",
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.plusJakartaSans(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15),
          ),
          const Spacer(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _rewardStat("Total", data.totalPoints.toString()),
              _rewardStat("Redeemed", data.redeemedPoints.toString()),
              _rewardStat("Available", data.actualPoints.toString(), highlight: true),
            ],
          ),
        ],
      ),
    );
  }

  Widget _rewardStat(String label, String val, {bool highlight = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: GoogleFonts.plusJakartaSans(color: Colors.white60, fontSize: 10)),
        const SizedBox(height: 4),
        Text(
          val,
          style: GoogleFonts.plusJakartaSans(
            color: highlight ? accentCyan : Colors.white,
            fontWeight: FontWeight.w800,
            fontSize: 16,
          ),
        ),
      ],
    );
  }

  Widget _enquiryCard(Enquiries data) {
    String formattedDate = "N/A";
    if (data.createdAt != null) {
      try {
        DateTime dt = DateTime.parse(data.createdAt!);
        formattedDate = DateFormat('dd MMM, yyyy').format(dt);
      } catch (e) {
        formattedDate = data.createdAt!;
      }
    }

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(12),
      decoration: SharedWidgets.cardBoxDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              CircleAvatar(
                  backgroundColor: Colors.black.withValues(alpha: 0.05),
                  radius: 16,
                  child: const Icon(Icons.person_outline, size: 16, color: Colors.black)
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  data.enquiryListing?.listingTitle ?? "General Enquiry",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.plusJakartaSans(
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                      color: primaryDark
                  ),
                ),
              ),

              Text(
                formattedDate,
                style: GoogleFonts.plusJakartaSans(
                    fontSize: 9,
                    color: Colors.grey,
                    fontWeight: FontWeight.w600
                ),
              ),
            ],
          ),
          const Padding(
              padding: EdgeInsets.symmetric(vertical: 10),
              child: Divider(height: 1, thickness: 0.5)
          ),
          const SizedBox(height: 2),
          Text(
            "Enquiry : ${data.enquiry ?? "No enquiry message found."}",
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.plusJakartaSans(
                fontSize: 11,
                color: Colors.blueGrey,
                height: 1.4,
                fontWeight: FontWeight.w500
            ),
          ),
        ],
      ),
    );
  }

  Widget _billingCard(RecentBilling data) {
    String date = "N/A";
    try {
      date = DateFormat('dd MMM, yyyy').format(DateTime.parse(data.createdAt!));
    } catch (_) {}

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: primaryDark.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            height: 48,
            width: 48,
            decoration: BoxDecoration(
              color: const Color(0xFFF1F5F9),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              Icons.receipt_long_rounded,
              color: primaryDark.withValues(alpha: 0.7),
              size: 24,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  data.listingTitle ?? "Service Payment",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.plusJakartaSans(
                    fontWeight: FontWeight.w700,
                    fontSize: 12,
                    color: primaryDark,
                  ),
                ),
                const SizedBox(height: 4),
                FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.centerLeft,
                  child: Row(
                    children: [
                      Text(
                        date,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 10.5,
                          color: Colors.grey[500],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        width: 3,
                        height: 3,
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        data.paymentType == "0" ? "Offline" : "Online",
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 10.5,
                          color: data.paymentType == "0" ? Colors.orange[700] : Colors.blue[700],
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "₹${data.total ?? "0"}",
                style: GoogleFonts.plusJakartaSans(
                  fontWeight: FontWeight.w800,
                  fontSize: 12,
                  color: primaryDark,
                ),
              ),
              Text(
                "Paid",
                style: GoogleFonts.plusJakartaSans(
                  fontWeight: FontWeight.w700,
                  fontSize: 9,
                  color: Colors.green[600],
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }


  Widget _bookingCard(BookingHistory data) {
    bool isPending = data.status == 0;
    String bookingDate = "N/A";
    try {
      bookingDate = DateFormat('dd MMM, yyyy').format(DateTime.parse(data.bookingDate!));
    } catch (_) {}

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: primaryDark.withValues(alpha: 0.06),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(30),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [primaryDark, primaryDark.withValues(alpha: 0.85)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(Icons.confirmation_number_outlined, color: Colors.white, size: 18),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          data.bookingListing?.listingTitle ?? "Service Booking",
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.plusJakartaSans(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                          ),
                        ),
                        Text(
                          "ID: #${data.id ?? "000"}",
                          style: GoogleFonts.plusJakartaSans(
                            color: Colors.white70,
                            fontSize: 8,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  _statusBadge(isPending),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                children: [
                  Row(
                    children: [
                      _infoChip(Icons.person_rounded, data.name ?? "User"),
                      const SizedBox(width: 8),
                      _infoChip(Icons.phone_android_rounded, data.phone ?? "N/A"),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF8FAFC),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.black.withValues(alpha: 0.03)),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _gridItem("DATE", bookingDate, Icons.calendar_today_rounded),
                        _gridItem("START", data.startTime ?? "N/A", Icons.access_time_filled_rounded),
                        _gridItem("END", data.endTime ?? "N/A", Icons.history_toggle_off_rounded),
                      ],
                    ),
                  ),

                  const SizedBox(height: 12),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("TOTAL AMOUNT",
                              style: GoogleFonts.plusJakartaSans(fontSize: 7, color: Colors.grey, fontWeight: FontWeight.bold, letterSpacing: 1)),
                          Text("₹${data.totalAmount ?? "0"}",
                              style: GoogleFonts.plusJakartaSans(fontSize: 16, fontWeight: FontWeight.w900, color: primaryDark)),
                        ],
                      ),
                      _viewButton(data),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _statusBadge(bool isPending) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: isPending ? Colors.orange.withValues(alpha: 0.2) : accentCyan.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: isPending ? Colors.orange : accentCyan, width: 0.5),
      ),
      child: Text(
        isPending ? "PENDING" : "CONFIRMED",
        style: GoogleFonts.plusJakartaSans(
          color: isPending ? Colors.orange : accentCyan,
          fontWeight: FontWeight.bold,
          fontSize: 9,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  Widget _infoChip(IconData icon, String label) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: Colors.grey.withValues(alpha: 0.1)),
        ),
        child: Row(
          children: [
            Icon(icon, size: 14, color: primaryDark.withValues(alpha: 0.5)),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.plusJakartaSans(fontSize: 12, fontWeight: FontWeight.w600, color: primaryDark),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _gridItem(String title, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, size: 16, color: primaryDark.withValues(alpha: 0.3)),
        const SizedBox(height: 6),
        Text(title, style: GoogleFonts.plusJakartaSans(fontSize: 8, color: Colors.grey, fontWeight: FontWeight.bold)),
        const SizedBox(height: 2),
        Text(value, style: GoogleFonts.plusJakartaSans(fontSize: 12, fontWeight: FontWeight.bold, color: primaryDark)),
      ],
    );
  }


  Widget _viewButton(BookingHistory data) {
    return GestureDetector(
      onTap: () {
        _showBookingDetailsDialog(context, data);
      },
      child: Container(
        height: 48,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
          color: primaryDark,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: primaryDark.withValues(alpha: 0.3),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Center(
          child: Row(
            children: [
              const Icon(Icons.arrow_outward_rounded,
                  color: Colors.white, size: 18),
              const SizedBox(width: 8),
              Text(
                "VIEW",
                style: GoogleFonts.plusJakartaSans(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showBookingDetailsDialog(BuildContext context, BookingHistory data) {
    int totalMin = 0;
    data.bookingService?.forEach((element) {
      totalMin += int.tryParse(element.duration.toString()) ?? 0;
    });
    double totalAmount = 0.0;
    data.bookingService?.forEach((service) {
      totalAmount += double.tryParse(service.servicePrice.toString()) ?? 0.0;
    });

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
        contentPadding: EdgeInsets.zero,
        content: Container(
          width: MediaQuery.of(context).size.width * 0.9,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 10, 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text("Booking Details",
                          style: GoogleFonts.montserrat(fontWeight: FontWeight.w800, fontSize: 18, color: primaryDark),
                          overflow: TextOverflow.ellipsis),
                    ),
                    IconButton(onPressed: () => Navigator.pop(context), icon: Icon(Icons.close, color: Colors.grey[400]))
                  ],
                ),
              ),
              const Divider(height: 1),

              Flexible(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.location_on_outlined, size: 18, color: Colors.blueGrey[300]),
                          const SizedBox(width: 5),
                          Expanded(child: Text(data.description ?? "Location", style: GoogleFonts.montserrat(fontSize: 14, color: Colors.blueGrey[300], fontWeight: FontWeight.w600))),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Text("Selected Services", style: GoogleFonts.montserrat(fontWeight: FontWeight.w800, fontSize: 15, color: primaryDark)),
                      const SizedBox(height: 10),
                      if (data.bookingService != null)
                        ...data.bookingService!.map((s) => _buildServiceCard(
                            s.serviceTitle ?? "Service",
                            "${s.duration ?? '0'} Min",
                            "${s.servicePrice ?? '0'}"
                        )).toList(),

                      const SizedBox(height: 20),

                      Container(
                        padding: const EdgeInsets.all(15),
                        decoration: BoxDecoration(color: primaryDark.withValues(alpha: 0.04), borderRadius: BorderRadius.circular(15)),
                        child: Column(
                          children: [
                            _infoRow("Appointment Date", data.bookingDate ?? ""),
                            const SizedBox(height: 12),
                            _infoRow("Time Slot", "${data.startTime} - ${data.endTime}"),
                            const SizedBox(height: 12),
                            _infoRow("Total Duration", "$totalMin Min"),
                          ],
                        ),
                      ),
                      const SizedBox(height: 25),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Final Amount", style: GoogleFonts.montserrat(fontWeight: FontWeight.w700, fontSize: 14, color: Colors.grey)),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text("₹ ${totalAmount}",
                                textAlign: TextAlign.end,
                                style: GoogleFonts.montserrat(fontWeight: FontWeight.w900, fontSize: 22, color: primaryDark)),
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
      ),
    );
  }

  Widget _buildServiceCard(String title, String duration, String price) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: Colors.grey[100]!),
          boxShadow: [
            BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 10, offset: const Offset(0, 4))
          ]
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(color: primaryDark.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(10)),
            child: Icon(Icons.check_circle_outline, color: primaryDark, size: 20),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: GoogleFonts.montserrat(fontWeight: FontWeight.w700, fontSize: 14),
                    overflow: TextOverflow.ellipsis),
                Text(duration, style: GoogleFonts.montserrat(fontSize: 12, color: Colors.grey)),
              ],
            ),
          ),
          const SizedBox(width: 10),
          Text("₹$price", style: GoogleFonts.montserrat(fontWeight: FontWeight.w800, fontSize: 14, color: primaryDark)),
        ],
      ),
    );
  }


  Widget _infoRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: GoogleFonts.montserrat(fontSize: 12, color: Colors.blueGrey[400], fontWeight: FontWeight.w600)),
        const SizedBox(width: 20),
        Expanded(
          child: Text(
            value,
            textAlign: TextAlign.end,
            style: GoogleFonts.montserrat(fontSize: 12, fontWeight: FontWeight.w700, color: primaryDark),
            overflow: TextOverflow.visible,
          ),
        ),
      ],
    );
  }

  Future<void> callUserDashboard() async {
    isApiComplete.value = false;
    rewardListingData.clear();
    enquiryData.clear();
    billingData.clear();
    bookingData.clear();
    _callUserDashboard();
  }

  Future<void> _callUserDashboard() async {
    bool internet = await MyApplication.checkInternet();
    if (internet) {
      try {
        ResponseUserDashboard? response = await ApiCalls.callUserDashboard(
          RequestUserDashboard(userId: AppPrefs.userId ?? ""),
        );

        if (response != null && response.result!.toLowerCase().contains("pass")) {
          setState(() {
            rewardListingData.addAll(response.data!.rewards!);
            enquiryData.addAll(response.data!.enquiries!);
            billingData.addAll(response.data!.recentBilling!);
            bookingData.addAll(response.data!.bookingHistory!);
          });
        }
      } catch (e) {
        log("Dashboard Error: $e");
      } finally {
        isApiComplete.value = true;
      }
    } else {
      SharedWidgets.showTopSnackBar(context, message: "No Internet Available",title:"fail");
      isApiComplete.value = true;
    }
  }
}