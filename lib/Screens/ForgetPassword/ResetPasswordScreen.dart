import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gotilo_new/Api/ApiCalls.dart';
import 'package:gotilo_new/Api/Response/Otp/ResponseResetPassword.dart';
import 'package:gotilo_new/CustomeWidgets/SharedWidgets.dart';
import 'package:gotilo_new/MyApplication/MyApplication.dart';
import 'package:gotilo_new/Screens/Login/view/LoginScreen.dart';

import '../../Api/Request/Otp/RequestResetPassword.dart';

class ResetPasswordScreen extends StatefulWidget {
  String? number="";
   ResetPasswordScreen({super.key,required this.number});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  bool _isObscure = true;
  bool _isConfirmObscure = true;
  final Color primaryColor = const Color(0xFFF012BE);
  final Color darkBlue = const Color(0xFF1B2E3F);

  final TextEditingController _newPass=TextEditingController();
  final TextEditingController _confirmPass=TextEditingController();

  @override
  Widget build(BuildContext context) {
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
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            Text("Reset Password 🔐",
                style: GoogleFonts.plusJakartaSans(fontSize: 28, fontWeight: FontWeight.w900, color: darkBlue)),
            const SizedBox(height: 10),
            Text("Create a strong new password to secure your account.",
                style: GoogleFonts.plusJakartaSans(fontSize: 14, color: Colors.grey[600], height: 1.5)),
            const SizedBox(height: 40),

            _buildLabel("New Password"),
            _buildPasswordField(
              controller:_newPass,
              hint: "Enter new password",
              isObscure: _isObscure,
              onToggle: () => setState(() => _isObscure = !_isObscure),
            ),

            const SizedBox(height: 25),
            _buildLabel("Confirm Password"),
            _buildPasswordField(
              controller: _confirmPass,
              hint: "Confirm your password",
              isObscure: _isConfirmObscure,
              onToggle: () => setState(() => _isConfirmObscure = !_isConfirmObscure),
            ),

            const SizedBox(height: 40),


            GestureDetector(
              onTap: () {
                if(_newPass.text != "" && _confirmPass.text != ""){
                  _resetPassword();
                }else{
                  SharedWidgets.showTopSnackBar(context, message: "Try Again");
                }

              },
              child: Container(
                width: double.infinity,
                height: 60,
                decoration: BoxDecoration(
                    color: darkBlue,
                    borderRadius: BorderRadius.circular(18),
                    boxShadow: [
                      BoxShadow(color: darkBlue.withOpacity(0.2), blurRadius: 10, offset: const Offset(0, 5))
                    ]
                ),
                child: Center(
                  child: Text("UPDATE PASSWORD",
                      style: GoogleFonts.plusJakartaSans(color: Colors.white, fontWeight: FontWeight.w800, letterSpacing: 1)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLabel(String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Text(label, style: GoogleFonts.plusJakartaSans(fontSize: 13, fontWeight: FontWeight.bold, color: darkBlue)),
    );
  }

  Widget _buildPasswordField({required String hint, required bool isObscure, required VoidCallback onToggle,required TextEditingController controller}) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF1F5F9),
        borderRadius: BorderRadius.circular(15),
      ),
      child: TextField(
        obscureText: isObscure,
        controller: controller,
        style: GoogleFonts.plusJakartaSans(color: darkBlue),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: GoogleFonts.plusJakartaSans(fontSize: 14, color: Colors.grey),
          prefixIcon: Icon(Icons.lock_outline_rounded, color: primaryColor),
          suffixIcon: IconButton(
            icon: Icon(isObscure ? Icons.visibility_off_outlined : Icons.visibility_outlined, color: Colors.grey),
            onPressed: onToggle,
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 15),
        ),
      ),
    );
  }

  Future<void> _resetPassword() async {
    MyApplication.checkInternet().then((internet) async {
          if(internet){
            try{
              ResponseResetPassword? response = await ApiCalls.callResetPassword(
                  RequestResetPassword(
                      phone:widget.number,
                      password: _newPass.text,
                      passwordConfirmation: _confirmPass.text
                  )
              );
              if(response != null){
                if(response.result!.isNotEmpty && response.result != null &&
                response.result!.toLowerCase().contains("pass")){
                  SharedWidgets.showTopSnackBar(context, message: response.message!);
                  Get.off(()=>const ModernLoginScreen());
                }
              }
            }on Exception catch(e){
              log("$e");
            }catch(e){
              log("$e");
            }
          }else{
            SharedWidgets.showTopSnackBar(context, message: "No Internet Connection");
          }
    },);
  }
}