import 'dart:async';
import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gotilo_new/Screens/HeritageHomeScreen.dart';
import 'package:shimmer/shimmer.dart';

import '../../Api/ApiCalls.dart';
import '../../Api/Request/AllCollection/RequestAllCollection.dart';
import '../../Api/Response/AllCollection/ResponseAllCollection.dart';
import '../../MyApplication/MyApplication.dart';
import '../AllCollection/CollectionDetailScreen.dart';

class AllCollectionScreen extends StatefulWidget {
  bool? isHome=false;
  AllCollectionScreen({super.key,required this.isHome});

  @override
  State<AllCollectionScreen> createState() => _AllCollectionScreenState();
}

class _AllCollectionScreenState extends State<AllCollectionScreen> {
  ValueNotifier<bool> isDataAvailable = ValueNotifier(false);
  ValueNotifier<bool> isApiComplete = ValueNotifier(false);

  bool isApiCalling = false;
  List<AllCollectionData> categories = [];

  final ScrollController _scrollController = ScrollController();
  int counter = 0;
  final int limit = 10;
  bool isLoadingMore = false;
  bool hasMoreData = true;

  // Premium Bento Box Gradients List
  final List<List<Color>> gradients = [
    [const Color(0xFF1E2640), const Color(0xFF0F1424)], // Cyber Midnight Blue
    [const Color(0xFF281D3C), const Color(0xFF130A1E)], // Premium Dark Amethyst
    [const Color(0xFF102A2D), const Color(0xFF051214)], // Deep Oceanic Teal
    [const Color(0xFF232526), const Color(0xFF111111)], // Pure Obsidian / Onyx
    [const Color(0xFF2D1F1F), const Color(0xFF160E0E)], // Dark Charcoal Maroon
    [const Color(0xFF17252A), const Color(0xFF0B1316)], // Minimal Deep Slate
    [const Color(0xFF1A2332), const Color(0xFF0D131A)], // Shadow Steel Blue
    [const Color(0xFF1C2826), const Color(0xFF0E1413)], // Premium Forest Obsidian
    [const Color(0xFF2D221E), const Color(0xFF17100E)], // Muted Luxury Espresso
    [const Color(0xFF1E1E24), const Color(0xFF111115)], // Dark Titanium Gray
  ];

  bool isSearching = false;
  TextEditingController searchController = TextEditingController();
  Timer? _debounce;
  String lastSearchText = "";

  @override
  void initState() {
    super.initState();
    callAllCollection(reset: true);

    _scrollController.addListener(() {
      if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 100) {
        if (!isApiCalling && hasMoreData && !isLoadingMore) {
          loadMore();
        }
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    searchController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  void loadMore() {
    counter += limit;
    callAllCollection();
  }

  Future<void> callAllCollection({bool reset = false}) async {
    if (isApiCalling) return;

    if (reset) {
      counter = 0;
      hasMoreData = true;
      isApiComplete.value = false;
      categories.clear();
      if (mounted) setState(() {});
    }

    try {
      isApiCalling = true;

      if (counter != 0) {
        setState(() => isLoadingMore = true);
      }

      bool internet = await MyApplication.checkInternet();
      if (!internet) {
        isApiComplete.value = true;
        isLoadingMore = false;
        isApiCalling = false;
        return;
      }

      ResponseAllCollection? response = await ApiCalls.callAllCollection(
        RequestAllCollection(
          counter: counter.toString(),
          search: searchController.text.trim(),
        ),
      );

      if (response != null &&
          response.result != null &&
          response.result!.toLowerCase().contains("pass") &&
          response.data != null) {

        List<AllCollectionData> newData = response.data!;
        print("New Data : - $newData");

        for (var item in newData) {
          if (!categories.any((e) => e.id == item.id)) {
            categories.add(item);
          }
        }

        hasMoreData = newData.length >= limit;
        isDataAvailable.value = categories.isNotEmpty;
      } else {
        hasMoreData = false;
        isDataAvailable.value = categories.isNotEmpty;
      }
    } catch (e) {
      log("API Error: $e");
    } finally {
      isApiCalling = false;
      isLoadingMore = false;
      isApiComplete.value = true;
      if (mounted) setState(() {});
    }
  }

// STEP 1: Pehla tamara class na constructor ma aa line verify/add kari lejo boss:
// final bool isHome;
// const AllCollectionScreen({super.key, this.isHome = false});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ModernHeritageApp.appBg,
      body: CustomScrollView(
        controller: _scrollController,
        physics: const BouncingScrollPhysics(),
        slivers: [
          _buildAppBar(),
          ValueListenableBuilder(
            valueListenable: isApiComplete,
            builder: (context, apiDone, child) {
              if (!apiDone && categories.isEmpty) {
                return const SliverFillRemaining(
                  child: Center(child: CircularProgressIndicator(color: Colors.black)),
                );
              }

              return ValueListenableBuilder(
                valueListenable: isDataAvailable,
                builder: (context, hasData, child) {
                  if (!hasData) {
                    return const SliverFillRemaining(
                      child: Center(child: Text("No data available")),
                    );
                  }

                  return SliverPadding(
                    padding: const EdgeInsets.fromLTRB(16, 10, 16, 20),
                    sliver: SliverList(
                      delegate: SliverChildListDelegate(
                        [
                          GridView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              mainAxisSpacing: 14,
                              crossAxisSpacing: 14,
                              childAspectRatio: 0.82, // Perfect Bento aspect ratio
                            ),
                            itemCount: categories.length,
                            itemBuilder: (context, index) {
                              final cat = categories[index];
                              final gradient = gradients[index % gradients.length];
                              return _buildPremiumBentoCard(cat, gradient);
                            },
                          ),

                          // Loader padding checklist block
                          if (isLoadingMore && hasMoreData)
                            const Padding(
                              padding: EdgeInsets.all(20),
                              child: Center(child: CircularProgressIndicator(color: Colors.black)),
                            ),
                          SizedBox(height: widget.isHome! ? 90 : 0),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }

  SliverAppBar _buildAppBar() {
    return SliverAppBar(
      expandedHeight: 130,
      collapsedHeight: 80,
      toolbarHeight: 75,
      pinned: true,
      backgroundColor: const Color(0xFFFDFDFD),
      elevation: 0,
      centerTitle: true,
      leading: !widget.isHome! ? IconButton(
        icon: const Icon(Icons.arrow_back_ios_new, color: Color(0xFF0D1B1E), size: 18),
        onPressed: () {
          if (isSearching) {
            setState(() {
              isSearching = false;
              searchController.clear();
              lastSearchText = "";
              callAllCollection(reset: true);
            });
          } else {
            Navigator.pop(context);
          }
        },
      ):SizedBox(),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 10),
          child: IconButton(
            icon: Icon(isSearching ? Icons.close_rounded : Icons.search_rounded,
                color: const Color(0xFF0D1B1E), size: 28),
            onPressed: () {
              setState(() {
                isSearching = !isSearching;
                if (!isSearching) {
                  searchController.clear();
                  lastSearchText = "";
                  callAllCollection(reset: true);
                }
              });
            },
          ),
        ),
      ],
      flexibleSpace: FlexibleSpaceBar(
        centerTitle: true,
        expandedTitleScale: 1.0,
        titlePadding: EdgeInsets.only(bottom: isSearching ? 12 : 20, left: 0, right: 0),
        title: AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: isSearching
              ? Container(
            key: const ValueKey("PremiumSearch"),
            height: 45,
            margin: const EdgeInsets.symmetric(horizontal: 55),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
              border: Border.all(color: const Color(0xFFE9ECEF), width: 1.5),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: TextField(
              controller: searchController,
              autofocus: true,
              textAlignVertical: TextAlignVertical.center,
              style: GoogleFonts.montserrat(
                  fontSize: 14, fontWeight: FontWeight.w600, color: const Color(0xFF0D1B1E)),
              onChanged: (value) {
                if (_debounce?.isActive ?? false) _debounce!.cancel();
                _debounce = Timer(const Duration(milliseconds: 600), () {
                  if (value.trim() != lastSearchText) {
                    lastSearchText = value.trim();
                    callAllCollection(reset: true);
                  }
                });
              },
              decoration: InputDecoration(
                hintText: "Search here...",
                hintStyle: GoogleFonts.montserrat(fontSize: 13, color: Colors.grey.shade400),
                border: InputBorder.none,
                prefixIcon: const Icon(Icons.search_rounded, size: 20, color: Color(0xFF0D1B1E)),
                contentPadding: EdgeInsets.zero,
                isDense: true,
              ),
            ),
          )
              : Text(
            "COLLECTIONS",
            key: const ValueKey("TitleText"),
            style: GoogleFonts.montserrat(
                letterSpacing: 3, fontWeight: FontWeight.w900, fontSize: 15, color: const Color(0xFF0D1B1E)),
          ),
        ),
      ),
    );
  }

  // New Premium Bento Box Card Method Integration
  Widget _buildPremiumBentoCard(AllCollectionData cat, List<Color> gradient) {
    return GestureDetector(
      onTap: () => Get.to(() => CollectionDetailScreen(categoryId: cat.id, title: cat.name)),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(28),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: gradient,
          ),
          boxShadow: [
            BoxShadow(
              color: gradient.first.withOpacity(0.3),
              blurRadius: 14,
              spreadRadius: 1,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(28),
          child: Stack(
            children: [
              // Background Circle Effect (Top Right)
              Positioned(
                top: -35,
                right: -20,
                child: Container(
                  height: 100,
                  width: 100,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withOpacity(0.12),
                  ),
                ),
              ),

              // Background Circle Effect (Bottom Left)
              Positioned(
                bottom: -20,
                left: -15,
                child: Container(
                  height: 75,
                  width: 75,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withOpacity(0.06),
                  ),
                ),
              ),

              // Card Main Internal Content Layout
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Icon Container Setup
                    Container(
                      height: 65,
                      width: 65,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.15),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: (cat.icon != null && cat.icon!.contains('.svg'))
                            ? SvgPicture.network(
                          cat.icon!,
                          colorFilter: const ColorFilter.mode(
                            Colors.white,
                            BlendMode.srcIn,
                          ),
                          placeholderBuilder: (_) => _shimmerCircle(),
                        )
                            : CachedNetworkImage(
                          imageUrl: cat.icon ?? "",
                          color: Colors.white,
                          placeholder: (context, url) => _shimmerCircle(),
                          errorWidget: (context, url, error) => const Icon(
                            Icons.category,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),

                    const Spacer(),

                    // Category Name Title
                    Text(
                      cat.name ?? "",
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.montserrat(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        height: 1.2,
                      ),
                    ),

                    const SizedBox(height: 6),

                    // Bottom Explore Text Row
                    Row(
                      children: [
                        Text(
                          "Explore",
                          style: GoogleFonts.montserrat(
                            color: Colors.white.withOpacity(0.8),
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(width: 4),
                        const Icon(
                          Icons.arrow_forward_rounded,
                          color: Colors.white,
                          size: 14,
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

  Widget _shimmerCircle() {
    return Shimmer.fromColors(
      baseColor: Colors.white.withOpacity(0.2),
      highlightColor: Colors.white.withOpacity(0.4),
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
        ),
      ),
    );
  }
}