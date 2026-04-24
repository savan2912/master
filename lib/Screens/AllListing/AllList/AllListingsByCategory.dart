
import 'dart:async';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gotilo_new/Api/Request/AllListings/RequestAllListings.dart';
import 'package:gotilo_new/Api/Response/AllListings/ResponseAllListings.dart';
import 'package:gotilo_new/Constant/AppPref.dart';
import 'package:shimmer/shimmer.dart';

import '../../../Api/ApiCalls.dart';
import '../../../MyApplication/MyApplication.dart';
import '../AllListingDetailScreen.dart';

class AllListingByCategory extends StatefulWidget {
  int? categoryId=0;
   AllListingByCategory({super.key,this.categoryId});

  @override
  State<AllListingByCategory> createState() => _AllListingByCategoryState();
}

class _AllListingByCategoryState extends State<AllListingByCategory> {
  List<AllListingsData> listingsList = [];
  bool isLoading = true;
  bool isMoreLoading = false;
  bool hasMoreData = true;
  int currentCounter = 0;

  bool isSearching = false;
  final TextEditingController searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    _callAllListings(isRefresh: true);
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 200) {
        if (!isMoreLoading && hasMoreData && !isLoading) {
          _callAllListings(isRefresh: false);
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
  _onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 700), () {
      _callAllListings(isRefresh: true);
    });
  }
  Future<void> _callAllListings({bool isRefresh = false}) async {
    if (isRefresh) {
      setState(() {
        isLoading = true;
        currentCounter = 0;
        hasMoreData = true;
      });
    } else {
      setState(() => isMoreLoading = true);
    }

    try {
      bool internet = await MyApplication.checkInternet();
      if (!internet) {
        Get.snackbar("Network Error", "Please check your internet connection.");
        setState(() => isLoading = false);
        return;
      }

      ResponseAllListing? response = await ApiCalls.callAllListings(
        RequestAllListings(
          categoryid: widget.categoryId ?? 0,
          locationid: AppPrefs.cityId,
          search: searchController.text,
          counter: currentCounter,
        ),
      );

      if (response != null &&
          response.result != null &&
          response.result!.toLowerCase().contains("pass") &&
          response.data != null) {

        List<AllListingsData> fetchedList = response.data ?? [];

        setState(() {
          if (isRefresh) {
            listingsList = fetchedList;
          } else {
            listingsList.addAll(fetchedList);
          }
          if (fetchedList.length < 10) {
            hasMoreData = false;
          } else {
            currentCounter += 10;
          }
        });
      } else {
        if (isRefresh) setState(() => listingsList = []);
        hasMoreData = false;
      }
    } catch (e) {
      log("API Error: $e");
    } finally {
      setState(() {
        isLoading = false;
        isMoreLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F8FB),
      body: CustomScrollView(
        controller: _scrollController,
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverAppBar(
            expandedHeight: 130,
            collapsedHeight: 80,
            toolbarHeight: 75,
            pinned: true,
            backgroundColor: const Color(0xFFF6F8FB),
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new, color: Color(0xFF0D1B1E), size: 18),
              onPressed: () {
                if (isSearching) {
                  setState(() {
                    isSearching = false;
                    searchController.clear();
                    _callAllListings(isRefresh: true);
                  });
                } else {
                  Navigator.pop(context);
                }
              },
            ),
            centerTitle: true,
            flexibleSpace: FlexibleSpaceBar(
              centerTitle: true,
              expandedTitleScale: 1.0,
              titlePadding: EdgeInsets.only(bottom: isSearching ? 15 : 20),
              title: AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: isSearching
                    ? Container(
                  key: const ValueKey("SearchBar"),
                  height: 42,
                  margin: const EdgeInsets.only(left: 55, right: 100),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(color: const Color(0xFFE9ECEF), width: 1.2),
                  ),
                  child: TextField(
                    controller: searchController,
                    autofocus: true,
                    onChanged: _onSearchChanged,
                    style: GoogleFonts.montserrat(fontSize: 13, fontWeight: FontWeight.w600),
                    decoration: const InputDecoration(
                      hintText: "Search...",
                      border: InputBorder.none,
                      prefixIcon: Icon(Icons.search_rounded, size: 18),
                      contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                    ),
                  ),
                )
                    : Text(
                  "EXPLORE ALL",
                  key: const ValueKey("TitleText"),
                  style: GoogleFonts.montserrat(
                    letterSpacing: 2,
                    fontWeight: FontWeight.w900,
                    fontSize: 14,
                    color: const Color(0xFF0D1B1E),
                  ),
                ),
              ),
            ),
            actions: [
              IconButton(
                icon: Icon(isSearching ? Icons.close_rounded : Icons.search_rounded, color: const Color(0xFF0D1B1E)),
                onPressed: () {
                  setState(() {
                    isSearching = !isSearching;
                    if (!isSearching) {
                      searchController.clear();
                      _callAllListings(isRefresh: true);
                    }
                  });
                },
              ),
              const SizedBox(width: 5),
            ],
          ),

          if (isLoading)
            const SliverFillRemaining(
              child: Center(child: CircularProgressIndicator(color: Color(0xFF6C63FF))),
            )
          else if (listingsList.isEmpty)
            SliverFillRemaining(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.search_off_rounded, size: 80, color: Colors.grey[300]),
                  const SizedBox(height: 10),
                  Text("No Data Found", style: GoogleFonts.montserrat(fontSize: 18, fontWeight: FontWeight.w700, color: Colors.grey)),
                ],
              ),
            )
          else
            ...[
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(25, 10, 25, 5),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Discover Places", style: GoogleFonts.montserrat(fontSize: 28, fontWeight: FontWeight.w900, color: const Color(0xFF0D1B1E))),
                      const SizedBox(height: 5),
                      Row(
                        children: [
                          Text("Showing ", style: GoogleFonts.montserrat(color: Colors.grey[600], fontSize: 13)),
                          Text("${listingsList.length} results", style: GoogleFonts.montserrat(color: const Color(0xFF6C63FF), fontSize: 13, fontWeight: FontWeight.w700)),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 25),
                sliver: SliverGrid(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 18,
                    crossAxisSpacing: 18,
                    mainAxisExtent: 260,
                  ),
                  delegate: SliverChildBuilderDelegate(
                        (context, index) => _buildBentoListingCard(listingsList[index]),
                    childCount: listingsList.length,
                  ),
                ),
              ),
            ],
          if (isMoreLoading)
            const SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 20),
                child: Center(child: CircularProgressIndicator(strokeWidth: 2, color: Color(0xFF6C63FF))),
              ),
            ),

          const SliverToBoxAdapter(child: SizedBox(height: 50)),
        ],
      ),
    );
  }

  Widget _buildBentoListingCard(AllListingsData item) {
    return GestureDetector(
      onTap: () => Get.to(() => AllListingDetailScreen(listId: item.id,)),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(25),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF0D1B1E).withOpacity(0.04),
              blurRadius: 15,
              offset: const Offset(0, 8),
            )
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AspectRatio(
              aspectRatio: 1,
              child: Container(
                margin: const EdgeInsets.all(8),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.network(
                    item.imageUrl ?? "",
                    fit: BoxFit.cover,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Shimmer.fromColors(
                        baseColor: Colors.grey[300]!,
                        highlightColor: Colors.grey[100]!,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                      );
                    },
                    errorBuilder: (c, e, s) => Container(
                      color: Colors.grey[100],
                      child: const Icon(Icons.broken_image_outlined, color: Colors.grey),
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(15, 5, 15, 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.categoryName?.toUpperCase() ?? "CATEGORY",
                          style: GoogleFonts.montserrat(
                            fontSize: 9,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF6C63FF),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          item.listingTitle ?? "No Title",
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.montserrat(
                            fontWeight: FontWeight.w800,
                            fontSize: 13,
                            height: 1.2,
                          ),
                        ),
                      ],
                    ),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.star_rounded, color: Colors.orange, size: 16),
                            const SizedBox(width: 2),
                            Text(
                                item.rating ?? "0.0",
                                style: GoogleFonts.montserrat(fontWeight: FontWeight.w800, fontSize: 11)
                            ),
                          ],
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFFEBF2),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            item.cityName ?? "City",
                            style: GoogleFonts.montserrat(
                              color: const Color(0xFFFF4081),
                              fontWeight: FontWeight.w900,
                              fontSize: 9,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
