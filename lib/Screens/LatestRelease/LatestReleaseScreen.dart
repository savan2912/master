import 'dart:async';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gotilo_new/Screens/AllListing/AllListingDetailScreen.dart';
import 'package:shimmer/shimmer.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:gotilo_new/Api/Request/AllLatestRelease/RequestAllLatestRelease.dart';
import 'package:gotilo_new/Api/Response/AllLatestRelease/ResponseAllLatestRelease.dart';
import '../../Api/ApiCalls.dart';
import '../../MyApplication/MyApplication.dart';
import '../HeritageHomeScreen.dart';

class LatestReleaseScreen extends StatefulWidget {
  const LatestReleaseScreen({super.key});

  @override
  State<LatestReleaseScreen> createState() => _LatestReleaseScreenState();
}

class _LatestReleaseScreenState extends State<LatestReleaseScreen> {
  final TextEditingController searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  bool isSearching = false;
  ValueNotifier<bool> isApiComplete = ValueNotifier(false);
  ValueNotifier<bool> isMoreLoading = ValueNotifier(false);

  Timer? _debounce;
  List<AllLatestRelease> allProducts = [];

  int currentCounter = 0;
  bool hasMoreData = true;

  @override
  void initState() {
    super.initState();
    _callAllLatestRelease(searchText: "", count: "0");

    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent * 0.9) {
        if (!isMoreLoading.value && hasMoreData && isApiComplete.value) {
          _loadMore();
        }
      }
    });
  }

  @override
  void dispose() {
    searchController.dispose();
    _scrollController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  void _loadMore() {
    currentCounter += 10;
    _callAllLatestRelease(
      searchText: searchController.text,
      count: currentCounter.toString(),
      isLoadMore: true,
    );
  }

  void _runFilter(String enteredKeyword) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();

    _debounce = Timer(const Duration(milliseconds: 700), () {
      currentCounter = 0;
      hasMoreData = true;
      allProducts.clear();
      isApiComplete.value = false;
      _callAllLatestRelease(searchText: enteredKeyword, count: "0");
    });
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final bool isTablet = screenWidth >= 600;

    int crossAxisCount = 1;
    if (screenWidth >= 1200) {
      crossAxisCount = 3;
    } else if (isTablet) {
      crossAxisCount = 2;
    }

    double horizontalPadding = screenWidth * 0.05;
    if (horizontalPadding < 16) horizontalPadding = 16;
    if (horizontalPadding > 60) horizontalPadding = 60;

    return Scaffold(
      backgroundColor: ModernHeritageApp.appBg,
      body: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 1440),
          child: CustomScrollView(
            controller: _scrollController,
            physics: const BouncingScrollPhysics(),
            slivers: [
              SliverAppBar(
                pinned: true,
                backgroundColor: const Color(0xFFFDFDFD),
                surfaceTintColor: const Color(0xFFFDFDFD),
                elevation: 0,
                leading: IconButton(
                  icon: const Icon(
                    Icons.arrow_back_ios_new,
                    color: Color(0xFF0D1B1E),
                    size: 18,
                  ),
                  onPressed: () => Navigator.pop(context),
                ),
                centerTitle: true,
                title: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  child: isSearching
                      ? Container(
                          key: const ValueKey("SearchBar"),
                          height: 40,
                          decoration: BoxDecoration(
                            color: Colors.grey[100],
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: TextField(
                            controller: searchController,
                            autofocus: true,
                            onChanged: (value) => _runFilter(value),
                            style: GoogleFonts.montserrat(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                            ),
                            decoration: InputDecoration(
                              hintText: "Search releases...",
                              hintStyle: GoogleFonts.montserrat(
                                fontSize: 12,
                                color: Colors.grey,
                              ),
                              border: InputBorder.none,
                              prefixIcon: const Icon(
                                Icons.search,
                                size: 18,
                                color: Colors.grey,
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                vertical: 10,
                              ),
                            ),
                          ),
                        )
                      : Text(
                          "LATEST RELEASES",
                          key: const ValueKey("TitleText"),
                          style: GoogleFonts.montserrat(
                            letterSpacing: 2,
                            fontWeight: FontWeight.w900,
                            fontSize: 16,
                            color: const Color(0xFF0D1B1E),
                          ),
                        ),
                ),
                actions: [
                  IconButton(
                    icon: Icon(
                      isSearching ? Icons.close_rounded : Icons.search_rounded,
                      color: const Color(0xFF0D1B1E),
                    ),
                    onPressed: () {
                      setState(() {
                        isSearching = !isSearching;
                        if (!isSearching) {
                          searchController.clear();
                          _runFilter('');
                        }
                      });
                    },
                  ),
                  const SizedBox(width: 8),
                ],
              ),

              ValueListenableBuilder(
                valueListenable: isApiComplete,
                builder: (context, complete, child) {
                  if (!complete && allProducts.isEmpty) {
                    return const SliverFillRemaining(
                      child: Center(
                        child: CircularProgressIndicator(
                          color: Color(0xFF0D1B1E),
                        ),
                      ),
                    );
                  }
                  return const SliverToBoxAdapter(child: SizedBox.shrink());
                },
              ),

              if (allProducts.isNotEmpty)
                SliverPadding(
                  padding: EdgeInsets.fromLTRB(
                    horizontalPadding,
                    20,
                    horizontalPadding,
                    20,
                  ),
                  sliver: SliverGrid(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: crossAxisCount,
                      mainAxisSpacing: 20,
                      crossAxisSpacing: 20,
                      childAspectRatio: crossAxisCount == 1 ? 1.05 : 0.85,
                    ),
                    delegate: SliverChildBuilderDelegate(
                      (context, index) => _buildLuxuryReleaseCard(
                        allProducts[index],
                        crossAxisCount > 1,
                      ),
                      childCount: allProducts.length,
                    ),
                  ),
                )
              else if (isApiComplete.value)
                SliverFillRemaining(
                  child: Center(
                    child: Text(
                      "No results found!",
                      style: GoogleFonts.montserrat(
                        color: Colors.grey,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),

              SliverToBoxAdapter(
                child: ValueListenableBuilder(
                  valueListenable: isMoreLoading,
                  builder: (context, loading, child) {
                    return loading
                        ? const Padding(
                            padding: EdgeInsets.symmetric(vertical: 20),
                            child: Center(
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Color(0xFF0D1B1E),
                              ),
                            ),
                          )
                        : const SizedBox(height: 30);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _callAllLatestRelease({
    required String searchText,
    required String count,
    bool isLoadMore = false,
  }) async {
    if (isLoadMore) {
      isMoreLoading.value = true;
    } else {
      isApiComplete.value = false;
    }

    try {
      bool internet = await MyApplication.checkInternet();
      if (!internet) {
        isApiComplete.value = true;
        isMoreLoading.value = false;
        return;
      }

      ResponseAllLatestRelease? response = await ApiCalls.callAllLatestRelease(
        RequestAllLatestRelease(search: searchText, counter: count),
      );

      if (response != null &&
          response.result != null &&
          response.result!.toLowerCase().contains("pass") &&
          response.data != null) {
        List<AllLatestRelease> fetchedData = response.data!;

        if (count == "0") {
          allProducts.clear();
        }

        if (fetchedData.length < 10) {
          hasMoreData = false;
        } else {
          hasMoreData = true;
        }

        allProducts.addAll(fetchedData);
      } else {
        if (count == "0") allProducts.clear();
        hasMoreData = false;
      }
    } catch (e) {
      log("API Error: $e");
    } finally {
      isApiComplete.value = true;
      isMoreLoading.value = false;
      if (mounted) setState(() {});
    }
  }

  Widget _buildLuxuryReleaseCard(AllLatestRelease item, bool isGrid) {
    return GestureDetector(
      onTap: () {
        Get.to(() => AllListingDetailScreen(listId: item.id));
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(25),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF0D1B1E).withOpacity(0.05),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(25),
                    ),
                    child: CachedNetworkImage(
                      imageUrl: item.listingImage ?? "",
                      height: double.infinity,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Shimmer.fromColors(
                        baseColor: Colors.grey[300]!,
                        highlightColor: Colors.grey[100]!,
                        child: Container(color: Colors.white),
                      ),
                      errorWidget: (context, url, error) => Container(
                        color: Colors.grey[200],
                        child: const Icon(
                          Icons.broken_image,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ),
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
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.star_rounded,
                            color: Color(0xFFFFB300),
                            size: 16,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            item.rating ?? "0.0",
                            style: GoogleFonts.montserrat(
                              fontWeight: FontWeight.bold,
                              fontSize: 11,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item.listingTitle ?? "No Title",
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.montserrat(
                                fontSize: 14,
                                fontWeight: FontWeight.w900,
                                color: const Color(0xFF0D1B1E),
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              item.serviceType ?? "",
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.montserrat(
                                fontSize: 11,
                                fontWeight: FontWeight.w500,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Text(
                        item.openClose ?? "",
                        style: GoogleFonts.montserrat(
                          fontSize: 13,
                          fontWeight: FontWeight.w800,
                          color: const Color(0xFF00ACC1),
                        ),
                      ),
                    ],
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 10),
                    child: Divider(height: 1, color: Color(0xFFF0F0F0)),
                  ),
                  Row(
                    children: [
                      const Icon(
                        Icons.location_on_outlined,
                        color: Color(0xFF0D1B1E),
                        size: 14,
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          item.cityName ?? "",
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.montserrat(
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF0D1B1E).withOpacity(0.7),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFF1A1A1A),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          "EXPLORE",
                          style: GoogleFonts.montserrat(
                            fontSize: 9,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                            letterSpacing: 0.5,
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
      ),
    );
  }
}
