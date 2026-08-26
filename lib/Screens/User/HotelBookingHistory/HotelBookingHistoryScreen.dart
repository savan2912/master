import 'dart:async';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gotilo_new/Api/ApiCalls.dart';
import 'package:gotilo_new/Api/Request/User/HotelBooking/RequestHotelBooking.dart';
import 'package:gotilo_new/Api/Response/User/HotelBooking/ResponseHotelBooking.dart';
import 'package:gotilo_new/Constant/AppPref.dart';
import 'package:gotilo_new/CustomeWidgets/CustomAppbar.dart';
import 'package:gotilo_new/CustomeWidgets/SharedWidgets.dart';
import 'package:gotilo_new/MyApplication/MyApplication.dart';
import '../../../Api/Request/User/HotelBooking/RequestHotelBookingCancellation.dart';
import '../../../Api/Response/User/HotelBooking/ResponseHotelBookingCancellation.dart';
import '../../../CustomeWidgets/CustomDrawer.dart';
import '../../../CustomeWidgets/CustomLoader.dart';
import 'HotelBookingDetailScreen.dart';
import 'HotelRoomBookingHistory.dart';
import 'HotelServiceBooking.dart';

class HotelBookingHistory extends StatefulWidget {
  const HotelBookingHistory({super.key});

  @override
  State<HotelBookingHistory> createState() => _HotelBookingHistoryState();
}

class _HotelBookingHistoryState extends State<HotelBookingHistory> {
  final Color primaryDark = const Color(0xFF0F172A);
  final Color accentBlue = const Color(0xFF3B82F6);
  final Color bgLight = const Color(0xFFF1F5F9);
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  List<HotelBooking> bookingList = [];
  final ScrollController _scrollController = ScrollController();
  Timer? _debounce;

  ValueNotifier<bool> isDataAvailable = ValueNotifier(false);
  ValueNotifier<bool> isApiComplete = ValueNotifier(false);
  ValueNotifier<bool> isLoadingMore = ValueNotifier(false);

  int counter = 0;
  bool hasMoreData = true;
  String searchQuery = "";

  @override
  void initState() {
    super.initState();
    callHotelBooking();

    _scrollController.addListener(() {
      if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 100) {
        if (!isLoadingMore.value && hasMoreData && bookingList.length >= 10) {
          _loadMoreData();
        }
      }
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _scrollController.dispose();
    super.dispose();
  }


  Future<void> callHotelBooking() async {
    counter = 0;
    hasMoreData = true;
    setState(() {
      bookingList.clear();
      isApiComplete.value = false;
      isDataAvailable.value = false;
    });
    await _fetchBookings();
  }

  Future<void> _loadMoreData() async {
    setState(() => isLoadingMore.value = true);
    counter += 10;
    await _fetchBookings();
    setState(() => isLoadingMore.value = false);
  }

  Future<void> _fetchBookings() async {
    bool internet = await MyApplication.checkInternet();
    if (internet) {
      try {
        ResponseHotelBooking? response = await ApiCalls.callHotelBooking(RequestHotelBooking(
          userId: AppPrefs.userId,
          counter: counter,
          search: searchQuery,
        ));

        if (response != null && response.result?.toLowerCase() == "pass") {
          if (response.data != null && response.data!.isNotEmpty) {
            if (counter == 0) bookingList.clear();
            bookingList.addAll(response.data!);
            isDataAvailable.value = true;
            if (response.data!.length < 10) hasMoreData = false;
          } else {
            hasMoreData = false;
          }
        }
      } catch (e) {
        log("Hotel Booking Error: $e");
      } finally {
        isApiComplete.value = true;
        if (mounted) setState(() {});
      }
    } else {
      SharedWidgets.showTopSnackBar(context, message: "No Internet Available",title:"fail");
      isApiComplete.value = true;
    }
  }


  void _showCancelDialog(HotelBooking data) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Text(
            "Cancel Booking?",
            style: GoogleFonts.montserrat(fontWeight: FontWeight.bold, color: primaryDark),
          ),
          content: Text(
            "Are you sure you want to cancel your booking at ${data.hotelName}? This action cannot be undone.",
            style: GoogleFonts.inter(fontSize: 14, color: Colors.grey[700]),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("No", style: GoogleFonts.inter(color: Colors.grey[600], fontWeight: FontWeight.w600)),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                _callHotelBookingCancellation(bookingId: data.id.toString());
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              child: Text("Yes, Cancel", style: GoogleFonts.inter(color: Colors.white, fontWeight: FontWeight.bold)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: bgLight,
      appBar: CustomAppBar(
        title: "Booking History",
        showAction: false,
        showSearchIcon: true,
        onMenuTap: () => _scaffoldKey.currentState?.openDrawer(),
        onSearchChanged: (val) {
          if (_debounce?.isActive ?? false) _debounce?.cancel();
          _debounce = Timer(const Duration(milliseconds: 500), () {
            searchQuery = val;
            callHotelBooking();
          });
        },
      ),
      drawer: const CustomDrawer(initialRoute: 'hotel.booking-history'),
      body: ValueListenableBuilder(
        valueListenable: isApiComplete,
        builder: (context, apiDone, child) {
          if (!apiDone && counter == 0) {
            return const Center(child: CustomLoader(message: "Loading Hotel Booking History..",));
          }
          return ValueListenableBuilder(
            valueListenable: isDataAvailable,
            builder: (context, dataExist, child) {
              if (!dataExist) return _buildEmptyState();

              return RefreshIndicator(
                onRefresh: callHotelBooking,
                color: accentBlue,
                child: ListView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  itemCount: bookingList.length + (isLoadingMore.value ? 1 : 0),
                  itemBuilder: (context, index) {
                    if (index < bookingList.length) {
                      return _buildBookingCard(bookingList[index]);
                    } else {
                      return const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Center(child: CircularProgressIndicator()),
                      );
                    }
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildBookingCard(HotelBooking data) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: SharedWidgets.cardBoxDecoration(),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildStatusBadge("Booking: ${data.bookingStatus}", _getStatusColor(data.bookingStatus)),
                _buildStatusBadge("Cancel: ${data.bookingCancellationStatus}", _getStatusColor(data.bookingCancellationStatus)),
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        data.hotelName ?? "N/A",
                        style: GoogleFonts.montserrat(fontWeight: FontWeight.w700, fontSize: 16, color: primaryDark),
                      ),
                      const SizedBox(height: 4),
                      Text("Final Amount: ₹${data.finalAmount}",
                          style: GoogleFonts.inter(fontWeight: FontWeight.w700, color: accentBlue, fontSize: 14)),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () {
                    Get.to(()=> HotelBookingDetailScreen(bookingId: data.id.toString(),));
                  },
                  icon: Icon(Icons.visibility_outlined, color: primaryDark.withOpacity(0.7)),
                  tooltip: "View Details",
                ),
              ],
            ),
          ),

          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Divider(height: 1, thickness: 0.5),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildDetailItem(Icons.calendar_today_outlined, "Check-In", data.checkInDate ?? "N/A"),
                _buildDetailItem(Icons.logout_outlined, "Check-Out", data.checkOutDate ?? "N/A"),
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildDetailItem(Icons.hotel_outlined, "Rooms", "${data.totalRooms}"),
                _buildDetailItem(Icons.airline_seat_flat_outlined, "Mattress", "${data.totalMattress}"),
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Expanded(child: _buildSecondaryButton(Icons.history, "Room History", () {
                  Get.to(()=> HotelRoomBookingHistory(bookingId: data.id.toString(),));
                })),
                const SizedBox(width: 8),
                Expanded(child: _buildSecondaryButton(Icons.room_service_outlined, "Services", () {
                  Get.to(()=> HotelServiceBooking(bookingId: data.id.toString(),));
                })),
                const SizedBox(width: 8),
                _buildCancelButton(() => _showCancelDialog(data)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusBadge(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.3), width: 0.5),
      ),
      child: Text(
        label,
        style: GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.bold, color: color),
      ),
    );
  }

  Widget _buildDetailItem(IconData icon, String label, String value) {
    return Expanded(
      child: Row(
        children: [
          Icon(icon, size: 16, color: Colors.grey[400]),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: GoogleFonts.inter(fontSize: 10, color: Colors.grey[500], fontWeight: FontWeight.w500)),
              Text(value, style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w600, color: primaryDark)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSecondaryButton(IconData icon, String label, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 14, color: primaryDark),
            const SizedBox(width: 4),
            Text(label, style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w600, color: primaryDark)),
          ],
        ),
      ),
    );
  }

  Widget _buildCancelButton(VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.red[50],
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.red.withOpacity(0.2)),
        ),
        child: Text("Cancel", style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.red[700])),
      ),
    );
  }

  Color _getStatusColor(String? status) {
    switch (status?.toLowerCase()) {
      case 'pending': return Colors.orange[700]!;
      case 'confirmed': return Colors.green[700]!;
      case 'cancelled': return Colors.red[700]!;
      default: return Colors.blueGrey;
    }
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.hotel_outlined, size: 80, color: Colors.grey[300]),
          const SizedBox(height: 16),
          Text("No booking history found", style: GoogleFonts.montserrat(fontSize: 16, color: Colors.grey[600], fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }




  Future<void> _callHotelBookingCancellation({String? bookingId=""}) async {
    MyApplication.checkInternet().then((internet) async{
      if(internet){
        try{
          ResponseHotelBookingCancellation? response = await ApiCalls.callHotelBookingCancellation(RequestHotelBookingCancellation(
              bookingId: bookingId,
              userId: AppPrefs.userId
          ));
          if(response != null){
            if(response.result!.isNotEmpty && response.result != null &&
                response.result!.toLowerCase().contains("pass")){
                  SharedWidgets.showTopSnackBar(context, message: response.message!,title: "pass");
            }else{
              SharedWidgets.showTopSnackBar(context, message: response.message!,title: "fail");
            }
          }
        }on Exception catch(e){
          log("$e");
        }catch(e){
          log("$e");
        }finally{

        }
      }else{
        SharedWidgets.showTopSnackBar(context, message: "No Internet Available",title:"fail");
      }
    },);
  }
}








