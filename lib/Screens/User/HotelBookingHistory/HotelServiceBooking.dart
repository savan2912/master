import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../Api/ApiCalls.dart';
import '../../../Api/Request/User/HotelBooking/RequestHotelBookingServiceHistory.dart';
import '../../../Api/Response/User/HotelBooking/ResponseHotelBookingServiceHistory.dart';
import '../../../CustomeWidgets/CustomAppbar.dart';
import '../../../CustomeWidgets/SharedWidgets.dart';
import '../../../MyApplication/MyApplication.dart';

class HotelServiceBooking extends StatefulWidget {
  final String? bookingId;
  HotelServiceBooking({super.key, this.bookingId});

  @override
  State<HotelServiceBooking> createState() => _HotelServiceBookingState();
}

class _HotelServiceBookingState extends State<HotelServiceBooking> {
  List<HotelBookingServiceHistory> hotelRoom = [];
  ValueNotifier<bool> isDataAvailable = ValueNotifier(false);
  ValueNotifier<bool> isApiComplete = ValueNotifier(false);

  // Pagination & Search variables
  int counter = 0;
  String searchQuery = "";
  bool isLoadMore = false;
  bool hasMoreData = true;
  final ScrollController _scrollController = ScrollController();

  final Color primaryPink = const Color(0xFFE91E63);
  final Color bgLight = const Color(0xFFF8FAFC);
  final Color darkBlue = const Color(0xFF0F172A);

  @override
  void initState() {
    super.initState();
    _callHotelBookingServiceHistory(); // ફર્સ્ટ ટાઈમ ડેટા લોડ

    // Scroll listener for Pagination
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

  // લોડ મોર ફંક્શન
  void _loadMoreData() {
    setState(() {
      isLoadMore = true;
      counter = counter + 10; // 0, 10, 20...
    });
    _callHotelBookingServiceHistory();
  }

  // સર્ચ ફંક્શન
  void _onSearch(String query) {
    setState(() {
      searchQuery = query;
      counter = 0; // સર્ચ વખતે ફરીથી 0 થી શરૂઆત
      hotelRoom.clear(); // જૂનો ડેટા કાઢી નાખવો
      isApiComplete.value = false;
    });
    _callHotelBookingServiceHistory();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgLight,
      appBar: CustomAppBar(
        title: "Service History",
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

            if (!isDataAvailable.value && hotelRoom.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.layers_clear_outlined, size: 60, color: Colors.grey.shade400),
                    const SizedBox(height: 10),
                    Text("No services found", style: GoogleFonts.inter(color: Colors.grey.shade600)),
                  ],
                ),
              );
            }

            return ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(16),
              itemCount: hotelRoom.length + (isLoadMore ? 1 : 0),
              itemBuilder: (context, index) {
                if (index < hotelRoom.length) {
                  return _buildServiceCard(hotelRoom[index]);
                } else {
                  return const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Center(child: CircularProgressIndicator()),
                  );
                }
              },
            );
          }),
    );
  }

  Widget _buildServiceCard(HotelBookingServiceHistory service) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: darkBlue.withOpacity(0.05),
              borderRadius: const BorderRadius.only(topLeft: Radius.circular(16), topRight: Radius.circular(16)),
            ),
            child: Row(
              children: [
                Icon(Icons.location_city, size: 14, color: darkBlue),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    "${service.hotelName}".toUpperCase(),
                    style: GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.bold, color: darkBlue, letterSpacing: 0.5),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text("${service.serviceName}", style: GoogleFonts.montserrat(fontWeight: FontWeight.bold, fontSize: 16)),
                    ),
                    Text("₹${service.totalPrice}", style: GoogleFonts.montserrat(fontWeight: FontWeight.bold, fontSize: 18, color: primaryPink)),
                  ],
                ),
                const SizedBox(height: 4),
                Text("${service.serviceDescription}", style: GoogleFonts.inter(fontSize: 12, color: Colors.grey.shade600, height: 1.4)),
                const Divider(height: 24),
                Row(
                  children: [
                    _buildInfoBadge(Icons.shopping_basket_outlined, "Qty: ${service.quantity}"),
                    const SizedBox(width: 12),
                    _buildInfoBadge(Icons.sell_outlined, "Price: ₹${service.unitPrice}"),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoBadge(IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(color: Colors.grey.shade100, borderRadius: BorderRadius.circular(8)),
      child: Row(
        children: [
          Icon(icon, size: 14, color: Colors.grey.shade700),
          const SizedBox(width: 6),
          Text(label, style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.grey.shade800)),
        ],
      ),
    );
  }

  Future<void> _callHotelBookingServiceHistory() async {
    bool internet = await MyApplication.checkInternet();
    if (internet) {
      try {
        ResponseHotelBookingServiceHistory? response = await ApiCalls.callHotelBookingServiceHistory(
          RequestHotelBookingServiceHistory(
            search: searchQuery,
            counter: counter.toString(),
            userBookingId: widget.bookingId,
          ),
        );

        if (response != null && response.result != null && response.result!.toLowerCase().contains("pass")) {
          if (response.data != null && response.data!.isNotEmpty) {
            // ડુપ્લીકેટ રોકવા માટે: જો આ પહેલો પેજ (counter 0) હોય તો લિસ્ટ ક્લિયર કરવું
            if (counter == 0) {
              hotelRoom.clear();
            }

            hotelRoom.addAll(response.data!);
            isDataAvailable.value = true;
            hasMoreData = response.data!.length >= 10; // જો 10 થી ઓછા હોય તો સમજો કે હવે ડેટા પતી ગયો
          } else {
            if (counter == 0) isDataAvailable.value = false;
            hasMoreData = false;
          }
        }
      } catch (e) {
        log("Error: $e");
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