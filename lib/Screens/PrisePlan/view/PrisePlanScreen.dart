import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:gotilo_new/CustomeWidgets/SharedWidgets.dart';
import '../../../Api/Response/CompanyLogo/ResponseCompanyLogo.dart';
import '../../../CustomeWidgets/AppColors.dart';
import '../../../Routes/app_routes.dart';


class PrisePlanScreen extends StatefulWidget {
  const PrisePlanScreen({super.key});

  @override
  State<PrisePlanScreen> createState() => _PrisePlanScreenState();
}

class _PrisePlanScreenState extends State<PrisePlanScreen> {
  bool? isSearch=false;
  CompanyLogo? logo;

  @override
  void initState() {

    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: SharedWidgets.customAppBar(
          centerImagePath: logo?.siteLogo,
          searchVisible: true,
          showSearch: isSearch!,
          onSearchTap: () {
            isSearch = true;
            setState(() {

            });
          },
          onSearchChanged: (value) {
            print("search value is :- $value");
          },
          onCloseSearch: () {
            isSearch = false;
            setState(() {

            });
          },
          showSignInIcon: true,
          showJoinUsIcon: false,
          onSignInTap: () {
            Get.toNamed(AppRoutes.login);
          },
          onJoinUsTap: () {
            Get.toNamed(AppRoutes.joinUs);
          },
          gradient: const LinearGradient(colors: [
            AppColors.gradientStart,AppColors.gradientEnd
            // AppColors.gradientStart,AppColors.gradientMid,AppColors.gradientEnd
              ])
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),
            // Header Section
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "We Have Excellent ",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                SharedWidgets.gradientText(text: "Packages For You")
              ],
            ),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 8.0),
              child: Text(
                "Get the Best Deals with Our Outstanding Packages!",
                style: TextStyle(color: Colors.grey),
              ),
            ),
            const SizedBox(height: 30),

            // Pricing Cards List
            SizedBox(
              height: 650, // Card ni height set kari che
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 15),
                children: const [
                  PriceCard(
                    title: "Gotilo introductory",
                    price: "15000.00",
                    cityCount: "1",
                    headerColor: Colors.pink,
                  ),
                  PriceCard(
                    title: "City Explorer Package Features",
                    price: "25000.00",
                    cityCount: "5",
                    headerColor: Colors.blueAccent,
                  ),
                  PriceCard(
                    title: "City Pro Package Features",
                    price: "40000.00",
                    cityCount: "10",
                    headerColor: Colors.pink,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }



}

class PriceCard extends StatelessWidget {
  final String title;
  final String price;
  final String cityCount;
  final Color headerColor;

  const PriceCard({
    super.key,
    required this.title,
    required this.price,
    required this.cityCount,
    required this.headerColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 320,
      margin: const EdgeInsets.only(right: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            spreadRadius: 2,
          )
        ],
      ),
      child: Column(
        children: [
          const SizedBox(height: 20),
          // Package Title Tag
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: headerColor,
              borderRadius: BorderRadius.circular(5),
            ),
            child: Text(
              title,
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12),
            ),
          ),
          const SizedBox(height: 15),
          // Price
          Text(
            "₹ $price + GST",
            style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
          ),
          const Divider(height: 40, indent: 20, endIndent: 20),
          // Features List
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: ListView(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  featureItem("Listing in up to $cityCount city"),
                  featureItem("Search Visibility"),
                  featureItem("Online Catalogue"),
                  featureItem("Smart Lead System"),
                  featureItem("Create Deals"),
                  featureItem("Autopilot System"),
                  featureItem("Customer Retention"),
                  featureItem("Premium Customer Support"),
                  featureItem("Call and WhatsApp Integration"),
                  featureItem("Whatsapp Messages"),
                  featureItem("Text Messages"),
                  featureItem("Email Notification"),
                  featureItem("Level 1"),
                ],
              ),
            ),
          ),
          // Choose Plan Button
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF0D1B2A),
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Choose Plan ", style: TextStyle(color: Colors.white)),
                  Icon(Icons.arrow_circle_right_outlined, color: Colors.white, size: 18),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget featureItem(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          const Icon(Icons.check_circle_outline, color: Colors.green, size: 18),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(color: Colors.black87, fontSize: 13),
            ),
          ),
        ],
      ),
    );
  }
}