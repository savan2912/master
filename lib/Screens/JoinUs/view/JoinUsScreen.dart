import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:google_fonts/google_fonts.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  // લક્ઝરી થીમ કલર્સ (બ્રાન્ડ મુજબ)
  static const Color appBg = Color(0xFFF0F4F7);
  static const Color textDark = Color(0xFF0D1B1E);
  static const Color primaryCyan = Color(0xFF00ACC1); // મેઈન Cyan
  static const Color accentCyan = Color(0xFF26C6DA);  // હાઈલાઈટ Cyan
  static const Color softPink = Color(0xFFFF4081);   // હળવો પિંક (Accents)

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  // સ્ટેટ મેનેજમેન્ટ
  String _selectedRole = 'User';
  bool _obscureText1 = true;
  bool _obscureText2 = true;
  bool _agreedToTerms = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: RegisterScreen.appBg,
      // કીબોર્ડ ઓપન થાય ત્યારે UI આપમેળે ઉપર જાય એ માટે
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Container(
                // નાની સ્ક્રીનમાં ઓવરફ્લો અટકાવવા
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 30),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center, // બધું સેન્ટરમાં રહેશે
                  children: [
                    const SizedBox(height: 10),
                    // ૧. બ્રાન્ડ લોગો સેક્શન
                    _buildLogoSection(),

                    const SizedBox(height: 30),

                    // ૨. મેઈન રજીસ્ટ્રેશન કાર્ડ (The Professional Box)
                    _buildRegisterCard(),

                    const SizedBox(height: 30),

                    // ૩. કોપીરાઈટ ફૂટર
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

  // --- ૧. લોગો સેક્શન ---
  Widget _buildLogoSection() {
    return Column(
      children: [
        Icon(Icons.layers_rounded, size: 40, color: RegisterScreen.primaryCyan),
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

  // --- ૨. મેઈન રજીસ્ટ્રેશન કાર્ડ ---
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
          _buildRoleSelector(),
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

  Widget _buildRoleSelector() {
    return Column(
      children: [
        Text(
          "Pick Your Sign Up Type",
          style: GoogleFonts.montserrat(
            fontSize: 13,
            fontWeight: FontWeight.bold,
            color: RegisterScreen.textDark,
          ),
        ),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(child: _roleButton('User', Icons.person_rounded)),
            const SizedBox(width: 10), // બટન્સ વચ્ચે થોડી જગ્યા
            Expanded(child: _roleButton('Vendor', Icons.store_rounded)),
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
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
        decoration: BoxDecoration(
          color: isSelected ? RegisterScreen.primaryCyan : RegisterScreen.appBg.withOpacity(0.3),
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
            color: isSelected ? RegisterScreen.primaryCyan : Colors.grey.withOpacity(0.2),
            width: 1.5,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 16, color: isSelected ? Colors.white : Colors.grey[600]),
            const SizedBox(width: 6),
            Flexible(
              child: Text(
                role,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.montserrat(
                  fontSize: 11,
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
        // ફર્સ્ટ નેમ અને લાસ્ટ નેમ (Row માં)
        Row(
          children: [
            Expanded(child: _customTextField(hintText: "Enter First Name", icon: Icons.person_outline_rounded)),
            const SizedBox(width: 15),
            Expanded(child: _customTextField(hintText: "Enter Last Name", icon: Icons.person_outline_rounded)),
          ],
        ),
        const SizedBox(height: 15),

        // ફોન નંબર ફિલ્ડ
        _customTextField(
          hintText: "Enter Your Mobile Number",
          prefixIcon: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(width: 15),
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
          obscureText: _obscureText1,
          icon: Icons.lock_outline_rounded,
          suffixIcon: IconButton(
            icon: Icon(
              _obscureText1 ? Icons.visibility_off_outlined : Icons.visibility_outlined,
              color: Colors.grey[500],
              size: 20,
            ),
            onPressed: () => setState(() => _obscureText1 = !_obscureText1),
          ),
        ),
        const SizedBox(height: 10),

        // પાસવર્ડ સ્ટ્રેન્થ ઇન્ડિકેટર (ઈમેજ મુજબ)
        _buildPasswordStrengthBar(),
        const SizedBox(height: 15),

        // કન્ફર્મ પાસવર્ડ ફિલ્ડ
        _customTextField(
          hintText: "Confirm Password",
          isPassword: true,
          obscureText: _obscureText2,
          icon: Icons.lock_outline_rounded,
          suffixIcon: IconButton(
            icon: Icon(
              _obscureText2 ? Icons.visibility_off_outlined : Icons.visibility_outlined,
              color: Colors.grey[500],
              size: 20,
            ),
            onPressed: () => setState(() => _obscureText2 = !_obscureText2),
          ),
        ),
      ],
    );
  }

  Widget _customTextField({
    required String hintText,
    bool isPassword = false,
    bool obscureText = false,
    IconData? icon,
    Widget? prefixIcon,
    Widget? suffixIcon,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: RegisterScreen.appBg.withOpacity(0.3),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.grey.withOpacity(0.1)),
      ),
      child: TextField(
        obscureText: isPassword && obscureText,
        style: GoogleFonts.montserrat(color: RegisterScreen.textDark, fontSize: 13),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: GoogleFonts.montserrat(color: Colors.grey[400], fontSize: 12),
          prefixIcon: prefixIcon ?? (icon != null ? Icon(icon, color: Colors.grey[400], size: 20) : null),
          suffixIcon: suffixIcon,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 18, horizontal: 15),
        ),
      ),
    );
  }

  // ઈમેજ ૧ મુજબની પાસવર્ડ સ્ટ્રેન્થ બાર (Fixed!)
  Widget _buildPasswordStrengthBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(child: _strengthIndicatorBar(Colors.green)), // મજબૂત (ઈમેજ મુજબ ગ્રીન)
          const SizedBox(width: 4),
          Expanded(child: _strengthIndicatorBar(Colors.grey[300]!)),
          const SizedBox(width: 4),
          Expanded(child: _strengthIndicatorBar(Colors.grey[300]!)),
          const SizedBox(width: 4),
          Expanded(child: _strengthIndicatorBar(Colors.grey[300]!)),
        ],
      ),
    );
  }

  Widget _strengthIndicatorBar(Color color) {
    return Container(
      height: 3,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(5),
      ),
    );
  }

  Widget _buildTermsAndCondition() {
    return Row(
      children: [
        SizedBox(
          height: 24, width: 24,
          child: Checkbox(
            value: _agreedToTerms,
            activeColor: RegisterScreen.primaryCyan,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
            side: BorderSide(color: Colors.grey.withOpacity(0.5)),
            onChanged: (val) => setState(() => _agreedToTerms = val!),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: RichText(
            text: TextSpan(
              style: GoogleFonts.montserrat(fontSize: 11, color: Colors.grey[600]),
              children: [
                const TextSpan(text: "I agree to "),
                TextSpan(
                  text: "Terms of use",
                  recognizer: TapGestureRecognizer()..onTap = () {}, // Terms Click
                  style: GoogleFonts.montserrat(
                    fontWeight: FontWeight.w600,
                    color: RegisterScreen.softPink, // પિંક કલર જે ઈમેજ ૨ માં હતો
                  ),
                ),
                const TextSpan(text: " & "),
                TextSpan(
                  text: "Privacy policy",
                  recognizer: TapGestureRecognizer()..onTap = () {}, // Privacy Click
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
        onPressed: () {},
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        ),
        child: Text(
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
            style: GoogleFonts.montserrat(fontSize: 10, color: Colors.grey[500], fontWeight: FontWeight.w600),
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
                Navigator.pop(context); // લોગિન સ્ક્રીન પર પાછા જવા
              },
            style: GoogleFonts.montserrat(
              fontWeight: FontWeight.bold,
              color: RegisterScreen.primaryCyan, // Cyan Link
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