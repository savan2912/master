import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gotilo_new/CustomeWidgets/CustomAppbar.dart';

import '../../../Api/ApiCalls.dart';
import '../../../Api/Request/User/HotelBooking/RequestHotelBookingDetail.dart';
import '../../../Api/Response/User/HotelBooking/ResponseHotelBookingDetail.dart';
import '../../../CustomeWidgets/SharedWidgets.dart';
import '../../../MyApplication/MyApplication.dart';

class HotelBookingDetailScreen extends StatefulWidget {
  String? bookingId="";
  HotelBookingDetailScreen({super.key,this.bookingId});

  @override
  State<HotelBookingDetailScreen> createState() => _HotelBookingDetailScreenState();
}

class _HotelBookingDetailScreenState extends State<HotelBookingDetailScreen> {

  HotelBookingDetail? hotelBooking;

  final Color primaryPink = const Color(0xFFE91E63);
  final Color bgLight = const Color(0xFFF8FAFC);
  final Color borderColor = Colors.grey.shade300;
  final Color darkBlue = const Color(0xFF0F172A);

  ValueNotifier<bool> isDataAvailable= ValueNotifier(false);
  ValueNotifier<bool> isApiComplete= ValueNotifier(false);

  @override
  void initState() {
    callHotelBookingDetail();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgLight,
      appBar: const CustomAppBar(
        title: "Booking Detail",
        showMenu: false,
        showBackButton: true,
        showAction: false,
      ),
      // ValueListenableBuilder ને અહીં બહાર લઈ લો જેથી તે આખી સ્ક્રીન કવર કરી શકે
      body: ValueListenableBuilder(
        valueListenable: isApiComplete,
        builder: (context, apiDone, child) {

          // 1. જો API હજુ લોડ થતું હોય
          if (!apiDone) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          // 2. જો API પૂરું થઈ ગયું હોય, તો ડેટા ચેક કરો
          return ValueListenableBuilder(
            valueListenable: isDataAvailable,
            builder: (context, dataAvailable, child) {

              if (!dataAvailable) {
                return const Center(
                  child: Text("No data"),
                );
              }

              // 3. જો ડેટા મળી ગયો હોય, ત્યારે જ ScrollView બતાવો
              return SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 30),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSectionCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("${hotelBooking!.rooms![0].totalRooms} x Deluxe Room",
                              style: GoogleFonts.montserrat(color: primaryPink, fontWeight: FontWeight.bold, fontSize: 16)),
                          const SizedBox(height: 12),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                flex: 2,
                                child: Column(
                                  children: [
                                    _buildInfoTile(Icons.people_outline, "${hotelBooking!.rooms![0].adults} Adults, ${hotelBooking!.rooms![0].children} Children"),
                                    const SizedBox(height: 10),
                                    _buildCancellationBox(),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                flex: 1,
                                child: _buildPriceSummarySide(),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),
                    if (hotelBooking!.additionalServices!.isNotEmpty) ...[
                      _buildSectionHeader("Additional Service"),
                      Column(
                        children: hotelBooking!.additionalServices!.map((service) {
                          return _buildServiceItemCard(service);
                        }).toList(),
                      ),
                    ],

                    const SizedBox(height: 20),
                    _buildSectionHeader("Booking Full History"),
                    _buildSectionCard(
                      padding: EdgeInsets.zero,
                      child: Column(
                        children: [
                          _buildHistoryRow("Total Night :", "${hotelBooking!.summary!.totalNights}"),
                          _buildHistoryRow("Total Adults :", "${hotelBooking!.summary!.totalAdults}"),
                          _buildHistoryRow("Total Childrens :", "${hotelBooking!.summary!.totalChildren}"),
                          _buildHistoryRow("Payment Type :", "${hotelBooking!.summary!.paymentType}"),
                          _buildHistoryRow("Room Details :", hotelBooking!.summary!.roomDetails!.join(',')),
                          _buildHistoryRow("Sub Total Amount :", "₹ ${hotelBooking!.summary!.subTotalAmount}"),
                          _buildHistoryRow("Tax Amount :", "₹ ${hotelBooking!.summary!.taxAmount}"),
                          _buildHistoryRow("Discount Amount :", "₹${hotelBooking!.summary!.discountAmount}", isDiscount: true),
                          _buildHistoryRow("Final Amount :", "₹ ${hotelBooking!.summary!.finalAmount}", isLast: true, isBold: true, highlight: true),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildServiceItemCard(AdditionalServices service) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(service.serviceName!, style: GoogleFonts.montserrat(fontWeight: FontWeight.bold, fontSize: 14)),
              Text("₹ ${service.total}", style: GoogleFonts.inter(fontWeight: FontWeight.bold, color: primaryPink)),
            ],
          ),
          const SizedBox(height: 4),
          Text(service.description!, style: GoogleFonts.inter(fontSize: 11, color: Colors.grey.shade600)),
          const Divider(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildServiceDetailItem("Qty", service.quantity.toString()),
              _buildServiceDetailItem("Unit Price", "₹ ${service.unitPrice}"),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildServiceDetailItem(String label, String value) {
    return Row(
      children: [
        Text("$label: ", style: GoogleFonts.inter(fontSize: 11, color: Colors.grey.shade500)),
        Text(value, style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w600)),
      ],
    );
  }
  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8, left: 4),
      child: Text(title, style: GoogleFonts.montserrat(color: primaryPink, fontWeight: FontWeight.bold, fontSize: 15)),
    );
  }

  Widget _buildSectionCard({required Widget child, EdgeInsets? padding}) {
    return Container(
      width: double.infinity,
      padding: padding ?? const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: borderColor),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 5, offset: const Offset(0, 2))
        ],
      ),
      child: child,
    );
  }

  Widget _buildInfoTile(IconData icon, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
      decoration: BoxDecoration(
        border: Border.all(color: borderColor),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(icon, size: 16, color: primaryPink),
          const SizedBox(width: 8),
          Text(text, style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }

  Widget _buildCancellationBox() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        border: Border.all(color: borderColor),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("${hotelBooking!.rooms![0].planName}", style: GoogleFonts.montserrat(color: primaryPink, fontWeight: FontWeight.bold, fontSize: 12)),
          const SizedBox(height: 4),
          Text("${hotelBooking!.rooms![0].features![0].title}", style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 11, color: Colors.green[700])),
          Text("${hotelBooking!.rooms![0].features![0].description}", style: GoogleFonts.inter(fontSize: 10, color: Colors.grey.shade600)),
        ],
      ),
    );
  }

  Widget _buildPriceSummarySide() {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        border: Border.all(color: borderColor),
        borderRadius: BorderRadius.circular(8),
        color: bgLight,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Pricing", style: GoogleFonts.montserrat(color: primaryPink, fontWeight: FontWeight.bold, fontSize: 11)),
          const Divider(),
          _buildSidePriceRow("Date", "${hotelBooking!.rooms![0].priceBreakup![0].date}"),
          _buildSidePriceRow("Mattress", "${hotelBooking!.rooms![0].mattress!.total}"),
          const Divider(),
          _buildSidePriceRow("Sub Total", "${hotelBooking!.rooms![0].subTotal}", color: primaryPink, isBold: true),
        ],
      ),
    );
  }

  Widget _buildSidePriceRow(String label, String value, {Color? color, bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(child: Text(label, style: GoogleFonts.inter(fontSize: 9, fontWeight: isBold ? FontWeight.bold : FontWeight.w500, color: color))),
          Text(value, style: GoogleFonts.inter(fontSize: 9, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildHistoryRow(String label, String value, {bool isLast = false, bool isBold = false, bool highlight = false, bool isDiscount = false}) {
    return Container(
      decoration: BoxDecoration(
        color: highlight ? primaryPink.withOpacity(0.05) : Colors.transparent,
        border: isLast ? null : Border(bottom: BorderSide(color: borderColor.withOpacity(0.5))),
      ),
      child: Row(
        children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(12),
              color: highlight ? Colors.transparent : Colors.grey.shade50,
              child: Text(label, style: GoogleFonts.inter(fontSize: 12, fontWeight: highlight ? FontWeight.bold : FontWeight.w500)),
            ),
          ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(12),
              child: Text(
                value,
                style: GoogleFonts.inter(
                  fontSize: highlight ? 14 : 12,
                  fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
                  color: isDiscount ? Colors.green[700] : (highlight ? primaryPink : darkBlue),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> callHotelBookingDetail() async {
    isDataAvailable.value=false;
    isApiComplete.value=false;
    _callHotelBookingDetail();
  }

  Future<void> _callHotelBookingDetail() async {
    MyApplication.checkInternet().then((internet) async{
      if(internet){
        try{
          ResponseHotelBookingDetail? response = await ApiCalls.callHotelBookingDetail(RequestHotelBookingDetail(
              bookingId: widget.bookingId
          ));
          if(response != null){
            if(response.result!.isNotEmpty && response.result != null &&
                response.result!.toLowerCase().contains("pass")){
                hotelBooking = response.data!;
                isDataAvailable.value=true;
                setState(() {});
            }
          }
        }on Exception catch(e){
          log("$e");
          isDataAvailable.value=false;
        }catch(e){
          log("$e");
          isDataAvailable.value=false;
        }finally{
          isApiComplete.value=true;
        }
      }else{
        SharedWidgets.showTopSnackBar(context, message: "No Internet Available",title:"fail");
      }
    },);
  }
}

