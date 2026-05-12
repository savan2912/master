import 'dart:async';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gotilo_new/Api/ApiCalls.dart';
import 'package:gotilo_new/Api/Request/Cart/RequestCartAddress.dart';
import 'package:gotilo_new/Api/Request/Cart/RequestCartDelete.dart';
import 'package:gotilo_new/Api/Request/Cart/RequestCartItem.dart';
import 'package:gotilo_new/Api/Request/Cart/RequestUpdateCart.dart';
import 'package:gotilo_new/Api/Response/Cart/ResponseCartAddress.dart';
import 'package:gotilo_new/Api/Response/Cart/ResponseCartDelete.dart';
import 'package:gotilo_new/Api/Response/Cart/ResponseCartItem.dart';
import 'package:gotilo_new/Api/Response/User/Profile/ResponseEditAddress.dart';
import 'package:gotilo_new/Constant/AppPref.dart';
import 'package:gotilo_new/CustomeWidgets/SharedWidgets.dart';
import 'package:gotilo_new/MyApplication/MyApplication.dart';
import '../../Api/Request/User/Profile/RequestEditAddress.dart';
import '../OrderProcessingScreen/OrderProcessingScreen.dart';
import '../User/Account/MapScreen.dart';

class CartScreen extends StatefulWidget {
  final int? listingId;
  const CartScreen({super.key, required this.listingId});
  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  List<Items> cartItem = [];
  String? total = "0";
  bool isLoading = true;
  bool isAddressLoading = true;
  bool isEditingAddress = false;

  List<CartAddress> addressList = [];
  CartAddress? selectedAddress;

  String selectedPaymentMethod = "COD";

  final TextEditingController _latController = TextEditingController();
  final TextEditingController _lngController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _pincodeController = TextEditingController();

  Timer? _debounce;
  Map<int, int> pendingUpdates = {};

  final Color primaryColor = const Color(0xFFF012BE);
  final Color darkBlue = const Color(0xFF1B2E3F);
  final Color bgColor = const Color(0xFFF8FAFC);
  final Color softShadow = Colors.grey.withOpacity(0.1);
  final Color textBlack = const Color(0xFF1B2E3F);

  double _dragPosition = 0;
  bool _isFinished = false;

  @override
  void initState() {
    super.initState();
    callCartItem();
    callGetAddress();
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _latController.dispose();
    _lngController.dispose();
    _addressController.dispose();
    _pincodeController.dispose();
    super.dispose();
  }

  void safeSetState(VoidCallback fn) {
    if (mounted) setState(fn);
  }

  void _onQtyChanged(Items item, bool isIncrement) {
    int cartId = item.id ?? 0;
    safeSetState(() {
      if (isIncrement) {
        item.quantity = (item.quantity ?? 1) + 1;
        pendingUpdates[cartId] = (pendingUpdates[cartId] ?? 0) + 1;
      } else {
        if ((item.quantity ?? 1) > 1) {
          item.quantity = (item.quantity ?? 1) - 1;
          pendingUpdates[cartId] = (pendingUpdates[cartId] ?? 0) - 1;
        }
      }
    });

    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 800), () {
      _sendBulkUpdate();
    });
  }

  Future<void> _sendBulkUpdate() async {
    if (pendingUpdates.isEmpty) return;
    for (var entry in pendingUpdates.entries) {
      int cartId = entry.key;
      int change = entry.value;
      if (change == 0) continue;
      String action = change > 0 ? "1" : "0";
      String finalQty = change.abs().toString();
      await callAddCart(qty: finalQty, cartId: cartId.toString(), action: action);
    }
    pendingUpdates.clear();
    callCartItem(showLoader: false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: Colors.white, elevation: 0, centerTitle: true,
        leading: IconButton(
            icon: Icon(Icons.arrow_back_ios_new, color: darkBlue, size: 20),
            onPressed: () {
              if (isEditingAddress) {
                safeSetState(() => isEditingAddress = false);
              } else {
                Navigator.pop(context);
              }
            }),
        title: Text("Checkout", style: TextStyle(color: darkBlue, fontWeight: FontWeight.w900, fontSize: 18)),
      ),
      bottomNavigationBar: (cartItem.isEmpty || isEditingAddress) ? null : _buildCheckoutSection(),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : cartItem.isEmpty
          ? const Center(child: Text("Your cart is empty"))
          : SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildStepIndicator(),
            const SizedBox(height: 30),
            if (!isEditingAddress) ...[
              _sectionHeader("Items in Cart"),
              ...cartItem.map((item) => Padding(padding: const EdgeInsets.only(bottom: 15.0), child: _buildCartItem(item))),
              const SizedBox(height: 20),
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                _sectionHeader("Delivery Address"),
                TextButton(
                    onPressed: () => safeSetState(() => isEditingAddress = true),
                    child: Text("+ Add New", style: TextStyle(color: primaryColor, fontWeight: FontWeight.bold))),
              ]),
              _buildAddressSection(),
              const SizedBox(height: 25),
              _sectionHeader("Payment Method"),
              _buildPaymentSection(),
              const SizedBox(height: 25),
              _sectionHeader("Order Summary"),
              _buildPriceDetails(),
              const SizedBox(height: 40),
            ] else
              _buildAddressForm(),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: primaryColor.withOpacity(0.5), width: 1.5),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(color: Colors.green[50], shape: BoxShape.circle),
            child: const Icon(Icons.payments_outlined, color: Colors.green, size: 24),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Cash on Delivery", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: darkBlue)),
                Text("Pay when you receive your order", style: TextStyle(color: Colors.grey[600], fontSize: 12)),
              ],
            ),
          ),
          Icon(Icons.check_circle, color: primaryColor),
        ],
      ),
    );
  }

  Widget _buildAddressForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionHeader("Add New Address"),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(child: _buildCoordinateInput("Latitude", _latController)),
            const SizedBox(width: 12),
            Expanded(child: _buildCoordinateInput("Longitude", _lngController)),
            const SizedBox(width: 12),
            GestureDetector(
              onTap: () => _pickAddressFromMap(),
              child: Container(
                height: 55, width: 55,
                decoration: BoxDecoration(color: textBlack, borderRadius: BorderRadius.circular(15)),
                child: const Icon(Icons.map_rounded, color: Colors.white),
              ),
            ),
          ],
        ),
        const SizedBox(height: 15),
        _buildLabel("Full Address"),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(18), border: Border.all(color: softShadow)),
          child: TextField(
            controller: _addressController,
            maxLines: 3,
            style: GoogleFonts.plusJakartaSans(fontSize: 14),
            decoration: const InputDecoration(border: InputBorder.none, hintText: "House no, Street..."),
          ),
        ),
        const SizedBox(height: 15),
        _buildLabel("Pincode"),
        Container(
          height: 55,
          padding: const EdgeInsets.symmetric(horizontal: 15),
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(15), border: Border.all(color: softShadow)),
          child: TextField(
            controller: _pincodeController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(border: InputBorder.none, icon: Icon(Icons.pin_drop_outlined, color: Colors.orange)),
          ),
        ),
        const SizedBox(height: 25),
        _buildGradientButton("SAVE ADDRESS", onTap: _saveAddress),
      ],
    );
  }

  void _saveAddress() async {
    if (_addressController.text.isEmpty || _pincodeController.text.isEmpty) {
      SharedWidgets.showTopSnackBar(context, message: "Please enter all details");
      return;
    }
    _addAddress();
  }

  Future<void> _pickAddressFromMap() async {
    final result = await Navigator.push(context, MaterialPageRoute(builder: (context) => const MapScreen()));
    if (result != null && result is Map<String, dynamic>) {
      safeSetState(() {
        _addressController.text = result['address'] ?? "";
        _latController.text = result['lat'].toString();
        _lngController.text = result['lng'].toString();
      });
    }
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(left: 5, bottom: 8),
      child: Text(text, style: GoogleFonts.plusJakartaSans(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.grey.shade600)),
    );
  }

  Widget _buildCoordinateInput(String label, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLabel(label),
        Container(
          height: 55,
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(15), border: Border.all(color: softShadow)),
          child: TextField(
            controller: controller, readOnly: true, textAlign: TextAlign.center,
            style: GoogleFonts.plusJakartaSans(fontSize: 12, fontWeight: FontWeight.bold),
            decoration: const InputDecoration(border: InputBorder.none),
          ),
        ),
      ],
    );
  }

  Widget _buildGradientButton(String text, {required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: double.infinity, height: 60,
        decoration: BoxDecoration(color: textBlack, borderRadius: BorderRadius.circular(20)),
        child: Center(child: Text(text, style: GoogleFonts.plusJakartaSans(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 16))),
      ),
    );
  }

  Widget _buildStepIndicator() {
    return Row(mainAxisAlignment: MainAxisAlignment.center, children: [_stepCircle("1", "Cart", true), _stepLine(true), _stepCircle("2", "Address", true), _stepLine(true), _stepCircle("3", "Payment", true)]);
  }

  Widget _stepCircle(String step, String label, bool isActive) {
    return Column(children: [
      AnimatedContainer(duration: const Duration(milliseconds: 300), height: 28, width: 28, decoration: BoxDecoration(color: isActive ? primaryColor : Colors.grey[300], shape: BoxShape.circle, boxShadow: isActive ? [BoxShadow(color: primaryColor.withOpacity(0.3), blurRadius: 8)] : []), child: Center(child: Text(step, style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)))),
      const SizedBox(height: 6),
      Text(label, style: TextStyle(fontSize: 11, color: isActive ? darkBlue : Colors.grey, fontWeight: FontWeight.bold)),
    ]);
  }

  Widget _stepLine(bool isActive) => Container(width: 50, height: 2, margin: const EdgeInsets.only(left: 8, right: 8, bottom: 15), color: isActive ? primaryColor : Colors.grey[300]);

  Widget _buildCartItem(Items item) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(24), boxShadow: [BoxShadow(color: darkBlue.withOpacity(0.04), blurRadius: 20, offset: const Offset(0, 10))]),
      child: Row(children: [
        ClipRRect(borderRadius: BorderRadius.circular(18), child: Image.network(item.thumbnail ?? "", height: 80, width: 80, fit: BoxFit.cover, errorBuilder: (context, error, stackTrace) => Image.asset("assets/dry.png", height: 80, width: 80))),
        const SizedBox(width: 15),
        Expanded(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Expanded(child: Text(item.productName ?? "No Name", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: darkBlue), maxLines: 1, overflow: TextOverflow.ellipsis)),
              GestureDetector(
                onTap: () => _showDeleteConfirmation(item),
                child: Container(padding: const EdgeInsets.all(5), decoration: BoxDecoration(color: Colors.red.withOpacity(0.1), shape: BoxShape.circle), child: const Icon(Icons.delete_outline, color: Colors.red, size: 20)),
              ),
            ]),
            const SizedBox(height: 8),
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Text("₹${item.price}", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: darkBlue)),
              _buildQtyController(item),
            ]),
          ]),
        ),
      ]),
    );
  }

  void _showDeleteConfirmation(Items item) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        decoration: const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.vertical(top: Radius.circular(30))),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Container(height: 4, width: 40, margin: const EdgeInsets.only(bottom: 20), decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(10))),
          Container(padding: const EdgeInsets.all(15), decoration: BoxDecoration(color: Colors.red[50], shape: BoxShape.circle), child: const Icon(Icons.delete_sweep_rounded, color: Colors.red, size: 40)),
          const SizedBox(height: 20),
          Text("Remove from Cart?", style: GoogleFonts.plusJakartaSans(fontSize: 20, fontWeight: FontWeight.w800, color: darkBlue)),
          const SizedBox(height: 10),
          Text("Are you sure you want to remove '${item.productName}'?", textAlign: TextAlign.center, style: GoogleFonts.plusJakartaSans(fontSize: 14, color: Colors.grey[600])),
          const SizedBox(height: 30),
          Row(children: [
            Expanded(child: OutlinedButton(onPressed: () => Navigator.pop(context), style: OutlinedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 15), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))), child: Text("Keep it", style: TextStyle(color: darkBlue, fontWeight: FontWeight.bold)))),
            const SizedBox(width: 15),
            Expanded(child: ElevatedButton(onPressed: () { Navigator.pop(context); _deleteCartItem(addressId: item.id.toString()); }, style: ElevatedButton.styleFrom(backgroundColor: Colors.red, padding: const EdgeInsets.symmetric(vertical: 15), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))), child: const Text("Remove", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)))),
          ]),
          const SizedBox(height: 10),
        ]),
      ),
    );
  }

  Widget _buildQtyController(Items item) {
    return Container(
      decoration: BoxDecoration(color: const Color(0xFFF1F5F9), borderRadius: BorderRadius.circular(12)),
      child: Row(children: [
        _qtyBtn(Icons.remove, () => _onQtyChanged(item, false)),
        Padding(padding: const EdgeInsets.symmetric(horizontal: 8), child: Text("${item.quantity ?? 1}", style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 14))),
        _qtyBtn(Icons.add, () => _onQtyChanged(item, true)),
      ]),
    );
  }

  Widget _qtyBtn(IconData icon, VoidCallback onTap) => InkWell(onTap: onTap, child: Padding(padding: const EdgeInsets.all(8), child: Icon(icon, size: 16, color: darkBlue)));

  Widget _buildAddressSection() {
    if (isAddressLoading) return const Center(child: Padding(padding: EdgeInsets.all(20), child: CircularProgressIndicator()));
    if (addressList.isEmpty) return const Center(child: Padding(padding: EdgeInsets.all(20), child: Text("No addresses found.")));

    return Column(
      children: addressList.map((addr) {
        bool isSelected = selectedAddress?.id == addr.id;
        return GestureDetector(
          onTap: () => safeSetState(() => selectedAddress = addr),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 250), margin: const EdgeInsets.only(bottom: 12), padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(22), border: Border.all(color: isSelected ? primaryColor : Colors.white, width: 2)),
            child: Row(children: [
              Icon(isSelected ? Icons.check_circle_rounded : Icons.radio_button_off_rounded, color: isSelected ? primaryColor : Colors.grey),
              const SizedBox(width: 15),
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(addr.addressLine ?? "Home Address", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: darkBlue)),
                Text("${addr.pincode}", style: TextStyle(color: Colors.grey[600], fontSize: 12), maxLines: 1, overflow: TextOverflow.ellipsis),
              ])),
              const Icon(Icons.location_on_outlined, color: Colors.grey, size: 18),
            ]),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildPriceDetails() {
    return Container(padding: const EdgeInsets.all(22), decoration: BoxDecoration(color: darkBlue, borderRadius: BorderRadius.circular(28)), child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [const Text("Total Amount", style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)), Text("₹$total", style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.w900))]));
  }

  Widget _buildCheckoutSection() {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 35),
      decoration: const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.vertical(top: Radius.circular(30))),
      child: LayoutBuilder(builder: (context, constraints) {
        double maxWidth = constraints.maxWidth, buttonSize = 54, maxDrag = maxWidth - buttonSize - 8;
        return Container(
          height: 66, width: maxWidth, decoration: BoxDecoration(color: const Color(0xFFF1F5F9), borderRadius: BorderRadius.circular(33)),
          child: Stack(alignment: Alignment.center, children: [
            Text(_isFinished ? "ORDER PLACED" : "Slide to Pay • ₹$total", style: TextStyle(color: darkBlue, fontWeight: FontWeight.w900, fontSize: 13)),
            Positioned(
              left: 6 + _dragPosition,
              child: GestureDetector(
                onHorizontalDragUpdate: (details) => safeSetState(() { _dragPosition += details.delta.dx; if (_dragPosition < 0) _dragPosition = 0; if (_dragPosition > maxDrag) _dragPosition = maxDrag; }),
                onHorizontalDragEnd: (details) {
                  if (_dragPosition > maxDrag * 0.75) {
                    if (selectedAddress == null) {
                      safeSetState(() => _dragPosition = 0);
                      SharedWidgets.showTopSnackBar(context, message: "Please select an address first");
                      return;
                    }

                    safeSetState(() {
                      _dragPosition = maxDrag;
                      _isFinished = true;
                    });

                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => OrderProcessingScreen(
                          addressId: selectedAddress!.id.toString(),
                          totalAmount: total ?? "0",
                          listingId: widget.listingId.toString(),
                        ),
                      ),
                    ).then((value) {
                      if (mounted) {
                        safeSetState(() {
                          _dragPosition = 0;
                          _isFinished = false;
                        });
                      }
                    });

                  } else {
                    safeSetState(() => _dragPosition = 0);
                  }
                },
                child: Container(height: buttonSize, width: buttonSize, decoration: BoxDecoration(color: darkBlue, shape: BoxShape.circle), child: const Icon(Icons.arrow_forward_ios_rounded, color: Colors.white, size: 20)),
              ),
            ),
          ]),
        );
      }),
    );
  }

  Widget _sectionHeader(String title) => Padding(padding: const EdgeInsets.only(bottom: 12), child: Text(title, style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: darkBlue)));

  Future<void> callCartItem({bool showLoader = true}) async {
    if (await MyApplication.checkInternet()) {
      if (showLoader) safeSetState(() => isLoading = true);
      try {
        var response = await ApiCalls.callCartItem(RequestCartItem(
            userId: AppPrefs.userId,
            listingId: widget.listingId.toString()
        ));
        if (response != null && response.result!.toLowerCase().contains("pass")) {
          safeSetState(() { cartItem = response.data ?? []; total = response.total ?? "0"; });
        }
      } catch (e) { log("Error: $e"); }
      finally { if (showLoader) safeSetState(() => isLoading = false); }
    }
  }

  Future<void> callAddCart({String? action, String? cartId, String? qty}) async {
    if (await MyApplication.checkInternet()) {
      try {
        await ApiCalls.callCartUpdateCart(RequestUpdateCart(action: action, cartId: cartId, quantity: qty));
      } catch (e) { log("Error: $e"); }
    }
  }

  Future<void> callGetAddress() async {
    safeSetState(() => isAddressLoading = true);
    if (await MyApplication.checkInternet()) {
      try {
        ResponseCartAddress? response = await ApiCalls.callCartAddress(RequestCartAddress(userId: AppPrefs.userId));
        if (response != null && response.result!.toLowerCase().contains("pass")) {
          safeSetState(() {
            addressList = response.data ?? [];
            if (addressList.isNotEmpty) {
              selectedAddress = addressList[0];
            }
          });
        }
      } catch (e) { log("Error: $e"); }
      finally { safeSetState(() => isAddressLoading = false); }
    }
  }

  Future<void> _addAddress() async {
    bool internet = await MyApplication.checkInternet();
    if (internet) {
      ResponseEditAddress? response = await ApiCalls.callEditAddress(
          RequestEditAddress(
              userId: AppPrefs.userId, addressId: "", latitude: _latController.text,
              address: _addressController.text, longitude: _lngController.text, pincode: _pincodeController.text
          )
      );
      if (response != null && response.result!.toLowerCase().contains("pass")) {
        SharedWidgets.showTopSnackBar(context, message: response.message!);
        safeSetState(() => isEditingAddress = false);
        _addressController.clear(); _pincodeController.clear(); _lngController.clear(); _latController.clear();
        callGetAddress();
      }
    }
  }

  Future<void> _deleteCartItem({String? addressId = "0"}) async {
    if (await MyApplication.checkInternet()) {
      try {
        ResponseCartDelete? response = await ApiCalls.callCartDelete(RequestCartDelete(userId: AppPrefs.userId, id: addressId));
        if (response != null && response.result!.toLowerCase().contains("pass")) {
          SharedWidgets.showTopSnackBar(context, message: response.message!);
          callCartItem();
        }
      } catch (e) { log("$e"); }
    } else {
      SharedWidgets.showTopSnackBar(context, message: "No Internet Available");
    }
  }
}