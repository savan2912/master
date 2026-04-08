import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:gotilo_new/CustomeWidgets/SharedWidgets.dart';

import '../../CustomeWidgets/AppColors.dart';
import '../../CustomeWidgets/FilterBottomSheetContent.dart';
import 'SubCategoryDetail.dart';

class SubCategoryListing extends StatefulWidget {
  const SubCategoryListing({super.key});

  @override
  State<SubCategoryListing> createState() => _SubCategoryListingState();
}

class _SubCategoryListingState extends State<SubCategoryListing> {
  bool? isSearch=false;
  final List<Map<String, String>> vendors = [
    {
      "name": "KT's Cafe",
      "image": "assets/banner2.png",
      "address": "OPPO RANGOLI ICECREAM, Univer...",
      "rating": "0.0",
      "location": "Rajkot"
    },
    {
      "name": "FATHER'S CATERING",
      "image": "assets/banner3.png",
      "address": "Office No. 1008, Aqua Coral New 150 ...",
      "rating": "0.0",
      "location": "Rajkot"
    },
    {
      "name": "Ivory House Cafe",
      "image": "assets/banner4.png",
      "address": "shop 2,3,4, Surya Complex, brts, 150 ...",
      "rating": "0.0",
      "location": "Rajkot"
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar:SharedWidgets.customAppBar(
        isFilterShow: true,
        searchVisible: true,
        showSearch: isSearch!,
        onSearchTap: () {
          isSearch=true;
          setState(() {});
        },
        onCloseSearch:() {
          isSearch=false;
          setState(() {});
        },
        onFilterTap: () {
          openFilterSheet(context);
        },
        title: "Food & Dining",
        gradient: const LinearGradient(colors: [
          AppColors.gradientStart,AppColors.gradientEnd
        ])
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(12),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.75,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
        ),
        itemCount: vendors.length,
        itemBuilder: (context, index) {
          final vendor = vendors[index];
          return _buildVendorCard(vendor);
        },
      ),
    );
  }

  Widget _buildVendorCard(Map<String, String> vendor) {
    return GestureDetector(
      onTap: () {
        Get.to(()=> const SubCategoryDetailScreen());
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 5,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                  child: Image.asset(
                    vendor['image']!,
                    height: 120,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      height: 120,
                      color: Colors.grey[300],
                      child: const Icon(Icons.image),
                    ),
                  ),
                ),
                Positioned(
                  top: 8,
                  left: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.7),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: const Text(
                      "Food & Dining",
                      style: TextStyle(color: Colors.white, fontSize: 10),
                    ),
                  ),
                ),
                const Positioned(
                  top: 8,
                  right: 8,
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: 14,
                        backgroundColor: Colors.white,
                        child: Icon(Icons.favorite_border, size: 16, color: Colors.black),
                      ),
                      SizedBox(height: 8),
                      CircleAvatar(
                        radius: 14,
                        backgroundColor: Colors.white,
                        child: Icon(Icons.share_outlined, size: 16, color: Colors.black),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    vendor['name']!,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.location_on_outlined, size: 12, color: Colors.grey),
                      const SizedBox(width: 2),
                      Expanded(
                        child: Text(
                          vendor['address']!,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(color: Colors.grey, fontSize: 11),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  // Rating and City
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.star, size: 14, color: Colors.amber),
                          const SizedBox(width: 2),
                          Text(vendor['rating']!, style: const TextStyle(fontSize: 12)),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.pink.shade50,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.location_on, size: 10, color: Colors.pink),
                            const SizedBox(width: 2),
                            Text(
                              vendor['location']!,
                              style: const TextStyle(color: Colors.pink, fontSize: 10, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
  void openFilterSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const FilterBottomSheetContent(),
    );
  }
}