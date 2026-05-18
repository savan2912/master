import 'dart:developer';
import 'dart:math' hide log;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart'; // url_launcher ઈમ્પોર્ટ કર્યું
import 'package:gotilo_new/Api/ApiCalls.dart';
import 'package:gotilo_new/Api/Response/PrisePlan/ResponsePrisePlan.dart';
import 'package:gotilo_new/CustomeWidgets/SharedWidgets.dart';
import 'package:gotilo_new/MyApplication/MyApplication.dart';

class PrisePlanScreen extends StatefulWidget {
  const PrisePlanScreen({super.key});

  @override
  State<PrisePlanScreen> createState() => _PrisePlanScreenState();
}

class _PrisePlanScreenState extends State<PrisePlanScreen> {
  List<PrisePlan> priseList = [];
  bool isLoading = true;
  String? number="";
  String? email="";

  @override
  void initState() {
    super.initState();
    _callPrisePlan();
  }

  Future<void> _makePhoneCall(String phoneNumber) async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );
    if (await canLaunchUrl(launchUri)) {
      await launchUrl(launchUri);
    } else {
      log('Could not launch $launchUri');
    }
  }

  Future<void> _sendEmail(String emailAddress, String planName) async {
    final Uri launchUri = Uri(
      scheme: 'mailto',
      path: emailAddress,
      queryParameters: {
        'subject': 'Inquiry for $planName Package',
        'body': 'Hello Gotilo Team,\n\nI want to become a vendor under the $planName plan. Please guide me further.',
      },
    );
    if (await canLaunchUrl(launchUri)) {
      await launchUrl(launchUri);
    } else {
      log('Could not launch $launchUri');
    }
  }

  void _showVendorContactBottomSheet(BuildContext context, String planName) {


    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
      ),
      backgroundColor: Colors.white,
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 30),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 50,
                height: 5,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              const SizedBox(height: 25),
              Text(
                "Brand Builder Digital PVT LTD",
                style: GoogleFonts.montserrat(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  color: const Color(0xFF0D1B1E),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                "Connect with Us",
                style: GoogleFonts.montserrat(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFF0D1B1E),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                "Interested in '$planName'? Choose how you want to reach us.",
                textAlign: TextAlign.center,
                style: GoogleFonts.montserrat(
                  fontSize: 13,
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 30),

              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.grey[200]!),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.phone_android_rounded, color: Colors.pinkAccent, size: 24),
                    const SizedBox(width: 15),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Call Us", style: GoogleFonts.montserrat(fontSize: 11, color: Colors.grey[500], fontWeight: FontWeight.bold)),
                          Text(number!, style: GoogleFonts.montserrat(fontSize: 15, color: const Color(0xFF0D1B1E), fontWeight: FontWeight.w600)),
                        ],
                      ),
                    ),
                    IconButton(
                      onPressed: () => _makePhoneCall(number!),
                      icon: const Icon(Icons.phone_forwarded_rounded, color: Colors.green, size: 24),
                      style: IconButton.styleFrom(backgroundColor: Colors.green.withOpacity(0.1)),
                    )
                  ],
                ),
              ),
              const SizedBox(height: 15),

              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.grey[200]!),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.email_outlined, color: Colors.pinkAccent, size: 24),
                    const SizedBox(width: 15),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Email Us", style: GoogleFonts.montserrat(fontSize: 11, color: Colors.grey[500], fontWeight: FontWeight.bold)),
                          Text(email!, style: GoogleFonts.montserrat(fontSize: 15, color: const Color(0xFF0D1B1E), fontWeight: FontWeight.w600)),
                        ],
                      ),
                    ),
                    IconButton(
                      onPressed: () => _sendEmail(email!, planName),
                      icon: const Icon(Icons.arrow_outward_rounded, color: Colors.blue, size: 24),
                      style: IconButton.styleFrom(backgroundColor: Colors.blue.withOpacity(0.1)),
                    )
                  ],
                ),
              ),
              const SizedBox(height: 15),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: isLoading
          ? const Center(child: CircularProgressIndicator(color: Colors.pinkAccent))
          : planWidget(),
    );
  }

  Widget planWidget() {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFFF8FAFB), Colors.white],
        ),
      ),
      child: RefreshIndicator(
        onRefresh: _callPrisePlan,
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              const SizedBox(height: 80),
              _buildPlanHeader(),
              const SizedBox(height: 50),

              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                physics: const BouncingScrollPhysics(),
                child: Row(
                  children: priseList.isEmpty
                      ? [const Center(child: Text("No plans available at the moment."))]
                      : priseList.asMap().entries.map((entry) {
                    int index = entry.key;
                    PrisePlan plan = entry.value;
                    List<Color> tagColors = [
                      const Color(0xFF00ACC1),
                      const Color(0xFF006064),
                      const Color(0xFFE91E63),
                      const Color(0xFF673AB7),
                    ];

                    return _buildPricingCard(
                      title: plan.planName ?? "N/A",
                      price: plan.price ?? "0.00",
                      tagColor: tagColors[index % tagColors.length],
                      isFeatured: index == 1,
                      features: plan.features?.map((f) => f.featureName ?? "").toList() ?? [],
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: 150),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPlanHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: Column(
        children: [
          RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              style: GoogleFonts.montserrat(
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                  color: const Color(0xFF0D1B1E),
                  letterSpacing: -0.5
              ),
              children: [
                const TextSpan(text: "We Have Excellent "),
                TextSpan(
                    text: "Packages For You",
                    style: TextStyle(color: Colors.pinkAccent[400])
                ),
              ],
            ),
          ),
          const SizedBox(height: 15),
          Text(
            "Get the Best Deals with Our Outstanding Packages!",
            textAlign: TextAlign.center,
            style: GoogleFonts.montserrat(
                fontSize: 13,
                color: Colors.grey[500],
                fontWeight: FontWeight.w500,
                height: 1.5
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPricingCard({
    required String title,
    required String price,
    required Color tagColor,
    required List<String> features,
    bool isFeatured = false,
  }) {
    return Container(
      width: 320,
      margin: const EdgeInsets.symmetric(horizontal: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(35),
        boxShadow: [
          BoxShadow(
            color: isFeatured ? tagColor.withOpacity(0.15) : Colors.black.withOpacity(0.04),
            blurRadius: 30,
            offset: const Offset(0, 15),
          ),
        ],
        border: isFeatured ? Border.all(color: tagColor.withOpacity(0.3), width: 1.5) : null,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(35),
        child: Stack(
          children: [
            Positioned(
              top: -50,
              right: -50,
              child: Container(
                height: 150,
                width: 150,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [tagColor.withOpacity(0.1), Colors.transparent],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(colors: [tagColor, tagColor.withOpacity(0.8)]),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      title.toUpperCase(),
                      style: GoogleFonts.montserrat(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w800, letterSpacing: 1),
                    ),
                  ),
                  const SizedBox(height: 30),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: [
                      Text("₹ ", style: GoogleFonts.montserrat(fontSize: 20, fontWeight: FontWeight.bold, color: const Color(0xFF0D1B1E))),
                      Text(price, style: GoogleFonts.montserrat(fontSize: 34, fontWeight: FontWeight.w900, color: const Color(0xFF0D1B1E))),
                      Text(" + GST", style: GoogleFonts.montserrat(fontSize: 12, color: Colors.grey[500], fontWeight: FontWeight.w600)),
                    ],
                  ),
                  const SizedBox(height: 20),
                  const Divider(thickness: 0.5),
                  const SizedBox(height: 20),
                  ...features.map((f) => Padding(
                    padding: const EdgeInsets.only(bottom: 18),
                    child: Row(
                      children: [
                        Icon(Icons.verified_rounded, color: tagColor, size: 20),
                        const SizedBox(width: 15),
                        Expanded(child: Text(f, style: GoogleFonts.montserrat(fontSize: 13, color: const Color(0xFF455A64), fontWeight: FontWeight.w500))),
                      ],
                    ),
                  )),
                  const SizedBox(height: 25),
                  Container(
                    width: double.infinity,
                    height: 55,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(18),
                      gradient: LinearGradient(
                        colors: isFeatured
                            ? [tagColor, const Color(0xFF0D1B1E)]
                            : [const Color(0xFF0D1B1E), const Color(0xFF37474F)],
                      ),
                      boxShadow: [
                        BoxShadow(color: tagColor.withOpacity(0.3), blurRadius: 12, offset: const Offset(0, 6))
                      ],
                    ),
                    child: ElevatedButton(
                      onPressed: () {
                        _showVendorContactBottomSheet(context, title,);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Become a vendor", style: GoogleFonts.montserrat(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 16)),
                          const SizedBox(width: 12),
                          const Icon(Icons.arrow_forward_rounded, color: Colors.white, size: 20),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _callPrisePlan() async {
    bool internet = await MyApplication.checkInternet();
    if (internet) {
      try {
        ResponsePrisePlan? response = await ApiCalls.callPrisePlan();
        if (response != null &&
            response.result != null &&
            response.result!.toLowerCase().contains("pass")) {
          setState(() {
            priseList = response.data ?? [];
            isLoading = false;
          });
          number = response.number;
          email = response.email;
        } else {
          setState(() => isLoading = false);
          SharedWidgets.showTopSnackBar(context, message: response?.message ?? "Failed to load plans");
        }
      } catch (e) {
        log("Error: $e");
        setState(() => isLoading = false);
      }
    } else {
      setState(() => isLoading = false);
      SharedWidgets.showTopSnackBar(context, message: "No Internet Available");
    }
  }
}