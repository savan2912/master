import 'package:flutter/material.dart';

class BottomAboutBanner extends StatelessWidget {
  const BottomAboutBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Stack(
        children: [
          Container(
            height: 200,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              image: const DecorationImage(
                image: AssetImage("assets/banner.png"),
                fit: BoxFit.cover,
              ),
            ),
          ),

          Container(
            height: 200,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: Colors.black.withOpacity(0.4),
            ),
          ),

          /// TEXT
          const Positioned(
            left: 20,
            top: 30,
            right: 20,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Grow Your Business with Gotilo",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  "Join thousands of businesses and reach more customers.",
                  style: TextStyle(color: Colors.white70, fontSize: 14),
                ),
              ],
            ),
          ),

          /// BUTTON
          Positioned(
            bottom: 20,
            left: 20,
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(backgroundColor: Colors.pink),
              child: const Text("Get Started"),
            ),
          ),
        ],
      ),
    );
  }
}
