import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gotilo_new/Api/ApiCalls.dart';
import 'package:gotilo_new/Api/Request/Otp/RequestLoginOtp.dart';
import 'package:gotilo_new/Api/Request/Otp/RequestVerifyOtp.dart';
import 'package:gotilo_new/Api/Response/Otp/ResponseLoginOtp.dart';
import 'package:gotilo_new/Api/Response/Otp/ResponseVerifyOtp.dart';
import 'package:gotilo_new/Constant/AppPref.dart';
import 'package:gotilo_new/CustomeWidgets/SharedWidgets.dart';
import 'package:gotilo_new/MyApplication/MyApplication.dart';
import 'package:gotilo_new/Screens/User/Dashboard/UserDashboardScreen.dart';
import 'package:sms_autofill/sms_autofill.dart';
import '../ForgetPassword/ResetPasswordScreen.dart';

class OtpVerificationScreen extends StatefulWidget {
  final String? number;
  bool? isLogin=false;
  OtpVerificationScreen({super.key, required this.number,required this.isLogin});

  @override
  State<OtpVerificationScreen> createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends State<OtpVerificationScreen>
    with CodeAutoFill {
  final Color primaryColor = const Color(0xFFF012BE);
  final Color darkBlue = const Color(0xFF1B2E3F);

  final List<TextEditingController> _controllers =
  List.generate(4, (_) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(4, (_) => FocusNode());

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 300), () {
      _listenForOtp();
    });
  }

  void _listenForOtp() async {
    await SmsAutoFill().unregisterListener();
    listenForCode();
    String signature = await SmsAutoFill().getAppSignature;
    log("App Signature: $signature");
  }

  @override
  void codeUpdated() {
    if (code != null && code!.length == 4) {
      log("AutoFill OTP: $code");
      for (int i = 0; i < 4; i++) {
        _controllers[i].text = code![i];
      }
      _verifyOtp();
    }
  }

  @override
  void dispose() {
    cancel();
    for (var c in _controllers) c.dispose();
    for (var f in _focusNodes) f.dispose();
    super.dispose();
  }

  Future<void> _verifyOtp() async {
    String enteredOtp = _controllers.map((c) => c.text).join();

    if (enteredOtp.length < 4) {
      SharedWidgets.showTopSnackBar(context, message: "Please enter full OTP",title: "fail");
      return;
    }

    MyApplication.checkInternet().then((internet) async {
      if (internet) {
        try {
          ResponseVerifyOtp? response = await ApiCalls.callVerifyOtp(
            RequestVerifyOtp(
              phone: widget.number,
              otp: enteredOtp,
            ),
          );

          if (response != null) {
            if (response.result != null &&
                response.result!.isNotEmpty &&
                response.result!.toLowerCase().contains("pass")) {


                Get.off(() => ResetPasswordScreen(number: widget.number,));

            } else {
              SharedWidgets.showTopSnackBar(context, message: "Invalid OTP, please try again.",title: "fail");
            }
          }
        } on Exception catch (e) {
          log("Exception: $e");
        } catch (e) {
          log("Error: $e");
        }
      } else {
        SharedWidgets.showTopSnackBar(context, message: "No Internet Available",title:"fail");
      }
    });
  }


  Future<void> _verifyOtpLogin() async {
    String enteredOtp = _controllers.map((c) => c.text).join();

    if (enteredOtp.length < 4) {
      SharedWidgets.showTopSnackBar(context, message: "Please enter full OTP",title: "fail");
      return;
    }

    MyApplication.checkInternet().then((internet) async {
      if (internet) {
        try {
          ResponseLoginOtp? response = await ApiCalls.callLoginOtp(
            RequestLoginOtp(
              userId: AppPrefs.userId,
              otp: enteredOtp,
            ),
          );

          if (response != null) {
            if (response.result != null &&
                response.result!.isNotEmpty &&
                response.result!.toLowerCase().contains("pass")) {
                Get.off(() =>const Userdashboardscreen());
            } else {
              SharedWidgets.showTopSnackBar(context, message: "Invalid OTP, please try again.",title: "fail");
            }
          }
        } on Exception catch (e) {
          log("Exception: $e");
        } catch (e) {
          log("Error: $e");
        }
      } else {
        SharedWidgets.showTopSnackBar(context, message: "No Internet Available",title:"fail");
      }
    });
  }

  Widget _otpBox(int index) {
    return Container(
      height: 65,
      width: 60,
      decoration: BoxDecoration(
        color: const Color(0xFFF1F5F9),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: _focusNodes[index].hasFocus ? primaryColor : Colors.transparent,
        ),
      ),
      child: TextField(
        controller: _controllers[index],
        focusNode: _focusNodes[index],
        onChanged: (value) {
          if (value.isNotEmpty && index < 3) {
            _focusNodes[index + 1].requestFocus();
          } else if (value.isEmpty && index > 0) {
            _focusNodes[index - 1].requestFocus();
          }

          if (value.length == 1 && index == 3) {
            _focusNodes[index].unfocus();
            if(widget.isLogin!){
              _verifyOtpLogin();
            }else{
              _verifyOtp();
            }

          }
        },
        textAlign: TextAlign.center,
        keyboardType: TextInputType.number,
        maxLength: 1,
        style: GoogleFonts.plusJakartaSans(
          fontSize: 22,
          fontWeight: FontWeight.bold,
          color: darkBlue,
        ),
        decoration: const InputDecoration(
          border: InputBorder.none,
          counterText: "",
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Color(0xFF1B2E3F)),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: Column(
          children: [
            const SizedBox(height: 40),
            Text("Verification Code ✅",
                style: GoogleFonts.plusJakartaSans(
                    fontSize: 26, fontWeight: FontWeight.w900, color: darkBlue)),
            const SizedBox(height: 10),
            Text(
              "We have sent the code verification to your mobile number ${widget.number}",
              textAlign: TextAlign.center,
              style: GoogleFonts.plusJakartaSans(fontSize: 14, color: Colors.grey[600]),
            ),
            const SizedBox(height: 50),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(4, (i) => _otpBox(i)),
            ),
            const SizedBox(height: 40),
            GestureDetector(
              onTap: widget.isLogin! ? _verifyOtpLogin : _verifyOtp,
              child: Container(
                width: double.infinity,
                height: 60,
                decoration: BoxDecoration(
                  color: darkBlue,
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Center(
                  child: Text("VERIFY",
                      style: GoogleFonts.plusJakartaSans(
                        color: Colors.white,
                        fontWeight: FontWeight.w800,
                      )),
                ),
              ),
            ),
            const SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Didn't receive code? ",
                    style: GoogleFonts.plusJakartaSans(color: Colors.grey)),
                TextButton(
                  onPressed: _listenForOtp,
                  child: Text("Resend",
                      style: GoogleFonts.plusJakartaSans(
                          color: primaryColor, fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

