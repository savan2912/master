import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gotilo_new/Screens/HeritageHomeScreen.dart';

import '../../Api/ApiCalls.dart';
import '../../Api/Request/AllCollection/RequestAllCollection.dart';
import '../../Api/Response/AllCollection/ResponseAllCollection.dart';
import '../../MyApplication/MyApplication.dart';
import '../AllCollection/CollectionDetailScreen.dart';

class AllCollectionScreen extends StatefulWidget {
  const AllCollectionScreen({super.key});

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

  final List<Color> colorList = [
    const Color(0xFFFF6B6B),
    const Color(0xFF4ECDC4),
    const Color(0xFFFFA94D),
    const Color(0xFF6C5CE7),
    const Color(0xFF00C853),
    const Color(0xFFFF4081),
    const Color(0xFF00B0FF),
    const Color(0xFFFFC107),
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
                    padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
                    sliver: SliverList(
                      delegate: SliverChildListDelegate(
                        [
                          GridView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              mainAxisSpacing: 15,
                              crossAxisSpacing: 15,
                              mainAxisExtent: 190,
                            ),
                            itemCount: categories.length,
                            itemBuilder: (context, index) {
                              final cat = categories[index];
                              bool isEven = index % 2 == 0;
                              Color color = colorList[index % colorList.length];
                              return _buildLuxuryCompactCard(cat, isEven, color);
                            },
                          ),
                          if (isLoadingMore && hasMoreData)
                            const Padding(
                              padding: EdgeInsets.all(20),
                              child: Center(child: CircularProgressIndicator(color: Colors.black)),
                            ),
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
      leading: IconButton(
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
      ),
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

  Widget _buildLuxuryCompactCard(AllCollectionData cat, bool isEven, Color color) {
    String iconUrl = "";
    if (cat.icon != null && cat.icon!.isNotEmpty) {
      iconUrl = cat.icon!.startsWith("http") ? cat.icon! : "https://yourdomain.com/${cat.icon!}";
    }

    return GestureDetector(
      onTap: () => Get.to(() => CollectionDetailScreen(categoryId: cat.id,title: cat.name,)),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(35),
            bottomRight: const Radius.circular(35),
            topRight: Radius.circular(isEven ? 12 : 35),
            bottomLeft: Radius.circular(isEven ? 35 : 12),
          ),
          boxShadow: [
            BoxShadow(color: const Color(0xFF0D1B1E).withOpacity(0.06), blurRadius: 15, offset: const Offset(0, 8)),
          ],
        ),
        child: Stack(
          children: [
            Positioned(
              top: 0,
              right: 0,
              child: Container(
                height: 90,
                width: 90,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.18),
                  borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(90)),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 56,
                    width: 56,
                    decoration: BoxDecoration(color: Colors.black, borderRadius: BorderRadius.circular(18)),
                    alignment: Alignment.center,
                    child: iconUrl.isNotEmpty
                        ? SvgPicture.network(iconUrl, height: 26, width: 26,
                        colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn))
                        : const Icon(Icons.image_not_supported, color: Colors.white),
                  ),
                  const Spacer(),
                  Text(
                    cat.name ?? "",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.montserrat(fontSize: 14, fontWeight: FontWeight.w900),
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