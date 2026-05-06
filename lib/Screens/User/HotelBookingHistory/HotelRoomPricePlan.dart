import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../Api/ApiCalls.dart';
import '../../../Api/Request/User/HotelBooking/RequestHotelBookingRoomPricePlan.dart';
import '../../../Api/Response/User/HotelBooking/ResponseHotelBookingRoomPricePlan.dart';
import '../../../CustomeWidgets/CustomAppbar.dart';
import '../../../CustomeWidgets/SharedWidgets.dart';
import '../../../MyApplication/MyApplication.dart';

class HotelRoomPricePlan extends StatefulWidget {
  final String? bookingId;
  final String? roomId;
  HotelRoomPricePlan({super.key, this.bookingId, this.roomId});

  @override
  State<HotelRoomPricePlan> createState() => _HotelRoomPricePlanState();
}

class _HotelRoomPricePlanState extends State<HotelRoomPricePlan> {
  List<HotelRoomPricePlanData> hotelRoom = [];
  ValueNotifier<bool> isDataAvailable = ValueNotifier(false);
  ValueNotifier<bool> isApiComplete = ValueNotifier(false);

  int counter = 0;
  bool isLoadMore = false;
  bool hasMoreData = true;
  final ScrollController _scrollController = ScrollController();

  final Color primaryPink = const Color(0xFFE91E63);
  final Color bgLight = const Color(0xFFF8FAFC);

  @override
  void initState() {
    super.initState();
    _callHotelBookingRoomPricePlan();
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
    _callHotelBookingRoomPricePlan();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgLight,
      appBar: CustomAppBar(
        title: "Room Price Plan",
        showAction: false,
        showBackButton: true,
        showSearchIcon: false,
      ),
      body: ValueListenableBuilder(
          valueListenable: isApiComplete,
          builder: (context, apiDone, child) {
            if (!apiDone && counter == 0) {
              return const Center(child: CircularProgressIndicator());
            }

            if (hotelRoom.isEmpty) {
              return const Center(child: Text("No price plan available"));
            }

            return Column(
              children: [
                _buildTableHeader(),
                Expanded(
                  child: ListView.separated(
                    controller: _scrollController,
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 20),
                    itemCount: hotelRoom.length + (isLoadMore ? 1 : 0),
                    separatorBuilder: (context, index) => const SizedBox(height: 8),
                    itemBuilder: (context, index) {
                      if (index < hotelRoom.length) {
                        return _buildPriceItem(hotelRoom[index]);
                      } else {
                        return const Padding(
                          padding: EdgeInsets.all(12.0),
                          child: Center(child: CircularProgressIndicator()),
                        );
                      }
                    },
                  ),
                ),
              ],
            );
          }),
    );
  }

  Widget _buildTableHeader() {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.black87,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Expanded(flex: 2, child: _headerText("Date / Day")),
          Expanded(flex: 1, child: _headerText("Price", textAlign: TextAlign.right)),
        ],
      ),
    );
  }

  Widget _headerText(String text, {TextAlign textAlign = TextAlign.left}) {
    return Text(
      text,
      textAlign: textAlign,
      style: GoogleFonts.montserrat(
        color: Colors.white,
        fontWeight: FontWeight.bold,
        fontSize: 12,
      ),
    );
  }

  Widget _buildPriceItem(HotelRoomPricePlanData item) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          const Icon(Icons.calendar_today_outlined, size: 18, color: Colors.grey),
          const SizedBox(width: 12),
          Expanded(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "${item.date}",
                  style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 14),
                ),
                Text(
                  "${item.dayName}",
                  style: GoogleFonts.inter(color: Colors.grey.shade600, fontSize: 12),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 1,
            child: Text(
              "₹ ${item.price}",
              textAlign: TextAlign.right,
              style: GoogleFonts.montserrat(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: primaryPink,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _callHotelBookingRoomPricePlan() async {
    bool internet = await MyApplication.checkInternet();
    if (internet) {
      try {
        ResponseHotelBookingRoomPricePlan? response =
        await ApiCalls.callHotelBookingRoomPricePlan(RequestHotelBookingRoomPricePlan(
            roomPlanId: widget.roomId,
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