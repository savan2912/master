import 'dart:developer';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gotilo_new/Api/ApiCalls.dart';
import 'package:gotilo_new/Api/Request/Login/RequestLogin.dart';
import 'package:gotilo_new/Api/Response/Login/ResponseLogin.dart';
import 'package:gotilo_new/Constant/AppPref.dart';
import 'package:gotilo_new/CustomeWidgets/SharedWidgets.dart';
import 'package:gotilo_new/MyApplication/MyApplication.dart';
import 'package:gotilo_new/Notifications/PushNotificationService.dart';
import 'package:gotilo_new/Screens/JoinUs/view/JoinUsScreen.dart';
import 'package:gotilo_new/Screens/User/Dashboard/UserDashboardScreen.dart';

class ModernLoginScreen extends StatefulWidget {
  const ModernLoginScreen({super.key});
  static const Color appBg = Color(0xFFF0F4F7);
  static const Color textDark = Color(0xFF0D1B1E);
  static const Color primaryCyan = Color(0xFF00ACC1);
  static const Color accentCyan = Color(0xFF26C6DA);
  static const Color softPink = Color(0xFFFF4081);

  @override
  State<ModernLoginScreen> createState() => _ModernLoginScreenState();
}

class _ModernLoginScreenState extends State<ModernLoginScreen> {
  final String _selectedRole = 'user';
  bool _rememberMe = false;
  bool _obscureText = true;
  bool _isLoading = false;
  final TextEditingController _mobileController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _mobileController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ModernLoginScreen.appBg,
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Container(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  horizontal: 25,
                  vertical: 30,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 20),
                    _buildLogoSection(),
                    const SizedBox(height: 30),
                    _buildLoginCard(),
                    const SizedBox(height: 40),
                    _buildFooter(),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildLogoSection() {
    return Column(
      children: [
        const Icon(
          Icons.layers_rounded,
          size: 40,
          color: ModernLoginScreen.primaryCyan,
        ),
        const SizedBox(height: 10),
        Text(
          "Gotilo",
          style: GoogleFonts.playfairDisplay(
            fontSize: 32,
            fontWeight: FontWeight.w900,
            color: ModernLoginScreen.textDark,
            letterSpacing: -1,
          ),
        ),
        Text(
          "Simplified Discovery",
          style: GoogleFonts.montserrat(
            fontSize: 10,
            color: ModernLoginScreen.textDark.withOpacity(0.6),
            letterSpacing: 2,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildLoginCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(35),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: Colors.grey.withOpacity(0.05)),
        boxShadow: [
          BoxShadow(
            color: ModernLoginScreen.textDark.withOpacity(0.04),
            blurRadius: 30,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildWelcomeHeader(),
          const SizedBox(height: 35),
          _buildRoleSelector(),
          const SizedBox(height: 35),
          _buildInputFields(),
          const SizedBox(height: 25),
          _buildRememberForgotPassword(),
          const SizedBox(height: 35),
          _buildSignInButton(), // <--- Loader aya batavse
          const SizedBox(height: 25),
          _buildOrDivider(),
          const SizedBox(height: 25),
          _buildRegisterLink(),
        ],
      ),
    );
  }

  Widget _buildWelcomeHeader() {
    return Column(
      children: [
        Text(
          "Welcome",
          style: GoogleFonts.playfairDisplay(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: ModernLoginScreen.textDark,
          ),
        ),
        const SizedBox(height: 10),
        Text(
          "Enter your credentials to access your account",
          textAlign: TextAlign.center,
          style: GoogleFonts.montserrat(
            fontSize: 12,
            color: Colors.grey[600],
            height: 1.5,
          ),
        ),
      ],
    );
  }

  Widget _buildRoleSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4),
          child: Text(
            "Continue as",
            style: GoogleFonts.plusJakartaSans(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: Colors.grey[700],
            ),
          ),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.cyan.withOpacity(0.05),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: Colors.cyan.withOpacity(0.3), width: 1.2),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.person_rounded, color: Colors.cyan, size: 20),
              const SizedBox(width: 8),
              Text(
                "User",
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildInputFields() {
    return Column(
      children: [
        _customTextField(
          hintText: "9999999999",
          controller: _mobileController,
          keyboardType: TextInputType.phone,
          prefixIcon: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(width: 15),
              const Text("🇮🇳", style: TextStyle(fontSize: 18)),
              const SizedBox(width: 10),
              Container(
                height: 20,
                width: 1,
                color: Colors.grey.withOpacity(0.3),
              ),
              const SizedBox(width: 10),
            ],
          ),
        ),
        const SizedBox(height: 15),
        _customTextField(
          hintText: "Enter Password",
          controller: _passwordController,
          isPassword: true,
          obscureText: _obscureText,
          prefixIcon: Icon(
            Icons.lock_outline_rounded,
            color: Colors.grey[400],
            size: 20,
          ),
          suffixIcon: IconButton(
            icon: Icon(
              _obscureText
                  ? Icons.visibility_off_outlined
                  : Icons.visibility_outlined,
              color: Colors.grey[500],
              size: 20,
            ),
            onPressed: () => setState(() => _obscureText = !_obscureText),
          ),
        ),
      ],
    );
  }

  Widget _customTextField({
    required String hintText,
    required TextEditingController controller,
    bool isPassword = false,
    bool obscureText = false,
    Widget? prefixIcon,
    Widget? suffixIcon,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: ModernLoginScreen.appBg.withOpacity(0.3),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.grey.withOpacity(0.1)),
      ),
      child: TextField(
        controller: controller,
        obscureText: isPassword && obscureText,
        keyboardType: keyboardType,
        style: GoogleFonts.montserrat(
          color: ModernLoginScreen.textDark,
          fontSize: 14,
        ),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: GoogleFonts.montserrat(
            color: Colors.grey[400],
            fontSize: 13,
          ),
          prefixIcon: prefixIcon,
          suffixIcon: suffixIcon,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            vertical: 18,
            horizontal: 15,
          ),
        ),
      ),
    );
  }

  Widget _buildRememberForgotPassword() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            SizedBox(
              height: 24,
              width: 24,
              child: Checkbox(
                value: _rememberMe,
                activeColor: ModernLoginScreen.primaryCyan,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
                side: BorderSide(color: Colors.grey.withOpacity(0.5)),
                onChanged: (val) => setState(() => _rememberMe = val!),
              ),
            ),
            const SizedBox(width: 8),
            Text(
              "Remember Me",
              style: GoogleFonts.montserrat(
                fontSize: 11,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
        TextButton(
          onPressed: () {},
          child: Text(
            "Forgot Password?",
            style: GoogleFonts.montserrat(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: ModernLoginScreen.primaryCyan,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSignInButton() {
    return Container(
      width: double.infinity,
      height: 55,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        gradient: const LinearGradient(
          colors: [ModernLoginScreen.primaryCyan, ModernLoginScreen.accentCyan],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        boxShadow: [
          BoxShadow(
            color: ModernLoginScreen.primaryCyan.withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: _isLoading
            ? null
            : () {
                // Loading hoy tyare button disable
                if (_mobileController.text.isNotEmpty &&
                    _passwordController.text.isNotEmpty) {
                  _callLogin();
                } else if (_mobileController.text.isEmpty) {
                  SharedWidgets.showTopSnackBar(
                    context,
                    message: "Please Enter Mobile Number",
                  );
                } else if (_passwordController.text.isEmpty) {
                  SharedWidgets.showTopSnackBar(
                    context,
                    message: "Please Enter Password",
                  );
                }
              },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
        ),
        child: _isLoading
            ? const SizedBox(
                height: 22,
                width: 22,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2.5,
                ),
              )
            : Text(
                "Sign In",
                style: GoogleFonts.montserrat(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  letterSpacing: 1,
                ),
              ),
      ),
    );
  }

  Widget _buildOrDivider() {
    return Row(
      children: [
        Expanded(child: Divider(color: Colors.grey.withOpacity(0.2))),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Text(
            "Or sign in with",
            style: GoogleFonts.montserrat(
              fontSize: 10,
              color: Colors.grey[500],
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        Expanded(child: Divider(color: Colors.grey.withOpacity(0.2))),
      ],
    );
  }

  Widget _buildRegisterLink() {
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
        style: GoogleFonts.montserrat(fontSize: 12, color: Colors.grey[700]),
        children: [
          const TextSpan(text: "Don't have an account? "),
          TextSpan(
            text: "Join us Today",
            recognizer: TapGestureRecognizer()
              ..onTap = () {
                Get.to(() => const RegisterScreen());
              },
            style: GoogleFonts.montserrat(
              fontWeight: FontWeight.bold,
              color: ModernLoginScreen.primaryCyan,
              decoration: TextDecoration.underline,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFooter() {
    return Text(
      "Copyright © 2026 Gotilo - All rights reserved.",
      style: GoogleFonts.montserrat(fontSize: 10, color: Colors.grey[500]),
    );
  }


  Future<void> _callLogin() async {
    var deviceTokenFuture = PushNotificationService.getSavedToken();

    bool internet = await MyApplication.checkInternet();

    if (internet) {
      setState(() {
        _isLoading = true;
      });

      try {
        String? token = await deviceTokenFuture;
        ResponseLogin? response = await ApiCalls.callLogin(
          RequestLogin(
            deviceToken: token,
            password: _passwordController.text,
            phone: _mobileController.text,
            role: "user",
          ),
        );

        if (response != null) {
          if (response.result != null &&
              response.result!.toLowerCase().contains("pass")) {
            AppPrefs.setUserId(response.data!.userId!);
            if (context.mounted) {
              SharedWidgets.showTopSnackBar(
                context,
                message: response.message!,
              );
            }

            if (response.data!.userId != null &&
                response.data!.userId!.isNotEmpty) {
              Get.offAll(
                () => const Userdashboardscreen(),
              );
            }
          } else {
            if (context.mounted) {
              SharedWidgets.showTopSnackBar(
                context,
                message: response.message ?? "Login Failed",
              );
            }
          }
        }
      } catch (e) {
        log("Login Error: $e");
      } finally {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      }
    } else {
      SharedWidgets.showTopSnackBar(context, message: "No Internet Available");
    }
  }
}
