import 'dart:developer';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gotilo_new/Constant/AppPref.dart';
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
  const CollectionDetailScreen({super.key, this.categoryId = 0});

  @override
  State<CollectionDetailScreen> createState() => _CollectionDetailScreenState();
}

class _CollectionDetailScreenState extends State<CollectionDetailScreen> {
  bool isSearching = false;
  final TextEditingController searchController = TextEditingController();

  // Overall API loading state
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
    // Banne API ne parallelly call karse
    await Future.wait([
      _callCollectionDetail(),
      _callCollectionProductList(),
    ]);
    isPageLoading.value = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDFDFD),
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          // 1. AppBar hamesha visible rahese
          _buildSliverAppBar(),

          ValueListenableBuilder(
            valueListenable: isPageLoading,
            builder: (context, isLoading, child) {

              // 2. Jyare API load thiti hoy tyare Center Loader
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

              // 3. Jo data available na hoy to
              if (categories.isEmpty && popularListings.isEmpty) {
                return const SliverFillRemaining(
                  hasScrollBody: false,
                  child: Center(
                    child: Text("No data found for this collection"),
                  ),
                );
              }

              // 4. Main Content (Grid + List)
              return SliverMainAxisGroup(
                slivers: [
                  // Categories Grid
                  if (categories.isNotEmpty)
                    SliverPadding(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      sliver: SliverGrid(
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisSpacing: 15,
                          crossAxisSpacing: 15,
                          mainAxisExtent: 180,
                        ),
                        delegate: SliverChildBuilderDelegate(
                              (context, index) => _buildMinimalCategoryCard(categories[index]),
                          childCount: categories.length,
                        ),
                      ),
                    ),

                  // Popular Listings Section
                  if (popularListings.isNotEmpty) ...[
                    _buildSectionHeader(),
                    SliverPadding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      sliver: SliverList(
                        delegate: SliverChildBuilderDelegate(
                              (context, index) => _buildVerticalListingCard(popularListings[index]),
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

  // --- UI COMPONENTS ---

  Widget _buildSliverAppBar() {
    return SliverAppBar(
      expandedHeight: isSearching ? 130 : 150,
      collapsedHeight: 85,
      toolbarHeight: 80,
      pinned: true,
      stretch: true,
      backgroundColor: const Color(0xFFFDFDFD),
      elevation: 0,
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
        const SizedBox(width: 10),
      ],
      flexibleSpace: FlexibleSpaceBar(
        centerTitle: true,
        title: SafeArea(
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: isSearching ? _buildSearchField() : _buildTitleText(),
          ),
        ),
      ),
    );
  }

  Widget _buildSearchField() {
    return Container(
      key: const ValueKey("SearchField"),
      height: 44,
      margin: const EdgeInsets.symmetric(horizontal: 55),
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
          isDense: true,
          contentPadding: EdgeInsets.only(top: 10),
        ),
      ),
    );
  }

  Widget _buildTitleText() {
    return Text(
      "COLLECTION DETAILS",
      key: const ValueKey("TitleText"),
      style: GoogleFonts.montserrat(
        letterSpacing: 2,
        fontWeight: FontWeight.w900,
        fontSize: 14,
        color: const Color(0xFF0D1B1E),
      ),
    );
  }

  Widget _buildSectionHeader() {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(25, 45, 25, 15),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Our Popular Listings",
                    style: GoogleFonts.montserrat(color: const Color(0xFF0D1B1E), fontSize: 20, fontWeight: FontWeight.w900)),
                Text("Explore the best places in town",
                    style: GoogleFonts.montserrat(color: Colors.grey, fontSize: 12, fontWeight: FontWeight.w500)),
              ],
            ),
            TextButton(
              onPressed: () {},
              child: Text("View All", style: GoogleFonts.montserrat(color: const Color(0xFF6C63FF), fontWeight: FontWeight.w700)),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildMinimalCategoryCard(CollectionDetail cat) {
    return GestureDetector(
      onTap: () => Get.to(() => const AllListingScreen()),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10, offset: const Offset(0, 5))],
        ),
        child: Column(
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
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

  Widget _buildVerticalListingCard(CollectionProductList item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 20, offset: const Offset(0, 8))],
      ),
      child: Column(
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(25)),
                child: CachedNetworkImage(
                  imageUrl: item.path ?? "",
                  height: 210,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => _shimmerBox(height: 210),
                  errorWidget: (context, url, error) => Container(height: 210, color: Colors.grey[200], child: const Icon(Icons.broken_image)),
                ),
              ),
              if (item.rating != null)
                Positioned(
                  bottom: 15,
                  right: 15,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
                    child: Row(
                      children: [
                        const Icon(Icons.star, color: Colors.orange, size: 16),
                        const SizedBox(width: 4),
                        Text(item.rating!, style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 13)),
                      ],
                    ),
                  ),
                ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item.listingTitle ?? "", style: GoogleFonts.montserrat(fontWeight: FontWeight.w800, fontSize: 17)),
                const SizedBox(height: 6),
                Row(
                  children: [
                    const Icon(Icons.location_on_outlined, size: 14, color: Colors.grey),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(item.address ?? "", maxLines: 1, overflow: TextOverflow.ellipsis,
                          style: const TextStyle(color: Colors.grey, fontSize: 12)),
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

