import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:gotilo_new/CustomeWidgets/CustomAppbar.dart';
import 'package:gotilo_new/CustomeWidgets/SharedWidgets.dart';
import 'package:gotilo_new/MyApplication/MyApplication.dart';

import '../../../Api/ApiCalls.dart';
import '../../../Api/Request/AllListings/RequestServiceBookingStaffList.dart';
import '../../../Api/Response/AllListings/ResponseServiceBookingStaffList.dart';
import 'AdditionalServiceSelectScreen.dart';

class AdditionalServiceAddScreen extends StatefulWidget {
  final String? listingId;
  const AdditionalServiceAddScreen({super.key, this.listingId});

  @override
  State<AdditionalServiceAddScreen> createState() =>
      _AdditionalServiceAddScreenState();
}

class _AdditionalServiceAddScreenState
    extends State<AdditionalServiceAddScreen> {
  List<ServiceBookingStaffList> serviceBookingStaffList = [];

  // Single Selection માટે ID અને Model સ્ટોર કરવા
  int? selectedStaffId;
  ServiceBookingStaffList? selectedStaff;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    callServiceBookingList();
  }

  Future<void> callServiceBookingList() async {
    _callServiceBookingList();
  }

  Future<void> _callServiceBookingList() async {
    setState(() {
      isLoading = true;
    });

    MyApplication.checkInternet().then(
          (internet) async {
        if (internet) {
          try {
            ResponseServiceBookingStaffList? response =
            await ApiCalls.callServiceBookingStaffList(
                RequestServiceBookingStaffList(listingId: widget.listingId));

            if (response != null &&
                response.result != null &&
                response.result!.toLowerCase().contains("pass")) {
              if (response.data != null) {
                setState(() {
                  serviceBookingStaffList = response.data!;
                });
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: "Additional Service Add",
        showAction: false,
        showBackButton: true,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : serviceBookingStaffList.isEmpty
          ? const Center(child: Text("No Staff Available"))
          : ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: serviceBookingStaffList.length,
        itemBuilder: (context, index) {
          final item = serviceBookingStaffList[index];
          final isSelected = selectedStaffId == item.id;

          return GestureDetector(
            onTap: () {
              setState(() {
                // Single Selection Logic
                selectedStaffId = item.id;
                selectedStaff = item; // Next Screen માટે ઓબ્જેક્ટ સ્ટોર કર્યો
              });
            },
            child: Container(
              margin: const EdgeInsets.only(bottom: 16.0),
              padding: const EdgeInsets.symmetric(
                  vertical: 20.0, horizontal: 16.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16.0),
                border: Border.all(
                  color: isSelected ? Colors.blue : Colors.grey.shade300,
                  width: isSelected ? 2.0 : 1.0,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.05),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Profile Icon
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.blue.shade50,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.person,
                      size: 40,
                      color: Colors.blue,
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Name
                  Text(
                    item.name ?? "",
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 6),

                  // Email
                  Text(
                    item.email ?? "",
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.black54,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          );
        },
      ),

      // Bottom Bar માં Next Button
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
          height: 50,
          child: ElevatedButton(
            onPressed: () {
              if (selectedStaffId == null) {
                // સેલેક્ટ ન કર્યું હોય તો SnackBar બતાવશે
                SharedWidgets.showTopSnackBar(
                  context,
                  message: "Please select a staff member to proceed",
                );
              } else {
               Get.to(()=> AdditionalServiceSelectScreen(listingId: widget.listingId,staffId: selectedStaffId.toString(),));
                log("Selected Staff ID: $selectedStaffId");
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0),
              ),
              elevation: 0,
            ),
            child: const Text(
              "Next",
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
}