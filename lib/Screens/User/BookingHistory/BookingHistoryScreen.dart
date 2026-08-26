import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gotilo_new/Api/ApiCalls.dart';
import 'package:gotilo_new/Api/Request/User/BookingHistory/RequestBookingHistory.dart';
import 'package:gotilo_new/Api/Request/User/BookingHistory/RequestBookingHistoryDetail.dart';
import 'package:gotilo_new/Api/Response/User/BookingHistory/ResponseBookingHistoryDetail.dart';
import 'package:gotilo_new/Constant/AppPref.dart';
import 'package:gotilo_new/CustomeWidgets/CustomAppbar.dart';
import 'package:gotilo_new/CustomeWidgets/SharedWidgets.dart';
import 'package:gotilo_new/MyApplication/MyApplication.dart';
import 'package:gotilo_new/Screens/AllListing/AllListingDetailScreen.dart';
import '../../../Api/Response/User/BookingHistory/ResponseBookingHistory.dart';
import '../../../CustomeWidgets/CustomDrawer.dart';
import '../../../CustomeWidgets/CustomLoader.dart';

const Color primaryDark = Color(0xFF1A237E); // Deep Indigo
const Color accentColor = Color(0xFF3949AB);
const Color bgLight = Color(0xFFF0F2F5);

class BookingHistoryScreen extends StatefulWidget {
  const BookingHistoryScreen({super.key});

  @override
  State<BookingHistoryScreen> createState() => _BookingHistoryScreenState();
}

class _BookingHistoryScreenState extends State<BookingHistoryScreen> {
  List<UserBookingHistory> bookingHistory = [];
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  ValueNotifier<bool> isDataAvailable = ValueNotifier(false);
  ValueNotifier<bool> isApiComplete = ValueNotifier(false);

  int counter = 0;
  bool isLoadingMore = false;
  String searchText = "";
  ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    callBookingHistory();
    scrollController.addListener(() {
      if (scrollController.position.pixels == scrollController.position.maxScrollExtent) {
        loadMore();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: bgLight,
      appBar: CustomAppBar(
        title: "My Bookings",
        showSearchIcon: true,
        onSearchChanged: (value) {
          searchText = value;
          callBookingHistory();
        },
        showAction: false,
        onMenuTap: () => _scaffoldKey.currentState?.openDrawer(),
      ),
      drawer: const CustomDrawer(initialRoute: 'booking-history'),
      body: ValueListenableBuilder(
        valueListenable: isApiComplete,
        builder: (context, value, child) {
          if (!value) return const Center(child: CustomLoader(message: "Loading Booking History..",));

          return ValueListenableBuilder(
            valueListenable: isDataAvailable,
            builder: (context, available, child) {
              if (!available) return _buildEmptyState();

              return ListView.builder(
                controller: scrollController,
                padding: const EdgeInsets.symmetric(vertical: 15),
                itemCount: bookingHistory.length + 1,
                itemBuilder: (context, index) {
                  if (index == bookingHistory.length) {
                    return isLoadingMore ? const Center(child: CircularProgressIndicator()) : const SizedBox(height: 50);
                  }

                  final data = bookingHistory[index];
                  return _buildBookingCard(data);
                },
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.calendar_today_outlined, size: 80, color: Colors.grey[300]),
          const SizedBox(height: 15),
          Text("No Bookings Found", style: GoogleFonts.montserrat(fontSize: 18, color: Colors.grey, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }

  Widget _buildBookingCard(UserBookingHistory data) {
    bool isConfirmed = data.statusText == "Confirmed";

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: SharedWidgets.cardBoxDecoration(),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              color: isConfirmed ? Colors.green[50] : Colors.orange[50],
              child: Row(
                children: [
                  CircleAvatar(
                    backgroundColor: isConfirmed ? Colors.green : Colors.orange,
                    radius: 4,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    data.statusText?.toUpperCase() ?? "",
                    style: GoogleFonts.montserrat(
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                      color: isConfirmed ? Colors.green[700] : Colors.orange[700],
                      letterSpacing: 1,
                    ),
                  ),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(data.listingTitle ?? "",
                      style: GoogleFonts.montserrat(fontSize: 18, fontWeight: FontWeight.w700, color: primaryDark)),
                  const SizedBox(height: 15),

                  Column(
                    children: [
                      _iconInfo(Icons.event_available, data.bookingDate ?? ""),
                      const SizedBox(width: 20),
                      _iconInfo(Icons.schedule, data.time ?? ""),
                      _iconInfo(Icons.phone, data.phone ?? ""),
                      _iconInfo(Icons.mail_outline, data.email ?? ""),
                    ],
                  ),

                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 15),
                    child: Divider(height: 1, thickness: 0.5),
                  ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Total Payable", style: GoogleFonts.montserrat(fontSize: 12, color: Colors.grey[500])),
                          Text("₹${data.amount}", style: GoogleFonts.montserrat(fontSize: 20, fontWeight: FontWeight.w800, color: primaryDark)),
                        ],
                      ),
                      ElevatedButton(
                        onPressed: () => callBookingHistoryDetail(bookingId: data.id.toString()),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: darkBlue,
                          foregroundColor: Colors.white,
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                        ),
                        child: Text("Details", style: GoogleFonts.montserrat(fontWeight: FontWeight.w600)),
                      ),
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

  Widget _iconInfo(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Row(
        children: [
          Icon(icon, size: 16, color: darkBlue),
          const SizedBox(width: 6),
          Text(text, style: GoogleFonts.montserrat(fontSize: 13, color: Colors.grey[700], fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }


  Future<void> callBookingHistory() async {
    counter = 0;
    bookingHistory.clear();
    isApiComplete.value = false;
    await fetchData();
  }

  Future<void> loadMore() async {
    if (isLoadingMore) return;
    isLoadingMore = true;
    counter += 10;
    await fetchData(isLoadMore: true);
    isLoadingMore = false;
  }

  Future<void> fetchData({bool isLoadMore = false}) async {
    bool internet = await MyApplication.checkInternet();
    if (!internet) {
      SharedWidgets.showTopSnackBar(context, message: "No Internet Connection",title: "fail");
      return;
    }
    try {
      ResponseBookingHistory? response = await ApiCalls.callBookingHistory(
        RequestBookingHistory(search: searchText, counter: counter.toString(), userId: AppPrefs.userId),
      );
      if (response != null && response.result!.toLowerCase().contains("pass")) {
        if (isLoadMore) {
          bookingHistory.addAll(response.data ?? []);
        } else {
          bookingHistory = response.data ?? [];
        }
        isDataAvailable.value = bookingHistory.isNotEmpty;
      }
    } catch (e) {
      log("Error: $e");
    } finally {
      isApiComplete.value = true;
      setState(() {});
    }
  }

  Future<void> callBookingHistoryDetail({String? bookingId = ""}) async {
    showDialog(context: context, barrierDismissible: false, builder: (context) => const Center(child: CircularProgressIndicator(color: primaryDark)));

    bool internet = await MyApplication.checkInternet();
    if (internet) {
      ResponseBookingHistoryDetail? response = await ApiCalls.callBookingHistoryDetail(RequestBookingHistoryDetail(bookingId: bookingId));
      Navigator.pop(context);

      if (response != null && response.data != null) {
        _showModernDetailsDialog(response.data!);
      }
    } else {
      Navigator.pop(context);
      SharedWidgets.showTopSnackBar(context, message: "No Internet",title: "fail");
    }
  }

  void _showModernDetailsDialog(BookingHistoryDetail data) {
    int totalMin = 0;
    double totalAmount = 0.0;
    data.bookingService?.forEach((e) {
      totalMin += int.tryParse(e.duration.toString()) ?? 0;
      totalAmount += double.tryParse(e.servicePrice.toString()) ?? 0.0;
    });

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.85,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
        ),
        child: Column(
          children: [
            const SizedBox(height: 12),
            Container(width: 50, height: 5, decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(10))),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Booking Summary", style: GoogleFonts.montserrat(fontSize: 22, fontWeight: FontWeight.w800, color: primaryDark)),
                    const SizedBox(height: 25),


                    Text("SERVICES", style: GoogleFonts.montserrat(fontSize: 12, fontWeight: FontWeight.w700, color: Colors.grey, letterSpacing: 1.2)),
                    const SizedBox(height: 15),
                    if (data.bookingService != null)
                      ...data.bookingService!.map((s) => _buildDetailServiceItem(s)).toList(),

                    const SizedBox(height: 30),

                    Text("APPOINTMENT INFO", style: GoogleFonts.montserrat(fontSize: 12, fontWeight: FontWeight.w700, color: Colors.grey, letterSpacing: 1.2)),
                    const SizedBox(height: 15),
                    _buildInfoTile(Icons.location_on_rounded, "Location", data.description ?? "N/A"),
                    _buildInfoTile(Icons.calendar_month_rounded, "Date & Time", "${data.bookingDate} | ${data.startTime}"),
                    _buildInfoTile(Icons.timer_rounded, "Total Duration", "$totalMin Minutes"),

                    const SizedBox(height: 30),


                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: primaryDark,
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Total Amount", style: GoogleFonts.montserrat(color: Colors.white70, fontSize: 16, fontWeight: FontWeight.w500)),
                          Text("₹$totalAmount", style: GoogleFonts.montserrat(color: Colors.white, fontSize: 24, fontWeight: FontWeight.w800)),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailServiceItem(BookingService s) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: Row(
        children: [
          Container(
            height: 45, width: 45,
            decoration: BoxDecoration(color: accentColor.withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
            child: const Icon(Icons.auto_awesome, color: accentColor, size: 20),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(s.serviceTitle ?? "", style: GoogleFonts.montserrat(fontWeight: FontWeight.w700, fontSize: 14)),
                Text("${s.duration} Min", style: GoogleFonts.montserrat(fontSize: 12, color: Colors.grey)),
              ],
            ),
          ),
          Text("₹${s.servicePrice}", style: GoogleFonts.montserrat(fontWeight: FontWeight.w700, color: primaryDark)),
        ],
      ),
    );
  }

  Widget _buildInfoTile(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: accentColor),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: GoogleFonts.montserrat(fontSize: 11, color: Colors.grey[500], fontWeight: FontWeight.w600)),
                const SizedBox(height: 2),
                Text(value, style: GoogleFonts.montserrat(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.black87)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}