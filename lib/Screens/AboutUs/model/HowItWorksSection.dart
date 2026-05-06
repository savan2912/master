import 'package:flutter/material.dart';

import 'WorkCard.dart';

class HowItWorksSection extends StatelessWidget {
  const HowItWorksSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      padding: const EdgeInsets.all(20),
      width: double.infinity,
      color: Colors.grey.shade100,
      child: const Column(
        children: [
          Text(
            "How It Works",
            style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
          ),

          Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              "Simplifying your service search with Gotilo – fast, easy, and local.",
              style: TextStyle(color: Colors.black54),
            ),
          ),

          Padding(
            padding: EdgeInsets.all(8.0),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  SizedBox(width: 10),

                  WorkCard(
                    number: "01",
                    icon: Icons.location_on_outlined,
                    title: "Choose Location",
                    desc: "Enter your mobile number to get started.",
                  ),

                  SizedBox(width: 20),

                  WorkCard(
                    number: "02",
                    icon: Icons.search,
                    title: "Pick Category",
                    desc: "Explore and select the most relevant category.",
                  ),

                  SizedBox(width: 20),

                  WorkCard(
                    number: "03",
                    icon: Icons.touch_app,
                    title: "Explore Place",
                    desc: "Discover locations tailored to your needs.",
                  ),

                  SizedBox(width: 10),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
