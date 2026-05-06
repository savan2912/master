import 'dart:async';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:gotilo_new/Constant/Constants.dart';
import 'package:gotilo_new/Screens/AllCollection/CollectionDetailScreen.dart';
import 'package:shimmer/shimmer.dart';
import 'package:gotilo_new/Api/Request/AllService/RequestAllService.dart';
import 'package:gotilo_new/Api/Response/AllService/ResponseAllService.dart';
import '../../Api/ApiCalls.dart';
import '../../MyApplication/MyApplication.dart';

class OurFeaturedServicesScreen extends StatefulWidget {
  const OurFeaturedServicesScreen({super.key});

  @override
  State<OurFeaturedServicesScreen> createState() =>
      _OurFeaturedServicesScreenState();
}

class _OurFeaturedServicesScreenState extends State<OurFeaturedServicesScreen> {
  ValueNotifier<bool> isApiComplete = ValueNotifier(false);
  ValueNotifier<bool> isLoadingMore = ValueNotifier(false);
  ValueNotifier<bool> isSearching = ValueNotifier(false);

  List<AllService> services = [];
  int currentCounter = 0;
  bool hasMoreData = true;
  final ScrollController _scrollController = ScrollController();
  bool isSearchActive = false;
  TextEditingController searchController = TextEditingController();
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    callAllService(isFirstLoad: true);
    print("User Lat :- ${Constants.userLat}");
    print("User Long :- ${Constants.userLong}");
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 200) {
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
    isApiComplete.dispose();
    isLoadingMore.dispose();
    isSearching.dispose();
    super.dispose();
  }

  void onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      callAllService(isFirstLoad: true, searchQuery: query);
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
              icon: const Icon(
                Icons.arrow_back_ios_new,
                color: Color(0xFF0D1B1E),
                size: 18,
              ),
              onPressed: () => Navigator.pop(context),
            ),
            actions: [
              IconButton(
                onPressed: () {
                  setState(() {
                    isSearchActive = !isSearchActive;
                    if (!isSearchActive) {
                      searchController.clear();
                      callAllService(isFirstLoad: true);
                    }
                  });
                },
                icon: Icon(
                  isSearchActive ? Icons.close : Icons.search,
                  color: const Color(0xFF0D1B1E),
                ),
              ),
            ],
            centerTitle: true,
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
                          cursorColor: const Color(0xFF00ACC1),
                          cursorHeight: 16,
                          style: GoogleFonts.montserrat(
                            fontSize: 13,
                            color: Colors.black,
                          ),
                          decoration: InputDecoration(
                            hintText: "Search services...",
                            hintStyle: GoogleFonts.montserrat(
                              fontSize: 11,
                              color: Colors.grey,
                            ),
                            filled: true,
                            fillColor: Colors.grey[200],
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 0,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(25),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                      ),
                    )
                  : Text(
                      "FEATURED SERVICES",
                      style: GoogleFonts.montserrat(
                        color: const Color(0xFF0D1B1E),
                        fontWeight: FontWeight.w900,
                        fontSize: 14,
                        letterSpacing: 2,
                      ),
                    ),
            ),
          ),

          ValueListenableBuilder(
            valueListenable: isSearching,
            builder: (context, loading, child) {
              if (loading) {
                return const SliverFillRemaining(
                  child: Center(
                    child: CircularProgressIndicator(color: Color(0xFF00ACC1)),
                  ),
                );
              }

              if (services.isEmpty && isApiComplete.value) {
                return const SliverFillRemaining(
                  child: Center(child: Text("No services found.")),
                );
              }

              return SliverPadding(
                padding: const EdgeInsets.only(left: 45, right: 20, top: 20),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate((context, index) {
                    if (index == services.length) {
                      return ValueListenableBuilder(
                        valueListenable: isLoadingMore,
                        builder: (context, loadingMore, child) {
                          return loadingMore
                              ? const Padding(
                                  padding: EdgeInsets.symmetric(vertical: 20),
                                  child: Center(
                                    child: CircularProgressIndicator(
                                      color: Color(0xFF00ACC1),
                                      strokeWidth: 2,
                                    ),
                                  ),
                                )
                              : const SizedBox.shrink();
                        },
                      );
                    }
                    return _buildModernServiceCard(services[index]);
                  }, childCount: services.length + 1),
                ),
              );
            },
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 50)),
        ],
      ),
    );
  }

  Widget _buildModernServiceCard(AllService service) {
    return GestureDetector(
      onTap: () {
        Get.to(() => CollectionDetailScreen(categoryId: service.id));
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 40),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(75, 25, 20, 25),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  bottomLeft: Radius.circular(20),
                  topRight: Radius.circular(50),
                  bottomRight: Radius.circular(50),
                ),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF0D1B1E).withOpacity(0.06),
                    blurRadius: 30,
                    offset: const Offset(0, 15),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          (service.name ?? "").toUpperCase(),
                          style: GoogleFonts.montserrat(
                            color: const Color(0xFF1A1A1A),
                            fontSize: 16,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 0.5,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          service.slug ?? "",
                          style: GoogleFonts.montserrat(
                            color: Colors.grey[600],
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            height: 1.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 10),
                  Container(
                    height: 35,
                    width: 35,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: const Color(0xFF1A1A1A).withOpacity(0.05),
                    ),
                    child: const Icon(
                      Icons.chevron_right_rounded,
                      color: Color(0xFF1A1A1A),
                      size: 22,
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              left: -35,
              top: 10,
              bottom: 10,
              child: Container(
                width: 90,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF00ACC1).withOpacity(0.25),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(25),
                  child: CachedNetworkImage(
                    imageUrl: service.serviceImage ?? "",
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Shimmer.fromColors(
                      baseColor: Colors.grey[300]!,
                      highlightColor: Colors.grey[100]!,
                      child: Container(color: Colors.white),
                    ),
                    errorWidget: (context, url, error) => Container(
                      color: Colors.grey[200],
                      child: const Icon(Icons.error, size: 20),
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
    await _callAllService(searchQuery: searchController.text);
  }

  Future<void> callAllService({
    bool isFirstLoad = false,
    String searchQuery = "",
  }) async {
    if (isFirstLoad) {
      isApiComplete.value = false;
      isSearching.value = true;
      currentCounter = 0;
      services.clear();
      hasMoreData = true;
    }
    _callAllService(searchQuery: searchQuery);
  }

  Future<void> _callAllService({String searchQuery = ""}) async {
    try {
      bool internet = await MyApplication.checkInternet();
      if (!internet) {
        isApiComplete.value = true;
        isSearching.value = false;
        isLoadingMore.value = false;
        return;
      }

      ResponseAllService? response = await ApiCalls.callAllService(
        RequestAllService(
          search: searchQuery,
          counter: currentCounter.toString(),
        ),
      );

      if (response != null &&
          response.result != null &&
          response.result!.toLowerCase().contains("pass") &&
          response.data != null) {
        if (response.data!.isEmpty) {
          hasMoreData = false;
        } else {
          services.addAll(response.data!);
          if (response.data!.length < 10) {
            hasMoreData = false;
          }
        }
      } else {
        hasMoreData = false;
      }
    } catch (e) {
      log("AllService Error: $e");
    } finally {
      isApiComplete.value = true;
      isSearching.value = false;
      isLoadingMore.value = false;
      if (mounted) {
        setState(() {});
      }
    }
  }
}
