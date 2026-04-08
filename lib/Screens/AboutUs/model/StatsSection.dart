import 'package:flutter/material.dart';

class StatsSection extends StatelessWidget {
  const StatsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 22),
      child: const Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: StatItem(
              icon: Icons.people,
              number: "5000+",
              label: "Happy Customers",
            ),
          ),

          VerticalDividerLine(),

          Expanded(
            child: StatItem(
              icon: Icons.handshake,
              number: "3000+",
              label: "Verified Businesses",
            ),
          ),

          VerticalDividerLine(),

          Expanded(
            child: StatItem(
              icon: Icons.location_city,
              number: "50+",
              label: "Cities Covered",
            ),
          ),

          VerticalDividerLine(),

          Expanded(
            child: StatItem(
              icon: Icons.work,
              number: "4000+",
              label: "Positive Reviews",
            ),
          ),
        ],
      ),
    );
  }
}

class StatItem extends StatelessWidget {
  final IconData icon;
  final String number;
  final String label;

  const StatItem({
    super.key,
    required this.icon,
    required this.number,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: SizedBox(
            height: 32,
            child: Icon(
              icon,
              color: Colors.pink,
              size: 28,
            ),
          ),
        ),

        Text(
          number,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),

        Padding(
          padding: const EdgeInsets.all(8.0),
          child: SizedBox(
            height: 32,
            child: Text(
              label,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 12,
                color: Colors.black54,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class VerticalDividerLine extends StatelessWidget {
  const VerticalDividerLine({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      width: 1,
      color: Colors.pink,
    );
  }
}