import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gotilo_new/Api/ApiCalls.dart';
import 'package:gotilo_new/Api/Request/Otp/RequestSendOtp.dart';
import 'package:gotilo_new/Api/Response/Otp/ResponseSendOtp.dart';
import 'package:gotilo_new/CustomeWidgets/SharedWidgets.dart';
import 'package:gotilo_new/MyApplication/MyApplication.dart';
import '../OTP/OtpVerifyScreen.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final TextEditingController _number = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _number.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Color primaryColor = const Color(0xFFF012BE);
    final Color darkBlue = const Color(0xFF1B2E3F);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new, color: darkBlue, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            Text("Forgot Password? 🔑",
                style: GoogleFonts.plusJakartaSans(fontSize: 28, fontWeight: FontWeight.w900, color: darkBlue)),
            const SizedBox(height: 10),
            Text("Please enter your mobile number to receive an OTP verification code.",
                style: GoogleFonts.plusJakartaSans(fontSize: 14, color: Colors.grey[600], height: 1.5)),
            const SizedBox(height: 40),

            Text("Mobile Number", style: GoogleFonts.plusJakartaSans(fontSize: 13, fontWeight: FontWeight.bold, color: darkBlue)),
            const SizedBox(height: 10),
            Container(
              decoration: BoxDecoration(
                color: const Color(0xFFF1F5F9),
                borderRadius: BorderRadius.circular(15),
              ),
              child: TextField(
                controller: _number,
                keyboardType: TextInputType.phone,
                maxLength: 10,
                decoration: InputDecoration(
                  counterText: "",
                  hintText: "Enter your Number",
                  hintStyle: GoogleFonts.plusJakartaSans(fontSize: 14, color: Colors.grey),
                  prefixIcon: Icon(Icons.phone, color: primaryColor),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(vertical: 15),
                ),
              ),
            ),

            const SizedBox(height: 30),

            GestureDetector(
              onTap: _isLoading ? null : () => _sendOtp(context),
              child: Container(
                width: double.infinity,
                height: 60,
                decoration: BoxDecoration(
                  color: darkBlue,
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Center(
                  child: _isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : Text("SEND OTP",
                      style: GoogleFonts.plusJakartaSans(color: Colors.white, fontWeight: FontWeight.w800, letterSpacing: 1)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _sendOtp(BuildContext c) async {
    if (_number.text.isEmpty || _number.text.length < 10) {
      SharedWidgets.showTopSnackBar(c, message: "Please enter a valid 10-digit mobile number",title: "fail");
      return;
    }
    bool internet = await MyApplication.checkInternet();
    if (!internet) {
      SharedWidgets.showTopSnackBar(c, message: "No Internet Available",title: "fail");
      return;
    }

    setState(() => _isLoading = true);

    try {
      ResponseSendOtp? response = await ApiCalls.callSendOtp(RequestSendOtp(
          phone: _number.text,
          userType: "user"
      ));

      if (response != null) {

        if (response.result != null && response.result!.toLowerCase().contains("pass")) {
          SharedWidgets.showTopSnackBar(c, message: response.message ?? "OTP sent successfully",title: "pass");
          Get.to(() => OtpVerificationScreen(number: _number.text,isLogin: false,));

        } else {
          SharedWidgets.showTopSnackBar(c, message: response.message ?? "Failed to send OTP",title: "fail");
        }
      } else {
        SharedWidgets.showTopSnackBar(c, message: "Something went wrong!",title: "fail");
      }
    } catch (e) {
      log("Error in _sendOtp: $e");
      SharedWidgets.showTopSnackBar(c, message: "Server Error!",title: "fail");
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }
}