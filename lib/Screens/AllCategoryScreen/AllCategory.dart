
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:gotilo_new/CustomeWidgets/SharedWidgets.dart';

import '../../CustomeWidgets/AppColors.dart';
import 'SubCategory.dart';

class AllCategoryScreen extends StatefulWidget {
  const AllCategoryScreen({super.key});

  @override
  State<AllCategoryScreen> createState() =>
      _AllCategoryScreenState();
}

class _AllCategoryScreenState
    extends State<AllCategoryScreen> {
  bool? isSearch=false;
  final List<Map<String, String>> categories =
  [
    {
      "title": "Food",
      "image":
      "assets/food.png",
    },
    {
      "title": "Auto Parts",
      "image":
      "assets/travel.png",
    },
    {
      "title": "Logistics",
      "image":
      "assets/helth.png",
    },
    {
      "title": "Cleaning",
      "image":
      "assets/education.png",
    },
    {
      "title": "Sports",
      "image":
      "assets/dry.png",
    },
    {
      "title": "Legal",
      "image":
      "assets/beauty.png",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SharedWidgets.customAppBar(
        title: "All Categories",
        iconColor: Colors.white,
          searchVisible:true,
          showSearch: isSearch!,
          onSearchTap:() {
            isSearch = true;
            setState(() {});
          },
          onCloseSearch: () {
            isSearch=false;
            setState(() {});
          },
        gradient:const LinearGradient(colors: [
          AppColors.gradientStart,AppColors.gradientEnd
        ])
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child:
        Column(
          children: List.generate(
            categories.length,
                (index) => _categoryCard(
              title: categories[index]["title"]!,
              image: categories[index]["image"]!,
            ),
          ),
        ),
      ),
    );
  }

  Widget _categoryCard({
    required String title,
    required String image,
  }) {
    return GestureDetector(
      onTap: () {
        Get.to(()=> const SubCategoryScreen());
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 14),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade300,
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              height: 60,
              width: 60,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.grey.shade100,
              ),
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: ClipOval(
                  child: Image.asset(
                    image,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),

            const SizedBox(width: 16),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),

                  const SizedBox(height: 4),

                  Text(
                    "Explore $title services",
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ),

            Container(
              height: 40,
              width: 40,
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.arrow_forward_ios,
                size: 18,
              ),
            ),
          ],
        ),
      ),
    );
  }
}