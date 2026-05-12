import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gotilo_new/Api/ApiCalls.dart';
import 'package:gotilo_new/Api/Request/PlaceOrder/RequestPlaceOrder.dart';
import 'package:gotilo_new/Api/Response/PlaceOrder/ResponsePlaceOrder.dart';
import 'package:gotilo_new/Constant/AppPref.dart';
import 'package:gotilo_new/MyApplication/MyApplication.dart';

class OrderProcessingScreen extends StatefulWidget {
  final String addressId;
  final String totalAmount;
  final String listingId;

  const OrderProcessingScreen({
    super.key,
    required this.addressId,
    required this.totalAmount,
    required this.listingId
  });

  @override
  State<OrderProcessingScreen> createState() => _OrderProcessingScreenState();
}

class _OrderProcessingScreenState extends State<OrderProcessingScreen> {
  bool _isSuccess = false;
  bool _isFailed = false;
  bool _isApiCalling = true;

  @override
  void initState() {
    super.initState();
    _placeOrder();
  }

  double _parseAmountToDouble(String amount) {
    try {
      return double.parse(amount.replaceAll(RegExp(r'[^0-9.]'), ''));
    } catch (e) {
      return 0.0;
    }
  }

  Future<void> _placeOrder() async {
    await Future.delayed(const Duration(seconds: 2));
    if (await MyApplication.checkInternet()) {
      try {
        log("Placing order for Address: ${widget.addressId}");

        ResponsePlaceOrder? response = await ApiCalls.callPlaceOrder(
            RequestPlaceOrder(
                userId: AppPrefs.userId,
                address: widget.addressId,
                listingId: widget.listingId
            )
        );

        if (mounted) {
          setState(() {
            _isApiCalling = false;
            if (response != null &&
                response.result != null &&
                response.result!.toLowerCase().contains("pass")) {
              _isSuccess = true;
              log("Order Success: ${response.message}");
            } else {
              _isFailed = true;
              log("Order Failed from API: ${response?.message}");
            }
          });
        }
      } catch (e) {
        log("Error in API Call: $e");
        if (mounted) {
          setState(() {
            _isApiCalling = false;
            _isFailed = true;
          });
        }
      }
    } else {
      if (mounted) {
        setState(() {
          _isApiCalling = false;
          _isFailed = true;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildAnimatedIcon(),

                  const SizedBox(height: 40),

                  Text(
                    _isFailed
                        ? "Order Failed!"
                        : (_isSuccess ? "Order Confirmed!" : "Confirming Order..."),
                    textAlign: TextAlign.center,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 26,
                      fontWeight: FontWeight.w900,
                      color: _isFailed ? Colors.redAccent : const Color(0xFF1B2E3F),
                    ),
                  ),

                  const SizedBox(height: 15),

                  Text(
                    _isFailed
                        ? "Something went wrong with your order. Please try again later."
                        : (_isSuccess
                        ? "Your order has been placed successfully. Thank you for shopping with us!"
                        : "Sit tight! We are securing your order with the store."),
                    textAlign: TextAlign.center,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 15,
                      color: Colors.grey[600],
                      height: 1.6,
                    ),
                  ),

                  if (_isSuccess) ...[
                    const SizedBox(height: 40),
                    TweenAnimationBuilder<double>(
                      tween: Tween<double>(begin: 0.0, end: _parseAmountToDouble(widget.totalAmount)),
                      duration: const Duration(seconds: 1),
                      builder: (context, double value, child) {
                        return Text(
                          "₹${value.toStringAsFixed(2)}",
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 38,
                            fontWeight: FontWeight.w900,
                            color: const Color(0xFF1B2E3F),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 50),
                    _buildActionButton(
                        label: "BACK TO HOME",
                        icon: Icons.home_rounded,
                        color: const Color(0xFF1B2E3F),
                        onTap: () => Get.back()
                    ),
                  ],

                  if (_isFailed) ...[
                    const SizedBox(height: 50),
                    _buildActionButton(
                      label: "TRY AGAIN",
                      icon: Icons.refresh_rounded,
                      color: Colors.redAccent,
                      onTap: () => Navigator.pop(context),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAnimatedIcon() {
    return SizedBox(
      height: 180,
      width: 180,
      child: Stack(
        alignment: Alignment.center,
        children: [
          if (_isApiCalling)
            const SizedBox(
              height: 160,
              width: 160,
              child: CircularProgressIndicator(
                strokeWidth: 3,
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFF012BE)),
              ),
            ),
          AnimatedContainer(
            duration: const Duration(milliseconds: 600),
            height: _isApiCalling ? 100 : 160,
            width: _isApiCalling ? 100 : 160,
            decoration: BoxDecoration(
              color: _isApiCalling
                  ? Colors.grey[100]
                  : (_isSuccess ? Colors.green.withOpacity(0.1) : Colors.red.withOpacity(0.1)),
              shape: BoxShape.circle,
            ),
            child: Icon(
              _isApiCalling
                  ? Icons.shopping_bag_outlined
                  : (_isSuccess ? Icons.check_circle_rounded : Icons.error_outline_rounded),
              size: _isApiCalling ? 50 : 90,
              color: _isApiCalling
                  ? const Color(0xFF1B2E3F)
                  : (_isSuccess ? Colors.green : Colors.red),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({required String label, required IconData icon, required Color color, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        height: 60,
        decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: color.withOpacity(0.3),
                blurRadius: 15,
                offset: const Offset(0, 8),
              )
            ]
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.white),
            const SizedBox(width: 15),
            Text(
              label,
              style: GoogleFonts.plusJakartaSans(
                color: Colors.white,
                fontWeight: FontWeight.w800,
                fontSize: 16,
                letterSpacing: 1.2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}