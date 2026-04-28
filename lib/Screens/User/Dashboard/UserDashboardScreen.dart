import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gotilo_new/Api/ApiCalls.dart';
import 'package:gotilo_new/Api/Request/User/Dashboard/RequestUserDashboard.dart';
import 'package:gotilo_new/Api/Response/User/Dashboard/ResponseUserDashboard.dart';
import 'package:gotilo_new/Constant/AppPref.dart';
import 'package:gotilo_new/CustomeWidgets/SharedWidgets.dart';
import 'package:gotilo_new/MyApplication/MyApplication.dart';
import 'package:intl/intl.dart';
import '../../../CustomeWidgets/CustomDrawer.dart';

class Userdashboardscreen extends StatefulWidget {
  const Userdashboardscreen({super.key});

  @override
  State<Userdashboardscreen> createState() => _UserdashboardscreenState();
}

class _UserdashboardscreenState extends State<Userdashboardscreen> {

  ValueNotifier<bool> isDataAvailable=ValueNotifier(false);
  ValueNotifier<bool> isApiComplete=ValueNotifier(false);
  final Color primaryDark = const Color(0xFF0F172A);
  final Color accentCyan = const Color(0xFF00E5FF);
  final Color glassWhite = Colors.white.withOpacity(0.9);

  List<Rewards> rewardListingData=[];
  List<Enquiries> enquiryData=[];
  List<RecentBilling> billingData=[];
  List<BookingHistory> bookingData=[];



  // final List<Map<String, dynamic>> bookingData = [
  //   {
  //     "date": "2026-02-16",
  //     "title": "Gotilo Cafe One",
  //     "name": "test",
  //     "email": "ravi.p@bbdpl.in",
  //     "phone": "7878787878",
  //     "time": "09:30:00 - 10:20:00",
  //     "amount": "100.00",
  //     "status": "Pending"
  //   },
  //   {
  //     "date": "2026-02-03",
  //     "title": "Gotilo Cafe Updated",
  //     "name": "Home",
  //     "email": "ravi.p@bbdpl.in",
  //     "phone": "7542424242",
  //     "time": "09:00:00 - 11:00:00",
  //     "amount": "1,500.00",
  //     "status": "Confirmed"
  //   },
  //   {
  //     "date": "2026-02-03",
  //     "title": "Gotilo Cafe Updated",
  //     "name": "test",
  //     "email": "test123@yopmail.com",
  //     "phone": "7542424242",
  //     "time": "09:30:00 - 11:30:00",
  //     "amount": "1,500.00",
  //     "status": "Confirmed"
  //   },
  //   {
  //     "date": "2026-02-03",
  //     "title": "Gotilo Cafe Updated",
  //     "name": "testt",
  //     "email": "ravi.p@bbdpl.in",
  //     "phone": "7542424242",
  //     "time": "18:30:00 - 20:30:00",
  //     "amount": "1,500.00",
  //     "status": "Confirmed"
  //   },
  //   {
  //     "date": "2026-02-03",
  //     "title": "Gotilo Cafe Updated",
  //     "name": "test",
  //     "email": "test554@yopmail.com",
  //     "phone": "7672772233",
  //     "time": "16:00:00 - 18:20:00",
  //     "amount": "2,000.00",
  //     "status": "Confirmed"
  //   },
  // ];


  @override
  void initState() {
    callUserDashboard();
    super.initState();
  }

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
        drawer: const CustomDrawer(initialRoute: 'user.overview'),
        body: RefreshIndicator(
          onRefresh: () async  {
            callUserDashboard();
          },
          child:
          CustomScrollView(
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
                  titlePadding: const EdgeInsets.only(bottom: 16),
                  title: Text("DASHBOARD", style: GoogleFonts.montserrat(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w800, letterSpacing: 2)),
                  background: Stack(
                    children: [
                      Positioned(right: -50, top: -50, child: CircleAvatar(radius: 100, backgroundColor: accentCyan.withOpacity(0.1))),
                      Padding(
                        padding: const EdgeInsets.only(left: 25, top: 80),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Hello, Savan", style: GoogleFonts.montserrat(color: Colors.white, fontSize: 24, fontWeight: FontWeight.w900)),
                            const SizedBox(height: 5),
                            Row(
                              children: [
                                Icon(Icons.verified_user_rounded, color: accentCyan, size: 14),
                                const SizedBox(width: 5),
                                Text("Premium Member", style: GoogleFonts.montserrat(color: Colors.white60, fontSize: 11, fontWeight: FontWeight.w600)),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

            ValueListenableBuilder(
              valueListenable: isApiComplete,
              builder: (context, value, child) {
                if(!value){
                  return SliverFillRemaining(
                    hasScrollBody: false,
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(accentCyan),
                            strokeWidth: 3,
                          ),
                        ],
                      ),
                    ),
                  );
                }
                return SliverMainAxisGroup(
                  slivers: [
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(20, 30, 20, 10),
                        child: _buildListingRewardsSection(),
                      ),
                    ),
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(20, 25, 20, 15),
                        child: _buildSectionHeader("Recent Enquiry"),
                      ),
                    ),
                    SliverPadding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      sliver: SliverList(
                        delegate: SliverChildBuilderDelegate(
                              (context, index) => _buildEnquiryCard(enquiryData[index]),
                          childCount: enquiryData.length,
                        ),
                      ),
                    ),
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(20, 30, 20, 15),
                        child: _buildSectionHeader("Recent Billing"),
                      ),
                    ),
                    SliverPadding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      sliver: SliverList(
                        delegate: SliverChildBuilderDelegate(
                              (context, index) => _buildModernTransactionCard(billingData[index]),
                          childCount: billingData.length,
                        ),
                      ),
                    ),
                    SliverPadding(
                      padding: const EdgeInsets.fromLTRB(20, 30, 20, 15),
                      sliver: SliverToBoxAdapter(child: _buildSectionHeader("Booking History")),
                    ),
                    SliverPadding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      sliver: SliverList(
                        delegate: SliverChildBuilderDelegate(
                              (context, index) => _buildModernBookingCard(context,bookingData[index]),
                          childCount: bookingData.length,
                        ),
                      ),
                    ),
                    const SliverToBoxAdapter(child: SizedBox(height: 50)),
                  ],
                );
               }
              ),
            ],
          ),
        ),
      ),
    );
  }
  

  Widget _buildSectionHeader(String title) {
    return Text(title.toUpperCase(), style: GoogleFonts.montserrat(fontSize: 13, fontWeight: FontWeight.w800, color: primaryDark.withOpacity(0.6), letterSpacing: 2));
  }

  Widget _buildEnquiryCard(Enquiries data) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(22), border: Border.all(color: accentCyan.withOpacity(0.2))),
      child: Row(
        children: [
          Container(
            height: 45, width: 45,
            decoration: BoxDecoration(color: accentCyan.withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
            child: Icon(Icons.question_answer_rounded, color: const Color(0xFF00ACC1), size: 18),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(data.enquiryListing?.listingTitle ?? "", style: GoogleFonts.montserrat(fontWeight: FontWeight.w800, fontSize: 13, color: primaryDark)),
                Text("Date: ${data.enquiryTime}", style: GoogleFonts.montserrat(fontSize: 10, color: Colors.blueGrey[300], fontWeight: FontWeight.w600)),
                Text("Enquiry: ${data.enquiry ?? ""}", style: GoogleFonts.montserrat(fontSize: 10, color: Colors.blueGrey[300], fontWeight: FontWeight.w600)),
              ],
            ),
          ),
          const Icon(Icons.arrow_forward_ios_rounded, size: 14, color: Colors.grey),
        ],
      ),
    );
  }

  Widget _buildListingRewardsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader("Listing Rewards"),
        const SizedBox(height: 15),
        ListView.builder(
          shrinkWrap: true,
          padding: EdgeInsets.zero,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: rewardListingData.length,
          itemBuilder: (context, index) {
            var data = rewardListingData[index];
            return Container(
              margin: const EdgeInsets.only(bottom: 15),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(25), boxShadow: [BoxShadow(color: primaryDark.withOpacity(0.02), blurRadius: 15, offset: const Offset(0, 8))]),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(width: 10), Text(data.rewardsListings?.listingTitle ?? "", style: GoogleFonts.montserrat(fontWeight: FontWeight.w800, fontSize: 14, color: primaryDark)),
                  const Padding(padding: EdgeInsets.symmetric(vertical: 15), child: Divider(height: 1, color: Color(0xFFF1F5F9))),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildRewardSmallStat("total", data.totalPoints.toString(), Colors.blueGrey),
                      _buildRewardSmallStat("Redeemed", data.redeemedPoints.toString(), Colors.redAccent),
                      _buildRewardSmallStat("Actual", data.actualPoints.toString(), const Color(0xFF10B981)),
                    ],
                  )
                ],
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildRewardSmallStat(String label, String value, Color valueColor) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(label, style: GoogleFonts.montserrat(fontSize: 10, fontWeight: FontWeight.w600, color: Colors.blueGrey[300])),
      const SizedBox(height: 4),
      Text(value, style: GoogleFonts.montserrat(fontSize: 14, fontWeight: FontWeight.w800, color: valueColor)),
    ]);
  }

  Widget _buildModernTransactionCard(RecentBilling data) {
    String apiDate = data.createdAt!;
    DateTime dateTime = DateTime.parse(apiDate);
    String onlyDate = DateFormat('dd-MM-yyyy').format(dateTime);
    
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: glassWhite, borderRadius: BorderRadius.circular(22), border: Border.all(color: Colors.white)),
      child: Row(
        children: [
          Container(height: 45, width: 45, decoration: BoxDecoration(color: primaryDark.withOpacity(0.05), borderRadius: BorderRadius.circular(12)), child: Icon(Icons.receipt_long_rounded, color: primaryDark, size: 18)),
          const SizedBox(width: 15),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(data.listingTitle ?? "", style: GoogleFonts.montserrat(fontWeight: FontWeight.w800, fontSize: 13, color: primaryDark)),
            Text("${onlyDate} • ${data.paymentType=="0" ? "Offline" : "Online"}", style: GoogleFonts.montserrat(fontSize: 10, color: Colors.blueGrey[300], fontWeight: FontWeight.w600)),
          ])),
          Text("₹ ${data.total}", style: GoogleFonts.montserrat(fontWeight: FontWeight.w900, color: primaryDark, fontSize: 14)),
        ],
      ),
    );
  }

  Widget _buildModernBookingCard(BuildContext context, BookingHistory data) {
    bool isPending = data.status == 0;
    Color statusColor = isPending ? const Color(0xFFF59E0B) : const Color(0xFF10B981);

    return Container(
      margin: const EdgeInsets.only(bottom: 15, left: 15, right: 15),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(25),
          boxShadow: [
            BoxShadow(
                color: primaryDark.withOpacity(0.05),
                blurRadius: 20,
                offset: const Offset(0, 10))
          ]),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                        child: Text(data.bookingListing?.listingTitle ?? "Booking",
                            style: GoogleFonts.montserrat(
                                fontWeight: FontWeight.w800,
                                fontSize: 14,
                                color: primaryDark))),
                    Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                            color: statusColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8)),
                        child: Text(isPending ? "Pending" : "Complete",
                            style: GoogleFonts.montserrat(
                                fontSize: 10,
                                fontWeight: FontWeight.w900,
                                color: statusColor))),
                  ],
                ),
                const SizedBox(height: 12),
                _rowInfo(Icons.person_outline, "Name: ${data.name ?? ""}"),
                _rowInfo(Icons.calendar_today_outlined, "Date: ${data.bookingDate ?? ""}"),
                _rowInfo(Icons.access_time_rounded, "Time: ${data.startTime ?? ""}"),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
            decoration: BoxDecoration(
                color: primaryDark.withOpacity(0.03),
                borderRadius: const BorderRadius.vertical(bottom: Radius.circular(25))),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Total Amount",
                        style: GoogleFonts.montserrat(
                            fontSize: 10,
                            color: Colors.blueGrey[300],
                            fontWeight: FontWeight.w700)),
                    Text("₹ ${data.totalAmount ?? "0"}",
                        style: GoogleFonts.montserrat(
                            fontWeight: FontWeight.w900,
                            fontSize: 15,
                            color: primaryDark)),
                  ],
                ),
                // --- View Details Button ---
                ElevatedButton(
                  onPressed: () => _showBookingDetailsDialog(context, data),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryDark,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 0),
                  ),
                  child: Text("View Details",
                      style: GoogleFonts.montserrat(fontSize: 11, fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          )
        ],
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
      // String ne double ma convert kari ne plus karo
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
              // HEADER
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
            overflow: TextOverflow.visible, // Jo value moti hoy to niche ni line ma jase
          ),
        ),
      ],
    );
  }

  Widget _rowInfo(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        children: [
          Icon(icon, size: 13, color: Colors.blueGrey[200]),
          const SizedBox(width: 10),
          Expanded(child: Text(text, style: GoogleFonts.montserrat(fontSize: 10, color: Colors.blueGrey[400], fontWeight: FontWeight.w600))),
        ],
      ),
    );
  }

  Future<void> callUserDashboard() async {
    isDataAvailable.value=false;
    isApiComplete.value=false;
    rewardListingData.clear();
   enquiryData.clear();
   billingData.clear();
   bookingData.clear();
    _callUserDashboard();
  }

  Future<void> _callUserDashboard() async {
    MyApplication.checkInternet().then((internet) async {
        if(internet){
          try{
            ResponseUserDashboard? response= await ApiCalls.callUserDashboard(RequestUserDashboard(
              userId: AppPrefs.userId ?? ""
            ));
            if(response != null){
              if(response.result!.isNotEmpty && response.result != null &&
              response.result!.toLowerCase().contains("pass")){
                rewardListingData.addAll(response.data!.rewards!);
                enquiryData.addAll(response.data!.enquiries!);
                billingData.addAll(response.data!.recentBilling!);
                bookingData.addAll(response.data!.bookingHistory!);
                isDataAvailable.value=true;
                setState(() {});
              }
            }
          }on Exception catch(e){
            isDataAvailable.value=false;
            log("$e");
          }catch(e){
            isDataAvailable.value=false;
            log("$e");
          }finally {
            isApiComplete.value=true;
          }
        }else{
          SharedWidgets.showTopSnackBar(context, message: "No Internet Available");
        }
    },);
  }



}