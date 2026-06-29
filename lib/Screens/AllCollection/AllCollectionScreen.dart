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
import '../../CustomeWidgets/SharedWidgets.dart';
import '../../MyApplication/MyApplication.dart';
import '../AllCollection/CollectionDetailScreen.dart';

class AllCollectionScreen extends StatefulWidget {
  final bool? isHome;
  const AllCollectionScreen({super.key, this.isHome = false});

  @override
  State<AllCollectionScreen> createState() => _AllCollectionScreenState();
}

class _AllCollectionScreenState extends State<AllCollectionScreen> {
  final ValueNotifier<bool> isDataAvailable = ValueNotifier(false);
  final ValueNotifier<bool> isApiComplete = ValueNotifier(false);

  bool isApiCalling = false;
  List<AllCollectionData> categories = [];

  final ScrollController _scrollController = ScrollController();

  int counter = 0;
  final int limit = 8;
  bool isLoadingMore = false;
  bool hasMoreData = true;

  final List<Color> premiumColors = [
    const Color(0xFF5B2B3E),
    const Color(0xFFE6A12E),
    const Color(0xFF069494),
    const Color(0xFFA84328),
    const Color(0xFF7A9C5E),
    const Color(0xFF4A7C93),
    const Color(0xFFD50032),
    const Color(0xFF163D42),
    const Color(0xFF8C1F2B),
    const Color(0xFF7B4B9E),
  ];

  bool isSearching = false;
  final TextEditingController searchController = TextEditingController();
  Timer? _debounce;
  String lastSearchText = "";

  @override
  void initState() {
    super.initState();
    callAllCollection(reset: true);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    searchController.dispose();
    _debounce?.cancel();
    isDataAvailable.dispose();
    isApiComplete.dispose();
    super.dispose();
  }

  void loadMore() {
    if (isApiCalling || !hasMoreData || isLoadingMore) return;

    counter += limit;
    log("Loading More Data... Counter Passed: $counter");
    callAllCollection();
  }

  Future<void> callAllCollection({bool reset = false}) async {
    if (isApiCalling) return;

    if (reset) {
      counter = 0;
      hasMoreData = true;
      isLoadingMore = false;
      isApiComplete.value = false;
      isDataAvailable.value = false;
      categories.clear();
      if (mounted) setState(() {});
    }

    try {
      isApiCalling = true;

      if (counter > 0) {
        setState(() => isLoadingMore = true);
      }

      final bool internet = await MyApplication.checkInternet();
      if (!internet) {
        isApiComplete.value = true;
        isLoadingMore = false;
        isApiCalling = false;
        return;
      }

      final String searchText = searchController.text.trim();
      log("Calling API with Counter: $counter, Search: $searchText");

      ResponseAllCollection? response = await ApiCalls.callAllCollection(
        RequestAllCollection(
          counter: counter.toString(),
          search: searchText,
        ),
      );

      if (response != null &&
          response.result != null &&
          response.result!.toLowerCase().contains("pass") &&
          response.data != null) {
        final List<AllCollectionData> newData = response.data ?? [];

        if (reset) {
          categories = List<AllCollectionData>.from(newData);
        } else {
          for (var item in newData) {
            final alreadyExists = categories.any((e) => e.id == item.id);
            if (!alreadyExists) {
              categories.add(item);
            }
          }
        }

        hasMoreData = newData.isNotEmpty && newData.length >= limit;
        isDataAvailable.value = categories.isNotEmpty;
      } else {
        if (reset) categories.clear();
        hasMoreData = false;
        isDataAvailable.value = categories.isNotEmpty;
      }
    } catch (e, st) {
      log("API Error: $e");
      log("StackTrace: $st");
    } finally {
      isApiCalling = false;
      isLoadingMore = false;
      isApiComplete.value = true;
      if (mounted) setState(() {});
    }
  }

  Future<void> _onSearchChanged(String value) async {
    if (_debounce?.isActive ?? false) _debounce!.cancel();

    _debounce = Timer(const Duration(milliseconds: 600), () {
      final text = value.trim();
      if (text != lastSearchText) {
        lastSearchText = text;
        callAllCollection(reset: true);
      }
    });
  }

  void _toggleSearch() {
    setState(() {
      isSearching = !isSearching;
      if (!isSearching) {
        searchController.clear();
        lastSearchText = "";
        callAllCollection(reset: true);
      }
    });
  }

  void _handleBack() {
    if (isSearching) {
      setState(() {
        isSearching = false;
        searchController.clear();
        lastSearchText = "";
      });
      callAllCollection(reset: true);
    } else {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ModernHeritageApp.appBg,
      body: NotificationListener<ScrollNotification>(
        onNotification: (ScrollNotification scrollInfo) {
          if (scrollInfo.metrics.pixels >= scrollInfo.metrics.maxScrollExtent - 150) {
            loadMore();
          }
          return true;
        },
        child: CustomScrollView(
          controller: _scrollController,
          physics: const AlwaysScrollableScrollPhysics(
            parent: BouncingScrollPhysics(),
          ),
          slivers: [
            _buildAppBar(),

            ValueListenableBuilder<bool>(
              valueListenable: isApiComplete,
              builder: (context, apiDone, child) {
                if (!apiDone && categories.isEmpty) {
                  return const SliverFillRemaining(
                    child: Center(
                      child: CircularProgressIndicator(color: Colors.black),
                    ),
                  );
                }

                return ValueListenableBuilder<bool>(
                  valueListenable: isDataAvailable,
                  builder: (context, hasData, child) {
                    if (!hasData) {
                      return const SliverFillRemaining(
                        child: Center(
                          child: Text(
                            "No data available",
                            style: TextStyle(
                              color: Colors.black87,
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      );
                    }

                    return SliverPadding(
                      padding: const EdgeInsets.fromLTRB(14, 12, 14, 10),
                      sliver: SliverGrid(
                        gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisSpacing: 14,
                          crossAxisSpacing: 14,
                          childAspectRatio: 0.95,
                        ),
                        delegate: SliverChildBuilderDelegate(
                              (context, index) {
                            final cat = categories[index];
                            final iconColor =
                            premiumColors[index % premiumColors.length];
                            return _buildPremiumBentoCard(cat, iconColor);
                          },
                          childCount: categories.length,
                        ),
                      ),
                    );
                  },
                );
              },
            ),

            SliverToBoxAdapter(
              child: isLoadingMore && hasMoreData
                  ? const Padding(
                padding: EdgeInsets.symmetric(vertical: 24),
                child: Center(
                  child: CircularProgressIndicator(color: Colors.black),
                ),
              )
                  : const SizedBox.shrink(),
            ),

            SliverToBoxAdapter(
              child: SizedBox(height: (widget.isHome ?? false) ? 100 : 30),
            ),
          ],
        ),
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
      leading: !(widget.isHome ?? false)
          ? IconButton(
        icon: const Icon(
          Icons.arrow_back_ios_new,
          color: Color(0xFF0D1B1E),
          size: 18,
        ),
        onPressed: _handleBack,
      )
          : const SizedBox(),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 10),
          child: IconButton(
            icon: Icon(
              isSearching ? Icons.close_rounded : Icons.search_rounded,
              color: const Color(0xFF0D1B1E),
              size: 28,
            ),
            onPressed: _toggleSearch,
          ),
        ),
      ],
      flexibleSpace: FlexibleSpaceBar(
        centerTitle: true,
        expandedTitleScale: 1.0,
        titlePadding:
        EdgeInsets.only(bottom: isSearching ? 12 : 20, left: 0, right: 0),
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
              border: Border.all(
                color: const Color(0xFFE9ECEF),
                width: 1.5,
              ),
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
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF0D1B1E),
              ),
              onChanged: _onSearchChanged,
              decoration: InputDecoration(
                hintText: "Search here...",
                hintStyle: GoogleFonts.montserrat(
                  fontSize: 13,
                  color: Colors.grey.shade400,
                ),
                border: InputBorder.none,
                prefixIcon: const Icon(
                  Icons.search_rounded,
                  size: 20,
                  color: Color(0xFF0D1B1E),
                ),
                contentPadding: EdgeInsets.zero,
                isDense: true,
              ),
            ),
          )
              : Text(
            "COLLECTIONS",
            key: const ValueKey("TitleText"),
            style: GoogleFonts.poppins(
              letterSpacing: 1.5,
              fontWeight: FontWeight.w900,
              fontSize: 18,
              color: const Color(0xFF0D1B1E),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPremiumBentoCard(AllCollectionData cat, Color iconColor) {
    return GestureDetector(
      onTap: () => Get.to(
            () => CollectionDetailScreen(
          categoryId: cat.id,
          title: cat.name,
        ),
      ),
      child: Container(
        decoration: SharedWidgets.cardBoxDecoration(),
        padding: const EdgeInsets.all(14.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 100,
              width: double.infinity,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: iconColor.withOpacity(0.08),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: iconColor.withOpacity(0.15),
                  width: 1,
                ),
              ),
              child: SizedBox(
                height: 54,
                width: 54,
                child: (cat.icon != null && cat.icon!.contains('.svg'))
                    ? SvgPicture.network(
                  cat.icon!,
                  fit: BoxFit.contain,
                  colorFilter: ColorFilter.mode(
                    iconColor,
                    BlendMode.srcIn,
                  ),
                  placeholderBuilder: (_) => _shimmerCircle(),
                )
                    : CachedNetworkImage(
                  imageUrl: cat.icon ?? "",
                  fit: BoxFit.contain,
                  color: iconColor,
                  placeholder: (context, url) => _shimmerCircle(),
                  errorWidget: (context, url, error) => Icon(
                    Icons.category,
                    color: iconColor,
                    size: 28,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              child: Text(
                cat.name ?? "",
                maxLines: 1,
                style: GoogleFonts.roboto(
                  color: Colors.black87,
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  height: 1.2,
                ),
              ),
            ),
            const SizedBox(height: 6),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "Explore",
                  style: GoogleFonts.montserrat(
                    color: Colors.black45,
                    fontSize: 11.5,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(width: 4),
                Icon(
                  Icons.arrow_forward_rounded,
                  color: iconColor.withOpacity(0.7),
                  size: 14,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _shimmerCircle() {
    return Shimmer.fromColors(
      baseColor: Colors.grey.withOpacity(0.1),
      highlightColor: Colors.grey.withOpacity(0.2),
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
        ),
      ),
    );
  }
}