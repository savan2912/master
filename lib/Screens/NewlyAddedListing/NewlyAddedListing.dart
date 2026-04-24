import 'dart:async';
import 'dart:developer';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:gotilo_new/Screens/AllListing/AllListingDetailScreen.dart';
import 'package:shimmer/shimmer.dart';
import 'package:gotilo_new/Api/Request/AllNewlyAdded/RequestAllNewlyAdded.dart';
import 'package:gotilo_new/Api/Response/AllNewlyAdded/ResponseAllNewlyAdded.dart';

import '../../Api/ApiCalls.dart';
import '../../MyApplication/MyApplication.dart';

class NewlyAddedListing extends StatefulWidget {
  const NewlyAddedListing({super.key});

  @override
  State<NewlyAddedListing> createState() => _NewlyAddedListingState();
}

class _NewlyAddedListingState extends State<NewlyAddedListing> {
  ValueNotifier<bool> isApiComplete = ValueNotifier(false);
  ValueNotifier<bool> isLoadingMore = ValueNotifier(false);
  ValueNotifier<bool> isSearching = ValueNotifier(false);

  List<AllNewlyAdded> listings = [];
  int currentCounter = 0;
  bool hasMoreData = true;
  final ScrollController _scrollController = ScrollController();

  bool isSearchActive = false;
  TextEditingController searchController = TextEditingController();
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    callAllNewlyAdded(isFirstLoad: true);

    _scrollController.addListener(() {
      if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 200) {
        if (!isLoadingMore.value && hasMoreData && isApiComplete.value) {
          loadMoreData();
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

  void onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      callAllNewlyAdded(isFirstLoad: true, searchQuery: query);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDFDFD),
      body: CustomScrollView(
        controller: _scrollController,
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverAppBar(
            expandedHeight: 120,
            pinned: true,
            elevation: 0,
            backgroundColor: const Color(0xFFFDFDFD),
            surfaceTintColor: const Color(0xFFFDFDFD),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new, color: Color(0xFF0D1B1E), size: 18),
              onPressed: () => Navigator.pop(context),
            ),
            actions: [
              IconButton(
                onPressed: () {
                  setState(() {
                    isSearchActive = !isSearchActive;
                    if (!isSearchActive) {
                      searchController.clear();
                      callAllNewlyAdded(isFirstLoad: true);
                    }
                  });
                },
                icon: Icon(isSearchActive ? Icons.close : Icons.search, color: const Color(0xFF0D1B1E)),
              )
            ],
            flexibleSpace: FlexibleSpaceBar(
              centerTitle: true,
              titlePadding: const EdgeInsets.only(bottom: 15),
              title: isSearchActive
                  ? Padding(
                padding: const EdgeInsets.symmetric(horizontal: 50),
                child: SizedBox(
                  height: 32,
                  child: TextField(
                    controller: searchController,
                    onChanged: onSearchChanged,
                    autofocus: true,
                    style: GoogleFonts.montserrat(fontSize: 13, color: Colors.black),
                    decoration: InputDecoration(
                      hintText: "Search...",
                      hintStyle: GoogleFonts.montserrat(fontSize: 11, color: Colors.grey),
                      filled: true,
                      fillColor: Colors.grey[200],
                      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 0),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(25), borderSide: BorderSide.none),
                    ),
                  ),
                ),
              )
                  : Text(
                "NEWLY ADDED",
                style: GoogleFonts.montserrat(color: const Color(0xFF0D1B1E), fontWeight: FontWeight.w900, fontSize: 14, letterSpacing: 2),
              ),
            ),
          ),

          ValueListenableBuilder(
            valueListenable: isSearching,
            builder: (context, loading, child) {
              if (loading) {
                return const SliverFillRemaining(
                  child: Center(
                    child: CircularProgressIndicator(
                      color: Color(0xFF00ACC1),
                    ),
                  ),
                );
              }

              if (listings.isEmpty && isApiComplete.value) {
                return const SliverFillRemaining(child: Center(child: Text("No listings found.")));
              }

              return SliverPadding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                        (context, index) {
                      if (index == listings.length) {
                        return ValueListenableBuilder(
                          valueListenable: isLoadingMore,
                          builder: (context, loadingMore, child) {
                            return loadingMore
                                ? const Padding(
                              padding: EdgeInsets.symmetric(vertical: 20),
                              child: Center(child: CircularProgressIndicator(color: Color(0xFF00ACC1), strokeWidth: 2,)),
                            )
                                : const SizedBox.shrink();
                          },
                        );
                      }
                      return _buildOverlappingCard(listings[index]);
                    },
                    childCount: listings.length + 1,
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildOverlappingCard(AllNewlyAdded item) {
    return GestureDetector(
      onTap: () {
        Get.to(()=> AllListingDetailScreen(listId: item.id,));
      },
      child: Container(
        height: 320,
        margin: const EdgeInsets.only(bottom: 30),
        child: Stack(
          children: [
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                height: 180,
                width: double.infinity,
                margin: const EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(40),
                  boxShadow: [BoxShadow(color: const Color(0xFF0D1B1E).withOpacity(0.06), blurRadius: 30, offset: const Offset(0, 15))],
                ),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(25, 60, 25, 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(item.listingTitle ?? "Unknown", style: GoogleFonts.montserrat(color: const Color(0xFF0D1B1E), fontSize: 18, fontWeight: FontWeight.w900)),
                      const SizedBox(height: 5),
                      Text(item.description ?? "", maxLines: 1, overflow: TextOverflow.ellipsis, style: GoogleFonts.montserrat(color: Colors.grey[500], fontSize: 12, fontWeight: FontWeight.w500)),
                      const SizedBox(height: 15),
                      Row(
                        children: [
                          const Icon(Icons.location_on_rounded, color: Color(0xFF00ACC1), size: 16),
                          const SizedBox(width: 5),
                          Text(item.cityName ?? "", style: GoogleFonts.montserrat(color: const Color(0xFF0D1B1E).withOpacity(0.7), fontSize: 12, fontWeight: FontWeight.w700)),
                          const Spacer(),
                          const Icon(Icons.arrow_forward_rounded, color: Color(0xFF1A1A1A), size: 20),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              top: 0,
              left: 40,
              right: 40,
              child: Container(
                height: 200,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(35),
                  boxShadow: [BoxShadow(color: const Color(0xFF0D1B1E).withOpacity(0.2), blurRadius: 20, offset: const Offset(0, 10))],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(35),
                  child: CachedNetworkImage(
                    imageUrl: item.listingImage ?? "",
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Shimmer.fromColors(
                      baseColor: Colors.grey[300]!,
                      highlightColor: Colors.grey[100]!,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(35),
                        ),
                      ),
                    ),
                    errorWidget: (context, url, error) => Container(color: Colors.grey[300], child: const Icon(Icons.error)),
                  ),
                ),
              ),
            ),
            Positioned(
              top: 150,
              right: 55,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    color: Colors.white.withOpacity(0.2),
                    child: Row(
                      children: [
                        const Icon(Icons.star_rounded, color: Colors.orangeAccent, size: 16),
                        const SizedBox(width: 4),
                        Text(item.rating ?? "0", style: GoogleFonts.montserrat(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> loadMoreData() async {
    isLoadingMore.value = true;
    currentCounter += 10;
    await _callAllNewlyAdded(searchQuery: searchController.text);
  }

  Future<void> callAllNewlyAdded({bool isFirstLoad = false, String searchQuery = ""}) async {
    if (isFirstLoad) {
      isApiComplete.value = false;
      isSearching.value = true;
      currentCounter = 0;
      listings.clear();
      hasMoreData = true;
    }
    _callAllNewlyAdded(searchQuery: searchQuery);
  }

  Future<void> _callAllNewlyAdded({String searchQuery = ""}) async {
    try {
      bool internet = await MyApplication.checkInternet();
      if (!internet) {
        isApiComplete.value = true;
        isSearching.value = false;
        isLoadingMore.value = false;
        return;
      }
      ResponseAllNewlyAdded? response = await ApiCalls.callAllNewlyAdded(RequestAllNewlyAdded(counter: currentCounter.toString(), search: searchQuery));
      if (response != null && response.result != null && response.result!.toLowerCase().contains("pass") && response.data != null) {
        if (response.data!.isEmpty) {
          hasMoreData = false;
        } else {
          listings.addAll(response.data!);
          if (response.data!.length < 10) hasMoreData = false;
        }
      } else {
        hasMoreData = false;
      }
    } catch (e) {
      log("Error: $e");
    } finally {
      isApiComplete.value = true;
      isSearching.value = false;
      isLoadingMore.value = false;
      if (mounted) setState(() {});
    }
  }
}