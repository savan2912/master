import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:gotilo_new/CustomeWidgets/SharedWidgets.dart';
import '../../../Api/Response/CompanyLogo/ResponseCompanyLogo.dart';
import '../../../CustomeWidgets/AppColors.dart';
import '../../../Routes/app_routes.dart';

class BlogScreen extends StatefulWidget {
  const BlogScreen({super.key});

  @override
  State<BlogScreen> createState() => _BlogScreenState();
}

class _BlogScreenState extends State<BlogScreen> {
  CompanyLogo? logo;
  bool? isSearch=false;
  final List<Map<String, String>> blogData = List.generate(12, (index) => {
    'title': 'Find the Best Services with Gotilo',
    'date': '12 Mar 2024',
    'description': 'Discover amazing local services and deals in your city. Gotilo helps you connect with the best providers...',
    'image': 'https://picsum.photos/500/500?random=$index',
  });

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar:SharedWidgets.customAppBar(
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
      body: LayoutBuilder(
        builder: (context, constraints) {
          int crossAxisCount = 1;
          if (constraints.maxWidth > 600) crossAxisCount = 2;
          if (constraints.maxWidth > 1000) crossAxisCount = 3;
          return GridView.builder(
            padding: const EdgeInsets.all(15),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: crossAxisCount,
              crossAxisSpacing: 15,
              mainAxisSpacing: 15,
              childAspectRatio: 0.75,
            ),
            itemCount: blogData.length,
            itemBuilder: (context, index) {
              return _buildBlogCard(blogData[index]);
            },
          );
        },
      ),
    );
  }

  Widget _buildBlogCard(Map<String, String> blog) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 5,
            child: ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
              child: Image.network(
                blog['image']!,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  color: Colors.grey[300],
                  child: const Icon(Icons.broken_image, color: Colors.grey),
                ),
              ),
            ),
          ),
          Expanded(
            flex: 4,
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.calendar_month, size: 14, color: Colors.blue),
                      const SizedBox(width: 5),
                      Text(
                        blog['date']!,
                        style: const TextStyle(fontSize: 12, color: Colors.grey, fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    blog['title']!,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    blog['description']!,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey[600],
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }


}