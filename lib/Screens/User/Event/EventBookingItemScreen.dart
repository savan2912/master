import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:gotilo_new/Api/ApiCalls.dart';
import 'package:gotilo_new/Api/Request/User/Event/RequestEventBookingItem.dart';
import 'package:gotilo_new/Api/Response/User/Event/ResponseEventBookingItem.dart';
import '../../../Constant/AppPref.dart';
import 'package:gotilo_new/CustomeWidgets/CustomAppbar.dart';
import '../../../CustomeWidgets/SharedWidgets.dart';
import 'package:gotilo_new/MyApplication/MyApplication.dart';

class EventBookingItemScreen extends StatefulWidget {
  final String? eventId;
  const EventBookingItemScreen({super.key, this.eventId});

  @override
  State<EventBookingItemScreen> createState() => _EventBookingItemScreenState();
}

class _EventBookingItemScreenState extends State<EventBookingItemScreen> {
  EventBookingItem? eventBookingItem;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _callEventBookingItem();
  }

  Future<void> _callEventBookingItem() async {
    bool internet = await MyApplication.checkInternet();
    if (internet) {
      try {
        ResponseEventBookingItem? response = await ApiCalls.callEventBookingItem(
          RequestEventBookingItem(
            userId: AppPrefs.userId,
            eventId: widget.eventId,
          ),
        );

        if (response != null &&
            response.result != null &&
            response.result!.toLowerCase().contains("pass")) {
          setState(() {
            eventBookingItem = response.data;
          });
        }
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
      if (mounted) {
        SharedWidgets.showTopSnackBar(context, message: "No Internet Connection");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: "Event Booking Details",
        showAction: false,
        showBackButton: true,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : eventBookingItem == null
          ? const Center(child: Text("No Data Found", style: TextStyle(fontSize: 16, color: Colors.grey)))
          : SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Section Header
            const Text(
              "Booked Items",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87),
            ),
            const SizedBox(height: 12),

            // Items List (Mobile Adaptive Cards)
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: eventBookingItem?.items?.length ?? 0,
              separatorBuilder: (context, index) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final item = eventBookingItem!.items![index];
                return _buildItemCard(item);
              },
            ),

            const SizedBox(height: 24),

            // Payment Summary Section
            const Text(
              "Payment Summary",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87),
            ),
            const SizedBox(height: 12),

            if (eventBookingItem?.paymentSummary != null)
              _buildPaymentSummaryCard(eventBookingItem!.paymentSummary!),
          ],
        ),
      ),
    );
  }

  // Item Display Card Widget
  Widget _buildItemCard(Items item) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  item.eventName ?? "-",
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  item.categoryName ?? "-",
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Theme.of(context).primaryColor),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Divider(height: 1, color: Color(0xFFEEEEEE)),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildDetailColumn("Slot", item.slotName ?? "-"),
              _buildDetailColumn("Quantity", "${item.quantity ?? 0}"),
              _buildDetailColumn("Price", "₹ ${item.price?.toStringAsFixed(2) ?? "0.00"}"),
              _buildDetailColumn("Total", "₹ ${item.total?.toStringAsFixed(2) ?? "0.00"}", isHighlight: true),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDetailColumn(String label, String value, {bool isHighlight = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 12, color: Colors.grey, fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 13,
            fontWeight: isHighlight ? FontWeight.bold : FontWeight.w600,
            color: isHighlight ? Theme.of(context).primaryColor : Colors.black87,
          ),
        ),
      ],
    );
  }

  // Payment Summary Card Widget
  Widget _buildPaymentSummaryCard(PaymentSummary summary) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          _buildSummaryRow("Subtotal", "₹ ${summary.subtotal?.toStringAsFixed(2) ?? "0.00"}"),
          const SizedBox(height: 10),
          _buildSummaryRow("GST Rate", "${summary.gstRate ?? 0}%"),
          const SizedBox(height: 10),
          _buildSummaryRow("GST Amount", "₹ ${summary.gstAmount?.toStringAsFixed(2) ?? "0.00"}"),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 12.0),
            child: Divider(height: 1, color: Color(0xFFEEEEEE)),
          ),
          _buildSummaryRow(
            "Total Amount",
            "₹ ${summary.totalAmount?.toStringAsFixed(2) ?? "0.00"}",
            isTotal: true,
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value, {bool isTotal = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: isTotal ? 16 : 14,
            fontWeight: isTotal ? FontWeight.bold : FontWeight.w500,
            color: isTotal ? Colors.black : Colors.grey[600],
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: isTotal ? 17 : 14,
            fontWeight: isTotal ? FontWeight.bold : FontWeight.w600,
            color: isTotal ? Theme.of(context).primaryColor : Colors.black87,
          ),
        ),
      ],
    );
  }
}