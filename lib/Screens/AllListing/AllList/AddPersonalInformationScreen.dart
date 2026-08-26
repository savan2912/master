import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:gotilo_new/Api/ApiCalls.dart';
import 'package:gotilo_new/Api/Request/AllListings/RequestAddService.dart';
import 'package:gotilo_new/Api/Request/AllListings/RequestShowServiceList.dart';
import 'package:gotilo_new/Api/Response/AllListings/ResponseAddService.dart' hide Services;
import 'package:gotilo_new/Constant/AppPref.dart';
import 'package:gotilo_new/CustomeWidgets/CustomAppbar.dart';
import 'package:gotilo_new/CustomeWidgets/SharedWidgets.dart';

import 'package:gotilo_new/MyApplication/MyApplication.dart';

import '../../../Api/Response/AllListings/ResponseShowServiceList.dart' hide Services;
import '../../HeritageHomeScreen.dart';

class AddPersonalInformationScreen extends StatefulWidget {
  final String? date;
  final String? serviceIds;
  final String? listingId;
  final String? staffId;
  final String? slotFrom;
  final String? slotTo;

  const AddPersonalInformationScreen({
    super.key,
    this.date = "",
    this.serviceIds = "",
    this.listingId = "",
    this.staffId = "",
    this.slotFrom = "",
    this.slotTo = "",
  });

  @override
  State<AddPersonalInformationScreen> createState() =>
      _AddPersonalInformationScreenState();
}

class _AddPersonalInformationScreenState
    extends State<AddPersonalInformationScreen> {
  ShowServiceList? showServiceList;
  bool isLoading = false;
  bool isSubmitting = false;

  // Controllers for Personal Info Form
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController notesController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _callShowServiceList();
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    addressController.dispose();
    notesController.dispose();
    super.dispose();
  }

  Future<void> _callShowServiceList() async {
    setState(() {
      isLoading = true;
    });

    MyApplication.checkInternet().then(
          (internet) async {
        if (internet) {
          try {
            ResponseShowServiceList? response =
            await ApiCalls.callShowServiceList(
              RequestShowServiceList(
                date: widget.date,
                serviceIds: widget.serviceIds,
                listingId: widget.listingId,
                staffId: widget.staffId,
                slotFrom: widget.slotFrom,
                slotTo: widget.slotTo,
              ),
            );

            if (response != null &&
                response.result != null &&
                response.result!.toLowerCase().contains("pass")) {
              setState(() {
                showServiceList = response.data;
              });
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

  Future<void> _callAddService() async {
    MyApplication.checkInternet().then(
          (internet) async {
        if (internet) {
          setState(() {
            isSubmitting = true;
          });

          try {
            // Response Services (String IDs) ને Request Services (int IDs) માં Convert કરવું
            List<Services>? requestServices =
            showServiceList?.services?.map((s) {
              return Services(
                id: int.tryParse(s.id ?? "0") ?? 0,
                name: s.name,
                price: s.price,
                minutes: s.minutes,
              );
            }).toList();

            RequestAddService request = RequestAddService(
              id: int.tryParse(AppPrefs.userId) ?? 0,
              listingId: int.tryParse(widget.listingId ?? "0") ?? 0,
              staffId: int.tryParse(widget.staffId ?? "0") ?? 0,
              name: nameController.text.trim(),
              email: emailController.text.trim(),
              phone: phoneController.text.trim(),
              address: addressController.text.trim(),
              description: notesController.text.trim(),
              bookingDate: widget.date,
              slotFrom: widget.slotFrom,
              slotTo: widget.slotTo,
              totalPrice: showServiceList?.totalPrice,
              totalMinutes: showServiceList?.totalMinutes,
              services: requestServices,
            );

            log("Request Payload: ${request.toJson()}");

            ResponseAddService? response =
            await ApiCalls.callAddService(request);

            if (response != null &&
                response.result != null &&
                response.result!.toLowerCase().contains("pass")) {
              Get.offAll(()=> ModernHeritageApp());
              SharedWidgets.showTopSnackBar(
                context,
                message: response.message ?? "Booking confirmed successfully!",title: "pass"
              );
              // Navigate to Home/Success screen as required
            } else {
              SharedWidgets.showTopSnackBar(
                context,
                message: response?.message ?? "Failed to confirm booking",
              );
            }
          } on Exception catch (e) {
            log("Exception in _callAddService: $e");
          } catch (e) {
            log("Error in _callAddService: $e");
          } finally {
            setState(() {
              isSubmitting = false;
            });
          }
        } else {
          SharedWidgets.showTopSnackBar(context,
              message: "No Internet Connection");
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      appBar: const CustomAppBar(
        title: "Add Personal Information",
        showAction: false,
        showBackButton: true,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : showServiceList == null
          ? const Center(child: Text("Failed to load booking summary."))
          : LayoutBuilder(
        builder: (context, constraints) {
          bool isWide = constraints.maxWidth > 800;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(20.0),
            child: isWide
                ? Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Left Column - Booking Summary
                Expanded(
                  flex: 4,
                  child: _buildSummarySection(),
                ),
                const SizedBox(width: 30),
                // Right Column - Form
                Expanded(
                  flex: 6,
                  child: _buildFormSection(),
                ),
              ],
            )
                : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSummarySection(),
                const SizedBox(height: 24),
                _buildFormSection(),
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
            onPressed: isSubmitting
                ? null
                : () {
              if (_formKey.currentState?.validate() ?? false) {
                _callAddService();
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
              elevation: 0,
            ),
            child: isSubmitting
                ? const SizedBox(
              height: 20,
              width: 20,
              child: CircularProgressIndicator(
                color: Colors.white,
                strokeWidth: 2,
              ),
            )
                : const Text(
              "Confirm Booking",
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

  // --- Left Section: Services Summary ---
  Widget _buildSummarySection() {
    var servicesList = showServiceList?.services ?? [];

    return Container(
      padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        color: const Color(0xFFF4F7F8),
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Service Items List
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: servicesList.length,
            separatorBuilder: (context, index) => const SizedBox(height: 16),
            itemBuilder: (context, index) {
              final service = servicesList[index];
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        service.name ?? "",
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "${service.minutes ?? 0} Min",
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                  Text(
                    "₹ ${service.price?.toStringAsFixed(2) ?? '0.00'}",
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                ],
              );
            },
          ),
          const SizedBox(height: 20),
          const Divider(thickness: 1, color: Color(0xFFE2E8F0)),
          const SizedBox(height: 16),

          // Total Amount
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Total Amount",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              Text(
                "₹ ${showServiceList?.totalPrice?.toStringAsFixed(2) ?? '0.00'}",
                style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Date & Time Summary
          const Text(
            "Date & Time",
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            "${showServiceList?.date ?? widget.date} | ${showServiceList?.slot?.from ?? widget.slotFrom} - ${showServiceList?.slot?.to ?? widget.slotTo}",
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade600,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  // --- Right Section: Personal Info Form ---
  Widget _buildFormSection() {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Row 1: Name & Email
          LayoutBuilder(
            builder: (context, constraints) {
              if (constraints.maxWidth > 500) {
                return Row(
                  children: [
                    Expanded(
                      child: _buildInputField(
                        label: "Name",
                        controller: nameController,
                        validator: (val) => val == null || val.isEmpty
                            ? "Please enter name"
                            : null,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _buildInputField(
                        label: "Email",
                        controller: emailController,
                        keyboardType: TextInputType.emailAddress,
                        validator: (val) => val == null || val.isEmpty
                            ? "Please enter email"
                            : null,
                      ),
                    ),
                  ],
                );
              } else {
                return Column(
                  children: [
                    _buildInputField(
                      label: "Name",
                      controller: nameController,
                      validator: (val) => val == null || val.isEmpty
                          ? "Please enter name"
                          : null,
                    ),
                    const SizedBox(height: 16),
                    _buildInputField(
                      label: "Email",
                      controller: emailController,
                      keyboardType: TextInputType.emailAddress,
                      validator: (val) => val == null || val.isEmpty
                          ? "Please enter email"
                          : null,
                    ),
                  ],
                );
              }
            },
          ),
          const SizedBox(height: 16),

          // Row 2: Phone & Address
          LayoutBuilder(
            builder: (context, constraints) {
              if (constraints.maxWidth > 500) {
                return Row(
                  children: [
                    Expanded(
                      child: _buildInputField(
                        label: "Phone Number",
                        controller: phoneController,
                        keyboardType: TextInputType.phone,
                        validator: (val) => val == null || val.isEmpty
                            ? "Please enter phone number"
                            : null,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _buildInputField(
                        label: "Address",
                        controller: addressController,
                      ),
                    ),
                  ],
                );
              } else {
                return Column(
                  children: [
                    _buildInputField(
                      label: "Phone Number",
                      controller: phoneController,
                      keyboardType: TextInputType.phone,
                      validator: (val) => val == null || val.isEmpty
                          ? "Please enter phone number"
                          : null,
                    ),
                    const SizedBox(height: 16),
                    _buildInputField(
                      label: "Address",
                      controller: addressController,
                    ),
                  ],
                );
              }
            },
          ),
          const SizedBox(height: 16),

          // Booking Notes
          _buildInputField(
            label: "Add booking notes",
            controller: notesController,
            maxLines: 4,
          ),
          const SizedBox(height: 24),

          // Cancellation Policy
          const Text(
            "Cancellation policy",
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            "Cancel for free anytime in advance, otherwise you will be charged 100% of the service price for not showing up.",
            style: TextStyle(
              fontSize: 13,
              color: Colors.grey.shade600,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  // --- Input Field Reusable Component ---
  Widget _buildInputField({
    required String label,
    required TextEditingController controller,
    int maxLines = 1,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          maxLines: maxLines,
          keyboardType: keyboardType,
          validator: validator,
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            contentPadding:
            const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
              borderSide: const BorderSide(color: Colors.blue, width: 1.5),
            ),
          ),
        ),
      ],
    );
  }
}