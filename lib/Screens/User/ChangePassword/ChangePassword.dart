import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gotilo_new/Api/ApiCalls.dart';
import 'package:gotilo_new/Api/Request/User/Profile/RequestChangePassword.dart';
import 'package:gotilo_new/Constant/AppPref.dart';
import 'package:gotilo_new/CustomeWidgets/CustomAppbar.dart';
import 'package:gotilo_new/CustomeWidgets/SharedWidgets.dart';
import 'package:gotilo_new/MyApplication/MyApplication.dart';

import '../../../Api/Response/User/Profile/ResponseChangePassword.dart';

class ChangePassword extends StatefulWidget {
  const ChangePassword({super.key});

  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  final Color bgWhite = const Color(0xFFFFFFFF);
  final Color surfaceWhite = const Color(0xFFF9FAFB);
  final Color softShadow = const Color(0xFFE5E7EB);
  final Color textBlack = const Color(0xFF111827);

  final TextEditingController _newPassword = TextEditingController();
  final TextEditingController _confirmPassword = TextEditingController();

  bool _isNewObscure = true;
  bool _isConfirmObscure = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: surfaceWhite,
      appBar: const CustomAppBar(
        title: "Set New Password",
        showAction: false,
        showBackButton: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25),
          child: Column(
            children: [
              const SizedBox(height: 40),
              // Security Icon
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: textBlack.withOpacity(0.03),
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.shield_moon_outlined, size: 45, color: textBlack),
              ),
              const SizedBox(height: 35),

              // New Password Field
              _buildPasswordField(
                label: "NEW PASSWORD",
                hint: "Enter New Password",
                controller: _newPassword,
                isObscure: _isNewObscure,
                onToggle: () => setState(() => _isNewObscure = !_isNewObscure),
              ),

              const SizedBox(height: 20),

              // Confirm Password Field
              _buildPasswordField(
                label: "CONFIRM PASSWORD",
                hint: "Enter Confirm Password",
                controller: _confirmPassword,
                isObscure: _isConfirmObscure,
                onToggle: () => setState(() => _isConfirmObscure = !_isConfirmObscure),
              ),

              const SizedBox(height: 50),

              // Premium Action Button
              _buildSubmitButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPasswordField({
    required String label,
    required String hint,
    required TextEditingController controller,
    required bool isObscure,
    required VoidCallback onToggle,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 8),
          child: Text(
            label,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 11,
              fontWeight: FontWeight.w800,
              color: Colors.grey.shade600,
              letterSpacing: 0.8,
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: bgWhite,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: softShadow),
          ),
          child: TextField(
            controller: controller,
            obscureText: isObscure,
            style: GoogleFonts.plusJakartaSans(fontSize: 14, fontWeight: FontWeight.bold, color: textBlack),
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
              border: InputBorder.none,
              hintText:hint,
              suffixIcon: IconButton(
                icon: Icon(
                  isObscure ? Icons.visibility_off_rounded : Icons.visibility_rounded,
                  color: Colors.grey.shade400,
                  size: 20,
                ),
                onPressed: onToggle,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSubmitButton() {
    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        if(_confirmPassword.text.isNotEmpty && (_newPassword.text == _confirmPassword.text)){
          _callChangePassword();
        }else{
          SharedWidgets.showTopSnackBar(context, message: "Try Again");
        }

      },
      child: Container(
        width: double.infinity,
        height: 58,
        decoration: BoxDecoration(
          color: textBlack,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: textBlack.withOpacity(0.2),
              blurRadius: 12,
              offset: const Offset(0, 6),
            )
          ],
        ),
        child: Center(
          child: Text(
            "RESET PASSWORD",
            style: GoogleFonts.plusJakartaSans(
              color: Colors.white,
              fontWeight: FontWeight.w800,
              fontSize: 15,
              letterSpacing: 1.2,
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _callChangePassword() async {
    MyApplication.checkInternet().then((internet) async {
        if(internet){
          try{
            ResponseChangePassword? response = await ApiCalls.callChangePassword(RequestChangePassword(
                userId: AppPrefs.userId,
                password: _confirmPassword.text
            ));
            if(response != null){
              if(response.result!.isNotEmpty && response.result != null &&
              response.result!.toLowerCase().contains("pass")){
                SharedWidgets.showTopSnackBar(context, message: response.message!);
                Get.back();
              }
            }
          }on Exception catch(e){
              log("$e");
          }catch(e){
            log("$e");
          }
        }else{
          SharedWidgets.showTopSnackBar(context, message: "No Internet Available");
        }
    },);
  }

}