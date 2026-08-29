import 'dart:async';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:gotilo_new/Api/ApiCalls.dart';
import 'package:gotilo_new/Api/Request/User/Event/RequestEventBookingHistory.dart';
import 'package:gotilo_new/Api/Response/User/Event/ResponseEventBookingHistory.dart';
import '../../../Constant/AppPref.dart';
import 'package:gotilo_new/CustomeWidgets/CustomAppbar.dart';
import 'package:gotilo_new/CustomeWidgets/CustomDrawer.dart';
import 'package:gotilo_new/CustomeWidgets/SharedWidgets.dart';
import 'package:gotilo_new/MyApplication/MyApplication.dart';

import 'EventBookingInvoiceScreen.dart';
import 'EventBookingItemScreen.dart';
import 'EventTicketDownloadScreen.dart';
import 'EventTicketViewScreen.dart';

class EventBookingHistoryScreen extends StatefulWidget {
  const EventBookingHistoryScreen({super.key});

  @override
  State<EventBookingHistoryScreen> createState() => _EventBookingHistoryScreenState();
}

class _EventBookingHistoryScreenState extends State<EventBookingHistoryScreen> {
  final List<EventBookingHistory> _eventBookingHistory = [];
  bool _isLoading = true;
  bool _isMoreLoading = false;
  bool _hasMoreData = true;

  String _searchQuery = "";
  Timer? _debounce;

  final ScrollController _scrollController = ScrollController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _callEventBookingHistory(isRefresh: true);
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _scrollController.dispose();
    super.dispose();
  }

  // Scroll Listener for Pagination
  void _onScroll() {
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 200) {
      if (!_isMoreLoading && _hasMoreData && !_isLoading) {
        _callEventBookingHistory(isRefresh: false);
      }
    }
  }

  // Search Debouncer Handling
  void _onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      setState(() {
        _searchQuery = query.trim();
        _isLoading = true;
      });
      _callEventBookingHistory(isRefresh: true);
    });
  }

  // Fetch Booking History with Dynamic Offset Counter & Duplicate Prevention
  Future<void> _callEventBookingHistory({bool isRefresh = false}) async {
    if (isRefresh) {
      _hasMoreData = true;
    }

    // Offset is dynamic based on current list length (0, 10, 20, ...)
    int offset = isRefresh ? 0 : _eventBookingHistory.length;

    bool internet = await MyApplication.checkInternet();
    if (internet) {
      if (!isRefresh) {
        setState(() {
          _isMoreLoading = true;
        });
      }

      try {
        ResponseEventBookingHistory? response = await ApiCalls.callEventBookingHistory(
          RequestEventBookingHistory(
            userId: AppPrefs.userId,
            counter: offset.toString(),
            search: _searchQuery,
          ),
        );

        if (response != null && response.result != null && response.result!.toLowerCase().contains("pass")) {
          List<EventBookingHistory> newItems = response.data ?? [];

          if (isRefresh) {
            _eventBookingHistory.clear();
          }

          if (newItems.isEmpty) {
            _hasMoreData = false;
          } else {
            // Prevent duplicate entries by booking_id
            for (var newItem in newItems) {
              bool exists = _eventBookingHistory.any(
                    (element) => element.bookingId == newItem.bookingId,
              );
              if (!exists) {
                _eventBookingHistory.add(newItem);
              }
            }

            // If received items are less than standard batch (10), no more data is available
            if (newItems.length < 10) {
              _hasMoreData = false;
            }
          }
        }
      } catch (e) {
        log("API Exception: $e");
      } finally {
        if (mounted) {
          setState(() {
            _isLoading = false;
            _isMoreLoading = false;
          });
        }
      }
    } else {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _isMoreLoading = false;
        });
      }
      SharedWidgets.showTopSnackBar(context, message: "No Internet Connection");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: CustomAppBar(
        title: "Event Booking History",
        showAction: false,
        showSearchIcon: true,
        onSearchChanged: _onSearchChanged,
        onMenuTap: () => _scaffoldKey.currentState?.openDrawer(),
      ),
      drawer: const CustomDrawer(initialRoute: "event.booking.history"),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: Color(0xFF00C4CC)))
          : _eventBookingHistory.isEmpty
          ? _buildEmptyState()
          : RefreshIndicator(
        onRefresh: () => _callEventBookingHistory(isRefresh: true),
        color: const Color(0xFF00C4CC),
        child: ListView.builder(
          controller: _scrollController,
          padding: const EdgeInsets.all(16),
          physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
          cacheExtent: 500,
          itemCount: _eventBookingHistory.length + (_isMoreLoading ? 1 : 0),
          itemBuilder: (context, index) {
            if (index == _eventBookingHistory.length) {
              return const Padding(
                padding: EdgeInsets.symmetric(vertical: 16),
                child: Center(
                  child: CircularProgressIndicator(color: Color(0xFF00C4CC)),
                ),
              );
            }
            final item = _eventBookingHistory[index];
            return _buildBookingCard(item);
          },
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
      child: Container(
        height: MediaQuery.of(context).size.height * 0.7,
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.history_rounded, size: 70, color: Colors.grey.shade400),
            const SizedBox(height: 12),
            Text(
              _searchQuery.isNotEmpty ? "No matching history found!" : "No booking history found!",
              style: const TextStyle(color: Colors.blueGrey, fontSize: 16, fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBookingCard(EventBookingHistory item) {
    bool isPaid = (item.paymentStatus ?? "").toLowerCase() == "paid";

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: SharedWidgets.cardBoxDecoration(),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Section: Event Title & Payment Status
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.eventName ?? "Event Name",
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF0F172A),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(Icons.confirmation_number_outlined, size: 14, color: Color(0xFF64748B)),
                          const SizedBox(width: 4),
                          Text(
                            "Booking ID: #${item.bookingId ?? 'N/A'}",
                            style: const TextStyle(fontSize: 12, color: Color(0xFF64748B), fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: isPaid ? const Color(0xFFDCFCE7) : const Color(0xFFFEE2E2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    item.paymentStatus ?? "Unpaid",
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: isPaid ? const Color(0xFF166534) : const Color(0xFF991B1B),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),
            const Divider(height: 1, color: Color(0xFFF1F5F9)),
            const SizedBox(height: 12),

            // Date & Amounts Section
            Row(
              children: [
                const Icon(Icons.access_time_rounded, size: 14, color: Color(0xFF64748B)),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    item.bookingDateAndTime ?? "",
                    style: const TextStyle(fontSize: 13, color: Color(0xFF475569)),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFF8FAFC),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: const Color(0xFFF1F5F9)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("Subtotal", style: TextStyle(fontSize: 11, color: Color(0xFF64748B))),
                      const SizedBox(height: 2),
                      Text("₹${item.subtotal ?? 0}.00", style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFF334155))),
                    ],
                  ),
                  Container(height: 24, width: 1, color: const Color(0xFFCBD5E1)),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      const Text("Total Amount", style: TextStyle(fontSize: 11, color: Color(0xFF64748B))),
                      const SizedBox(height: 2),
                      Text("₹${item.totalAmount ?? 0}.00", style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Color(0xFF00C4CC))),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 14),

            // Action Buttons Section (4 Buttons)
            Row(
              children: [
                // 1. Book Item History
                Expanded(
                  child: _buildIconButton(
                    icon: Icons.history,
                    tooltip: "Item History",
                    backgroundColor: const Color(0xFFF1F5F9),
                    iconColor: const Color(0xFF334155),
                    onTap: () {
                      Get.to(()=> EventBookingItemScreen(eventId: item.eventId,));
                    },
                  ),
                ),
                const SizedBox(width: 8),

                // 2. View Ticket
                Expanded(
                  child: _buildIconButton(
                    icon: Icons.visibility_outlined,
                    tooltip: "View Ticket",
                    backgroundColor: const Color(0xFFF1F5F9),
                    iconColor: const Color(0xFF334155),
                    onTap: () {
                      Get.to(()=> EventTicketViewScreen(bookingId:item.bookingId,));

                    },
                  ),
                ),
                const SizedBox(width: 8),

                // 3. Download Event Ticket
                Expanded(
                  child: _buildActionButton(
                    label: "Ticket",
                    icon: Icons.download_rounded,
                    backgroundColor: const Color(0xFF00C4CC),
                    textColor: Colors.white,
                    onTap: () {
                      SharedWidgets.showTopSnackBar(context, message: "Downloading Ticket...");
                      Get.to(()=> EventTicketDownloadScreen(bookingId: item.bookingId,));
                    },
                  ),
                ),
                const SizedBox(width: 8),

                // 4. View Receipt
                Expanded(
                  child: _buildActionButton(
                    label: "Receipt",
                    icon: Icons.receipt_long_rounded,
                    backgroundColor: const Color(0xFF10B981),
                    textColor: Colors.white,
                    onTap: () {
                      Get.to(()=> EventBookingInvoiceScreen(bookingId: item.bookingId,));
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIconButton({
    required IconData icon,
    required String tooltip,
    required Color backgroundColor,
    required Color iconColor,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: Ink(
          height: 38,
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Tooltip(
            message: tooltip,
            child: Icon(icon, size: 18, color: iconColor),
          ),
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required String label,
    required IconData icon,
    required Color backgroundColor,
    required Color textColor,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: Ink(
          height: 38,
          padding: const EdgeInsets.symmetric(horizontal: 4),
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 14, color: textColor),
              const SizedBox(width: 3),
              Flexible(
                child: Text(
                  label,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: textColor,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}