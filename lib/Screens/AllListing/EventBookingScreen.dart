import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:gotilo_new/Constant/AppPref.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

// Import your custom dependencies here
import 'package:gotilo_new/Api/ApiCalls.dart';
import 'package:gotilo_new/Api/Request/AllListings/RequestEventBookingList.dart';
import 'package:gotilo_new/Api/Response/AllListings/ResponseEventBookingList.dart';
import 'package:gotilo_new/CustomeWidgets/CustomAppbar.dart';
import 'package:gotilo_new/CustomeWidgets/SharedWidgets.dart';
import '../../MyApplication/MyApplication.dart';

class EventBookingScreen extends StatefulWidget {
  final String? listingId;
  const EventBookingScreen({super.key, this.listingId});

  @override
  State<EventBookingScreen> createState() => _EventBookingScreenState();
}

class _EventBookingScreenState extends State<EventBookingScreen> {
  EventBookingList? bookingData;
  bool isLoading = true;
  int? expandedEventIndex;

  // Track selected Slot ID per Event ID (eventId: slotId)
  Map<int, int> selectedSlots = {};

  // Track Selected Quantities per Category ID (categoryId: quantity)
  Map<int, int> selectedQuantities = {};

  // Razorpay Instance
  late Razorpay _razorpay;

  @override
  void initState() {
    super.initState();
    _initRazorpay();
    _callEventBookingList();
  }

  void _initRazorpay() {
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  @override
  void dispose() {
    _razorpay.clear();
    super.dispose();
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    SharedWidgets.showTopSnackBar(context, message: "Payment Successful: ${response.paymentId}",title: "pass");
    // Handle Backend API confirmation here
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    SharedWidgets.showTopSnackBar(context, message: "Payment Failed: ${response.message}",title: "fail");
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    SharedWidgets.showTopSnackBar(context, message: "External Wallet Selected: ${response.walletName}");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: const CustomAppBar(
        title: "Event Booking",
        showAction: false,
        showBackButton: true,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator(color: Color(0xFF00C4CC)))
          : (bookingData == null || bookingData!.events == null || bookingData!.events!.isEmpty)
          ? Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.event_busy_rounded, size: 70, color: Colors.grey.shade400),
            const SizedBox(height: 12),
            const Text(
              "No events available at the moment",
              style: TextStyle(color: Colors.blueGrey, fontSize: 16, fontWeight: FontWeight.w500),
            ),
          ],
        ),
      )
          : ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: bookingData!.events!.length,
        itemBuilder: (context, index) {
          final event = bookingData!.events![index];
          final isExpanded = expandedEventIndex == index;
          return _buildEventCard(event, index, isExpanded);
        },
      ),
    );
  }

  Widget _buildEventCard(Events event, int index, bool isExpanded) {
    int eventId = event.id ?? index;

    // Default first slot selection for event
    if (!selectedSlots.containsKey(eventId) &&
        event.vendorEventSlot != null &&
        event.vendorEventSlot!.isNotEmpty) {
      selectedSlots[eventId] = event.vendorEventSlot!.first.id ?? 0;
    }

    // Min price calculation logic
    double minPrice = 0;
    if (event.vendorEventSlot != null) {
      List<double> prices = [];
      for (var slot in event.vendorEventSlot!) {
        if (slot.vendorEventCategory != null) {
          for (var cat in slot.vendorEventCategory!) {
            double p = double.tryParse(cat.price ?? "0") ?? 0;
            if (p > 0) prices.add(p);
          }
        }
      }
      if (prices.isNotEmpty) {
        minPrice = prices.reduce((a, b) => a < b ? a : b);
      }
    }

    // Selected Ticket Calculations
    int particularEventTickets = 0;
    double particularEventTotalPrice = 0.0;

    if (event.vendorEventSlot != null) {
      for (var slot in event.vendorEventSlot!) {
        if (slot.vendorEventCategory != null) {
          for (var cat in slot.vendorEventCategory!) {
            final int catId = cat.id ?? 0;
            final int qty = selectedQuantities[catId] ?? 0;
            if (qty > 0) {
              particularEventTickets += qty;
              particularEventTotalPrice += (double.tryParse(cat.price ?? "0") ?? 0) * qty;
            }
          }
        }
      }
    }

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isExpanded ? const Color(0xFF00C4CC).withOpacity(0.4) : const Color(0xFFE2E8F0),
          width: isExpanded ? 1.5 : 1.0,
        ),
        boxShadow: [
          BoxShadow(
            color: isExpanded ? const Color(0xFF00C4CC).withOpacity(0.06) : Colors.black.withOpacity(0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Toggle
          InkWell(
            onTap: () {
              setState(() {
                expandedEventIndex = isExpanded ? null : index;
              });
            },
            borderRadius: BorderRadius.circular(16),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          event.title ?? "Event Title",
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF0F172A),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            const Icon(Icons.location_on_rounded, size: 15, color: Color(0xFF64748B)),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                event.address ?? "Location N/A",
                                style: const TextStyle(color: Color(0xFF64748B), fontSize: 13),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: const Color(0xFF00C4CC).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          minPrice > 0 ? "₹${minPrice.toStringAsFixed(0)}+" : "Price N/A",
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF00C4CC),
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Icon(
                        isExpanded ? Icons.keyboard_arrow_up_rounded : Icons.keyboard_arrow_down_rounded,
                        color: const Color(0xFF64748B),
                        size: 24,
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),

          if (isExpanded) ...[
            const Divider(height: 1, thickness: 1, color: Color(0xFFF1F5F9)),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (event.description != null && event.description!.isNotEmpty) ...[
                    const Text(
                      "About Event",
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF334155)),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      event.description!,
                      style: const TextStyle(color: Color(0xFF64748B), fontSize: 13, height: 1.4),
                    ),
                    const SizedBox(height: 18),
                  ],

                  const Text(
                    "Select Date & Slot",
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF334155)),
                  ),
                  const SizedBox(height: 10),

                  // Slot Choice Chips
                  if (event.vendorEventSlot != null && event.vendorEventSlot!.isNotEmpty)
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: event.vendorEventSlot!.map((slot) {
                          final isSlotSelected = selectedSlots[eventId] == slot.id;
                          return Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: ChoiceChip(
                              label: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    slot.slotName ?? "Slot",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: isSlotSelected ? Colors.white : const Color(0xFF0F172A),
                                      fontSize: 12,
                                    ),
                                  ),
                                  Text(
                                    "${slot.date ?? ''} | ${slot.startTime ?? ''}",
                                    style: TextStyle(
                                      color: isSlotSelected ? Colors.white.withOpacity(0.9) : const Color(0xFF64748B),
                                      fontSize: 10,
                                    ),
                                  ),
                                ],
                              ),
                              selected: isSlotSelected,
                              selectedColor: const Color(0xFF0F172A),
                              backgroundColor: const Color(0xFFF8FAFC),
                              side: BorderSide(
                                color: isSlotSelected ? const Color(0xFF0F172A) : const Color(0xFFE2E8F0),
                              ),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                              showCheckmark: false,
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                              onSelected: (selected) {
                                if (selected) {
                                  setState(() {
                                    selectedSlots[eventId] = slot.id ?? 0;
                                  });
                                }
                              },
                            ),
                          );
                        }).toList(),
                      ),
                    ),

                  const SizedBox(height: 16),

                  // Active Categories Table
                  if (event.vendorEventSlot != null && event.vendorEventSlot!.isNotEmpty) ...[
                    Builder(
                      builder: (context) {
                        final activeSlot = event.vendorEventSlot!.firstWhere(
                              (s) => s.id == selectedSlots[eventId],
                          orElse: () => event.vendorEventSlot!.first,
                        );

                        return _buildCategoryList(activeSlot);
                      },
                    )
                  ],

                  const SizedBox(height: 20),

                  // NEW BOTTOM BAR UI ACCORDING TO DESIGN
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF8FAFC),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: const Color(0xFFE2E8F0)),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "$particularEventTickets ${particularEventTickets > 1 ? 'Tickets' : 'Ticket'} Selected",
                              style: const TextStyle(
                                fontSize: 12,
                                color: Color(0xFF64748B),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              "₹ ${particularEventTotalPrice.toStringAsFixed(2)}",
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF0F172A),
                              ),
                            ),
                          ],
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: particularEventTickets > 0
                                ? const Color(0xFF0F172A)
                                : const Color(0xFF94A3B8),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                            elevation: 0,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          ),
                          onPressed: particularEventTickets > 0
                              ? () {
                            _showCheckoutBottomSheet(
                              event: event,
                              selectedTicketsCount: particularEventTickets,
                              basePrice: particularEventTotalPrice,
                            );
                          }
                              : null,
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                "Continue",
                                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                              ),
                              SizedBox(width: 4),
                              Icon(Icons.arrow_forward_rounded, size: 16),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            )
          ]
        ],
      ),
    );
  }

  Widget _buildCategoryList(VendorEventSlot slot) {
    if (slot.vendorEventCategory == null || slot.vendorEventCategory!.isEmpty) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 10),
        child: Text("No categories available.", style: TextStyle(color: Colors.grey, fontSize: 12)),
      );
    }

    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        children: slot.vendorEventCategory!.asMap().entries.map((entry) {
          int idx = entry.key;
          VendorEventCategory cat = entry.value;

          final int catId = cat.id ?? 0;
          final int qty = selectedQuantities[catId] ?? 0;
          final int remaining = cat.remainingQuantity ?? cat.totalQuantity ?? 0;
          final bool isAvailable = remaining > 0;
          final bool isLast = idx == slot.vendorEventCategory!.length - 1;

          return Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              border: isLast ? null : const Border(bottom: BorderSide(color: Color(0xFFE2E8F0))),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        cat.name ?? "Category",
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Color(0xFF0F172A)),
                      ),
                      const SizedBox(height: 2),
                      Row(
                        children: [
                          Text(
                            "₹${cat.price ?? '0'}",
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF00C4CC),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            "• Max ${cat.maxPerUser ?? 1}/user",
                            style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 11),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                if (isAvailable)
                  Container(
                    height: 36,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: const Color(0xFFCBD5E1)),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        InkWell(
                          onTap: () {
                            if (qty > 0) {
                              setState(() {
                                selectedQuantities[catId] = qty - 1;
                              });
                            }
                          },
                          child: const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                            child: Icon(Icons.remove, size: 16, color: Color(0xFF334155)),
                          ),
                        ),
                        Container(
                          alignment: Alignment.center,
                          constraints: const BoxConstraints(minWidth: 28),
                          child: Text(
                            "$qty",
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Color(0xFF0F172A)),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            int maxUser = cat.maxPerUser ?? 10;
                            if (qty < maxUser && qty < remaining) {
                              setState(() {
                                selectedQuantities[catId] = qty + 1;
                              });
                            }
                          },
                          child: const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                            child: Icon(Icons.add, size: 16, color: Color(0xFF334155)),
                          ),
                        ),
                      ],
                    ),
                  )
                else
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFEE2E2),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: const Text(
                      "Sold Out",
                      style: TextStyle(color: Color(0xFFEF4444), fontSize: 11, fontWeight: FontWeight.bold),
                    ),
                  )
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  // BOTTOM SHEET IMPLEMENTATION BASED ON DESIGN IMAGE
  void _showCheckoutBottomSheet({
    required Events event,
    required int selectedTicketsCount,
    required double basePrice,
  }) {
    double taxPercent = double.tryParse(bookingData?.taxPercent ?? "0.0") ?? 0.0;
    double taxAmount = (basePrice * taxPercent) / 100;
    double finalAmount = basePrice + taxAmount;

    // Filter out selected categories breakdown
    List<Map<String, dynamic>> selectedCategoryDetails = [];
    if (event.vendorEventSlot != null) {
      for (var slot in event.vendorEventSlot!) {
        if (slot.vendorEventCategory != null) {
          for (var cat in slot.vendorEventCategory!) {
            final int qty = selectedQuantities[cat.id ?? 0] ?? 0;
            if (qty > 0) {
              selectedCategoryDetails.add({
                "name": cat.name ?? "Category",
                "qty": qty,
                "price": double.tryParse(cat.price ?? "0") ?? 0.0,
              });
            }
          }
        }
      }
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Bottomsheet Header handle bar
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              Text(
                event.title ?? "Event Booking",
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
              ),
              const SizedBox(height: 16),

              // Breakdown Selected Categories
              const Text("Selected Tickets", style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13, color: Color(0xFF64748B))),
              const SizedBox(height: 8),

              ...selectedCategoryDetails.map((item) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("${item['name']} x ${item['qty']}", style: const TextStyle(fontSize: 14, color: Color(0xFF334155))),
                    Text("₹${(item['price'] * item['qty']).toStringAsFixed(2)}", style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF0F172A))),
                  ],
                ),
              )),

              const Divider(height: 24),

              // Price Calculation Detail
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Subtotal", style: TextStyle(color: Color(0xFF64748B))),
                  Text("₹${basePrice.toStringAsFixed(2)}", style: const TextStyle(fontWeight: FontWeight.w600)),
                ],
              ),
              const SizedBox(height: 6),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Tax (${taxPercent.toStringAsFixed(0)}%)", style: const TextStyle(color: Color(0xFF64748B))),
                  Text("₹${taxAmount.toStringAsFixed(2)}", style: const TextStyle(fontWeight: FontWeight.w600)),
                ],
              ),
              const Divider(height: 24),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Total Payable Amount", style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Color(0xFF0F172A))),
                  Text("₹${finalAmount.toStringAsFixed(2)}", style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF00C4CC))),
                ],
              ),
              const SizedBox(height: 20),

              // Pay / Confirm Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF00C4CC),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                    _openRazorpayCheckout(finalAmount);
                  },
                  child: const Text("Proceed to Payment", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // RAZORPAY GATEWAY CALL
  void _openRazorpayCheckout(double amount) {
    String? apiKey = bookingData?.listingPayment?.apiKey;

    // Model માંથી Dynamic Razorpay Logo મેળવવું
    String? logoUrl = bookingData?.razorpayLogo;

    if (apiKey == null || apiKey.isEmpty) {
      SharedWidgets.showTopSnackBar(context, message: "Payment Key missing!");
      return;
    }

    var options = {
      'key': apiKey,
      'amount': (amount * 100).toInt(), // Amount in paise
      'name': bookingData?.listingTitle ?? "${AppPrefs.profileName}",
      'description': 'Booking Tickets',
      if (logoUrl != null && logoUrl.isNotEmpty) 'image': logoUrl,

      // 1. Prefill Phone & Email (UPI Show કરવા માટે Dynamic/Static Phone-Email આવશ્યક છે)
      'prefill': {
        'contact': '7046874851', // User no phone number yahan pass karo
        'email': 'user@example.com', // User no email yahan pass karo
      },

      // 2. Multi-method support enablement
      'method': {
        'netbanking': true,
        'card': true,
        'upi': true, // Explicitly enabling UPI
        'wallet': true,
      },

      'external': {
        'wallets': ['paytm']
      }
    };
    try {
      _razorpay.open(options);
    } catch (e) {
      log("Razorpay Error: $e");
    }
  }

  Future<void> _callEventBookingList() async {
    bool internet = await MyApplication.checkInternet();
    if (internet) {
      try {
        ResponseEventBookingList? response = await ApiCalls.callEventBookingList(
          RequestEventBookingList(listingId: widget.listingId),
        );
        if (response != null && response.result != null && response.result!.toLowerCase().contains("pass")) {
          bookingData = response.data;
        }
      } catch (e) {
        log("API Exception: $e");
      } finally {
        setState(() {
          isLoading = false;
        });
      }
    } else {
      setState(() {
        isLoading = false;
      });
      SharedWidgets.showTopSnackBar(context, message: "No Internet Connection");
    }
  }
}