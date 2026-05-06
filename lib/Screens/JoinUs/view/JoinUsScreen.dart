import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gotilo_new/Api/ApiCalls.dart';
import 'package:gotilo_new/Api/Request/Register/RequestRegister.dart';
import 'package:gotilo_new/Api/Response/Register/ResponseRegister.dart';
import 'package:gotilo_new/CustomeWidgets/SharedWidgets.dart';
import 'package:gotilo_new/MyApplication/MyApplication.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  static const Color appBg = Color(0xFFF0F4F7);
  static const Color textDark = Color(0xFF0D1B1E);
  static const Color primaryCyan = Color(0xFF00ACC1);
  static const Color accentCyan = Color(0xFF26C6DA);
  static const Color softPink = Color(0xFFFF4081);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final String _selectedRole = 'User';
  bool _obscureText1 = true;
  bool _obscureText2 = true;
  bool _agreedToTerms = false;
  bool _isLoading = false; // <--- Loader state added

  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _mobileController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: RegisterScreen.appBg,
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
                    const SizedBox(height: 10),
                    _buildLogoSection(),
                    const SizedBox(height: 30),
                    _buildRegisterCard(),
                    const SizedBox(height: 30),
                    _buildFooter(),
                    const SizedBox(height: 10),
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
          color: RegisterScreen.primaryCyan,
        ),
        const SizedBox(height: 10),
        Text(
          "Gotilo",
          style: GoogleFonts.playfairDisplay(
            fontSize: 32,
            fontWeight: FontWeight.w900,
            color: RegisterScreen.textDark,
            letterSpacing: -1,
          ),
        ),
        Text(
          "Simplified Discovery",
          style: GoogleFonts.montserrat(
            fontSize: 10,
            color: RegisterScreen.textDark.withOpacity(0.6),
            letterSpacing: 2,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildRegisterCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(35),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: Colors.grey.withOpacity(0.05)),
        boxShadow: [
          BoxShadow(
            color: RegisterScreen.textDark.withOpacity(0.04),
            blurRadius: 30,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildWelcomeHeader(),
          const SizedBox(height: 35),
          _buildInputFields(),
          const SizedBox(height: 25),
          _buildTermsAndCondition(),
          const SizedBox(height: 35),
          _buildSignUpButton(),
          const SizedBox(height: 25),
          _buildOrDivider(),
          const SizedBox(height: 25),
          _buildLoginLink(),
        ],
      ),
    );
  }

  Widget _buildWelcomeHeader() {
    return Column(
      children: [
        Text(
          "Get Started With Gotilo",
          style: GoogleFonts.playfairDisplay(
            fontSize: 26,
            fontWeight: FontWeight.bold,
            color: RegisterScreen.textDark,
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

  Widget _buildInputFields() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(4.0),
          child: _customTextField(
            hintText: "Enter First Name",
            controller: _firstNameController,
            icon: Icons.person_outline_rounded,
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(4.0),
          child: _customTextField(
            hintText: "Enter Last Name",
            controller: _lastNameController,
            icon: Icons.person_outline_rounded,
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(4.0),
          child: _customTextField(
            hintText: "Email",
            controller: _emailController,
            icon: Icons.email,
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(4.0),
          child: _customTextField(
            hintText: "Enter Your Mobile Number",
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
        ),
        Padding(
          padding: const EdgeInsets.all(4.0),
          child: _customTextField(
            hintText: "Enter Password",
            controller: _passwordController,
            isPassword: true,
            obscureText: _obscureText1,
            icon: Icons.lock_outline_rounded,
            suffixIcon: IconButton(
              icon: Icon(
                _obscureText1
                    ? Icons.visibility_off_outlined
                    : Icons.visibility_outlined,
                color: Colors.grey[500],
                size: 20,
              ),
              onPressed: () => setState(() => _obscureText1 = !_obscureText1),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(4.0),
          child: _customTextField(
            hintText: "Confirm Password",
            controller: _confirmPasswordController,
            isPassword: true,
            obscureText: _obscureText2,
            icon: Icons.lock_outline_rounded,
            suffixIcon: IconButton(
              icon: Icon(
                _obscureText2
                    ? Icons.visibility_off_outlined
                    : Icons.visibility_outlined,
                color: Colors.grey[500],
                size: 20,
              ),
              onPressed: () => setState(() => _obscureText2 = !_obscureText2),
            ),
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
    IconData? icon,
    Widget? prefixIcon,
    Widget? suffixIcon,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: RegisterScreen.appBg.withOpacity(0.3),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.grey.withOpacity(0.1)),
      ),
      child: TextField(
        controller: controller,
        obscureText: isPassword && obscureText,
        keyboardType: keyboardType,
        style: GoogleFonts.montserrat(
          color: RegisterScreen.textDark,
          fontSize: 13,
        ),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: GoogleFonts.montserrat(
            color: Colors.grey[400],
            fontSize: 12,
          ),
          prefixIcon:
              prefixIcon ??
              (icon != null
                  ? Icon(icon, color: Colors.grey[400], size: 20)
                  : null),
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

  Widget _buildTermsAndCondition() {
    return Row(
      children: [
        SizedBox(
          height: 24,
          width: 24,
          child: Checkbox(
            value: _agreedToTerms,
            activeColor: RegisterScreen.primaryCyan,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5),
            ),
            side: BorderSide(color: Colors.grey.withOpacity(0.5)),
            onChanged: (val) => setState(() => _agreedToTerms = val!),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: RichText(
            text: TextSpan(
              style: GoogleFonts.montserrat(
                fontSize: 11,
                color: Colors.grey[600],
              ),
              children: [
                const TextSpan(text: "I agree to "),
                TextSpan(
                  text: "Terms of use",
                  recognizer: TapGestureRecognizer()..onTap = () {},
                  style: GoogleFonts.montserrat(
                    fontWeight: FontWeight.w600,
                    color: RegisterScreen.softPink,
                  ),
                ),
                const TextSpan(text: " & "),
                TextSpan(
                  text: "Privacy policy",
                  recognizer: TapGestureRecognizer()..onTap = () {},
                  style: GoogleFonts.montserrat(
                    fontWeight: FontWeight.w600,
                    color: RegisterScreen.softPink,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSignUpButton() {
    return Container(
      width: double.infinity,
      height: 55,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        gradient: const LinearGradient(
          colors: [RegisterScreen.primaryCyan, RegisterScreen.accentCyan],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        boxShadow: [
          BoxShadow(
            color: RegisterScreen.primaryCyan.withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: _isLoading
            ? null
            : () {
                if (_firstNameController.text.isNotEmpty &&
                    _lastNameController.text.isNotEmpty &&
                    _emailController.text.isNotEmpty &&
                    _mobileController.text.isNotEmpty &&
                    _passwordController.text.isNotEmpty &&
                    _confirmPasswordController.text.isNotEmpty) {
                  if (!_agreedToTerms) {
                    SharedWidgets.showTopSnackBar(
                      context,
                      message: "Please agree to Terms & Conditions",
                    );
                    return;
                  }
                  _callRegisters();
                } else {
                  // Validation checks
                  if (_firstNameController.text.isEmpty) {
                    SharedWidgets.showTopSnackBar(
                      context,
                      message: "Enter First Name",
                    );
                  } else if (_lastNameController.text.isEmpty)
                    SharedWidgets.showTopSnackBar(
                      context,
                      message: "Enter Last Name",
                    );
                  else if (_emailController.text.isEmpty)
                    SharedWidgets.showTopSnackBar(
                      context,
                      message: "Enter Email",
                    );
                  else if (_mobileController.text.isEmpty)
                    SharedWidgets.showTopSnackBar(
                      context,
                      message: "Enter Mobile Number",
                    );
                  else if (_passwordController.text.isEmpty)
                    SharedWidgets.showTopSnackBar(
                      context,
                      message: "Enter Password",
                    );
                  else if (_confirmPasswordController.text.isEmpty)
                    SharedWidgets.showTopSnackBar(
                      context,
                      message: "Enter Confirm Password",
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
                "Sign Up",
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
            "Or sign up with",
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

  Widget _buildLoginLink() {
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
        style: GoogleFonts.montserrat(fontSize: 12, color: Colors.grey[700]),
        children: [
          const TextSpan(text: "Already have an account? "),
          TextSpan(
            text: "Sign In",
            recognizer: TapGestureRecognizer()
              ..onTap = () {
                Navigator.pop(context);
              },
            style: GoogleFonts.montserrat(
              fontWeight: FontWeight.bold,
              color: RegisterScreen.primaryCyan,
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

  // --- Registration Logic ---
  Future<void> _callRegisters() async {
    bool internet = await MyApplication.checkInternet();

    if (internet) {
      setState(() => _isLoading = true);

      try {
        ResponseRegister? response = await ApiCalls.callRegister(
          RequestRegister(
            role: "user",
            phone: _mobileController.text,
            password: _passwordController.text,
            email: _emailController.text,
            firstName: _firstNameController.text,
            lastName: _lastNameController.text,
            confirmPassword: _confirmPasswordController.text,
            terms: _agreedToTerms ? 1 : 0,
          ),
        );

        if (response != null) {
          if (response.result != null &&
              response.result!.toLowerCase().contains("pass")) {
            // Success: Clear fields
            _passwordController.clear();
            _mobileController.clear();
            _confirmPasswordController.clear();
            _emailController.clear();
            _firstNameController.clear();
            _lastNameController.clear();

            if (context.mounted) {
              SharedWidgets.showTopSnackBar(
                context,
                message: response.message!,
              );
            }
          } else {
            if (context.mounted) {
              SharedWidgets.showTopSnackBar(
                context,
                message: response.message ?? "Registration failed",
              );
            }
          }
        }
      } catch (e) {
        log("Register Error: $e");
      } finally {
        if (mounted) {
          setState(() => _isLoading = false);
        }
      }
    } else {
      SharedWidgets.showTopSnackBar(context, message: "No Internet Available");
    }
  }
}
