import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gotilo_new/CustomeWidgets/SharedWidgets.dart';
import 'package:gotilo_new/Screens/CategoryDetail/CategoryDetailScreen.dart';

import '../../CustomeWidgets/AppColors.dart';
import '../../CustomeWidgets/FilterBottomSheetContent.dart';

class AllListingScreen extends StatefulWidget {
  const AllListingScreen({super.key});

  @override
  State<AllListingScreen> createState() => _AllListingScreenState();
}

class _AllListingScreenState extends State<AllListingScreen> {
  bool? isSearch=false;
  final List<Map<String, dynamic>> listings = [
    {
      "category": "Food & Dining",
      "image": "assets/banner1.png",
      "title": "Nature Velly",
      "address": "Naturevelly, shop no 185, Beside big bazaar...",
      "rating": 0.0,
      "location": "Rajkot",
    },
    {
      "category": "Food & Dining",
      "image": "assets/dry.png",
      "title": "The Mad Pizza Scientist",
      "address": "Shop no 8, West Gate Plus, near Raiya bridge...",
      "rating": 0.0,
      "location": "Rajkot",
    },
    {
      "category": "Food & Dining",
      "image": "assets/banner4.png",
      "title": "UFO - Fries and corn",
      "address": "The One World, B-2, 150 Feet Ring Rd...",
      "rating": 3.5,
      "location": "Rajkot",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:SharedWidgets.customAppBar(
        isFilterShow: true,
        searchVisible: true,
        showSearch: isSearch!,
        onCloseSearch: () {
          isSearch = false;
          setState(() {});
        },
        onSearchTap: () {
          isSearch = true;
          setState(() {});
        },
        onFilterTap: () {
          openFilterSheet(context);
        },
        gradient: const LinearGradient(colors: [
          AppColors.gradientStart,AppColors.gradientEnd
        ]),
        title: "All Listing",
      ),
      backgroundColor: Colors.grey.shade50,
      body: ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: listings.length,
        itemBuilder: (context, index) {
          final item = listings[index];
          return _buildListingCard(item);
        },
      ),
    );
  }

  Widget _buildListingCard(Map<String, dynamic> item) {
    return GestureDetector(
      onTap: () {
        Get.to( ()=> const CategoryDetailScreen());
      },
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        margin: const EdgeInsets.only(bottom: 16),
        elevation: 3,
        shadowColor: Colors.black.withOpacity(0.15),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(14),
          child: Stack(
            children: [
              Image.asset(
                item["image"],
                height: 180,
                width: double.infinity,
                fit: BoxFit.cover,
              ),

              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                height: 70,
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.black.withOpacity(0.7),
                        Colors.black.withOpacity(0),
                      ],
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 12,
                left: 12,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.black87,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    item["category"],
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 12,
                right: 12,
                child: Column(
                  children: [
                    _circleIconButton(icon: Icons.favorite_border, onPressed: () {
                      // TODO: Add favorite logic
                    }),
                    const SizedBox(height: 8),
                    _circleIconButton(icon: Icons.share, onPressed: () {
                      // TODO: Add share logic
                    }),
                  ],
                ),
              ),

              Positioned(
                left: 12,
                right: 12,
                bottom: 12,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item["title"],
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        shadows: [Shadow(blurRadius: 6, color: Colors.black87)],
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      item["address"],
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 13,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),

                    const SizedBox(height: 6),

                    // Rating and location row
                    Row(
                      children: [
                        Icon(Icons.star, size: 16, color: Colors.amber.shade400),
                        const SizedBox(width: 4),
                        Text(
                          item["rating"].toString(),
                          style: const TextStyle(color: Colors.white, fontSize: 13),
                        ),

                        const SizedBox(width: 16),

                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: Colors.pink.shade300,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.location_on, size: 14, color: Colors.white),
                              const SizedBox(width: 4),
                              Text(
                                item["location"],
                                style: const TextStyle(color: Colors.white, fontSize: 13),
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
      ),
    );
  }

  Widget _circleIconButton({required IconData icon, required VoidCallback onPressed}) {
    return Material(
      color: Colors.black54,
      shape: const CircleBorder(),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onPressed,
        child: Padding(
          padding: const EdgeInsets.all(6),
          child: Icon(icon, size: 20, color: Colors.white),
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
