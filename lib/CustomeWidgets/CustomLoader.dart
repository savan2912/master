import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomLoader extends StatefulWidget {
  final String message;
  const CustomLoader({super.key, this.message = "Loading..."});

  @override
  State<CustomLoader> createState() => _CustomLoaderState();
}

class _CustomLoaderState extends State<CustomLoader> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const Color premiumGold = Color(0xFF1E293B);
    const Color textBlack = Color(0xFF111827);

    return Container(
      color: Colors.white,
      width: double.infinity,
      height: double.infinity,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                RotationTransition(
                  turns: _controller,
                  child: Container(
                    height: 70,
                    width: 70,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: premiumGold.withOpacity(0.2),
                        width: 2,
                      ),
                    ),
                    child: Align(
                      alignment: Alignment.topCenter,
                      child: Container(
                        height: 8,
                        width: 8,
                        decoration: const BoxDecoration(
                          color: premiumGold,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                  ),
                ),
                Container(
                  height: 45,
                  width: 45,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      image: AssetImage('assets/app_icon.png'),
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Text(
              widget.message,
              style: GoogleFonts.plusJakartaSans(
                color: textBlack.withOpacity(0.7),
                fontWeight: FontWeight.w700,
                fontSize: 14,
                letterSpacing: 1.2,
                decoration: TextDecoration.none,
              ),
            ),
          ],
        ),
      ),
    );
  }
}