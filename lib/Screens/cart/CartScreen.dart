
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../CustomeWidgets/AppColors.dart';
import '../../CustomeWidgets/SharedWidgets.dart';
import '../../PaymentGateway/RazorpayPaymentScreen.dart';

class AddressModel {
  String name, mobile, address, city, state, pincode;
  bool isDefault;

  AddressModel({
    required this.name, required this.mobile, required this.address,
    required this.city, required this.state, required this.pincode,
    this.isDefault = false,
  });
  String get fullAddress => "$address, $city, $state - $pincode";
}

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});
  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  int qty = 1;
  double price = 499.0;
  double discount = 50.0;
  AddressModel? selectedAddress;
  double _dragPosition = 0;
  bool _isFinished = false;

  List<AddressModel> addressList = [
    AddressModel(
      name: "Savan", mobile: "9876543210", address: "102, Silver Heights, Kalawad Road",
      city: "Rajkot", state: "Gujarat", pincode: "360005", isDefault: true,
    ),
  ];

  double get subtotal => price * qty;
  double get total => subtotal - discount;

  @override
  void initState() {
    super.initState();
    if (addressList.isNotEmpty) {
      selectedAddress = addressList.firstWhere((a) => a.isDefault, orElse: () => addressList.first);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: SharedWidgets.customAppBar(
        title: "My Cart",
        gradient: const LinearGradient(colors: [AppColors.gradientStart, AppColors.gradientEnd]),
      ),
      bottomNavigationBar: _checkoutSection(),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _sectionTitle("Items in Cart"),
            _cartItem(),
            const SizedBox(height: 24),
            _sectionTitle("Delivery Address"),
            _addressSection(),
            const SizedBox(height: 24),
            _sectionTitle("Order Summary"),
            _priceDetails(),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12, left: 4),
      child: Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87)),
    );
  }

  Widget _cartItem() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 15, offset: const Offset(0, 5))],
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: Image.asset("assets/dry.png", height: 90, width: 90, fit: BoxFit.cover),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Premium Cotton Shirt", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("₹${price.toInt()}", style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: AppColors.gradientStart)),
                    _qtyController(),
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _qtyController() {
    return Container(
      decoration: BoxDecoration(color: Colors.grey[100], borderRadius: BorderRadius.circular(10)),
      child: Row(
        children: [
          _qtyBtn(Icons.remove, () => setState(() => qty > 1 ? qty-- : null)),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Text("$qty", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
          ),
          _qtyBtn(Icons.add, () => setState(() => qty++)),
        ],
      ),
    );
  }

  Widget _qtyBtn(IconData icon, VoidCallback onTap) {
    return InkWell(onTap: onTap, child: Padding(padding: const EdgeInsets.all(8), child: Icon(icon, size: 18, color: Colors.black)));
  }

  Widget _addressSection() {
    return Column(
      children: [
        ...addressList.asMap().entries.map((entry) {
          int index = entry.key;
          AddressModel address = entry.value;
          bool isSelected = selectedAddress == address;
          return GestureDetector(
            onTap: () => setState(() => selectedAddress = address),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: isSelected ? AppColors.gradientStart : Colors.transparent, width: 2),
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10, offset: const Offset(0, 4))],
              ),
              child: Row(
                children: [
                  Icon(isSelected ? Icons.check_circle : Icons.circle_outlined, color: isSelected ? AppColors.gradientStart : Colors.grey),
                  const SizedBox(width: 15),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(address.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                        Text(address.fullAddress, style: TextStyle(color: Colors.grey[600], fontSize: 13), maxLines: 2),
                      ],
                    ),
                  ),
                  _addressActionIcon(iconPath: 'assets/edit.svg', color: Colors.blueGrey, onPressed: () => _showAddressForm(index: index, address: address)),
                  const SizedBox(width: 8),
                  _addressActionIcon(iconPath: 'assets/delete.svg', color: Colors.red, onPressed: () => _deleteAddress(index)),
                ],
              ),
            ),
          );
        }).toList(),
        OutlinedButton.icon(
          onPressed: () => _showAddressForm(),
          icon: const Icon(Icons.add_location_alt_outlined, size: 18),
          label: const Text("Add New Address"),
          style: OutlinedButton.styleFrom(
            foregroundColor: AppColors.gradientStart,
            minimumSize: const Size(double.infinity, 50),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            side: const BorderSide(color: AppColors.gradientStart),
          ),
        ),
      ],
    );
  }

  Widget _addressActionIcon({required String iconPath, required Color color, required VoidCallback onPressed}) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
        child: SvgPicture.asset(iconPath, height: 18, width: 18, colorFilter: ColorFilter.mode(color, BlendMode.srcIn)),
      ),
    );
  }

  Widget _priceDetails() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 15, offset: const Offset(0, 5))],
      ),
      child: Column(
        children: [
          _row("Item Subtotal", "₹${subtotal.toInt()}", false),
          _row("Delivery Fee", "FREE", false, color: Colors.green),
          _row("Discount", "-₹${discount.toInt()}", false, color: Colors.red),
          const Divider(height: 30),
          _row("Grand Total", "₹${total.toInt()}", true),
        ],
      ),
    );
  }

  Widget _row(String label, String val, bool isBold, {Color? color}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(fontSize: isBold ? 17 : 14, fontWeight: isBold ? FontWeight.bold : FontWeight.w500, color: Colors.grey[700])),
          Text(val, style: TextStyle(fontSize: isBold ? 18 : 14, fontWeight: isBold ? FontWeight.bold : FontWeight.w700, color: color ?? Colors.black)),
        ],
      ),
    );
  }

  void _showAddressForm({int? index, AddressModel? address}) {
    final name = TextEditingController(text: address?.name ?? "");
    final mobile = TextEditingController(text: address?.mobile ?? "");
    final addrText = TextEditingController(text: address?.address ?? "");
    final city = TextEditingController(text: address?.city ?? "");
    final state = TextEditingController(text: address?.state ?? "");
    final pincode = TextEditingController(text: address?.pincode ?? "");

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(address == null ? "Add Address" : "Edit Address"),
        content: SingleChildScrollView(
          child: Column(
            children: [
              TextField(controller: name, decoration: const InputDecoration(labelText: "Name")),
              TextField(controller: mobile, decoration: const InputDecoration(labelText: "Mobile"), keyboardType: TextInputType.phone),
              TextField(controller: addrText, decoration: const InputDecoration(labelText: "Address")),
              TextField(controller: city, decoration: const InputDecoration(labelText: "City")),
              TextField(controller: state, decoration: const InputDecoration(labelText: "State")),
              TextField(controller: pincode, decoration: const InputDecoration(labelText: "Pincode"), keyboardType: TextInputType.number),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
          ElevatedButton(
            onPressed: () {
              setState(() {
                AddressModel newAddr = AddressModel(
                    name: name.text, mobile: mobile.text, address: addrText.text,
                    city: city.text, state: state.text, pincode: pincode.text);
                if (index == null) {
                  addressList.add(newAddr);
                } else {
                  addressList[index] = newAddr;
                }
              });
              Navigator.pop(context);
            },
            child: const Text("Save"),
          )
        ],
      ),
    );
  }

  void _deleteAddress(int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Delete Address"),
        content: const Text("Are you sure?"),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("No")),
          TextButton(onPressed: () {
            setState(() => addressList.removeAt(index));
            Navigator.pop(context);
          }, child: const Text("Yes", style: TextStyle(color: Colors.red))),
        ],
      ),
    );
  }

  Widget _checkoutSection() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      child: LayoutBuilder(builder: (context, constraints) {
        double maxWidth = constraints.maxWidth;
        double buttonSize = 50;
        double trackHeight = 60;
        double maxDrag = maxWidth - buttonSize - 10;

        return Container(
          height: trackHeight,
          width: maxWidth,
          decoration: BoxDecoration(color: Colors.black, borderRadius: BorderRadius.circular(30)),
          child: Stack(
            alignment: Alignment.center,
            children: [
              Text(_isFinished ? "Processing..." : "Slide to Pay • ₹${total.toInt()}",
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              Positioned(
                left: 5 + _dragPosition,
                child: GestureDetector(
                  onHorizontalDragUpdate: (details) {
                    setState(() {
                      _dragPosition += details.delta.dx;
                      if (_dragPosition < 0) _dragPosition = 0;
                      if (_dragPosition > maxDrag) _dragPosition = maxDrag;
                    });
                  },
                  onHorizontalDragEnd: (details) {
                    if (_dragPosition > maxDrag * 0.8) {
                      setState(() {
                        _dragPosition = maxDrag;
                        _isFinished = true;
                      });

                      Navigator.push(context, MaterialPageRoute(builder: (context) => RazorpayPaymentScreen(
                          amount: total, name: selectedAddress?.name ?? "User", mobile: selectedAddress?.mobile ?? "")));

                      Future.delayed(const Duration(seconds: 2), () {
                        setState(() { _dragPosition = 0; _isFinished = false; });
                      });
                    } else {
                      setState(() => _dragPosition = 0);
                    }
                  },
                  child: Container(
                    height: buttonSize, width: buttonSize,
                    decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                    child: const Icon(Icons.arrow_forward_ios, size: 18),
                  ),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}