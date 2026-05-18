
import 'dart:async';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shimmer/shimmer.dart';
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

class DealsScreen extends StatefulWidget {
  const DealsScreen({super.key});

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
      backgroundColor:ModernHeritageApp.appBg,
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
                style: GoogleFonts.montserrat(
                  letterSpacing: 2,
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
      padding: const EdgeInsets.only(top: 10, bottom: 30),
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
      padding: const EdgeInsets.only(top: 10, bottom: 30),
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
      name: deal.dealName ?? "",
      desc: deal.dealDesc ?? "",
      date: deal.endDate ?? "",
        id: deal.id.toString()
    );
  }

  Widget _buildHighImpactNearByDealCard(NearbyDeals deal) {
    return _baseDealCard(
      imageUrl: deal.templateImage ?? "",
      name: deal.dealName ?? "",
      desc: deal.dealDesc ?? "",
      date: deal.endDate ?? "",
      id: deal.id.toString() ?? ""
    );
  }

  Widget _baseDealCard({required String imageUrl, required String name, required String desc, required String date,required String id}) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(40),
        boxShadow: [BoxShadow(color: const Color(0xFF0D1B1E).withOpacity(0.06), blurRadius: 30, offset: const Offset(0, 15))],
      ),
      child: Column(
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(40)),
                child: CachedNetworkImage(
                  imageUrl: imageUrl,
                  height: 230, width: double.infinity, fit: BoxFit.cover,
                  memCacheWidth: 600,
                  placeholder: (context, url) => Shimmer.fromColors(
                    baseColor: Colors.grey[300]!,
                    highlightColor: Colors.grey[100]!,
                    child: Container(color: Colors.white),
                  ),
                ),
              ),
              Positioned(
                top: 20, left: 20,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(colors: [Color(0xFFFF5252), Color(0xFFFF1744)]),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(name, style: GoogleFonts.montserrat(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w900)),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(25),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(desc, style: GoogleFonts.montserrat(color: const Color(0xFF0D1B1E), fontSize: 18, fontWeight: FontWeight.w900)),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.timer_outlined, color: Colors.orange, size: 16),
                    const SizedBox(width: 6),
                    Text(date, style: GoogleFonts.montserrat(color: Colors.orange, fontSize: 12, fontWeight: FontWeight.w700)),
                  ],
                ),
                const SizedBox(height: 25),
                _buildCrackButton(dealId: id),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCrackButton({String? dealId=""}) {
    return GestureDetector(
      onTap: () {
        if(AppPrefs.userId != ""){
          _callCrackDeal(dealId:dealId);
        }else{
          SharedWidgets.showTopSnackBar(context, message: "Login First");
        }
      },
      child: Container(
        width: double.infinity, height: 58,
        decoration: BoxDecoration(color: const Color(0xFF1A1A1A), borderRadius: BorderRadius.circular(20)),
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("CRACK THE DEAL", style: GoogleFonts.montserrat(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w900, letterSpacing: 1.5)),
              const SizedBox(width: 10),
              const Icon(Icons.local_fire_department_rounded, color: Colors.orangeAccent, size: 20),
            ],
          ),
        ),
      ),
    );
  }

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

  Future<void> _callCrackDeal({String? dealId=""}) async {
    try {
      bool internet = await MyApplication.checkInternet();
      if(internet)
      {
        ResponseCrackDeal? response = await ApiCalls.callCrackDeal(RequestCrackDeal(
            userId: AppPrefs.userId,
            dealId: dealId
        ));
        if (response != null &&
            response.result != null &&
            response.result!.isNotEmpty &&
            response.result!.toLowerCase().contains("pass")) {
          Get.to(()=> const UserDealsScreen());
          SharedWidgets.showTopSnackBar(context, message: response.message!);
        } else {
          SharedWidgets.showTopSnackBar(context, message: response!.message!);
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