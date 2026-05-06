import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gotilo_new/CustomeWidgets/CustomAppbar.dart';

import '../../../Api/ApiCalls.dart';
import '../../../Api/Request/User/HotelBooking/RequestHotelBookingRoomHistory.dart';
import '../../../Api/Response/User/HotelBooking/ResponseHotelBookingRoomHistory.dart';
import '../../../CustomeWidgets/SharedWidgets.dart';
import '../../../MyApplication/MyApplication.dart';
import 'HotelRoomPricePlan.dart';

class HotelRoomBookingHistory extends StatefulWidget {
  final String? bookingId;
  HotelRoomBookingHistory({super.key, this.bookingId});

  @override
  State<HotelRoomBookingHistory> createState() => _HotelRoomBookingHistoryState();
}

class _HotelRoomBookingHistoryState extends State<HotelRoomBookingHistory> {
  List<HotelRoomHistory> hotelRoom = [];
  ValueNotifier<bool> isDataAvailable = ValueNotifier(false);
  ValueNotifier<bool> isApiComplete = ValueNotifier(false);

  int counter = 0;
  String searchQuery = "";
  bool isLoadMore = false;
  bool hasMoreData = true;
  final ScrollController _scrollController = ScrollController();

  final Color primaryPink = const Color(0xFFE91E63);
  final Color bgLight = const Color(0xFFF8FAFC);

  @override
  void initState() {
    super.initState();
    _callHotelBookingRoomHistory();


    _scrollController.addListener(() {
      if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
        if (!isLoadMore && hasMoreData) {
          _loadMoreData();
        }
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }


  void _loadMoreData() {
    setState(() {
      isLoadMore = true;
      counter = counter + 10;
    });
    _callHotelBookingRoomHistory();
  }


  void _onSearch(String query) {
    setState(() {
      searchQuery = query;
      counter = 0;
      hotelRoom.clear();
      isApiComplete.value = false;
    });
    _callHotelBookingRoomHistory();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgLight,
      appBar: CustomAppBar(
        title: "Room Booking History",
        showAction: false,
        showBackButton: true,
        showSearchIcon: true,
        onSearchChanged: (val) {
          _onSearch(val);
        },
      ),
      body: ValueListenableBuilder(
          valueListenable: isApiComplete,
          builder: (context, apiDone, child) {
            if (!apiDone && counter == 0) {
              return const Center(child: CircularProgressIndicator());
            }

            if (hotelRoom.isEmpty) {
              return const Center(child: Text("No data available"));
            }

            return ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(12),
              itemCount: hotelRoom.length + (isLoadMore ? 1 : 0),
              itemBuilder: (context, index) {
                if (index < hotelRoom.length) {
                  return _buildRoomCard(hotelRoom[index]);
                } else {
                  return const Padding(
                    padding: EdgeInsets.all(10.0),
                    child: Center(child: CircularProgressIndicator()),
                  );
                }
              },
            );
          }),
    );
  }

  Widget _buildRoomCard(HotelRoomHistory room) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: primaryPink.withOpacity(0.1),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(15),
                topRight: Radius.circular(15),
              ),
            ),
            child: Row(
              children: [
                const Icon(Icons.hotel, color: Color(0xFFE91E63), size: 20),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    "${room.hotelName}",
                    style: GoogleFonts.montserrat(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: Colors.black87,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "${room.roomName}",
                  style: GoogleFonts.inter(
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                    color: primaryPink,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  "Plan: ${room.planName}",
                  style: GoogleFonts.inter(fontSize: 12, color: Colors.grey.shade600),
                ),
                const Divider(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildDateColumn("CHECK-IN", room.checkIn ?? ""),
                    _buildDateColumn("CHECK-OUT", room.checkOut ?? ""),
                    _buildDateColumn("TOTAL ROOM", room.totalRoom?.toString() ?? "0"),
                  ],
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Get.to(() => HotelRoomPricePlan(
                        bookingId: widget.bookingId,
                        roomId: room.roomPlanId.toString(),
                      ));
                    },
                    icon: const Icon(Icons.receipt_long_rounded, size: 18),
                    label: const Text("View Room Price Plan"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black87,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
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

  Widget _buildDateColumn(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 10,
            letterSpacing: 0.5,
            fontWeight: FontWeight.bold,
            color: Colors.grey.shade500,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: GoogleFonts.inter(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }

  Future<void> _callHotelBookingRoomHistory() async {
    bool internet = await MyApplication.checkInternet();
    if (internet) {
      try {
        ResponseHotelBookingRoomHistory? response =
        await ApiCalls.callHotelBookingRoomHistory(
            RequestHotelBookingRoomHistory(
                search: searchQuery,
                counter: counter.toString(),
                userBookingId: widget.bookingId));
        if (response != null && response.result != null && response.result!.toLowerCase().contains("pass")) {
          if (response.data != null && response.data!.isNotEmpty) {
            if (counter == 0) {
              hotelRoom.clear();
            }

            hotelRoom.addAll(response.data!);
            isDataAvailable.value = true;
            hasMoreData = response.data!.length >= 10;
          } else {
            if (counter == 0) isDataAvailable.value = false;
            hasMoreData = false;
          }
        }
      } catch (e) {
        log("Error: $e");
        if (counter == 0) isDataAvailable.value = false;
      } finally {
        isApiComplete.value = true;
        isLoadMore = false;
        setState(() {});
      }
    } else {
      SharedWidgets.showTopSnackBar(context, message: "No Internet Available");
    }
  }
}