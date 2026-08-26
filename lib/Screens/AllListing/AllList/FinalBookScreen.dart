import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_utils/src/get_utils/get_utils.dart';
import '../../../CustomeWidgets/SharedWidgets.dart';
import 'package:gotilo_new/Api/ApiCalls.dart';
import 'package:gotilo_new/Api/Request/AllListings/RequestFinalBillAdd.dart' as req;
import 'package:gotilo_new/Api/Response/AllListings/ResponseFinalBillAdd.dart';
import 'package:gotilo_new/Constant/AppPref.dart';
import 'package:gotilo_new/CustomeWidgets/CustomAppbar.dart';
import 'package:gotilo_new/MyApplication/MyApplication.dart';
import 'package:gotilo_new/Screens/HomeMain.dart';
import '../../../Api/Response/AllListings/ResponseBookHotelRoom.dart';
import '../../HeritageHomeScreen.dart';

class FinalBookScreen extends StatefulWidget {
  final BookHotelRoomData? bookHotelRoomData;

  const FinalBookScreen({super.key, this.bookHotelRoomData});

  @override
  State<FinalBookScreen> createState() => _FinalBookScreenState();
}

class _FinalBookScreenState extends State<FinalBookScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  final Map<int, int> _roomServiceQty = {};
  final Map<int, int> _hotelServiceQty = {};

  double _calculatedSubTotal = 0.0;
  double _taxAmount = 0.0;
  double _grandTotal = 0.0;

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _initDefaultQuantities();
    _recalculateTotals();
  }

  void _initDefaultQuantities() {
    final rooms = widget.bookHotelRoomData?.rooms ?? [];
    final hotelServices = widget.bookHotelRoomData?.hotelServices ?? [];

    for (var room in rooms) {
      if (room.roomServices != null) {
        for (var service in room.roomServices!) {
          if (service.id != null) {
            _roomServiceQty[service.id!] = 0;
          }
        }
      }
    }

    for (int i = 0; i < hotelServices.length; i++) {
      _hotelServiceQty[i] = 0;
    }
  }

  void _recalculateTotals() {
    double baseSubTotal = (widget.bookHotelRoomData?.hotel?.subTotal ?? 0).toDouble();
    double servicesTotal = 0;

    final rooms = widget.bookHotelRoomData?.rooms ?? [];
    for (var room in rooms) {
      if (room.roomServices != null) {
        for (var service in room.roomServices!) {
          int qty = _roomServiceQty[service.id] ?? 0;
          double price = double.tryParse(service.price ?? '0') ?? 0;
          servicesTotal += (qty * price);
        }
      }
    }

    final hotelServices = widget.bookHotelRoomData?.hotelServices ?? [];
    for (int i = 0; i < hotelServices.length; i++) {
      int qty = _hotelServiceQty[i] ?? 0;
      String cleanPriceStr = (hotelServices[i].price ?? '0').replaceAll(RegExp(r'[^\d.]'), '');
      double price = double.tryParse(cleanPriceStr) ?? 0;
      servicesTotal += (qty * price);
    }

    _calculatedSubTotal = baseSubTotal + servicesTotal;
    int taxPercent = widget.bookHotelRoomData?.hotel?.taxPercent ?? 18;
    _taxAmount = (_calculatedSubTotal * taxPercent) / 100;
    _grandTotal = _calculatedSubTotal + _taxAmount;
  }

  String _parseHtmlString(String? htmlString) {
    if (htmlString == null) return "";
    String parsed = htmlString.replaceAll(RegExp(r'<[^>]*>|&nbsp;'), ' ');
    return parsed.replaceAll(RegExp(r'\s+'), ' ').trim();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final hotel = widget.bookHotelRoomData?.hotel;
    final rooms = widget.bookHotelRoomData?.rooms ?? [];
    final hotelServices = widget.bookHotelRoomData?.hotelServices ?? [];

    return GestureDetector(
      // Unfocus Keyboard smoothly
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus && currentFocus.focusedChild != null) {
          FocusManager.instance.primaryFocus?.unfocus();
        }
      },
      child: Scaffold(
        backgroundColor: const Color(0xFFF3F4F8),
        resizeToAvoidBottomInset: true,
        appBar: CustomAppBar(
          title: "Confirm Booking",
          showBackButton: true,
          showAction: false,
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            // Prevent frame skips during scroll/keyboard open
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHotelHeaderCard(hotel),
                const SizedBox(height: 16),

                if (rooms.isNotEmpty) _buildRoomsDetailCard(rooms),
                if (rooms.isNotEmpty) const SizedBox(height: 16),

                // OPTIMIZATION: Standalone Guest Form Widget to isolate rebuilds
                _buildBaseCard(
                  child: Form(
                    key: _formKey,
                    child: GuestFormSection(
                      nameController: _nameController,
                      emailController: _emailController,
                      phoneController: _phoneController,
                      headerWidget: _buildSectionHeader("Guest Information", Icons.person_outline_rounded),
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                _buildServicesSelectionCard(hotelServices, rooms),
                const SizedBox(height: 16),

                _buildBillingSummaryCard(hotel, rooms, hotelServices),
                const SizedBox(height: 16),

                if (hotel?.hotelPolicies != null && hotel!.hotelPolicies!.isNotEmpty)
                  _buildHotelPoliciesCard(hotel.hotelPolicies),
                const SizedBox(height: 30),
              ],
            ),
          ),
        ),

        bottomNavigationBar: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.08),
                blurRadius: 16,
                offset: const Offset(0, -5),
              ),
            ],
          ),
          child: SafeArea(
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("Total Price", style: TextStyle(fontSize: 12, color: Colors.grey, fontWeight: FontWeight.w500)),
                      const SizedBox(height: 2),
                      Text(
                        "₹${_grandTotal.round()}",
                        style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: Color(0xFF0F172A)),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Container(
                    height: 52,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF10B981), Color(0xFF059669)],
                      ),
                      borderRadius: BorderRadius.circular(14),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF10B981).withOpacity(0.35),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: ElevatedButton(
                      onPressed: _isLoading
                          ? null
                          : () {
                        if (_formKey.currentState!.validate()) {
                          _callFinalBillAdd();
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      ),
                      child: _isLoading
                          ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                      )
                          : const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Confirm Stay", style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                          SizedBox(width: 6),
                          Icon(Icons.arrow_forward_rounded, color: Colors.white, size: 20),
                        ],
                      ),
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

  // --- Static Helper Widgets ---
  Widget _buildHotelHeaderCard(Hotel? hotel) {
    return _buildBaseCard(
      padding: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.blue.shade800, Colors.indigo.shade900],
              ),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  hotel?.hotelName ?? "Gotilo Hotel",
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: [
                    _buildModernBadge("${hotel?.totalNights ?? 0} Nights", Colors.white.withOpacity(0.2)),
                    _buildModernBadge("${hotel?.totalAdults ?? 0} Adults", Colors.white.withOpacity(0.2)),
                    _buildModernBadge("${hotel?.totalChilds ?? 0} Childs", Colors.white.withOpacity(0.2)),
                    _buildModernBadge("${hotel?.totalRooms ?? 0} Room(s)", Colors.white.withOpacity(0.2)),
                  ],
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFF8FAFC),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFE2E8F0)),
              ),
              child: Row(
                children: [
                  Expanded(child: _buildCheckInfo("CHECK IN", hotel?.checkin ?? "", hotel?.checkinDay ?? "", Icons.login_rounded)),
                  Container(height: 36, width: 1, color: Colors.grey.shade300),
                  Expanded(child: _buildCheckInfo("CHECK OUT", hotel?.checkout ?? "", hotel?.checkoutDay ?? "", Icons.logout_rounded)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildModernBadge(String label, Color bgColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(color: bgColor, borderRadius: BorderRadius.circular(20)),
      child: Text(label, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: Colors.white)),
    );
  }

  Widget _buildCheckInfo(String title, String date, String day, IconData icon) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(color: Colors.blue.shade50, borderRadius: BorderRadius.circular(8)),
          child: Icon(icon, size: 18, color: Colors.blue.shade700),
        ),
        const SizedBox(width: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.grey)),
            Text(date, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFF1E293B))),
            Text(day, style: TextStyle(fontSize: 11, color: Colors.blue.shade600, fontWeight: FontWeight.w500)),
          ],
        ),
      ],
    );
  }

  Widget _buildRoomsDetailCard(List<Rooms> rooms) {
    return _buildBaseCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader("Selected Room Details", Icons.king_bed_outlined),
          const SizedBox(height: 14),
          ...rooms.map((room) => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      "${room.quantity ?? 1}x ${room.roomName}",
                      style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Color(0xFF1E293B)),
                    ),
                  ),
                  Text("₹${room.totalPrice}", style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: Color(0xFF0F172A))),
                ],
              ),
              if (room.planName != null) ...[
                const SizedBox(height: 2),
                Text(room.planName!, style: TextStyle(fontSize: 12, color: Colors.blue.shade700, fontWeight: FontWeight.w600)),
              ],
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                children: [
                  _buildChipTag("${room.adults ?? 0} Adults, ${room.childs ?? 0} Children", Icons.people_outline),
                  if ((room.mattress ?? 0) > 0)
                    _buildChipTag("Extra Mattress: ${room.mattress}", Icons.single_bed_outlined),
                ],
              ),
              if (room.planFeatures != null && room.planFeatures!.isNotEmpty) ...[
                const SizedBox(height: 10),
                ...room.planFeatures!.map((f) => Padding(
                  padding: const EdgeInsets.only(bottom: 4.0),
                  child: Row(
                    children: [
                      const Icon(Icons.check_circle_rounded, size: 15, color: Color(0xFF10B981)),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text("${f.name}: ${f.description}", style: const TextStyle(fontSize: 12, color: Color(0xFF475569))),
                      ),
                    ],
                  ),
                )),
              ],
              if (room.dateWisePrices != null && room.dateWisePrices!.isNotEmpty) ...[
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF8FAFC),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: const Color(0xFFE2E8F0)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("Date-wise Breakdown", style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.deepPurple)),
                      const SizedBox(height: 6),
                      ...room.dateWisePrices!.map((d) => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 2.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(d.date ?? '', style: const TextStyle(fontSize: 12, color: Color(0xFF64748B))),
                            Text("₹${d.finalPrice}", style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: Color(0xFF334155))),
                          ],
                        ),
                      )),
                    ],
                  ),
                ),
              ],
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 12.0),
                child: Divider(height: 1),
              ),
            ],
          )),
        ],
      ),
    );
  }

  Widget _buildChipTag(String label, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(color: const Color(0xFFF1F5F9), borderRadius: BorderRadius.circular(6)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: const Color(0xFF64748B)),
          const SizedBox(width: 4),
          Text(label, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w500, color: Color(0xFF475569))),
        ],
      ),
    );
  }

  Widget _buildServicesSelectionCard(List<HotelServices> hotelServices, List<Rooms> rooms) {
    bool hasRoomServices = rooms.any((r) => r.roomServices != null && r.roomServices!.isNotEmpty);
    if (hotelServices.isEmpty && !hasRoomServices) return const SizedBox.shrink();

    return _buildBaseCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader("Enhance Your Stay", Icons.star),
          const SizedBox(height: 14),

          if (hotelServices.isNotEmpty) ...[
            const Text("Hotel Addons", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.blueAccent)),
            const SizedBox(height: 8),
            ...List.generate(hotelServices.length, (index) {
              final service = hotelServices[index];
              int currentQty = _hotelServiceQty[index] ?? 0;

              return _buildServiceItemRow(
                title: service.name ?? '',
                subtitle: service.description,
                price: "₹${service.price}",
                currentQty: currentQty,
                onAdd: () {
                  setState(() {
                    _hotelServiceQty[index] = currentQty + 1;
                    _recalculateTotals();
                  });
                },
                onRemove: () {
                  if (currentQty > 0) {
                    setState(() {
                      _hotelServiceQty[index] = currentQty - 1;
                      _recalculateTotals();
                    });
                  }
                },
              );
            }),
          ],

          if (hasRoomServices) ...[
            const SizedBox(height: 10),
            const Text("Room Addons", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.blueAccent)),
            const SizedBox(height: 8),
            ...rooms.expand((room) => (room.roomServices ?? []).map((service) {
              int serviceId = service.id ?? 0;
              int currentQty = _roomServiceQty[serviceId] ?? 0;
              int maxLimit = service.maxLimit ?? 5;

              return _buildServiceItemRow(
                title: service.name ?? '',
                subtitle: "For: ${room.roomName} ${service.description != null ? '• ${service.description}' : ''}",
                price: "₹${service.price}",
                currentQty: currentQty,
                onAdd: () {
                  if (currentQty < maxLimit) {
                    setState(() {
                      _roomServiceQty[serviceId] = currentQty + 1;
                      _recalculateTotals();
                    });
                  }
                },
                onRemove: () {
                  if (currentQty > 0) {
                    setState(() {
                      _roomServiceQty[serviceId] = currentQty - 1;
                      _recalculateTotals();
                    });
                  }
                },
              );
            })),
          ]
        ],
      ),
    );
  }

  Widget _buildServiceItemRow({
    required String title,
    String? subtitle,
    required String price,
    required int currentQty,
    required VoidCallback onAdd,
    required VoidCallback onRemove,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: currentQty > 0 ? Colors.blue.shade50.withOpacity(0.4) : const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: currentQty > 0 ? Colors.blue.shade200 : const Color(0xFFE2E8F0)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFF1E293B))),
                if (subtitle != null && subtitle.isNotEmpty)
                  Text(subtitle, style: const TextStyle(fontSize: 11, color: Color(0xFF64748B))),
                const SizedBox(height: 4),
                Text(price, style: const TextStyle(fontWeight: FontWeight.w700, color: Color(0xFF10B981), fontSize: 13)),
              ],
            ),
          ),
          _buildQtyCounter(qty: currentQty, onAdd: onAdd, onRemove: onRemove),
        ],
      ),
    );
  }

  Widget _buildQtyCounter({required int qty, required VoidCallback onAdd, required VoidCallback onRemove}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFCBD5E1)),
      ),
      child: Row(
        children: [
          InkWell(
            onTap: onRemove,
            borderRadius: BorderRadius.circular(8),
            child: Padding(
              padding: const EdgeInsets.all(6.0),
              child: Icon(Icons.remove, size: 16, color: qty > 0 ? Colors.black87 : Colors.grey),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            color: const Color(0xFFF1F5F9),
            child: Text("$qty", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFF0F172A))),
          ),
          InkWell(
            onTap: onAdd,
            borderRadius: BorderRadius.circular(8),
            child: const Padding(
              padding: EdgeInsets.all(6.0),
              child: Icon(Icons.add, size: 16, color: Colors.black87),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBillingSummaryCard(Hotel? hotel, List<Rooms> rooms, List<HotelServices> hotelServices) {
    return _buildBaseCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader("Billing Summary", Icons.receipt_long_outlined),
          const SizedBox(height: 14),

          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            decoration: BoxDecoration(color: const Color(0xFFF1F5F9), borderRadius: BorderRadius.circular(8)),
            child: const Row(
              children: [
                Expanded(flex: 3, child: Text("ITEM", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11, color: Color(0xFF64748B)))),
                Expanded(flex: 1, child: Text("QTY", textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11, color: Color(0xFF64748B)))),
                Expanded(flex: 2, child: Text("PRICE", textAlign: TextAlign.right, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11, color: Color(0xFF64748B)))),
              ],
            ),
          ),
          const SizedBox(height: 8),

          ...rooms.map((r) => Padding(
            padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 4.0),
            child: Row(
              children: [
                Expanded(flex: 3, child: Text(r.roomName ?? '', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFF334155)))),
                Expanded(flex: 1, child: Text("${r.quantity ?? 1}", textAlign: TextAlign.center, style: const TextStyle(fontSize: 12))),
                Expanded(flex: 2, child: Text("₹${r.totalPrice ?? 0}", textAlign: TextAlign.right, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700))),
              ],
            ),
          )),

          ...List.generate(hotelServices.length, (index) {
            int qty = _hotelServiceQty[index] ?? 0;
            if (qty == 0) return const SizedBox.shrink();
            var service = hotelServices[index];
            String cleanPriceStr = (service.price ?? '0').replaceAll(RegExp(r'[^\d.]'), '');
            double price = (double.tryParse(cleanPriceStr) ?? 0) * qty;

            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 4.0),
              child: Row(
                children: [
                  Expanded(flex: 3, child: Text("${service.name} (Hotel Addon)", style: TextStyle(fontSize: 12, color: Colors.blue.shade700, fontWeight: FontWeight.w500))),
                  Expanded(flex: 1, child: Text("$qty", textAlign: TextAlign.center, style: const TextStyle(fontSize: 12))),
                  Expanded(flex: 2, child: Text("₹${price.toStringAsFixed(2)}", textAlign: TextAlign.right, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700))),
                ],
              ),
            );
          }),

          ...rooms.expand((room) => (room.roomServices ?? []).where((s) => (_roomServiceQty[s.id] ?? 0) > 0).map((s) {
            int qty = _roomServiceQty[s.id] ?? 0;
            double price = (double.tryParse(s.price ?? '0') ?? 0) * qty;

            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 4.0),
              child: Row(
                children: [
                  Expanded(flex: 3, child: Text("${s.name} (Room Addon)", style: TextStyle(fontSize: 12, color: Colors.blue.shade700, fontWeight: FontWeight.w500))),
                  Expanded(flex: 1, child: Text("$qty", textAlign: TextAlign.center, style: const TextStyle(fontSize: 12))),
                  Expanded(flex: 2, child: Text("₹${price.toStringAsFixed(2)}", textAlign: TextAlign.right, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700))),
                ],
              ),
            );
          })),

          const Padding(
            padding: EdgeInsets.symmetric(vertical: 10.0),
            child: Divider(height: 1),
          ),
          _buildPriceRow("Sub Total", "₹${_calculatedSubTotal.round()}"),
          const SizedBox(height: 6),
          _buildPriceRow("Tax (GST ${hotel?.taxPercent ?? 18}%)", "₹${_taxAmount.round()}"),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 10.0),
            child: Divider(height: 1),
          ),
          _buildPriceRow("Grand Total", "₹${_grandTotal.round()}", isGrandTotal: true),
        ],
      ),
    );
  }

  Widget _buildPriceRow(String label, String value, {bool isGrandTotal = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: isGrandTotal ? 15 : 13,
            fontWeight: isGrandTotal ? FontWeight.w800 : FontWeight.w500,
            color: isGrandTotal ? const Color(0xFF0F172A) : const Color(0xFF64748B),
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: isGrandTotal ? 17 : 13,
            fontWeight: isGrandTotal ? FontWeight.w800 : FontWeight.w700,
            color: isGrandTotal ? const Color(0xFF10B981) : const Color(0xFF1E293B),
          ),
        ),
      ],
    );
  }

  Widget _buildHotelPoliciesCard(String? policiesHtml) {
    return _buildBaseCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader("Hotel Policies", Icons.policy_outlined),
          const SizedBox(height: 8),
          Text(_parseHtmlString(policiesHtml), style: const TextStyle(fontSize: 12, color: Color(0xFF475569), height: 1.5)),
        ],
      ),
    );
  }

  Widget _buildBaseCard({required Widget child, EdgeInsetsGeometry? padding}) {
    return Container(
      width: double.infinity,
      padding: padding ?? const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: child,
    );
  }

  Widget _buildSectionHeader(String title, IconData icon) {
    return Row(
      children: [
        Icon(icon, size: 20, color: Colors.blue.shade800),
        const SizedBox(width: 8),
        Text(
          title,
          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
        ),
      ],
    );
  }

  Future<void> _callFinalBillAdd() async {
    bool internet = await MyApplication.checkInternet();
    if (!internet) {
      if (mounted) {
        SharedWidgets.showTopSnackBar(context, message: "No Internet Connection", title: "fail");
      }
      return;
    }

    setState(() => _isLoading = true);

    try {
      final hotel = widget.bookHotelRoomData?.hotel;
      final roomsData = widget.bookHotelRoomData?.rooms ?? [];
      final hotelServicesData = widget.bookHotelRoomData?.hotelServices ?? [];

      req.BookingMeta bookingMeta = req.BookingMeta(
        hotelMasterId: hotel?.hotelMasterId,
        checkin: hotel?.checkin,
        checkout: hotel?.checkout,
        adults: hotel?.totalAdults,
        childs: hotel?.totalChilds,
        rooms: hotel?.totalRooms,
        guestName: _nameController.text.trim(),
        guestEmail: _emailController.text.trim(),
        guestPhone: _phoneController.text.trim(),
      );

      List<req.Rooms> requestRoomsList = roomsData.map((room) {
        List<req.DateWisePrices>? dateWiseList = room.dateWisePrices?.map((dw) {
          return req.DateWisePrices(
            date: dw.date,
            finalPrice: dw.finalPrice,
          );
        }).toList();

        List<req.PlanFeatures>? planFeaturesList = room.planFeatures?.map((pf) {
          return req.PlanFeatures(
            name: pf.name,
            description: pf.description,
          );
        }).toList();

        return req.Rooms(
          roomId: room.roomId,
          planId: room.planId,
          quantity: room.quantity,
          totalAdults: room.adults,
          totalChilds: room.childs,
          totalMattress: room.mattress,
          mattressPrice: room.mattressPricePerUnit,
          dateWisePrices: dateWiseList,
          planFeatures: planFeaturesList,
        );
      }).toList();

      List<req.Services> requestServicesList = [];

      for (int i = 0; i < hotelServicesData.length; i++) {
        int qty = _hotelServiceQty[i] ?? 0;
        if (qty > 0) {
          var service = hotelServicesData[i];
          String cleanPriceStr = (service.price ?? '0').replaceAll(RegExp(r'[^\d.]'), '');
          int servicePrice = (double.tryParse(cleanPriceStr) ?? 0).toInt();

          requestServicesList.add(req.Services(
            serviceId: i + 1,
            serviceName: service.name,
            description: service.description,
            qty: qty,
            price: servicePrice,
          ));
        }
      }

      for (var room in roomsData) {
        if (room.roomServices != null) {
          for (var roomService in room.roomServices!) {
            int qty = _roomServiceQty[roomService.id] ?? 0;
            if (qty > 0) {
              int servicePrice = (double.tryParse(roomService.price ?? '0') ?? 0).toInt();

              requestServicesList.add(req.Services(
                serviceId: roomService.id,
                serviceName: roomService.name,
                description: roomService.description,
                qty: qty,
                price: servicePrice,
              ));
            }
          }
        }
      }

      req.RequestFinalBillAdd requestBody = req.RequestFinalBillAdd(
        userId: int.tryParse(AppPrefs.userId) ?? 0,
        bookingMeta: bookingMeta,
        subTotal: _calculatedSubTotal.round(),
        tax: _taxAmount.round(),
        grandTotal: _grandTotal.round(),
        allMattress: hotel?.totalMattress ?? 0,
        rooms: requestRoomsList,
        services: requestServicesList,
      );

      ResponseFinalBillAdd? response = await ApiCalls.callFinalBillAdd(requestBody);

      setState(() => _isLoading = false);

      if (response != null) {
        if (response.result != null && response.result!.toLowerCase().contains("pass")) {
          Get.offAll(() =>  const ModernHeritageApp());
          if (mounted) {
            SharedWidgets.showTopSnackBar(context, message: response.message ?? "Booking Success!");
          }
        } else {
          if (mounted) {
            SharedWidgets.showTopSnackBar(context, message: response.message ?? "Something went wrong!");
          }
        }
      }
    } catch (e) {
      setState(() => _isLoading = false);
      log("Error in _callFinalBillAdd: $e");
    }
  }
}

class GuestFormSection extends StatefulWidget {
  final TextEditingController nameController;
  final TextEditingController emailController;
  final TextEditingController phoneController;
  final Widget headerWidget;

  const GuestFormSection({
    super.key,
    required this.nameController,
    required this.emailController,
    required this.phoneController,
    required this.headerWidget,
  });

  @override
  State<GuestFormSection> createState() => _GuestFormSectionState();
}

class _GuestFormSectionState extends State<GuestFormSection> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true; // Prevents state disposal on viewport change

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        widget.headerWidget,
        const SizedBox(height: 14),

        TextFormField(
          controller: widget.nameController,
          keyboardType: TextInputType.name,
          textInputAction: TextInputAction.next,
          decoration: InputDecoration(
            labelText: "Full Name",
            hintText: "Enter Full Name",
            prefixIcon: const Icon(Icons.person_outline),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          ),
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return "Please enter full name";
            }
            return null;
          },
        ),
        const SizedBox(height: 12),

        TextFormField(
          controller: widget.emailController,
          keyboardType: TextInputType.emailAddress,
          textInputAction: TextInputAction.next,
          decoration: InputDecoration(
            labelText: "Email Address",
            hintText: "Enter Email Address",
            prefixIcon: const Icon(Icons.email_outlined),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          ),
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return "Please enter email address";
            }
            if (!GetUtils.isEmail(value.trim())) {
              return "Please enter valid email address";
            }
            return null;
          },
        ),
        const SizedBox(height: 12),

        TextFormField(
          controller: widget.phoneController,
          keyboardType: TextInputType.phone,
          textInputAction: TextInputAction.done,
          decoration: InputDecoration(
            labelText: "Phone Number",
            hintText: "Enter Phone Number",
            prefixIcon: const Icon(Icons.phone_outlined),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          ),
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return "Please enter phone number";
            }
            if (value.trim().length < 10) {
              return "Please enter valid phone number";
            }
            return null;
          },
        ),
      ],
    );
  }
}