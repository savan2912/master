import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:gotilo_new/CustomeWidgets/CustomAppbar.dart';
import 'package:gotilo_new/CustomeWidgets/SharedWidgets.dart'; // Maintain your project path
import 'package:gotilo_new/MyApplication/MyApplication.dart';

import '../../../Api/ApiCalls.dart';
import '../../../Api/Request/AllListings/RequestBookingCalender.dart';
import '../../../Api/Response/AllListings/ResponseBookingCalender.dart';
import 'AddPersonalInformationScreen.dart';

class BookingCalenderScreen extends StatefulWidget {
  final String? listingId;
  final String? staffId;
  final String? serviceIds;

  const BookingCalenderScreen({
    super.key,
    this.listingId = "",
    this.staffId = "",
    this.serviceIds = "",
  });

  @override
  State<BookingCalenderScreen> createState() => _BookingCalenderScreenState();
}

class _BookingCalenderScreenState extends State<BookingCalenderScreen> {
  List<Slots> slots = [];
  bool isLoading = false;

  // Selected Date Management
  DateTime selectedDate = DateTime.now();

  // Selected Slot Management
  Slots? selectedSlot;

  @override
  void initState() {
    super.initState();
    // Default current date સાથે API Call
    _callBookingCalender();
  }

  // DateTime ને yyyy-MM-dd ફોર્મેટમાં કન્વર્ટ કરવા માટે Helper Method
  String _formatDateToString(DateTime date) {
    String year = date.year.toString();
    String month = date.month.toString().padLeft(2, '0');
    String day = date.day.toString().padLeft(2, '0');
    return "$year-$month-$day";
  }

  Future<void> callBookingCalender() async {
    _callBookingCalender();
  }

  Future<void> _callBookingCalender() async {
    setState(() {
      isLoading = true;
      slots.clear();
      selectedSlot = null; // Reset slot selection on date change
    });

    String formattedDate = _formatDateToString(selectedDate);

    MyApplication.checkInternet().then(
          (internet) async {
        if (internet) {
          try {
            ResponseBookingCalender? response =
            await ApiCalls.callBookingCalender(
              RequestBookingCalender(
                staffId: widget.staffId,
                listingId: widget.listingId,
                serviceIds: widget.serviceIds,
                date: formattedDate,
              ),
            );

            if (response != null &&
                response.result != null &&
                response.result!.toLowerCase().contains("pass")) {
              if (response.slots != null) {
                setState(() {
                  slots = response.slots!;
                });
              }
            }
          } on Exception catch (e) {
            log("Exception: $e");
          } catch (e) {
            log("Error: $e");
          } finally {
            setState(() {
              isLoading = false;
            });
          }
        } else {
          setState(() {
            isLoading = false;
          });
          SharedWidgets.showTopSnackBar(context,
              message: "No Internet Connection");
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: "Booking Calender",
        showAction: false,
        showBackButton: true,
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          bool isWide = constraints.maxWidth > 700;
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: isWide
                ? Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Left Side - Calendar
                SizedBox(
                  width: 340,
                  child: _buildCalendarSection(),
                ),
                const SizedBox(width: 20),
                // Right Side - Slots
                Expanded(
                  child: _buildSlotsSection(),
                ),
              ],
            )
                : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildCalendarSection(),
                const SizedBox(height: 20),
                _buildSlotsSection(),
              ],
            ),
          );
        },
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, -3),
            ),
          ],
        ),
        child: SizedBox(
          width: double.infinity,
          height: 48,
          child: ElevatedButton(
            onPressed: () {
              if (selectedSlot == null) {
                SharedWidgets.showTopSnackBar(
                  context,
                  message: "Please select a time slot to proceed",
                );
              } else {
                log("Selected Date: ${_formatDateToString(selectedDate)}");
                log("Selected Slot: ${selectedSlot?.from} - ${selectedSlot?.to}");
                Get.to(()=> AddPersonalInformationScreen(
                  serviceIds: widget.serviceIds,
                  listingId: widget.listingId,
                  staffId: widget.staffId,
                  date: _formatDateToString(selectedDate),
                  slotFrom:selectedSlot?.from,
                  slotTo:selectedSlot?.to,
                ));
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              elevation: 0,
            ),
            child: const Text(
              "Book Now",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }

  // --- Widget 1: Calendar View ---
  Widget _buildCalendarSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Select date",
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 10),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12.0),
            border: Border.all(color: Colors.grey.shade200),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.02),
                blurRadius: 5,
                spreadRadius: 1,
              ),
            ],
          ),
          child: Theme(
            data: Theme.of(context).copyWith(
              colorScheme: ColorScheme.light(
                primary: Colors.teal.shade400, // Selected Day background
                onPrimary: Colors.white,
                onSurface: Colors.black87,
              ),
            ),
            child: CalendarDatePicker(
              initialDate: selectedDate,
              firstDate: DateTime.now(), // Previous dates disabled
              lastDate: DateTime.now().add(const Duration(days: 365)),
              onDateChanged: (newDate) {
                setState(() {
                  selectedDate = newDate;
                });
                _callBookingCalender(); // Date બદલાતા જ કૉલ થાશે
              },
            ),
          ),
        ),
      ],
    );
  }

  // --- Widget 2: Time Slots View ---
  Widget _buildSlotsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Select Time",
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 10),
        isLoading
            ? const Center(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 40.0),
            child: CircularProgressIndicator(),
          ),
        )
            : slots.isEmpty
            ? Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Center(
            child: Text(
              "No available slots for selected date.",
              style: TextStyle(color: Colors.grey),
            ),
          ),
        )
            : GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3, // Exact 3 Column design as image
            childAspectRatio: 2.1,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
          ),
          itemCount: slots.length,
          itemBuilder: (context, index) {
            final slot = slots[index];
            final isSelected = selectedSlot == slot;
            final isFull = slot.isFull ?? false;

            return InkWell(
              onTap: isFull
                  ? null
                  : () {
                setState(() {
                  selectedSlot = slot;
                });
              },
              borderRadius: BorderRadius.circular(8.0),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 150),
                decoration: BoxDecoration(
                  // Image UI color setup
                  color: isFull
                      ? Colors.grey.shade100
                      : isSelected
                      ? const Color(0xFF00C865) // Bright Green selected
                      : Colors.white,
                  borderRadius: BorderRadius.circular(8.0),
                  border: Border.all(
                    color: isFull
                        ? Colors.grey.shade200
                        : isSelected
                        ? const Color(0xFF00C865)
                        : Colors.grey.shade200,
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "${slot.from ?? ''} - ${slot.to ?? ''}",
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: isFull
                            ? Colors.grey
                            : isSelected
                            ? Colors.white
                            : Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      slot.durationInfo ?? "",
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w400,
                        color: isFull
                            ? Colors.grey.shade400
                            : isSelected
                            ? Colors.white.withOpacity(0.9)
                            : Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}