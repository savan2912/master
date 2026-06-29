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
      body: RefreshIndicator(
        onRefresh: () async => callUserDashboard(),
        color: accentCyan,
        child: ValueListenableBuilder(
          valueListenable: isApiComplete,
          builder: (context, value, child) {
            if (!value) {
              return const Center(child: CustomLoader(message: "Loading Dashboard..",));
            }

            return SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.only(bottom: 30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (rewardListingData.isNotEmpty) ...[
                    _sectionHeader("My Listing Rewards", Icons.stars_rounded),
                    SizedBox(
                      height: 180,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        itemCount: rewardListingData.length,
                        itemBuilder: (context, index) => _rewardCard(rewardListingData[index]),
                      ),
                    ),
                  ],
                  _sectionHeader("Recent Enquiries", Icons.chat_bubble_outline_rounded),
                  ...enquiryData.map((e) => _enquiryCard(e)),
                  _sectionHeader("Recent Billing", Icons.account_balance_wallet_outlined),
                  ...billingData.map((e) => _billingCard(e)),
                  _sectionHeader("Booking History", Icons.history_rounded),
                  ...bookingData.map((e) => _bookingCard(e)),

                  const SizedBox(height: 20),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
  Widget _sectionHeader(String title, IconData icon) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 25, 20, 12),
      child: Row(
        children: [
          Icon(icon, size: 20, color: primaryDark.withOpacity(0.7)),
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
          BoxShadow(color: primaryDark.withOpacity(0.2), blurRadius: 10, offset: const Offset(0, 5)),
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
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: SharedWidgets.cardBoxDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                  backgroundColor: Colors.black.withOpacity(0.05),
                  radius: 18,
                  child: const Icon(Icons.person_outline, size: 18, color: Colors.black)
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  data.enquiryListing?.listingTitle ?? "General Enquiry",
                  style: GoogleFonts.plusJakartaSans(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: primaryDark
                  ),
                ),
              ),

              Text(
                formattedDate,
                style: GoogleFonts.plusJakartaSans(
                    fontSize: 10,
                    color: Colors.grey,
                    fontWeight: FontWeight.w600
                ),
              ),
            ],
          ),
          const Padding(
              padding: EdgeInsets.symmetric(vertical: 12),
              child: Divider(height: 1, thickness: 0.5)
          ),
          const SizedBox(height: 4),
          Text(
            "Enquiry : ${data.enquiry ?? "No enquiry message found."}",
            style: GoogleFonts.plusJakartaSans(
                fontSize: 12,
                color: Colors.blueGrey,
                height: 1.5,
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
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
      padding: const EdgeInsets.all(15),
      decoration: SharedWidgets.cardBoxDecoration(),
      child: Row(
        children: [

          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
                color: Colors.green.withOpacity(0.1),
                borderRadius: BorderRadius.circular(14)
            ),
            child: const Icon(Icons.receipt_long_rounded, color: Colors.green, size: 22),
          ),
          const SizedBox(width: 15),


          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                    data.listingTitle ?? "Service Payment",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.bold, fontSize: 14)
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Text(date, style: GoogleFonts.plusJakartaSans(fontSize: 11, color: Colors.grey)),
                    const SizedBox(width: 8),
                    Container(
                      width: 4,
                      height: 4,
                      decoration: const BoxDecoration(color: Colors.grey, shape: BoxShape.circle),
                    ),
                    const SizedBox(width: 8),
                    Text(
                        data.paymentType == "0" ? "Offline" : "Online",
                        style: GoogleFonts.plusJakartaSans(
                            fontSize: 11,
                            color: data.paymentType == "0" ? Colors.orange : Colors.blue,
                            fontWeight: FontWeight.w600
                        )
                    ),
                  ],
                ),
              ],
            ),
          ),

          // --- TOTAL AMOUNT ---
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                "₹${data.total ?? "0"}",
                style: GoogleFonts.plusJakartaSans(
                    fontWeight: FontWeight.w800,
                    fontSize: 16,
                    color: Colors.black
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
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: primaryDark.withOpacity(0.06),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(30),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [primaryDark, primaryDark.withOpacity(0.85)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: const Icon(Icons.confirmation_number_outlined, color: Colors.white, size: 22),
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          data.bookingListing?.listingTitle ?? "Service Booking",
                          style: GoogleFonts.plusJakartaSans(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                        Text(
                          "ID: #${data.id ?? "000"}",
                          style: GoogleFonts.plusJakartaSans(
                            color: Colors.white70,
                            fontSize: 10,
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
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Row(
                    children: [
                      _infoChip(Icons.person_rounded, data.name ?? "User"),
                      const SizedBox(width: 10),
                      _infoChip(Icons.phone_android_rounded, data.phone ?? "N/A"),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Container(
                    padding: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF8FAFC),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.black.withOpacity(0.03)),
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

                  const SizedBox(height: 20),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("TOTAL AMOUNT",
                              style: GoogleFonts.plusJakartaSans(fontSize: 9, color: Colors.grey, fontWeight: FontWeight.bold, letterSpacing: 1)),
                          Text("₹${data.totalAmount ?? "0"}",
                              style: GoogleFonts.plusJakartaSans(fontSize: 20, fontWeight: FontWeight.w900, color: primaryDark)),
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
        color: isPending ? Colors.orange.withOpacity(0.2) : accentCyan.withOpacity(0.2),
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
          border: Border.all(color: Colors.grey.withOpacity(0.1)),
        ),
        child: Row(
          children: [
            Icon(icon, size: 14, color: primaryDark.withOpacity(0.5)),
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
        Icon(icon, size: 16, color: primaryDark.withOpacity(0.3)),
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
              color: primaryDark.withOpacity(0.3),
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
                        decoration: BoxDecoration(color: primaryDark.withOpacity(0.04), borderRadius: BorderRadius.circular(15)),
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
            BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10, offset: const Offset(0, 4))
          ]
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(color: primaryDark.withOpacity(0.1), borderRadius: BorderRadius.circular(10)),
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
      SharedWidgets.showTopSnackBar(context, message: "No Internet Available");
      isApiComplete.value = true;
    }
  }
}