import 'package:flutter/material.dart';

// --- Address Model ---
class AddressModel {
  String name, mobile, address, city, state, pincode;
  bool isDefault;

  AddressModel({
    required this.name,
    required this.mobile,
    required this.address,
    required this.city,
    required this.state,
    required this.pincode,
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
  // Colors & Themes
  final Color primaryColor = const Color(0xFFF012BE);
  final Color darkBlue = const Color(0xFF1B2E3F);
  final Color bgColor = const Color(0xFFF8FAFC);

  int qty = 1;
  double price = 249.0;
  double discount = 20.0;
  AddressModel? selectedAddress;
  double _dragPosition = 0;
  bool _isFinished = false;

  List<AddressModel> addressList = [
    AddressModel(
      name: "Savan Patel",
      mobile: "9876543210",
      address: "102, Silver Heights, Kalawad Road",
      city: "Rajkot",
      state: "Gujarat",
      pincode: "360005",
      isDefault: true,
    ),
  ];

  double get subtotal => price * qty;
  double get total => subtotal - discount;

  @override
  void initState() {
    super.initState();
    if (addressList.isNotEmpty) {
      selectedAddress = addressList.firstWhere(
        (a) => a.isDefault,
        orElse: () => addressList.first,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new, color: darkBlue, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "Checkout",
          style: TextStyle(
            color: darkBlue,
            fontWeight: FontWeight.w900,
            fontSize: 18,
          ),
        ),
      ),
      bottomNavigationBar: _buildCheckoutSection(),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildStepIndicator(),
            const SizedBox(height: 30),
            _sectionHeader("Items in Cart"),
            _buildCartItem(),
            const SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _sectionHeader("Delivery Address"),
                TextButton(
                  onPressed: () => _showAddressForm(),
                  child: Text(
                    "+ Add New",
                    style: TextStyle(
                      color: primaryColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            _buildAddressSection(),
            const SizedBox(height: 30),
            _sectionHeader("Order Summary"),
            _buildPriceDetails(),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  // --- STEP INDICATOR ---
  Widget _buildStepIndicator() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _stepCircle("1", "Cart", true),
        _stepLine(true),
        _stepCircle("2", "Address", true),
        _stepLine(false),
        _stepCircle("3", "Payment", false),
      ],
    );
  }

  Widget _stepCircle(String step, String label, bool isActive) {
    return Column(
      children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          height: 28,
          width: 28,
          decoration: BoxDecoration(
            color: isActive ? primaryColor : Colors.grey[300],
            shape: BoxShape.circle,
            boxShadow: isActive
                ? [
                    BoxShadow(
                      color: primaryColor.withOpacity(0.3),
                      blurRadius: 8,
                    ),
                  ]
                : [],
          ),
          child: Center(
            child: Text(
              step,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        const SizedBox(height: 6),
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            color: isActive ? darkBlue : Colors.grey,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _stepLine(bool isActive) {
    return Container(
      width: 50,
      height: 2,
      // marginBottom ni jagya e EdgeInsets.only vapro
      margin: const EdgeInsets.only(left: 8, right: 8, bottom: 15),
      color: isActive ? primaryColor : Colors.grey[300],
    );
  }

  // --- CART ITEM ---
  Widget _buildCartItem() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: darkBlue.withOpacity(0.04),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(18),
            child: Image.asset(
              "assets/dry.png",
              height: 80,
              width: 80,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Cold Brew Coffee",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: darkBlue,
                  ),
                ),
                Text(
                  "Gotilo Special Edition",
                  style: TextStyle(fontSize: 12, color: Colors.grey[500]),
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "₹${price.toInt()}",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w900,
                        color: darkBlue,
                      ),
                    ),
                    _buildQtyController(),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQtyController() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF1F5F9),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          _qtyBtn(Icons.remove, () => setState(() => qty > 1 ? qty-- : null)),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Text(
              "$qty",
              style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 14),
            ),
          ),
          _qtyBtn(Icons.add, () => setState(() => qty++)),
        ],
      ),
    );
  }

  Widget _qtyBtn(IconData icon, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Icon(icon, size: 16, color: darkBlue),
      ),
    );
  }

  // --- ADDRESS SECTION ---
  Widget _buildAddressSection() {
    return Column(
      children: addressList.asMap().entries.map((entry) {
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
              borderRadius: BorderRadius.circular(22),
              border: Border.all(
                color: isSelected ? primaryColor : Colors.white,
                width: 2,
              ),
              boxShadow: [
                BoxShadow(
                  color: isSelected
                      ? primaryColor.withOpacity(0.1)
                      : Colors.black.withOpacity(0.03),
                  blurRadius: 15,
                ),
              ],
            ),
            child: Row(
              children: [
                Icon(
                  isSelected
                      ? Icons.check_circle_rounded
                      : Icons.radio_button_off_rounded,
                  color: isSelected ? primaryColor : Colors.grey,
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        address.name,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                          color: darkBlue,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        address.fullAddress,
                        style: TextStyle(color: Colors.grey[600], fontSize: 12),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () => _deleteAddress(index),
                  icon: const Icon(
                    Icons.delete_outline_rounded,
                    color: Colors.red,
                    size: 18,
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  // --- PRICE DETAILS ---
  Widget _buildPriceDetails() {
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: darkBlue,
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: darkBlue.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          _priceRow("Subtotal", "₹${subtotal.toInt()}", Colors.white70),
          _priceRow("Discount", "-₹${discount.toInt()}", Colors.redAccent),
          _priceRow("Delivery Fee", "FREE", Colors.greenAccent),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 12),
            child: Divider(color: Colors.white12),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Total Amount",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                "₹${total.toInt()}",
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _priceRow(String label, String val, Color valColor) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(color: Colors.white60, fontSize: 14),
          ),
          Text(
            val,
            style: TextStyle(
              color: valColor,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  // --- SLIDE TO PAY SECTION ---
  Widget _buildCheckoutSection() {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 35),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          double maxWidth = constraints.maxWidth;
          double buttonSize = 54;
          double maxDrag = maxWidth - buttonSize - 8;

          return Container(
            height: 66,
            width: maxWidth,
            decoration: BoxDecoration(
              color: const Color(0xFFF1F5F9),
              borderRadius: BorderRadius.circular(33),
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                Text(
                  _isFinished
                      ? "SUCCESSFUL"
                      : "Slide to Pay • ₹${total.toInt()}",
                  style: TextStyle(
                    color: darkBlue,
                    fontWeight: FontWeight.w900,
                    fontSize: 13,
                    letterSpacing: 0.5,
                  ),
                ),
                Positioned(
                  left: 6 + _dragPosition,
                  child: GestureDetector(
                    onHorizontalDragUpdate: (details) {
                      setState(() {
                        _dragPosition += details.delta.dx;
                        if (_dragPosition < 0) _dragPosition = 0;
                        if (_dragPosition > maxDrag) _dragPosition = maxDrag;
                      });
                    },
                    onHorizontalDragEnd: (details) {
                      if (_dragPosition > maxDrag * 0.75) {
                        setState(() {
                          _dragPosition = maxDrag;
                          _isFinished = true;
                        });
                        // Navigation logic here
                        print("Payment Started!");
                      } else {
                        setState(() => _dragPosition = 0);
                      }
                    },
                    child: Container(
                      height: buttonSize,
                      width: buttonSize,
                      decoration: BoxDecoration(
                        color: darkBlue,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: darkBlue.withOpacity(0.3),
                            blurRadius: 10,
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.arrow_forward_ios_rounded,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  // --- DIALOGS ---
  void _showAddressForm() {
    // Basic implementation for adding address
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
          left: 20,
          right: 20,
          top: 20,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              "Add New Address",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            TextField(
              decoration: InputDecoration(
                labelText: "Full Name",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              decoration: InputDecoration(
                labelText: "Address Detail",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: darkBlue,
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                "Save Address",
                style: TextStyle(color: Colors.white),
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  void _deleteAddress(int index) {
    setState(() => addressList.removeAt(index));
  }

  Widget _sectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w900,
          color: darkBlue,
        ),
      ),
    );
  }
}
