
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:gotilo_new/Api/ApiCall.dart';
import 'package:gotilo_new/Api/ApiList.dart';
import 'package:gotilo_new/Api/Response/Banner/ResponseBanner.dart';
import 'package:gotilo_new/Api/Response/CompanyLogo/ResponseCompanyLogo.dart';
import 'package:gotilo_new/CustomeWidgets/SharedWidgets.dart';
import 'package:gotilo_new/Routes/app_routes.dart';
import 'package:marquee/marquee.dart';
import '../../../CustomeWidgets/AppColors.dart';
import '../../HeritageHomeScreen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  CompanyLogo? logo;
  List<BannerData>? banner;
  ValueNotifier<bool> isApiComplete=ValueNotifier(false);
  ValueNotifier<bool> isDataAvailable=ValueNotifier(false);

  bool? isSearch=false;
  String selectedTab = "All Deals";
  var searchText= TextEditingController();

  final List<String> banners = [
    "assets/banner1.png",
    "assets/banner2.png",
    "assets/banner3.png",
    "assets/banner4.png",
    "assets/banner5.png",
  ];

  int bannerIndex  = 0;

  final List<Map<String, String>> categories =
  [
    {
      "title": "Food & Dining",
      "image": "assets/food.png"
    },
    {
      "title": "Travel Tourism",
      "image": "assets/travel.png"
    },
    {
      "title": "Healthcare",
      "image": "assets/helth.png"
    },
    {
      "title": "Education",
      "image": "assets/education.png"
    },
    {
      "title": "Beauty",
      "image": "assets/beauty.png"
    },
    {
      "title": "Construction",
      "image": "assets/construction.png"
    },
    {
      "title": "Education",
      "image": "assets/travel.png"
    },
    {
      "title": "Beauty",
      "image": "assets/food.png"
    },
    {
      "title": "Construction",
      "image": "assets/education.png"
    },
  ];

  final List<Map<String, String>> listings =
  [
    {
      "title": "Umang Solar fsdfsadfdfds dsafsdfds fdsf sdf ds f sdf sd fds f ",
      "image": "assets/solar.png"
    },
    {
      "title": "Patel Dry Fruits df",
      "image": "assets/dry.png"
    },
    {
      "title": "Nature Velly",
      "image": "assets/nature.png"
    },
    {
      "title": "Om Beauty Salon",
      "image": "assets/beauty_salon.png"
    },
  ];

  final List<Map<String, String>> featuredService=
  [
    {
      "title": "Umang Solar",
      "image": "assets/solar.png"
    },
    {
      "title": "Patel Dry Fruits",
      "image": "assets/dry.png"
    },
    {
      "title": "Nature Velly",
      "image": "assets/nature.png"
    },
    {
      "title": "Om Beauty Salon",
      "image": "assets/beauty_salon.png"
    },
  ];

  @override
  void initState() {
    _callGetCompanyLogo();
    _callGetBanner();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SharedWidgets.customAppBar(
          searchVisible: true,
          showSearch: isSearch!,
          onSearchTap: () {
            isSearch = true;
            setState(() {});
          },
          onSearchChanged: (value) {
            print("search value is :- $value");
          },
          onCloseSearch: () {
            isSearch = false;
            setState(() {});
          },
          centerImagePath: logo?.siteLogo,
          iconColor: AppColors.white,
          showSignInIcon: true,
          showJoinUsIcon: false,
          onSignInTap: () {
            Get.toNamed(AppRoutes.login);
          },
          onJoinUsTap: () {
            Get.toNamed(AppRoutes.joinUs);
          },
          gradient:const LinearGradient(colors: [
            AppColors.gradientStart,AppColors.gradientEnd
          ])
      ),
      body:
      ValueListenableBuilder(
        valueListenable: isApiComplete,
        builder: (context, value, child) {
          return Visibility(
            visible: value,
            replacement: const Center(child: CircularProgressIndicator(),),
            child: ValueListenableBuilder(
              valueListenable: isDataAvailable,
              builder: (context, value, child) {
                return Visibility(
                  visible: value,
                  replacement: const Center(child: Text("No Data Available"),),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 12),
                          child: Column(
                            children: [

                              CarouselSlider.builder(
                                itemCount: banner?.length,
                                itemBuilder: (context, index, realIndex) {
                                  return Container(
                                    margin: const EdgeInsets.symmetric(horizontal: 6),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(16),
                                      image: DecorationImage(
                                        image: NetworkImage(banner![index].image!),
                                        fit: BoxFit.cover,
                                      ),
                                      boxShadow: const [
                                        BoxShadow(
                                          color: Colors.black12,
                                          blurRadius: 6,
                                          offset: Offset(0, 3),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                                options: CarouselOptions(
                                  height: 170,
                                  autoPlay: banner?.isNotEmpty ?? false,
                                  viewportFraction: 0.95,
                                  enlargeCenterPage: true,
                                  autoPlayInterval: const Duration(seconds: 3),
                                  onPageChanged: (index, reason) {
                                    setState(() {
                                      bannerIndex = index;
                                    });
                                  },
                                ),
                              ),
                              const SizedBox(height: 8),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: List.generate(
                                  banner?.length ?? 0,
                                      (index) => AnimatedContainer(
                                    duration: const Duration(milliseconds: 300),
                                    margin: const EdgeInsets.symmetric(horizontal: 4),
                                    height: 8,
                                    width: (banner != null && bannerIndex == index) ? 20 : 8,
                                    decoration: BoxDecoration(
                                      color: (banner != null && bannerIndex == index)
                                          ? Colors.blue
                                          : Colors.grey.shade400,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      const Text(
                                        "Explore ",
                                        style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                                      ),
                                      SharedWidgets.gradientText(
                                        text: "Categories",
                                        style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      Get.toNamed(AppRoutes.allCategory);
                                    },
                                    child: const Text(
                                      "View All",
                                      style: TextStyle(fontSize: 14),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),

                              GridView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: categories.length,
                                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 3,
                                  crossAxisSpacing: 12,
                                  mainAxisSpacing: 12,
                                  childAspectRatio: 0.95,
                                ),
                                itemBuilder: (context, index) {
                                  return TweenAnimationBuilder<double>(
                                    tween: Tween(begin: 0.8, end: 1),
                                    duration: Duration(milliseconds: 350 + (index * 50)),
                                    curve: Curves.easeOutCubic,
                                    builder: (context, scale, child) {
                                      return Transform.scale(
                                        scale: scale,
                                        child: child,
                                      );
                                    },
                                    child: Column(
                                      children: [
                                        Container(
                                          height: 90,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(15),
                                            image: DecorationImage(
                                              image: AssetImage(categories[index]['image']!),
                                              fit: BoxFit.cover,
                                            ),
                                            boxShadow: const [
                                              BoxShadow(
                                                color: Colors.black12,
                                                blurRadius: 6,
                                                offset: Offset(0, 3),
                                              )
                                            ],
                                          ),
                                        ),
                                        const SizedBox(height: 6),
                                        Text(
                                          categories[index]['title']!,
                                          textAlign: TextAlign.center,
                                          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                              const SizedBox(height: 20),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      const Text(
                                        "Latest Listing ",
                                        style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                                      ),
                                      SharedWidgets.gradientText(
                                        text: "Near You",
                                        style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      Get.to(()=> const ModernHeritageApp());
                                    },
                                    child: const Text(
                                      "View All",
                                      style: TextStyle(fontSize: 14),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 15),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                                child: ListView.builder(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: listings.length,
                                  itemBuilder: (context, index) {
                                    return TweenAnimationBuilder<double>(
                                      tween: Tween(begin: 0.9, end: 1),
                                      duration: Duration(milliseconds: 400 + (index * 50)),
                                      curve: Curves.easeOutCubic,
                                      builder: (context, scale, child) {
                                        return Transform.scale(
                                          scale: scale,
                                          child: child,
                                        );
                                      },
                                      child: Container(
                                        width: double.infinity,
                                        margin: const EdgeInsets.only(bottom: 16),
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(15),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.black.withOpacity(0.05),
                                              blurRadius: 10,
                                              offset: const Offset(0, 5),
                                            )
                                          ],
                                        ),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                              height: 180,
                                              decoration: BoxDecoration(
                                                borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
                                                image: DecorationImage(
                                                  image: AssetImage(listings[index]['image']!),
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                            ),

                                            Padding(
                                              padding: const EdgeInsets.all(15),
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  SizedBox(
                                                    height: 24,
                                                    child: LayoutBuilder(
                                                      builder: (context, constraints) {
                                                        final title = listings[index]['title'] ?? "";
                                                        const titleStyle = TextStyle(
                                                          fontWeight: FontWeight.bold,
                                                          fontSize: 18,
                                                        );

                                                        final textPainter = TextPainter(
                                                          text: TextSpan(text: title, style: titleStyle),
                                                          maxLines: 1,
                                                          textDirection: TextDirection.ltr,
                                                        )..layout(maxWidth: double.infinity);

                                                        if (textPainter.width > constraints.maxWidth) {
                                                          return Marquee(
                                                            text: title,
                                                            style: titleStyle,
                                                            scrollAxis: Axis.horizontal,
                                                            blankSpace: 30,
                                                            velocity: 30,
                                                            pauseAfterRound: const Duration(seconds: 1),
                                                            accelerationDuration: const Duration(seconds: 1),
                                                            accelerationCurve: Curves.linear,
                                                          );
                                                        }
                                                        return Text(
                                                          title,
                                                          style: titleStyle,
                                                          maxLines: 1,
                                                        );
                                                      },
                                                    ),
                                                  ),

                                                  const SizedBox(height: 10),

                                                  Row(
                                                    children: [
                                                      Container(
                                                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                                        decoration: BoxDecoration(
                                                          color: Colors.amber.withOpacity(0.1),
                                                          borderRadius: BorderRadius.circular(8),
                                                        ),
                                                        child: const Row(
                                                          mainAxisSize: MainAxisSize.min,
                                                          children: [
                                                            Icon(Icons.star, size: 16, color: Colors.amber),
                                                            SizedBox(width: 4),
                                                            Text("4.5", style: TextStyle(fontWeight: FontWeight.bold)),
                                                          ],
                                                        ),
                                                      ),

                                                      const SizedBox(width: 12),

                                                      Flexible(
                                                        child: Container(
                                                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                                          decoration: BoxDecoration(
                                                            color: AppColors.gradientEnd.withOpacity(0.1),
                                                            borderRadius: BorderRadius.circular(8),
                                                          ),
                                                          child: Row(
                                                            mainAxisSize: MainAxisSize.min,
                                                            children: [
                                                              const Icon(CupertinoIcons.location, size: 16, color: AppColors.gradientEnd),
                                                              const SizedBox(width: 4),
                                                              Flexible(
                                                                child: SizedBox(
                                                                  height: 18,
                                                                  child: LayoutBuilder(
                                                                    builder: (context, constraints) {
                                                                      final loc = listings[index]['location'] ?? "Rajkot, Gujarat";
                                                                      const locStyle = TextStyle(
                                                                        color: AppColors.gradientEnd,
                                                                        fontWeight: FontWeight.bold,
                                                                      );

                                                                      final locPainter = TextPainter(
                                                                        text: TextSpan(text: loc, style: locStyle),
                                                                        maxLines: 1,
                                                                        textDirection: TextDirection.ltr,
                                                                      )..layout(maxWidth: double.infinity);
                                                                      if (locPainter.width > constraints.maxWidth) {
                                                                        return Marquee(
                                                                          text: loc,
                                                                          style: locStyle,
                                                                          scrollAxis: Axis.horizontal,
                                                                          blankSpace: 20,
                                                                          velocity: 25,
                                                                          pauseAfterRound: const Duration(seconds: 1),
                                                                        );
                                                                      }
                                                                      return Text(
                                                                        loc,
                                                                        style: locStyle,
                                                                        maxLines: 1,
                                                                      );
                                                                    },
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),

                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        const Text(
                                          "Newly ",
                                          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                                        ),
                                        SharedWidgets.gradientText(
                                          text: "Added Listing",
                                          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                    TextButton(
                                      onPressed: () {

                                      },
                                      child: const Text(
                                        "View All",
                                        style: TextStyle(fontSize: 14),
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              GridView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: 4,
                                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  crossAxisSpacing: 10,
                                  mainAxisSpacing: 10,
                                  childAspectRatio: 0.98,
                                ),
                                itemBuilder: (context, index) {
                                  return TweenAnimationBuilder<double>(
                                    tween: Tween(begin: 0.9, end: 1),
                                    duration: Duration(milliseconds: 400 + (index * 50)),
                                    curve: Curves.easeOutCubic,
                                    builder: (context, scale, child) => Transform.scale(scale: scale, child: child),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(12),
                                        color: Colors.white,
                                        boxShadow: [
                                          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 4, offset: const Offset(0, 2)),
                                        ],
                                      ),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        mainAxisSize: MainAxisSize.min,
                                        children: [

                                          Container(
                                            height: 105,
                                            width: double.infinity,
                                            decoration: BoxDecoration(
                                              borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                                              image: DecorationImage(
                                                image: AssetImage(listings[index]['image'] ?? ""),
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          ),

                                          Padding(
                                            padding: const EdgeInsets.symmetric(horizontal: 6.0, vertical: 8.0),
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [

                                                SizedBox(
                                                  height: 18,
                                                  child: LayoutBuilder(
                                                    builder: (context, constraints) {
                                                      final title = listings[index]['title'] ?? "";
                                                      const textStyle = TextStyle(fontWeight: FontWeight.bold, fontSize: 13);
                                                      final textPainter = TextPainter(
                                                        text: TextSpan(text: title, style: textStyle),
                                                        maxLines: 1,
                                                        textDirection: TextDirection.ltr,
                                                      )..layout(maxWidth: constraints.maxWidth);

                                                      if (!textPainter.didExceedMaxLines) {
                                                        return Text(title, style: textStyle, maxLines: 1, overflow: TextOverflow.ellipsis);
                                                      }
                                                      return Marquee(
                                                        text: title,
                                                        style: textStyle,
                                                        scrollAxis: Axis.horizontal,
                                                        blankSpace: 20,
                                                        velocity: 25,
                                                      );
                                                    },
                                                  ),
                                                ),

                                                const SizedBox(height: 8),
                                                Container(
                                                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 5),
                                                  decoration: BoxDecoration(
                                                    color: AppColors.gradientEnd.withOpacity(0.08),
                                                    borderRadius: BorderRadius.circular(6),
                                                  ),
                                                  child: Row(
                                                    children: [
                                                      const Icon(Icons.star, size: 14, color: Colors.amber),
                                                      const SizedBox(width: 2),
                                                      const Text(
                                                        "4.5",
                                                        style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.bold),
                                                      ),

                                                      const SizedBox(width: 12),
                                                      Expanded(
                                                        child: Row(
                                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                          children: [
                                                            const Icon(
                                                              CupertinoIcons.location,
                                                              size: 13,
                                                              color: AppColors.gradientEnd,
                                                            ),
                                                            const SizedBox(width: 3),
                                                            Expanded(
                                                              child: SizedBox(
                                                                height: 16,
                                                                child: LayoutBuilder(
                                                                  builder: (context, constraints) {
                                                                    final location = listings[index]['location'] ?? "Jam Khambhadiya";
                                                                    const textStyle = TextStyle(
                                                                      color: AppColors.gradientEnd,
                                                                      fontSize: 11.5,
                                                                      fontWeight: FontWeight.w700,
                                                                    );

                                                                    final textPainter = TextPainter(
                                                                      text: TextSpan(text: location, style: textStyle),
                                                                      maxLines: 1,
                                                                      textDirection: TextDirection.ltr,
                                                                    )..layout(maxWidth: double.infinity);


                                                                    if (textPainter.width > constraints.maxWidth) {
                                                                      return Marquee(
                                                                        text: location,
                                                                        style: textStyle,
                                                                        scrollAxis: Axis.horizontal,
                                                                        blankSpace: 20,
                                                                        velocity: 22,
                                                                        pauseAfterRound: const Duration(seconds: 1),
                                                                        accelerationDuration: const Duration(seconds: 1),
                                                                        accelerationCurve: Curves.linear,
                                                                      );
                                                                    }

                                                                    return Text(
                                                                      location,
                                                                      style: textStyle,
                                                                      maxLines: 1,
                                                                    );
                                                                  },
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),

                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        const Text(
                                          "Our Featured ",
                                          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                                        ),
                                        SharedWidgets.gradientText(
                                          text: "Service",
                                          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                    TextButton(
                                      onPressed: () {
                                      },
                                      child: const Text(
                                        "View All",
                                        style: TextStyle(fontSize: 14),
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: ListView.builder(
                                  physics: const NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  itemCount: featuredService.length,
                                  itemBuilder: (BuildContext context, int index) {
                                    return  _subCategoryCard(
                                        title:featuredService[index]['title']!,
                                        image: featuredService[index]["image"]!
                                    );
                                  },


                                ),
                              ),

                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        _dealToggleButton("All Deals"),
                                        const SizedBox(width: 12),
                                        _dealToggleButton("Nearby Deals"),
                                      ],
                                    ),

                                    const SizedBox(height: 20),

                                    if (selectedTab == "All Deals")
                                      Column(
                                        children: [
                                          _buildDealCard(title: "Gotilo Cafe One", tag: "Couple Combo", image: "assets/beauty.png", location: "Rajkot", validTill: "07 Apr, 2026"),
                                          const SizedBox(height: 12),
                                          _buildDealCard(title: "Grand Thakar", tag: "Family Pack", image: "assets/food.png", location: "Rajkot", validTill: "10 Apr, 2026"),
                                        ],
                                      )
                                    else
                                      _buildDealCard(
                                          title: "Nearby Restro",
                                          tag: "Flash Sale",
                                          image: "assets/dry.png",
                                          location: "1.2 km away",
                                          validTill: "Today Only"
                                      ),
                                  ],
                                ),
                              ),

                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 16),
                                child: _howItWorksSection(),
                              ),
                              const SizedBox(height: 20),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                );
              }
            ),
          );
        }
      ),
    );
  }

  Widget _dealToggleButton(String text) {
    bool isSelected = selectedTab == text;

    return InkWell(
      onTap: () {
        setState(() {
          selectedTab = text;
        });
      },
      borderRadius: BorderRadius.circular(8),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          gradient: isSelected
              ? const LinearGradient(colors: [AppColors.gradientStart, AppColors.gradientEnd])
              : null,
          color: isSelected ? null : Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: isSelected ? null : Border.all(color: Colors.grey.shade300),
          boxShadow: isSelected ? [
            BoxShadow(color: AppColors.gradientStart.withOpacity(0.3), blurRadius: 8, offset: const Offset(0, 4))
          ] : null,
        ),
        child: Text(
          text,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.blueGrey.shade800,
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        ),
      ),
    );
  }

  Widget _buildDealCard({
    required String title,
    required String validTill,
    required String location,
    required String tag,
    required String image,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 15,
            offset: const Offset(0, 5),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                height: 180,
                width: double.infinity,
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                  gradient: LinearGradient(
                    colors: [Color(0xFFFF9800), Color(0xFFFF5722)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                  child: Opacity(
                    opacity: 0.15,
                    child: Image.asset(image, fit: BoxFit.cover),
                  ),
                ),
              ),

              Positioned(
                right: 15,
                top: 10,
                bottom: 10,
                child: Transform(
                  alignment: Alignment.center,
                  transform: Matrix4.identity()
                    ..setEntry(3, 2, 0.002)
                    ..rotateY(-0.1)
                    ..rotateX(0.05),
                  child: Container(
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.3),
                          blurRadius: 20,
                          offset: const Offset(10, 10),
                        ),
                      ],
                    ),
                    child: Image.asset(
                      image,
                      width: 140,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ),

              Positioned(
                top: 15,
                left: 15,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.8),
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: const [
                      BoxShadow(color: Colors.black26, blurRadius: 4, offset: const Offset(0, 2))
                    ],
                  ),
                  child: Text(
                    tag,
                    style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),

          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87),
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Icon(Icons.calendar_today, size: 14, color: Colors.grey.shade500),
                    const SizedBox(width: 6),
                    Text(
                      "Valid till • $validTill",
                      style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
                    ),
                  ],
                ),
                const SizedBox(height: 15),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.pink.shade50,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.location_on, size: 14, color: Colors.pink.shade400),
                          const SizedBox(width: 4),
                          Text(
                            location,
                            style: TextStyle(color: Colors.pink.shade400, fontWeight: FontWeight.bold, fontSize: 12),
                          ),
                        ],
                      ),
                    ),

                    Material(
                      color: const Color(0xFF0D1B2A),
                      borderRadius: BorderRadius.circular(10),
                      elevation: 4,
                      child: InkWell(
                        onTap: () {},
                        borderRadius: BorderRadius.circular(10),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                          child: const Text(
                            "Crack the Deal",
                            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _subCategoryCard({
    required String title,
    required String image,
  }) {
    return Card(
      color: Colors.white,
      elevation: 4,
      shadowColor: Colors.black.withOpacity(0.15),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
      ),
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.asset(
                image,
                height: 70,
                width: 70,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 6),
                  const Row(
                    children: [
                      Icon(Icons.star, size: 16, color: Colors.amber),
                      SizedBox(width: 4),
                      Text("4.5", style: TextStyle(fontSize: 12)),
                      SizedBox(width: 12),
                      Icon(Icons.location_on, size: 16, color: Colors.blue),
                      SizedBox(width: 4),
                      Text("Rajkot", style: TextStyle(fontSize: 12)),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    "Category Name",
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: Colors.grey,
            ),
          ],
        ),
      ),
    );
  }

  Widget _howItWorksSection() {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(vertical: 20),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
      decoration: BoxDecoration(
        color: const Color(0xFF000000),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.purple.withOpacity(0.1),
            blurRadius: 20,
            spreadRadius: 5,
          )
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "How Gotilo ",
                style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
              ),
              ShaderMask(
                shaderCallback: (bounds) => const LinearGradient(
                  colors: [Colors.purpleAccent, Colors.blueAccent],
                ).createShader(bounds),
                child: const Text(
                  "Works",
                  style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            "Discover how Gotilo connects you with trusted businesses in just a few simple steps.",
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey.shade400, fontSize: 13),
          ),
          const SizedBox(height: 40),
          _buildStepItem(
            stepNum: "1",
            title: "Choose Location",
            desc: "Enter your mobile number to get started.",
            icon: Icons.location_on_outlined,
          ),
          _buildVerticalLine(),
          _buildStepItem(
            stepNum: "2",
            title: "Pick Category",
            desc: "Explore and select the most relevant category for your business.",
            icon: Icons.category_outlined,
          ),
          _buildVerticalLine(),
          _buildStepItem(
            stepNum: "3",
            title: "Explore Place",
            desc: "Discover various locations tailored to your specific needs.",
            icon: Icons.explore_outlined,
          ),
        ],
      ),
    );
  }

  Widget _buildStepItem({required String stepNum, required String title, required String desc, required IconData icon}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.05),
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white12),
          ),
          child: Icon(icon, color: Colors.white, size: 26),
        ),
        const SizedBox(width: 20),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "$stepNum. $title",
                style: const TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 5),
              Text(
                desc,
                style: TextStyle(color: Colors.grey.shade500, fontSize: 14, height: 1.4),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildVerticalLine() {
    return Container(
      margin: const EdgeInsets.only(left: 25, top: 5, bottom: 5),
      height: 30,
      width: 1,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Colors.purpleAccent.withOpacity(0.5), Colors.transparent],
        ),
      ),
    );
  }

  Future<void> _callGetCompanyLogo() async {
    final api = ApiCall();
    final json = await api.getRequest(ApiList.getCompanyLogo);

    if (json != null) {
      ResponseCompanyLogo responseData = ResponseCompanyLogo.fromJson(json);
      if (responseData.result == "pass" || responseData.data != null) {
        setState(() {
          logo = responseData.data;
        });
        print("Logo URL: ${logo?.siteLogo}");
      }
    }

    setState(() {

    });
  }
  Future<void> _callGetBanner() async {
    isApiComplete.value = false;
    isDataAvailable.value = false;

    final api = ApiCall();
    final json = await api.getBanner(ApiList.getBanner);

    if (json != null) {
      ResponseBanner responseData = ResponseBanner.fromJson(json);

      if (responseData.result == "pass" && responseData.data != null) {
        setState(() {
          banner ??= [];
          banner!.clear();
          banner!.addAll(responseData.data!);
        });
        isDataAvailable.value = banner!.isNotEmpty;
      }
    }

    isApiComplete.value = true;
  }
}
