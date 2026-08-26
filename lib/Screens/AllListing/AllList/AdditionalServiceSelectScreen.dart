import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:gotilo_new/Api/ApiCalls.dart';
import 'package:gotilo_new/Api/Request/AllListings/RequestAdditionalServiceList.dart';
import 'package:gotilo_new/Api/Response/AllListings/ResponseAdditionalServiceList.dart';
import 'package:gotilo_new/CustomeWidgets/CustomAppbar.dart';
import 'package:gotilo_new/CustomeWidgets/SharedWidgets.dart';
import 'package:gotilo_new/MyApplication/MyApplication.dart';

import 'BookingCalenderScreen.dart';

class AdditionalServiceSelectScreen extends StatefulWidget {
  final String? listingId;
  final String? staffId;

  const AdditionalServiceSelectScreen({
    super.key,
    this.listingId = "",
    this.staffId = "",
  });

  @override
  State<AdditionalServiceSelectScreen> createState() =>
      _AdditionalServiceSelectScreenState();
}

class _AdditionalServiceSelectScreenState
    extends State<AdditionalServiceSelectScreen> {
  List<AdditionalServiceList> additionalServiceList = [];

  // Multiple Selection માટે List
  List<AdditionalServiceList> selectedServices = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    callAdditionalServiceList();
  }

  Future<void> callAdditionalServiceList() async {
    _callAdditionalServiceList();
  }

  Future<void> _callAdditionalServiceList() async {
    setState(() {
      isLoading = true;
    });

    MyApplication.checkInternet().then(
          (internet) async {
        if (internet) {
          try {
            ResponseAdditionalServiceList? response =
            await ApiCalls.callAdditionalServiceList(
              RequestAdditionalServiceList(
                listingId: widget.listingId,
                staffId: widget.staffId,
              ),
            );

            if (response != null &&
                response.result != null &&
                response.result!.toLowerCase().contains("pass")) {
              if (response.data != null) {
                additionalServiceList = response.data!;
              }
            }
          } on Exception catch (e) {
            log("$e");
          } catch (e) {
            log("$e");
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

  // Duration ને "01:20:00" માંથી "80 min" ફોર્મેટમાં ફેરવવા માટે Helper Function
  String formatDuration(String? duration) {
    if (duration == null || duration.isEmpty) return "0 min";
    try {
      List<String> parts = duration.split(':');
      if (parts.length == 3) {
        int hours = int.tryParse(parts[0]) ?? 0;
        int minutes = int.tryParse(parts[1]) ?? 0;
        int totalMinutes = (hours * 60) + minutes;
        return "$totalMinutes min";
      }
    } catch (e) {
      log("Duration parsing error: $e");
    }
    return duration;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: "Additional Service Select",
        showAction: false,
        showBackButton: true,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : additionalServiceList.isEmpty
          ? const Center(child: Text("No Additional Services Found"))
          : ListView.builder(
        padding: const EdgeInsets.all(12.0),
        itemCount: additionalServiceList.length,
        itemBuilder: (context, index) {
          final item = additionalServiceList[index];
          final isSelected = selectedServices.contains(item);

          return Container(
            margin: const EdgeInsets.only(bottom: 12.0),
            padding: const EdgeInsets.symmetric(
                horizontal: 16.0, vertical: 14.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10.0),
              border: Border.all(
                color: isSelected
                    ? Colors.green.shade400
                    : Colors.grey.shade200,
                width: isSelected ? 1.5 : 1.0,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.02),
                  blurRadius: 4,
                  spreadRadius: 1,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Title, Price & Duration Info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.serviceTitle ?? "",
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        "₹${item.basePrice ?? '0'} / ${formatDuration(item.duration)}",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey.shade700,
                        ),
                      ),
                    ],
                  ),
                ),

                // Add / Added Toggle Button
                InkWell(
                  onTap: () {
                    setState(() {
                      if (isSelected) {
                        selectedServices.remove(item);
                      } else {
                        selectedServices.add(item);
                      }
                    });
                  },
                  borderRadius: BorderRadius.circular(8),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14.0, vertical: 8.0),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? Colors.green.shade50
                          : Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(8.0),
                      border: Border.all(
                        color: isSelected
                            ? Colors.green
                            : Colors.grey.shade300,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          isSelected
                              ? Icons.check_circle_outline
                              : Icons.add_circle_outline,
                          size: 18,
                          color: isSelected
                              ? Colors.green
                              : Colors.grey.shade700,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          isSelected ? "Added" : "Add",
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: isSelected
                                ? Colors.green
                                : Colors.grey.shade800,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),

      // Bottom Bar (Done / Continue Button)
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
              if (selectedServices.isEmpty) {
                SharedWidgets.showTopSnackBar(
                  context,
                  message: "Please select at least one service",
                );
              } else {
                // અહીં ID ની '1,2,3' વાળી Comma Separated String બનાવી છે
                String serviceIdsString = selectedServices
                    .map((e) => e.id)
                    .where((id) => id != null)
                    .join(',');

                log("Selected Service IDs String: $serviceIdsString");

                Get.to(
                      () => BookingCalenderScreen(
                    staffId: widget.staffId,
                    listingId: widget.listingId,
                    serviceIds: serviceIdsString, // "1,2,3" પાસ થશે
                  ),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              elevation: 0,
            ),
            child: Text(
              selectedServices.isNotEmpty
                  ? "Continue (${selectedServices.length} Selected)"
                  : "Continue",
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }
}