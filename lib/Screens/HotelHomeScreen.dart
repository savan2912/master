import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gotilo_new/CustomeWidgets/SharedWidgets.dart';
import 'package:gotilo_new/MyApplication/MyApplication.dart';
import 'package:intl/intl.dart';

import '../Api/ApiCalls.dart';
import '../Api/Request/AllListings/RequestReserveBook.dart';
import '../Api/Response/AllListings/ResponseReserveBook.dart';
import '../Api/Response/Home/ResponseHomeHotelAvailable.dart';
import '../Api/Response/Home/ResponseHomeServiceAvailable.dart' as ServiceModel;
import '../Constant/AppPref.dart';
import 'AllListing/AllList/AdditionalServiceAddScreen.dart';
import 'AllListing/AllList/HotelDetailScreenForBook.dart';

class HotelHomeScreen extends StatefulWidget {
  const HotelHomeScreen({super.key});

  @override
  State<HotelHomeScreen> createState() => _HotelHomeScreenState();
}

class _HotelHomeScreenState extends State<HotelHomeScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  HotelHomeList? homeHotelList;
  ServiceModel.HomeServiceList? homeServiceList;

  bool isHotelLoading = true;
  bool isServiceLoading = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _callHomeHotel();
    _callHomeServiceList();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
      appBar: AppBar(
        title: Text(
          "Bookings",
          style: GoogleFonts.poppins(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: const Color(0xFF1E293B),
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(50),
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            height: 44,
            decoration: BoxDecoration(
              color: const Color(0xFFF1F5F9),
              borderRadius: BorderRadius.circular(12),
            ),
            child: TabBar(
              controller: _tabController,
              indicator: BoxDecoration(
                color: const Color(0xFF2563EB),
                borderRadius: BorderRadius.circular(10),
              ),
              indicatorSize: TabBarIndicatorSize.tab,
              labelColor: Colors.white,
              unselectedLabelColor: const Color(0xFF64748B),
              labelStyle: GoogleFonts.poppins(
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
              unselectedLabelStyle: GoogleFonts.poppins(
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
              tabs: const [
                Tab(text: "Hotel Booking"),
                Tab(text: "Service Booking"),
              ],
            ),
          ),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildHotelBookingTab(),
          _buildServiceBookingTab(),
        ],
      ),
    );
  }

  // ================= HOTEL TAB =================
  Widget _buildHotelBookingTab() {
    if (isHotelLoading) {
      return const Center(
        child: CircularProgressIndicator(
          color: Color(0xFF2563EB),
          strokeWidth: 2.5,
        ),
      );
    }

    if (homeHotelList?.listings == null || homeHotelList!.listings!.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.hotel_outlined, size: 64, color: Colors.grey.shade400),
            const SizedBox(height: 12),
            Text(
              "No Hotels Available Currently",
              style: GoogleFonts.poppins(
                fontSize: 15,
                fontWeight: FontWeight.w500,
                color: Colors.grey.shade600,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 16.0, bottom: 100.0),
      itemCount: homeHotelList?.listings?.length ?? 0,
      itemBuilder: (context, index) {
        final item = homeHotelList!.listings![index];
        return _buildPremiumHotelCard(item);
      },
    );
  }

  Widget _buildPremiumHotelCard(Listings item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0F172A).withOpacity(0.06),
            blurRadius: 20,
            spreadRadius: 0,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                child: Image.network(
                  item.imgS3Path ?? '',
                  height: 190,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    height: 190,
                    color: Colors.grey.shade200,
                    child: const Icon(Icons.hotel_rounded, size: 54, color: Colors.grey),
                  ),
                ),
              ),
              if (item.category?.name != null)
                Positioned(
                  top: 12,
                  left: 12,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.55),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Text(
                      item.category!.name!,
                      style: GoogleFonts.poppins(
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.listingTitle ?? "N/A",
                  style: GoogleFonts.poppins(
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF0F172A),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 6),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.location_on_outlined, size: 16, color: Color(0xFF64748B)),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        "${item.address ?? ''}, ${item.zipCode ?? ''}",
                        style: GoogleFonts.poppins(
                          fontSize: 13,
                          color: const Color(0xFF64748B),
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    const Icon(Icons.phone_outlined, size: 16, color: Color(0xFF64748B)),
                    const SizedBox(width: 4),
                    Text(
                      item.mobileNo ?? "N/A",
                      style: GoogleFonts.poppins(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xFF64748B),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF2563EB),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    onPressed: () {
                      _showBookingBottomSheet(item);
                    },
                    child: Text(
                      "Book Now",
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
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

  // ================= SERVICE TAB =================
  Widget _buildServiceBookingTab() {
    if (isServiceLoading) {
      return const Center(
        child: CircularProgressIndicator(
          color: Color(0xFF2563EB),
          strokeWidth: 2.5,
        ),
      );
    }

    if (homeServiceList?.listings == null || homeServiceList!.listings!.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.cleaning_services_outlined, size: 64, color: Colors.grey.shade400),
            const SizedBox(height: 12),
            Text(
              "No Services Available Currently",
              style: GoogleFonts.poppins(
                fontSize: 15,
                fontWeight: FontWeight.w500,
                color: Colors.grey.shade600,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 16.0, bottom: 100.0),
      itemCount: homeServiceList?.listings?.length ?? 0,
      itemBuilder: (context, index) {
        final item = homeServiceList!.listings![index];
        return _buildServiceCard(item);
      },
    );
  }

  Widget _buildServiceCard(ServiceModel.Listings item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0F172A).withOpacity(0.06),
            blurRadius: 20,
            spreadRadius: 0,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                child: Image.network(
                  item.imgS3Path ?? '',
                  height: 190,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    height: 190,
                    color: Colors.grey.shade200,
                    child: const Icon(Icons.cleaning_services_rounded, size: 54, color: Colors.grey),
                  ),
                ),
              ),
              if (item.category?.name != null)
                Positioned(
                  top: 12,
                  left: 12,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.55),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Text(
                      item.category!.name!,
                      style: GoogleFonts.poppins(
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.listingTitle ?? "N/A",
                  style: GoogleFonts.poppins(
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF0F172A),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 6),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.location_on_outlined, size: 16, color: Color(0xFF64748B)),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        "${item.address ?? ''}, ${item.zipCode ?? ''}",
                        style: GoogleFonts.poppins(
                          fontSize: 13,
                          color: const Color(0xFF64748B),
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    const Icon(Icons.phone_outlined, size: 16, color: Color(0xFF64748B)),
                    const SizedBox(width: 4),
                    Text(
                      item.mobileNo ?? "N/A",
                      style: GoogleFonts.poppins(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xFF64748B),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF2563EB),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    onPressed: () {
                      if(AppPrefs.userId != ""){
                        Get.to(()=> AdditionalServiceAddScreen(listingId: item.id.toString(),));
                      }else{
                        SharedWidgets.showTopSnackBar(context, message:"Please Login First", title: "fail");
                      }
                    },
                    child: Text(
                      "Book Service",
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
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

  // ================= HOTEL BOTTOM SHEET =================
  void _showBookingBottomSheet(Listings hotel) {
    DateTime? checkInDate;
    DateTime? checkOutDate;
    int adults = 1;
    int children = 0;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useRootNavigator: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: EdgeInsets.only(
                left: 20,
                right: 20,
                top: 12,
                bottom: MediaQuery.of(context).viewInsets.bottom + 20,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 36,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    hotel.listingTitle ?? "Reserve Stay",
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF0F172A),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "Select dates and number of guests",
                    style: GoogleFonts.poppins(fontSize: 12, color: const Color(0xFF64748B)),
                  ),
                  const SizedBox(height: 18),
                  Row(
                    children: [
                      Expanded(
                        child: _buildDateTile(
                          title: "Check-In",
                          date: checkInDate,
                          onTap: () async {
                            DateTime? picked = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime.now(),
                              lastDate: DateTime.now().add(const Duration(days: 365)),
                            );
                            if (picked != null) {
                              setModalState(() {
                                checkInDate = picked;
                              });
                            }
                          },
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildDateTile(
                          title: "Check-Out",
                          date: checkOutDate,
                          onTap: () async {
                            DateTime initial = checkInDate ?? DateTime.now();
                            DateTime? picked = await showDatePicker(
                              context: context,
                              initialDate: initial.add(const Duration(days: 1)),
                              firstDate: initial,
                              lastDate: DateTime.now().add(const Duration(days: 365)),
                            );
                            if (picked != null) {
                              setModalState(() {
                                checkOutDate = picked;
                              });
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF8FAFC),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: const Color(0xFFE2E8F0)),
                    ),
                    child: Column(
                      children: [
                        _buildCounterRow(
                          title: "Adults",
                          subtitle: "Age 12+",
                          count: adults,
                          onDecrement: adults > 1 ? () => setModalState(() => adults--) : null,
                          onIncrement: () => setModalState(() => adults++),
                        ),
                        const Divider(height: 16, color: Color(0xFFE2E8F0)),
                        _buildCounterRow(
                          title: "Children",
                          subtitle: "Age 0-11",
                          count: children,
                          onDecrement: children > 0 ? () => setModalState(() => children--) : null,
                          onIncrement: () => setModalState(() => children++),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF2563EB),
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      onPressed: () {
                        if(AppPrefs.userId != ""){
                          _callReserveBook(adults: adults,childs: children,checkInDate: checkInDate,checkOutDate: checkOutDate,listingId:hotel.id);
                        }else{
                          SharedWidgets.showTopSnackBar(context, message:"Please Login First",title: "fail");
                        }
                        log("Booking Submitted for ${hotel.id}: CheckIn: $checkInDate, CheckOut: $checkOutDate, Adults: $adults, Children: $children");
                      },
                      child: Text(
                        "Confirm Booking",
                        style: GoogleFonts.poppins(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  )
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildDateTile({required String title, DateTime? date, required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: const Color(0xFFF8FAFC),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: const Color(0xFFE2E8F0)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.calendar_today_outlined, size: 14, color: Color(0xFF64748B)),
                const SizedBox(width: 6),
                Text(
                  title,
                  style: GoogleFonts.poppins(fontSize: 11, color: const Color(0xFF64748B)),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              date != null ? DateFormat('dd MMM yyyy').format(date) : "Select Date",
              style: GoogleFonts.poppins(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: date != null ? const Color(0xFF0F172A) : const Color(0xFF94A3B8),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCounterRow({
    required String title,
    required String subtitle,
    required int count,
    VoidCallback? onDecrement,
    required VoidCallback onIncrement,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w600, color: const Color(0xFF0F172A)),
            ),
            Text(
              subtitle,
              style: GoogleFonts.poppins(fontSize: 11, color: const Color(0xFF94A3B8)),
            ),
          ],
        ),
        Row(
          children: [
            IconButton(
              onPressed: onDecrement,
              icon: const Icon(Icons.remove_circle_outline_rounded),
              color: onDecrement != null ? const Color(0xFF2563EB) : const Color(0xFFCBD5E1),
              iconSize: 22,
            ),
            Text(
              "$count",
              style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w600, color: const Color(0xFF0F172A)),
            ),
            IconButton(
              onPressed: onIncrement,
              icon: const Icon(Icons.add_circle_outline_rounded),
              color: const Color(0xFF2563EB),
              iconSize: 22,
            ),
          ],
        ),
      ],
    );
  }

  // ================= API CALLS =================
  Future<void> _callHomeHotel() async {
    bool? internet = await MyApplication.checkInternet();
    if (internet == true) {
      try {
        ResponseHomeHotelAvailable? response = await ApiCalls.callHomeHotelAvailable();
        if (response != null &&
            response.result != null &&
            response.result!.isNotEmpty &&
            response.result!.toLowerCase().contains("pass")) {
          homeHotelList = response.data;
        }
      } catch (e) {
        log("Hotel API Error: $e");
      } finally {
        if (mounted) {
          setState(() {
            isHotelLoading = false;
          });
        }
      }
    } else {
      if (mounted) {
        setState(() {
          isHotelLoading = false;
        });
        SharedWidgets.showTopSnackBar(context, message: "No Internet Connection", title: "fail");
      }
    }
  }

  Future<void> _callHomeServiceList() async {
    bool? internet = await MyApplication.checkInternet();
    if (internet == true) {
      try {
        ServiceModel.ResponseHomeServiceAvailable? response = await ApiCalls.callHomeServiceAvailable();
        if (response != null &&
            response.result != null &&
            response.result!.isNotEmpty &&
            response.result!.toLowerCase().contains("pass")) {
          homeServiceList = response.data;
        }
      } catch (e) {
        log("Service API Error: $e");
      } finally {
        if (mounted) {
          setState(() {
            isServiceLoading = false;
          });
        }
      }
    } else {
      if (mounted) {
        setState(() {
          isServiceLoading = false;
        });
        SharedWidgets.showTopSnackBar(context, message: "No Internet Connection", title: "fail");
      }
    }
  }

  Future<void> _callReserveBook({int? adults,int? childs,DateTime? checkInDate,DateTime? checkOutDate,int? listingId}) async {
    MyApplication.checkInternet().then((internet) async {
      if(internet){
        try{
          // DateFormat નો ઇન્સ્ટન્સ બનાવો
          final DateFormat apiDateFormat = DateFormat('yyyy-MM-dd');

          ResponseReserveBook? response = await ApiCalls.callReserveBook(RequestReserveBook(
            userId: AppPrefs.userId,
            listingId: listingId,
            adults:adults,
            childs: childs,
            // અહીં .toString() ની જગ્યાએ ફોર્મેટેડ તારીખ મોકલો
            checkin: checkInDate != null ? apiDateFormat.format(checkInDate) : "",
            checkout: checkOutDate != null ? apiDateFormat.format(checkOutDate) : "",
          ));

          if(response != null){
            if(response.result!.isNotEmpty && response.result != null &&
                response.result!.toLowerCase().contains("pass")){
              if(response.data.toString().isNotEmpty){
                Get.to(()=> HotelDetailScreenForBook(hotelDesign: response.data,));
              }
              SharedWidgets.showTopSnackBar(context, message: response.message!, title: "pass");
            }else{
              SharedWidgets.showTopSnackBar(context, message: response.message!, title: "fail");
            }
          }
        } on Exception catch(e){
          log("$e");
        } catch(e){
          log("$e");
        }
      } else {
        SharedWidgets.showTopSnackBar(context, message:"No Internet Connection",title: "fail");
      }
    });
  }


}