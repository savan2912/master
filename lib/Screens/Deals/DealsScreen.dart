import 'dart:async';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shimmer/shimmer.dart';
import 'package:marquee/marquee.dart'; // Marquee પેકેજ ઈમ્પોર્ટ કર્યું
import 'package:gotilo_new/Api/Request/AllDeals/RequestAllDeals.dart';
import 'package:gotilo_new/Api/Response/AllDeals/ResponseAllDeals.dart';
import 'package:gotilo_new/Constant/Constants.dart';
import '../../Api/ApiCalls.dart';
import '../../Api/Request/CrackDeal/RequestCrackDeal.dart';
import '../../Api/Response/CrackDeal/ResponseCrackDeal.dart';
import '../../Constant/AppPref.dart';
import '../../CustomeWidgets/SharedWidgets.dart';
import '../../MyApplication/MyApplication.dart';
import '../HeritageHomeScreen.dart';
import '../User/Deals/DealsScreen.dart';

class _T {
  static const Color white = Colors.white;
  static const Color red = Color(0xFFFF2A44); // બ્રાઇટ રેડ ગ્લો કલર
  static const Color border = Color(0xEAEAEAFF);
  static const Color textHi = Color(0xFF0D1B1E);
  static const Color textMid = Color(0xFF55666A);
  static const Color textLow = Color(0xFF88999E);
  static const Color bg = Color(0xFFF5F7F8);
  static const Color cyan = Color(0xFF00B4D8);
  static const Color cyanDim = Color(0xFF0077B6);
  static const Color surface2 = Color(0xFFEEEEEE);
}

class DealsScreen extends StatefulWidget {
  bool? isHome = false;
  DealsScreen({super.key, required this.isHome});

  @override
  State<DealsScreen> createState() => _DealsScreenState();
}

class _DealsScreenState extends State<DealsScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final ScrollController _scrollController = ScrollController();

  ValueNotifier<bool> isApiComplete = ValueNotifier(false);
  ValueNotifier<bool> isLoadingMore = ValueNotifier(false);
  ValueNotifier<bool> isSearching = ValueNotifier(false);

  List<Deals> allDeals = [];
  List<NearbyDeals> nearbyDeals = [];

  int currentCounter = 0;
  bool hasMoreData = true;
  bool isSearchActive = false;
  TextEditingController searchController = TextEditingController();
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    callAllDeals(isFirstLoad: true);

    _scrollController.addListener(() {
      if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 200) {
        if (!isLoadingMore.value && hasMoreData && isApiComplete.value) {
          loadMoreData();
        }
      }
    });

    _tabController.addListener(() {
      if (_tabController.indexIsChanging) {
        callAllDeals(isFirstLoad: true, searchQuery: searchController.text);
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _scrollController.dispose();
    searchController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  void onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      callAllDeals(isFirstLoad: true, searchQuery: query);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
      body: CustomScrollView(
        controller: _scrollController,
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverAppBar(
            expandedHeight: 180,
            pinned: true,
            backgroundColor: const Color(0xFFFDFDFD),
            surfaceTintColor: const Color(0xFFFDFDFD),
            elevation: 0,
            leading: !widget.isHome! ? IconButton(
              icon: const Icon(Icons.arrow_back_ios_new, color: Color(0xFF0D1B1E), size: 18),
              onPressed: () => Navigator.pop(context),
            ) : const SizedBox(),
            actions: [
              IconButton(
                onPressed: () {
                  setState(() {
                    isSearchActive = !isSearchActive;
                    if (!isSearchActive) {
                      searchController.clear();
                      callAllDeals(isFirstLoad: true);
                    }
                  });
                },
                icon: Icon(isSearchActive ? Icons.close : Icons.search, color: const Color(0xFF0D1B1E)),
              )
            ],
            flexibleSpace: FlexibleSpaceBar(
              centerTitle: true,
              titlePadding: EdgeInsets.only(bottom: isSearchActive ? 85 : 75),
              title: isSearchActive
                  ? Padding(
                padding: const EdgeInsets.symmetric(horizontal: 50),
                child: SizedBox(
                  height: 35,
                  child: TextField(
                    controller: searchController,
                    onChanged: onSearchChanged,
                    autofocus: true,
                    style: GoogleFonts.montserrat(fontSize: 13, color: Colors.black),
                    decoration: InputDecoration(
                      hintText: "Search deals...",
                      hintStyle: GoogleFonts.montserrat(fontSize: 11, color: Colors.grey),
                      filled: true,
                      fillColor: Colors.grey[200],
                      contentPadding: const EdgeInsets.symmetric(horizontal: 15),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(20), borderSide: BorderSide.none),
                    ),
                  ),
                ),
              )
                  : Text(
                "EXCLUSIVE DEALS",
                style: GoogleFonts.poppins(
                  letterSpacing: 1,
                  fontWeight: FontWeight.w900,
                  fontSize: 14,
                  color: const Color(0xFF0D1B1E),
                ),
              ),
            ),
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(70),
              child: Container(
                margin: const EdgeInsets.fromLTRB(25, 0, 25, 15),
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(color: const Color(0xFFF1F1F1), borderRadius: BorderRadius.circular(25)),
                child: TabBar(
                  controller: _tabController,
                  dividerColor: Colors.transparent,
                  indicatorSize: TabBarIndicatorSize.tab,
                  indicator: BoxDecoration(
                    color: const Color(0xFF1A1A1A),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 10, offset: const Offset(0, 4))],
                  ),
                  labelColor: Colors.white,
                  unselectedLabelColor: const Color(0xFF666666),
                  labelStyle: GoogleFonts.montserrat(fontWeight: FontWeight.w800, fontSize: 11),
                  tabs: const [Tab(text: "ALL DEALS"), Tab(text: "NEARBY DEALS")],
                ),
              ),
            ),
          ),

          ValueListenableBuilder(
            valueListenable: isSearching,
            builder: (context, loading, child) {
              if (loading) {
                return const SliverFillRemaining(child: Center(child: CircularProgressIndicator(color: Color(0xFF0D1B1E))));
              }
              return SliverFillRemaining(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    _buildDealsList(allDeals),
                    _buildNearByDealsList(nearbyDeals),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildDealsList(List<Deals> data) {
    if (data.isEmpty && isApiComplete.value) return const Center(child: Text("No Deals Found"));
    return ListView.builder(
      padding: EdgeInsets.only(top: 10, left: 16, right: 16, bottom: widget.isHome! ? 95 : 30),
      itemCount: data.length + 1,
      physics: const BouncingScrollPhysics(),
      itemBuilder: (context, index) {
        if (index == data.length) return _buildLoadMoreIndicator();
        return _buildHighImpactDealCard(data[index]);
      },
    );
  }

  Widget _buildNearByDealsList(List<NearbyDeals> data) {
    if (data.isEmpty && isApiComplete.value) return const Center(child: Text("No Nearby Deals Found"));
    return ListView.builder(
      padding: EdgeInsets.only(top: 10, left: 16, right: 16, bottom: widget.isHome! ? 95 : 30),
      itemCount: data.length + 1,
      physics: const BouncingScrollPhysics(),
      itemBuilder: (context, index) {
        if (index == data.length) return _buildLoadMoreIndicator();
        return _buildHighImpactNearByDealCard(data[index]);
      },
    );
  }

  Widget _buildLoadMoreIndicator() {
    return ValueListenableBuilder(
      valueListenable: isLoadingMore,
      builder: (context, loading, child) {
        return loading
            ? const Padding(padding: EdgeInsets.all(20), child: Center(child: CircularProgressIndicator(strokeWidth: 2)))
            : const SizedBox.shrink();
      },
    );
  }

  Widget _buildHighImpactDealCard(Deals deal) {
    return _baseDealCard(
        imageUrl: deal.templateImage ?? "",
        name: deal.dealName ?? "OFFER",
        desc: deal.dealDesc ?? "",
        startDate: deal.startDate ?? "-",
        endDate: deal.endDate ?? "-",
        cityName: deal.cityName ?? "Location",
        listingTitle: deal.listingTitle ?? "Shop Name",
        id: deal.id.toString()
    );
  }

  Widget _buildHighImpactNearByDealCard(NearbyDeals deal) {
    return _baseDealCard(
        imageUrl: deal.templateImage ?? "",
        name: deal.dealName ?? "OFFER",
        desc: deal.dealDesc ?? "",
        startDate: deal.startDate ?? "-",
        endDate: deal.endDate ?? "-",
        cityName: deal.cityName ?? "Location",
        listingTitle: deal.listingTitle ?? "Shop Name",
        id: deal.id.toString()
    );
  }

  // ════════════ COMPACT PREVENTING TEXT OVERFLOW CARD DESIGN ════════════
  Widget _baseDealCard({
    required String imageUrl,
    required String name,
    required String desc,
    required String startDate,
    required String endDate,
    required String cityName,
    required String listingTitle,
    required String id
  }) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: _T.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: _T.border.withOpacity(0.7)),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0D1117).withOpacity(0.04),
            blurRadius: 16,
            offset: const Offset(0, 8),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. IMAGE & HIGH-HIGHLIGHTED MARQUEE TAG
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
            child: Stack(
              children: [
                CachedNetworkImage(
                  imageUrl: imageUrl,
                  height: 145, // કમ્પેક્ટ હાઇટ
                  width: double.infinity,
                  fit: BoxFit.cover,
                  memCacheWidth: 600,
                  placeholder: (context, url) => Shimmer.fromColors(
                    baseColor: Colors.grey[300]!,
                    highlightColor: Colors.grey[100]!,
                    child: Container(color: Colors.white),
                  ),
                  errorWidget: (_, __, ___) => Container(height: 145, color: _T.surface2),
                ),
                Positioned(
                  top: 10,
                  left: 10,
                  right: 10,
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: _T.red,
                        borderRadius: BorderRadius.circular(30),
                        boxShadow: [
                          BoxShadow(
                            color: _T.red.withOpacity(0.45),
                            blurRadius: 10,
                            offset: const Offset(0, 3),
                          )
                        ],
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.local_offer_rounded, color: Colors.white, size: 11),
                          const SizedBox(width: 5),
                          Flexible(
                            child: SizedBox(
                              height: 14,
                              width: 140, // ટેક્સ્ટ કપાશે નહીં, મસ્ત મારક્યુ થશે
                              child: Marquee(
                                text: name.toUpperCase(),
                                style: GoogleFonts.montserrat(
                                  color: Colors.white,
                                  fontSize: 10,
                                  fontWeight: FontWeight.w900,
                                  letterSpacing: 1.2,
                                ),
                                scrollAxis: Axis.horizontal,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                blankSpace: 20.0,
                                velocity: 30.0,
                                pauseAfterRound: const Duration(seconds: 1),
                                startPadding: 0.0,
                                accelerationDuration: const Duration(seconds: 1),
                                accelerationCurve: Curves.linear,
                                decelerationDuration: const Duration(milliseconds: 500),
                                decelerationCurve: Curves.easeOut,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // 2. CONTENT DETAILS SECTION
          Padding(
            padding: const EdgeInsets.all(14), // કમ્પેક્ટ પેડિંગ
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ડીલ ડિસ્ક્રિપ્શન
                Text(
                  desc,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.roboto(
                    color: _T.textHi,
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                    height: 1.3,
                  ),
                ),
                const SizedBox(height: 10),
                Container(height: 1, color: _T.border.withOpacity(0.5)),
                const SizedBox(height: 10),

                // શોપ નામ
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(top: 2),
                      height: 16,
                      width: 16,
                      child: const Icon(Icons.storefront_rounded, color: _T.cyan, size: 16), // ઓલ્ટરનેટિવ જો એસેટ ના વાપરવો હોય
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        listingTitle,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.montserrat(
                          color: _T.textHi,
                          fontSize: 14,
                          fontWeight: FontWeight.w800,
                          height: 1.3,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 10),
                Container(height: 1, color: _T.border.withOpacity(0.5)),
                const SizedBox(height: 10),

                // ડેટ સેક્શન (સ્ટાર્ટ અને એન્ડ ડેટ)
                Row(
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          const Icon(Icons.calendar_today_rounded, color: _T.textMid, size: 13),
                          const SizedBox(width: 6),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("START DATE", style: GoogleFonts.montserrat(fontSize: 8, fontWeight: FontWeight.w700, color: _T.textLow, letterSpacing: 0.5)),
                                Text(
                                  startDate,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: GoogleFonts.montserrat(color: _T.textMid, fontSize: 11, fontWeight: FontWeight.w600),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(width: 1, height: 22, color: _T.border),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Row(
                        children: [
                          const Icon(Icons.calendar_month_rounded, color: _T.red, size: 13),
                          const SizedBox(width: 6),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("END DATE", style: GoogleFonts.montserrat(fontSize: 8, fontWeight: FontWeight.w700, color: _T.red.withOpacity(0.7), letterSpacing: 0.5)),
                                Text(
                                  endDate,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: GoogleFonts.montserrat(color: _T.textHi, fontSize: 11, fontWeight: FontWeight.w600),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                // સિટી / લોકેશન
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: _T.bg,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.location_on_rounded, color: _T.cyan, size: 12),
                      const SizedBox(width: 4),
                      Flexible(
                        child: Text(
                          cityName,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.montserrat(
                            color: _T.textMid,
                            fontSize: 10.5,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 14),

                // CRACK THE DEAL BUTTON
                _buildCrackButton(dealId: id),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCrackButton({String? dealId = ""}) {
    return GestureDetector(
      onTap: () {
        if (AppPrefs.userId != "") {
          _callCrackDeal(dealId: dealId);
        } else {
          SharedWidgets.showTopSnackBar(context, message: "Login First",title: "fail");
        }
      },
      child: Container(
        width: double.infinity,
        height: 42, // કમ્પેક્ટ હાઇટ
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [_T.cyan, _T.cyanDim],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: _T.cyan.withOpacity(0.3),
              blurRadius: 10,
              offset: const Offset(0, 4),
            )
          ],
        ),
        alignment: Alignment.center,
        child: Text(
          "CRACK THE DEAL",
          style: GoogleFonts.montserrat(
            color: Colors.white,
            fontSize: 11,
            fontWeight: FontWeight.w900,
            letterSpacing: 1.2,
          ),
        ),
      ),
    );
  }

  // API Call લોજિક અગાઉ મુજબ યથાવત રાખેલું છે...
  Future<void> loadMoreData() async {
    isLoadingMore.value = true;
    currentCounter += 10;
    await _callAllDeals(searchQuery: searchController.text);
  }

  Future<void> callAllDeals({bool isFirstLoad = false, String searchQuery = ""}) async {
    if (isFirstLoad) {
      isApiComplete.value = false;
      isSearching.value = true;
      currentCounter = 0;
      allDeals.clear();
      nearbyDeals.clear();
      hasMoreData = true;
    }
    _callAllDeals(searchQuery: searchQuery);
  }

  Future<void> _callAllDeals({String searchQuery = ""}) async {
    try {
      bool internet = await MyApplication.checkInternet();
      if (!internet) {
        isApiComplete.value = true;
        isSearching.value = false;
        isLoadingMore.value = false;
        return;
      }

      ResponseAllDeals? response = await ApiCalls.callAllDeals(
          RequestAllDeals(
            counter: currentCounter.toString(),
            search: searchQuery,
            latitude: Constants.userLat.toString(),
            longitude: Constants.userLong.toString(),
          ));

      if (response != null && response.result != null && response.result!.toLowerCase().contains("pass") && response.data != null) {
        var newDataDeals = response.data!.deals ?? [];
        var newDataNearby = response.data!.nearbyDealsData ?? [];

        if (newDataDeals.isEmpty && newDataNearby.isEmpty) {
          hasMoreData = false;
        } else {
          allDeals.addAll(newDataDeals);
          nearbyDeals.addAll(newDataNearby);
          if (newDataDeals.length < 10 && newDataNearby.length < 10) {
            hasMoreData = false;
          }
        }
      } else {
        hasMoreData = false;
      }
    } catch (e) {
      log("Deals Error: $e");
    } finally {
      isApiComplete.value = true;
      isSearching.value = false;
      isLoadingMore.value = false;
      if (mounted) setState(() {});
    }
  }

  Future<void> _callCrackDeal({String? dealId = ""}) async {
    try {
      bool internet = await MyApplication.checkInternet();
      if (internet) {
        ResponseCrackDeal? response = await ApiCalls.callCrackDeal(RequestCrackDeal(
            userId: AppPrefs.userId,
            dealId: dealId
        ));
        if (response != null &&
            response.result != null &&
            response.result!.isNotEmpty &&
            response.result!.toLowerCase().contains("pass")) {
          Get.to(() => const UserDealsScreen());
          SharedWidgets.showTopSnackBar(context, message: response.message!,title: "pass");
        } else {
          SharedWidgets.showTopSnackBar(context, message: response!.message!,title: "fail");
        }
      }
    } catch (e) {
      log("HomeBanner Error: $e");
    } finally {
      if (mounted) {
        setState(() {});
      }
    }
  }
}