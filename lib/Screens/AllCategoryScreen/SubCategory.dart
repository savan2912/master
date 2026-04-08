import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gotilo_new/CustomeWidgets/SharedWidgets.dart';
import 'package:gotilo_new/Screens/AllCategoryScreen/SubCategoryListing.dart';
import 'package:gotilo_new/Screens/AllListing/AllListingScreen.dart';
import '../../CustomeWidgets/AppColors.dart';

class SubCategoryScreen extends StatefulWidget {
  const SubCategoryScreen({super.key});

  @override
  State<SubCategoryScreen> createState() => _SubCategoryScreenState();
}

class _SubCategoryScreenState extends State<SubCategoryScreen> {
  bool? isSearch=false;

  final List<Map<String, String>> categories = [
    {"title": "Food", "image": "assets/food.png"},
    {"title": "Auto Parts", "image": "assets/travel.png"},
    {"title": "Logistics", "image": "assets/helth.png"},
    {"title": "Cleaning", "image": "assets/education.png"},
    {"title": "Sports", "image": "assets/dry.png"},
    {"title": "Legal", "image": "assets/beauty.png"},
  ];

  final List<Map<String, String>> subCategories = [
    {"title": "All Listing", "image": "assets/banner1.png"},
    {"title": "Restaurants", "image": "assets/banner2.png"},
    {"title": "Fast Foods", "image": "assets/banner3.png"},
    {"title": "Cafe", "image": "assets/banner4.png"},
  ];

  final List<Map<String, String>> exploreSubCategories =
  [
    {
      "title": "Pizza Palace",
      "image": "assets/banner1.png",
      "location": "Rajkot",
      "rating": "4.5"
    },
    {
      "title": "Cafe Coffee",
      "image": "assets/banner2.png",
      "location": "Ahmedabad",
      "rating": "4.2"
    },
    {
      "title": "Burger Hub",
      "image": "assets/banner3.png",
      "location": "Surat",
      "rating": "4.7"
    },
    {
      "title": "Food Corner",
      "image": "assets/banner4.png",
      "location": "Vadodara",
      "rating": "4.3"
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,

      appBar: SharedWidgets.customAppBar(
        title: "Sub Categories",
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
        gradient: const LinearGradient(
          colors: [
            AppColors.gradientStart,
            AppColors.gradientEnd,
          ],
        ),
      ),

      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: GridView.builder(
                itemCount: subCategories.length,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate:
                const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 1.2,
                ),
                itemBuilder: (context, index) {
                  return _subCategoryCard(
                    title: subCategories[index]["title"]!,
                    image: subCategories[index]["image"]!,
                  );
                },
              ),
            ),

            const Padding(
              padding: EdgeInsets.all(8),
              child: Text(
                "Discover What's Popular",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: List.generate(
                  categories.length,
                      (index) => _categoryCard(
                    title: categories[index]["title"]!,
                    image: categories[index]["image"]!,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  const Text(
                    "Explore Our Subcategories",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 6),

                  Text(
                    "Choose a subcategory to find the right service, product.svg, or place for your needs.",
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade600,
                    ),
                  ),

                  const SizedBox(height: 16),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child:
              ListView.builder(
                itemCount: exploreSubCategories.length,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemBuilder: (context, index) {
                  return _subCategoryCardBottom(
                    title: exploreSubCategories[index]["title"]!,
                    image: exploreSubCategories[index]["image"]!,
                    location: exploreSubCategories[index]["location"]!,
                    rating: exploreSubCategories[index]["rating"]!,
                  );
                },
              )
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }


  Widget _categoryCard({
    required String title,
    required String image,
  })
  {
    return Container(
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
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),

          const Icon(Icons.arrow_forward_ios, size: 18),
        ],
      ),
    );
  }


  Widget _subCategoryCard({
    required String title,
    required String image,
  })
  {
    return GestureDetector(
      onTap: () {
        if(title.toLowerCase().removeAllWhitespace == "alllisting"){
          Get.to(()=> const AllListingScreen());
        }
        if(title.toLowerCase().removeAllWhitespace == "restaurants"){
          Get.to(()=> const SubCategoryListing());
        }
      },
        child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 8,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Stack(
          children: [

            ClipRRect(
              borderRadius: BorderRadius.circular(14),
              child: Image.asset(
                image,
                width: double.infinity,
                height: double.infinity,
                fit: BoxFit.cover,
              ),
            ),

            Positioned(
              left: 12,
              right: 12,
              bottom: 12,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 8,
                  horizontal: 12,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFF2E3192),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
            ),
      );
  }

  Widget _subCategoryCardBottom({
    required String title,
    required String image,
    required String location,
    required String rating,
    bool isFavorite = false, // new parameter to track favorite state
    VoidCallback? onFavoriteTap, // callback when heart is tapped
  })
  {
    return GestureDetector(
      onTap: () {},
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        height: 200,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade300,
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(18),
          child: Stack(
            children: [

              /// Background Image
              Image.asset(
                image,
                width: double.infinity,
                height: double.infinity,
                fit: BoxFit.cover,
              ),

              /// Gradient Overlay
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [
                      Colors.black.withOpacity(0.75),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),

              /// Favorite Icon (Top-Left)
              Positioned(
                top: 12,
                left: 12,
                child: GestureDetector(
                  onTap: onFavoriteTap,
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.9),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      isFavorite ? Icons.favorite : Icons.favorite_border,
                      color: Colors.red,
                      size: 20,
                    ),
                  ),
                ),
              ),

              /// Rating Badge (Top-Right)
              Positioned(
                top: 12,
                right: 12,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.star,
                        color: Colors.orange,
                        size: 16,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        rating,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              /// Bottom Content
              Positioned(
                left: 16,
                right: 16,
                bottom: 16,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    /// Title
                    Text(
                      title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 6),

                    /// Location Row
                    Row(
                      children: [
                        const Icon(
                          Icons.location_on,
                          color: Colors.white,
                          size: 16,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          location,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 13,
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

}