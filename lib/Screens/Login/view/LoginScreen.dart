import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gotilo_new/Screens/JoinUs/view/JoinUsScreen.dart';

class ModernLoginScreen extends StatefulWidget {
  const ModernLoginScreen({super.key});

  // લક્ઝરી થીમ કલર્સ (તમારા એપ મુજબ)
  static const Color appBg = Color(0xFFF0F4F7);
  static const Color textDark = Color(0xFF0D1B1E);
  static const Color primaryCyan = Color(0xFF00ACC1); // મેઈન Cyan
  static const Color accentCyan = Color(0xFF26C6DA);  // હાઈલાઈટ Cyan
  static const Color softPink = Color(0xFFFF4081);   // હળવો પિંક (optional accents માટે)

  @override
  State<ModernLoginScreen> createState() => _ModernLoginScreenState();
}

class _ModernLoginScreenState extends State<ModernLoginScreen> {
  // રોલ સિલેક્શન માટે સ્ટેટ
  String _selectedRole = 'User';
  bool _rememberMe = false;
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ModernLoginScreen.appBg,
      // કીબોર્ડ આવે ત્યારે વિજેટ્સ આપમેળે એડજસ્ટ થાય એના માટે
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Container(
                // અહીં લઘુત્તમ ઊંચાઈ સેટ કરી જેથી સ્ક્રીન નાની હોય તો પણ ઓવરફ્લો ના થાય
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 30),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center, // બધું સેન્ટરમાં રહેશે
                  children: [
                    const SizedBox(height: 20),

                    // ૧. બ્રાન્ડ લોગો સેક્શન
                    _buildLogoSection(),

                    const SizedBox(height: 30),

                    // ૨. મેઈન લોગિન કાર્ડ
                    _buildLoginCard(),

                    const SizedBox(height: 40),

                    // ૩. કોપીરાઈટ ફૂટર
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

  // --- ૧. લોગો સેક્શન ---
  Widget _buildLogoSection() {
    return Column(
      children: [
        // તમે અહીં તમારો ઈમેજ લોગો પણ મૂકી શકો
        Icon(Icons.layers_rounded, size: 40, color: ModernLoginScreen.primaryCyan),
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

  // --- ૨. મેઈન લોગિન કાર્ડ ---
  Widget _buildLoginCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(35),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: Colors.grey.withOpacity(0.05)),
        boxShadow: [
          // હળવો પ્રોફેશનલ શેડો
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
          _buildSignInButton(),
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
      children: [
        Text(
          "Select Your Role",
          style: GoogleFonts.montserrat(
            fontSize: 13,
            fontWeight: FontWeight.bold,
            color: ModernLoginScreen.textDark,
          ),
        ),
        const SizedBox(height: 20),
        // Row ને બદલે Expanded નો ઉપયોગ કર્યો જેથી ઓવરફ્લો ના થાય
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(child: _roleButton('User', Icons.person_rounded)),
            const SizedBox(width: 8), // બટન્સ વચ્ચે થોડી જગ્યા
            Expanded(child: _roleButton('Vendor', Icons.store_rounded)),
            const SizedBox(width: 8),
            Expanded(child: _roleButton('Cashier', Icons.point_of_sale_rounded)),
          ],
        ),
      ],
    );
  }

  Widget _roleButton(String role, IconData icon) {
    final isSelected = _selectedRole == role;
    return GestureDetector(
      onTap: () => setState(() => _selectedRole = role),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        // પેડિંગ થોડું ઓછું કર્યું જેથી નાની સ્ક્રીનમાં પ્રોબ્લેમ ના થાય
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
        decoration: BoxDecoration(
          color: isSelected ? ModernLoginScreen.primaryCyan : ModernLoginScreen.appBg.withOpacity(0.3),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? ModernLoginScreen.primaryCyan : Colors.grey.withOpacity(0.2),
            width: 1.5,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center, // આઈકોન અને ટેક્સ્ટ સેન્ટરમાં રહે
          children: [
            Icon(icon, size: 14, color: isSelected ? Colors.white : Colors.grey[600]),
            const SizedBox(width: 4),
            Flexible( // ટેક્સ્ટ બહુ લાંબી હોય તો ઓવરફ્લો ના થાય એના માટે
              child: Text(
                role,
                overflow: TextOverflow.ellipsis, // જો નામ મોટું હોય તો '...' થઈ જશે
                style: GoogleFonts.montserrat(
                  fontSize: 11, // ફોન્ટ સાઈઝ થોડી ઘટાડી
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                  color: isSelected ? Colors.white : Colors.grey[700],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInputFields() {
    return Column(
      children: [
        // ફોન નંબર ફિલ્ડ
        _customTextField(
          hintText: "7990465270",
          prefixIcon: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(width: 15),
              // ઈન્ડિયા ફ્લેગનો આઈકોન (તમે ઈમેજ એસેટ પણ વાપરી શકો)
              Text("🇮🇳", style: const TextStyle(fontSize: 18)),
              const SizedBox(width: 10),
              Container(height: 20, width: 1, color: Colors.grey.withOpacity(0.3)),
              const SizedBox(width: 10),
            ],
          ),
        ),
        const SizedBox(height: 15),
        // પાસવર્ડ ફિલ્ડ
        _customTextField(
          hintText: "Enter Password",
          isPassword: true,
          obscureText: _obscureText,
          prefixIcon: Icon(Icons.lock_outline_rounded, color: Colors.grey[400], size: 20),
          suffixIcon: IconButton(
            icon: Icon(
              _obscureText ? Icons.visibility_off_outlined : Icons.visibility_outlined,
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
    bool isPassword = false,
    bool obscureText = false,
    Widget? prefixIcon,
    Widget? suffixIcon,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: ModernLoginScreen.appBg.withOpacity(0.3),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.grey.withOpacity(0.1)),
      ),
      child: TextField(
        obscureText: isPassword && obscureText,
        style: GoogleFonts.montserrat(color: ModernLoginScreen.textDark, fontSize: 14),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: GoogleFonts.montserrat(color: Colors.grey[400], fontSize: 13),
          prefixIcon: prefixIcon,
          suffixIcon: suffixIcon,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 18, horizontal: 15),
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
              height: 24, width: 24,
              child: Checkbox(
                value: _rememberMe,
                activeColor: ModernLoginScreen.primaryCyan,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                side: BorderSide(color: Colors.grey.withOpacity(0.5)),
                onChanged: (val) => setState(() => _rememberMe = val!),
              ),
            ),
            const SizedBox(width: 8),
            Text(
              "Remember Me",
              style: GoogleFonts.montserrat(fontSize: 11, color: Colors.grey[600]),
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
              color: ModernLoginScreen.primaryCyan, // Cyan accent
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
        onPressed: () {},
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        ),
        child: Text(
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
            style: GoogleFonts.montserrat(fontSize: 10, color: Colors.grey[500], fontWeight: FontWeight.w600),
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
               Get.to(()=> const RegisterScreen());
                print("Join Us Clicked!");
              },
            style: GoogleFonts.montserrat(
              fontWeight: FontWeight.bold,
              color: ModernLoginScreen.primaryCyan,
              decoration: TextDecoration.underline, // ક્લિકેબલ લાગે એ માટે અંડરલાઈન (Optional)
            ),
          ),
        ],
      ),
    );
  }

  // --- ૩. ફૂટર સેક્શન ---
  Widget _buildFooter() {
    return Text(
      "Copyright © 2026 Gotilo - All rights reserved.",
      style: GoogleFonts.montserrat(fontSize: 10, color: Colors.grey[500]),
    );
  }
}