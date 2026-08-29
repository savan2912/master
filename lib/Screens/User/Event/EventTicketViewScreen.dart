import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:gotilo_new/Api/ApiCalls.dart';
import 'package:gotilo_new/Api/Request/User/Event/RequestEventTicketView.dart';
import 'package:gotilo_new/Api/Response/User/Event/ResponseEventTicketView.dart';
import 'package:gotilo_new/Constant/AppPref.dart';
import 'package:gotilo_new/CustomeWidgets/CustomAppbar.dart';
import 'package:gotilo_new/CustomeWidgets/SharedWidgets.dart';
import '../../../MyApplication/MyApplication.dart';

class EventTicketViewScreen extends StatefulWidget {
  final String? bookingId;
  const EventTicketViewScreen({super.key, this.bookingId});

  @override
  State<EventTicketViewScreen> createState() => _EventTicketViewScreenState();
}

class _EventTicketViewScreenState extends State<EventTicketViewScreen> {
  EventTicketView? eventTicketView;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _callEventTicketView();
  }

  Future<void> _callEventTicketView() async {
    bool internet = await MyApplication.checkInternet();
    if (internet) {
      try {
        ResponseEventTicketView? response = await ApiCalls.callEventTicketView(
          RequestEventTicketView(
            userId: AppPrefs.userId,
            bookingId: widget.bookingId,
          ),
        );
        if (response != null && response.result != null && response.result!.toLowerCase().contains("pass")) {
          eventTicketView = response.data;
        }
      } catch (e) {
        log("Exception: $e");
      } finally {
        if (mounted) {
          setState(() {
            isLoading = false;
          });
        }
      }
    } else {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
      SharedWidgets.showTopSnackBar(context, message: "No Internet Connection");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF1F5F9),
      appBar: const CustomAppBar(
        title: "Event Ticket",
        showAction: false,
        showBackButton: true,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator(color: Color(0xFF00C4CC)))
          : eventTicketView == null
          ? _buildEmptyView()
          : SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        child: Center(
          child: Container(
            width: 400,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Header Banner Section
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: const BoxDecoration(
                    color: Color(0xFF00C4CC),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                  ),
                  child: Column(
                    children: [
                      const Icon(Icons.confirmation_number_rounded, color: Colors.white, size: 40),
                      const SizedBox(height: 8),
                      Text(
                        eventTicketView?.event?.title ?? "Event Title",
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          "Booking ID: #${eventTicketView?.bookingId ?? 'N/A'}",
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // Event Details Section
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      _buildDetailRow(
                        icon: Icons.person_outline_rounded,
                        title: "Attendee Name",
                        value: eventTicketView?.user?.fullName ?? "N/A",
                      ),
                      const SizedBox(height: 16),
                      _buildDetailRow(
                        icon: Icons.calendar_today_rounded,
                        title: "Booking Date & Time",
                        value: "${eventTicketView?.bookingDate ?? ''} | ${eventTicketView?.bookingTime ?? ''}",
                      ),
                      const SizedBox(height: 16),
                      _buildDetailRow(
                        icon: Icons.confirmation_number_outlined,
                        title: "Total Pass / Tickets",
                        value: "${eventTicketView?.totalTickets ?? 0} Person(s)",
                      ),
                      const SizedBox(height: 16),
                      _buildDetailRow(
                        icon: Icons.location_on_outlined,
                        title: "Venue Address",
                        value: eventTicketView?.event?.address ?? "N/A",
                      ),
                    ],
                  ),
                ),

                // Dotted Cutout Divider
                _buildTicketDivider(),

                // Bottom Pass Status Section (Replacing QR)
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF8FAFC),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: const Color(0xFFE2E8F0)),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(Icons.verified_rounded, color: Color(0xFF10B981), size: 20),
                        SizedBox(width: 8),
                        Text(
                          "Valid Entry Pass",
                          style: TextStyle(
                            color: Color(0xFF0F172A),
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Row Item Builder Widget
  Widget _buildDetailRow({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: const Color(0xFFF1F5F9),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: const Color(0xFF00C4CC), size: 18),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: Color(0xFF64748B),
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: const TextStyle(
                  color: Color(0xFF0F172A),
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // Ticket Dotted Cutout Line Component
  Widget _buildTicketDivider() {
    return Row(
      children: [
        const SizedBox(
          height: 20,
          width: 10,
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: Color(0xFFF1F5F9),
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(10),
                bottomRight: Radius.circular(10),
              ),
            ),
          ),
        ),
        Expanded(
          child: LayoutBuilder(
            builder: (context, constraints) {
              return Flex(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                direction: Axis.horizontal,
                children: List.generate(
                  (constraints.constrainWidth() / 10).floor(),
                      (_) => const SizedBox(
                    width: 5,
                    height: 1.5,
                    child: DecoratedBox(
                      decoration: BoxDecoration(color: Color(0xFFCBD5E1)),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(
          height: 20,
          width: 10,
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: Color(0xFFF1F5F9),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10),
                bottomLeft: Radius.circular(10),
              ),
            ),
          ),
        ),
      ],
    );
  }

  // Empty Data View Widget
  Widget _buildEmptyView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.confirmation_number_outlined, size: 70, color: Colors.grey.shade400),
          const SizedBox(height: 12),
          const Text(
            "Ticket details not available!",
            style: TextStyle(color: Colors.blueGrey, fontSize: 16, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }
}