import 'dart:developer';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gotilo_new/Constant/AppPref.dart';
import 'package:gotilo_new/CustomeWidgets/SharedWidgets.dart';
import 'package:gotilo_new/Screens/AllListing/AllList/AllListingsByCategory.dart';
import 'package:gotilo_new/Screens/HeritageHomeScreen.dart';
import 'package:shimmer/shimmer.dart';
import 'package:gotilo_new/Api/Request/AllCollection/RequestCollectionDetails.dart';
import 'package:gotilo_new/Api/Request/AllCollection/RequestCollectionProductListings.dart';
import 'package:gotilo_new/Api/Response/AllCollection/ResponseCollectionDetails.dart';
import 'package:gotilo_new/Api/Response/AllCollection/ResponseCollectionProductList.dart';
import 'package:gotilo_new/Screens/AllListing/AllListingScreen.dart';
import '../../Api/ApiCalls.dart';
import '../../MyApplication/MyApplication.dart';

class CollectionDetailScreen extends StatefulWidget {
  final int? categoryId;
  String? title = "";
  CollectionDetailScreen({super.key, this.categoryId = 0, required this.title});

  @override
  State<CollectionDetailScreen> createState() => _CollectionDetailScreenState();
}

class _CollectionDetailScreenState extends State<CollectionDetailScreen> {
  bool isSearching = false;
  final TextEditingController searchController = TextEditingController();
  ValueNotifier<bool> isPageLoading = ValueNotifier(true);

  List<CollectionDetail> categories = [];
  List<CollectionProductList> popularListings = [];

  @override
  void initState() {
    super.initState();
    initData();
  }

  Future<void> initData() async {
    isPageLoading.value = true;
    await Future.wait([
      _callCollectionDetail(),
      _callCollectionProductList(),
    ]);
    isPageLoading.value = false;
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final bool isTablet = screenWidth >= 600;
    final bool isDesktop = screenWidth >= 1024;

    int categoryCrossAxisCount = 2;
    if (screenWidth >= 1200) {
      categoryCrossAxisCount = 6;
    } else if (screenWidth >= 900) {
      categoryCrossAxisCount = 4;
    } else if (isTablet) {
      categoryCrossAxisCount = 3;
    }

    int listingCrossAxisCount = 1;
    if (screenWidth >= 1024) {
      listingCrossAxisCount = 3;
    } else if (isTablet) {
      listingCrossAxisCount = 2;
    }

    double horizontalPadding = screenWidth * 0.05;
    if (horizontalPadding < 20) horizontalPadding = 20;
    if (horizontalPadding > 60) horizontalPadding = 60;

    double categoryAspectRatio = 0.85;
    double listingAspectRatio = listingCrossAxisCount == 1 ? 1.1 : 0.85;

    return Scaffold(
      backgroundColor: ModernHeritageApp.appBg,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          _buildSliverAppBar(),
          ValueListenableBuilder(
            valueListenable: isPageLoading,
            builder: (context, isLoading, child) {
              if (isLoading) {
                return const SliverFillRemaining(
                  hasScrollBody: false,
                  child: Center(
                    child: CircularProgressIndicator(
                      color: Color(0xFF6C63FF),
                      strokeWidth: 3,
                    ),
                  ),
                );
              }

              if (categories.isEmpty && popularListings.isEmpty) {
                return const SliverFillRemaining(
                  hasScrollBody: false,
                  child: Center(
                    child: Text("No data found for this collection"),
                  ),
                );
              }

              return SliverMainAxisGroup(
                slivers: [
                  if (categories.isNotEmpty)
                    SliverPadding(
                      padding: EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: 10),
                      sliver: SliverGrid(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: categoryCrossAxisCount,
                          mainAxisSpacing: 15,
                          crossAxisSpacing: 15,
                          childAspectRatio: categoryAspectRatio,
                        ),
                        delegate: SliverChildBuilderDelegate(
                              (context, index) {
                            if (index == 0) {
                              return _buildAllListingCard();
                            }
                            final cat = categories[index - 1];
                            return _buildMinimalCategoryCard(cat);
                          },
                          childCount: categories.length + 1,
                        ),
                      ),
                    ),

                  if (popularListings.isNotEmpty) ...[
                    _buildSectionHeader(horizontalPadding),
                    SliverPadding(
                      padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                      sliver: SliverGrid(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: listingCrossAxisCount,
                          mainAxisSpacing: 20,
                          crossAxisSpacing: 20,
                          childAspectRatio: listingAspectRatio,
                        ),
                        delegate: SliverChildBuilderDelegate(
                              (context, index) => _buildVerticalListingCard(popularListings[index], listingCrossAxisCount > 1),
                          childCount: popularListings.length,
                        ),
                      ),
                    ),
                  ],

                  const SliverToBoxAdapter(child: SizedBox(height: 100)),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildAllListingCard() {
    return GestureDetector(
      onTap: () => Get.to(() => AllListingByCategory(categoryId: widget.categoryId)),
      child: Container(
        // color: Colors.cyan,
        decoration:SharedWidgets.cardBoxDecoration(bgColor: const Color(0xFF192841)),
        child: Column(
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(10)),
                child: Image.asset(
                  "assets/g_icon.png",
                  fit: BoxFit.contain,
                  width: double.infinity,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Text(
                "All Listings",
                style: GoogleFonts.montserrat(
                  fontWeight: FontWeight.w900,
                  color: Colors.white,
                  fontSize: 11,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSliverAppBar() {
    return SliverAppBar(
      pinned: true,
      elevation: 0,
      centerTitle: true,
      backgroundColor: const Color(0xFFFDFDFD),
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios_new, color: Color(0xFF0D1B1E), size: 18),
        onPressed: () {
          if (isSearching) {
            setState(() {
              isSearching = false;
              searchController.clear();
            });
          } else {
            Navigator.pop(context);
          }
        },
      ),
      actions: [
        IconButton(
          icon: Icon(
            isSearching ? Icons.close_rounded : Icons.search_rounded,
            color: const Color(0xFF0D1B1E),
            size: 26,
          ),
          onPressed: () {
            setState(() {
              isSearching = !isSearching;
              if (!isSearching) searchController.clear();
            });
          },
        ),
        // const SizedBox(width: 10),
      ],
      // ટાઈટલને FlexibleSpaceBar માંથી હટાવીને ડાયરેક્ટ title પ્રોપર્ટીમાં સેટ કર્યું જેથી ઓવરફ્લો ન થાય
      title: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        child: isSearching ? _buildSearchField() : _buildTitleText(),
      ),
    );
  }

  Widget _buildSearchField() {
    return Container(
      key: const ValueKey("SearchField"),
      height: 40,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE9ECEF), width: 1.2),
      ),
      child: TextField(
        controller: searchController,
        autofocus: true,
        style: GoogleFonts.montserrat(fontSize: 13, color: const Color(0xFF0D1B1E)),
        decoration: const InputDecoration(
          hintText: "Search here...",
          border: InputBorder.none,
          prefixIcon: Icon(Icons.search_rounded, size: 18),
          contentPadding: EdgeInsets.symmetric(vertical: 10),
        ),
      ),
    );
  }

  Widget _buildTitleText() {
    if (widget.title == null || widget.title!.isEmpty) {
      return const SizedBox.shrink();
    }

    final TextStyle titleStyle = GoogleFonts.montserrat(
      letterSpacing: 2,
      fontWeight: FontWeight.w900,
      fontSize: 14,
      color: const Color(0xFF0D1B1E),
    );

    // LayoutBuilder નો ઉપયોગ કરીને ટર્મિનલ સ્ક્રીન પ્રમાણે માપ લઈએ
    return LayoutBuilder(
      builder: (context, constraints) {
        // આજુબાજુના આઈકોન્સને ન નડે એ રીતે વિડ્થ સેટ કરી (સ્ક્રીનની 60% જગ્યા જ રોકશે)
        // double availableWidth = MediaQuery.of(context).size.width * 0.6;

        return SizedBox(
          key: const ValueKey("TitleText"),
          // width: availableWidth,
          height: 22,
          child: Text(widget.title!)
        );
      },
    );
  }

  Widget _buildSectionHeader(double horizontalPadding) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: EdgeInsets.fromLTRB(horizontalPadding + 5, 45, horizontalPadding + 5, 15),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Our Popular Listings",
                      style: GoogleFonts.montserrat(color: const Color(0xFF0D1B1E), fontSize: 18, fontWeight: FontWeight.w900)),
                  Text("Explore the best places in town",
                      style: GoogleFonts.montserrat(color: Colors.grey, fontSize: 11, fontWeight: FontWeight.w500)),
                ],
              ),
            ),
            TextButton(
              onPressed: () {
                Get.to(() => AllListingByCategory(categoryId: widget.categoryId));
              },
              child: Text("View All", style: GoogleFonts.montserrat(color: const Color(0xFF6C63FF), fontWeight: FontWeight.w700)),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildMinimalCategoryCard(CollectionDetail cat) {
    return GestureDetector(
      onTap: () => Get.to(() => AllListingScreen(subCategoryId: cat.id)),
      child: Container(
        decoration: SharedWidgets.cardBoxDecoration(),
        child: Column(
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(10)),
                child: CachedNetworkImage(
                  imageUrl: cat.imageLink ?? "",
                  fit: BoxFit.cover,
                  width: double.infinity,
                  placeholder: (context, url) => _shimmerBox(),
                  errorWidget: (context, url, error) => Container(color: Colors.grey[200], child: const Icon(Icons.error)),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Text(cat.name ?? "",
                  style: GoogleFonts.montserrat(fontWeight: FontWeight.w900, fontSize: 11),
                  maxLines: 1, overflow: TextOverflow.ellipsis),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVerticalListingCard(CollectionProductList item, bool isGrid) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 20, offset: const Offset(0, 8))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                  child: CachedNetworkImage(
                    imageUrl: item.path ?? "",
                    height: double.infinity,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => _shimmerBox(height: double.infinity),
                    errorWidget: (context, url, error) => Container(color: Colors.grey[200], child: const Icon(Icons.broken_image)),
                  ),
                ),
                if (item.rating != null)
                  Positioned(
                    bottom: 12,
                    right: 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8)),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.star, color: Colors.orange, size: 14),
                          const SizedBox(width: 4),
                          Text(item.rating!, style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 11)),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(item.listingTitle ?? "", 
                    style: GoogleFonts.montserrat(fontWeight: FontWeight.w800, fontSize: 14),
                    maxLines: 1, overflow: TextOverflow.ellipsis),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.location_on_outlined, size: 12, color: Colors.grey),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(item.address ?? "", maxLines: 1, overflow: TextOverflow.ellipsis,
                          style: const TextStyle(color: Colors.grey, fontSize: 10)),
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

  Widget _shimmerBox({double height = double.infinity, double borderRadius = 12}) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        height: height,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(borderRadius),
        ),
      ),
    );
  }

  Future<void> _callCollectionDetail() async {
    try {
      if (!await MyApplication.checkInternet()) return;
      var response = await ApiCalls.callCollectionDetail(
          RequestCollectionDetail(categoryId: widget.categoryId ?? 0));
      if (response?.result?.toLowerCase().contains("pass") == true && response?.collectionDetail != null) {
        categories = response!.collectionDetail!;
      }
    } catch (e) {
      log("Detail API Error: $e");
    }
  }

  Future<void> _callCollectionProductList() async {
    try {
      if (!await MyApplication.checkInternet()) return;
      var response = await ApiCalls.callCollectionProductList(
          RequestCollectionProductListings(categoryId: widget.categoryId ?? 0, cityId: AppPrefs.cityId));
      if (response?.result?.toLowerCase().contains("pass") == true && response?.listings != null) {
        popularListings = response!.listings!;
      }
    } catch (e) {
      log("Product API Error: $e");
    }
  }
}