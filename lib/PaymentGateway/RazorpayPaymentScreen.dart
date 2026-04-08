import 'package:flutter/material.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

class RazorpayPaymentScreen extends StatefulWidget {
  final double amount;
  final String mobile;
  final String name;

  const RazorpayPaymentScreen({
    super.key,
    required this.amount,
    required this.mobile,
    required this.name,
  });

  @override
  State<RazorpayPaymentScreen> createState() =>
      _RazorpayPaymentScreenState();
}

class _RazorpayPaymentScreenState
    extends State<RazorpayPaymentScreen> {
  late Razorpay _razorpay;

  @override
  void initState() {
    super.initState();

    _razorpay = Razorpay();

    _razorpay.on(
      Razorpay.EVENT_PAYMENT_SUCCESS,
      _handlePaymentSuccess,
    );

    _razorpay.on(
      Razorpay.EVENT_PAYMENT_ERROR,
      _handlePaymentError,
    );

    _razorpay.on(
      Razorpay.EVENT_EXTERNAL_WALLET,
      _handleExternalWallet,
    );

    /// Auto open payment
    Future.delayed(
      const Duration(milliseconds: 500),
      openCheckout,
    );
  }

  @override
  void dispose() {
    _razorpay.clear();
    super.dispose();
  }

  void openCheckout() {
    var options = {
      'key': 'rzp_test_Sa5PgaVhfP97pi',
      'amount': (widget.amount * 100).toInt(),
      'name': widget.name,
      'description': 'Order Payment',
      'prefill': {
        'contact': widget.mobile,
        'email': 'test@gmail.com',
      },
      'theme': {
        'color': '#000000',
      }
    };

    try {
      _razorpay.open(options);
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  void _handlePaymentSuccess(
      PaymentSuccessResponse response) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Payment Successful"),
      ),
    );

    print("Payment ID: ${response.paymentId}");

    Navigator.pop(context, true);
  }

  void _handlePaymentError(
      PaymentFailureResponse response) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Payment Failed"),
      ),
    );

    Navigator.pop(context, false);
  }

  void _handleExternalWallet(
      ExternalWalletResponse response) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          "Wallet: ${response.walletName}",
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Processing Payment"),
        centerTitle: true,
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment:
          MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 20),
            Text(
              "Opening Payment Gateway...",
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}