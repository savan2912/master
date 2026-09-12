import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gotilo_new/Api/ApiCalls.dart';
import 'package:gotilo_new/Api/Request/User/Deal/RequestCrackedDeal.dart';
import 'package:gotilo_new/Api/Request/User/Deal/RequestUserDeal.dart';
import 'package:gotilo_new/Api/Response/User/Deal/ResponseCrackedDeal.dart';
import 'package:gotilo_new/Api/Response/User/Deal/ResponseUserDeal.dart';
import 'package:gotilo_new/Constant/AppPref.dart';
import 'package:gotilo_new/CustomeWidgets/CustomAppbar.dart';
import 'package:gotilo_new/CustomeWidgets/SharedWidgets.dart';
import 'package:gotilo_new/MyApplication/MyApplication.dart';
import 'package:intl/intl.dart';
import '../../../CustomeWidgets/CustomDrawer.dart';
import '../../../CustomeWidgets/CustomLoader.dart';

class UserDealsScreen extends StatefulWidget {
  const UserDealsScreen({super.key});

  @override
  State<UserDealsScreen> createState() => _DealsScreenState();
}

class _DealsScreenState extends State<UserDealsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  List<UserDeal> userDeal = [];
  final ScrollController _scrollControllerActive = ScrollController();
  int counterActive = 0;
  bool isLoadingActive = false;
  bool hasMoreActive = true;
  String searchQuery = "";

  List<CrackedDeal> crackedDeal = [];
  final ScrollController _scrollControllerCracked = ScrollController();
  int counterCracked = 0;
  bool isLoadingCracked = false;
  bool hasMoreCracked = true;

  final Color primaryDark = const Color(0xFF1A1C1E);
  final Color accentGold = const Color(0xFFC5A358);
  final Color surfaceLight = const Color(0xFFF8F9FA);

  ValueNotifier<bool> isApiComplete = ValueNotifier(false);
  bool showSearch = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);

    _tabController.addListener(() {
      setState(() {
        showSearch = _tabController.index == 0;
      });
    });

    callUserDeal();
    callCrackedDeal();

    _scrollControllerActive.addListener(() {
      if (_scrollControllerActive.position.pixels >=
          _scrollControllerActive.position.maxScrollExtent - 200) {
        if (!isLoadingActive && hasMoreActive) _loadMoreActive();
      }
    });

    _scrollControllerCracked.addListener(() {
      if (_scrollControllerCracked.position.pixels >=
          _scrollControllerCracked.position.maxScrollExtent - 200) {
        if (!isLoadingCracked && hasMoreCracked) _loadMoreCracked();
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _scrollControllerActive.dispose();
    _scrollControllerCracked.dispose();
    super.dispose();
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
      key: _scaffoldKey,
      backgroundColor: surfaceLight,
      appBar: CustomAppBar(
        title: "MY DEALS",
        showSearchIcon: showSearch,
        onSearchChanged: (val) {
          searchQuery = val;
          callUserDeal();
        },
        showAction: false,
        onMenuTap: () => _scaffoldKey.currentState?.openDrawer(),
      ),
      drawer: const CustomDrawer(initialRoute: 'user.deals'),
      body: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 1440),
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.symmetric(
                  horizontal: horizontalPadding,
                  vertical: 8,
                ),
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: primaryDark.withValues(alpha: 0.05),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: TabBar(
                  controller: _tabController,
                  indicatorSize: TabBarIndicatorSize.tab,
                  indicator: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: primaryDark,
                  ),
                  labelColor: Colors.white,
                  unselectedLabelColor: primaryDark.withValues(alpha: 0.5),
                  labelStyle: GoogleFonts.montserrat(
                    fontWeight: FontWeight.w700,
                    fontSize: 13,
                  ),
                  unselectedLabelStyle: GoogleFonts.montserrat(
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                  ),
                  dividerColor: Colors.transparent,
                  tabs: const [
                    Tab(text: "Active Deals"),
                    Tab(text: "Cracked Deals"),
                  ],
                ),
              ),
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    _buildActiveDealsTab(crossAxisCount, horizontalPadding),
                    _buildCrackedDealsTab(crossAxisCount, horizontalPadding),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActiveDealsTab(int crossAxisCount, double horizontalPadding) {
    return RefreshIndicator(
      onRefresh: () async => callUserDeal(),
      color: primaryDark,
      child: ValueListenableBuilder(
        valueListenable: isApiComplete,
        builder: (context, apiDone, child) {
          if (!apiDone && counterActive == 0) {
            return const Center(
              child: CustomLoader(message: "Loading Deals.."),
            );
          }
          if (userDeal.isEmpty) return _buildEmptyState();

          return GridView.builder(
            controller: _scrollControllerActive,
            padding: EdgeInsets.fromLTRB(
              horizontalPadding,
              10,
              horizontalPadding,
              20,
            ),
            physics: const AlwaysScrollableScrollPhysics(
              parent: BouncingScrollPhysics(),
            ),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: crossAxisCount,
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
              mainAxisExtent: 135,
            ),
            itemCount: userDeal.length + (hasMoreActive ? 1 : 0),
            itemBuilder: (context, index) {
              if (index < userDeal.length) {
                return _buildDealCard(
                  userDeal[index].discountValue ?? "0",
                  userDeal[index].listingTitle,
                  userDeal[index].dealName,
                  userDeal[index].endDate,
                  userDeal[index].status == 0 ? "Pending" : "Complete",
                );
              }
              return _buildLoader();
            },
          );
        },
      ),
    );
  }

  Widget _buildCrackedDealsTab(int crossAxisCount, double horizontalPadding) {
    return RefreshIndicator(
      onRefresh: () async => callCrackedDeal(),
      color: primaryDark,
      child: crackedDeal.isEmpty && !isLoadingCracked
          ? _buildEmptyState()
          : GridView.builder(
              controller: _scrollControllerCracked,
              padding: EdgeInsets.fromLTRB(
                horizontalPadding,
                10,
                horizontalPadding,
                20,
              ),
              physics: const AlwaysScrollableScrollPhysics(
                parent: BouncingScrollPhysics(),
              ),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: crossAxisCount,
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
                mainAxisExtent: 135,
              ),
              itemCount: crackedDeal.length + (hasMoreCracked ? 1 : 0),
              itemBuilder: (context, index) {
                if (index < crackedDeal.length) {
                  return _buildDealCard(
                    crackedDeal[index].discountValue ?? "0",
                    crackedDeal[index].listingTitle,
                    crackedDeal[index].dealName,
                    crackedDeal[index].endDate,
                    "Cracked",
                  );
                }
                return _buildLoader();
              },
            ),
    );
  }

  Widget _buildDealCard(
    String discount,
    String? title,
    String? dealName,
    String? date,
    String status,
  ) {
    return Container(
      decoration: SharedWidgets.cardBoxDecoration(),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: IntrinsicHeight(
          child: Row(
            children: [
              Container(
                width: 80,
                decoration: BoxDecoration(color: primaryDark),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          "$discount%",
                          style: GoogleFonts.montserrat(
                            color: accentGold,
                            fontWeight: FontWeight.w900,
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ),
                    Text(
                      "OFF",
                      style: GoogleFonts.montserrat(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        fontSize: 9,
                        letterSpacing: 1,
                      ),
                    ),
                    const SizedBox(height: 6),
                    ...List.generate(
                      3,
                      (i) => Container(
                        margin: const EdgeInsets.symmetric(vertical: 2),
                        width: 2,
                        height: 6,
                        color: Colors.white24,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              title?.toUpperCase() ?? "SHOP NAME",
                              style: GoogleFonts.montserrat(
                                color: Colors.teal,
                                fontWeight: FontWeight.w800,
                                fontSize: 9,
                                letterSpacing: 1,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          _statusTag(status),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        dealName ?? "Special Deal",
                        style: GoogleFonts.montserrat(
                          fontWeight: FontWeight.w700,
                          fontSize: 13,
                          color: primaryDark,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          if (date != "" && date != null)
                            Icon(
                              Icons.access_time_rounded,
                              size: 12,
                              color: Colors.grey[400],
                            ),
                          const SizedBox(width: 4),
                          if (date != "" && date != null)
                            Expanded(
                              child: Text(
                                "Valid: $date",
                                style: GoogleFonts.montserrat(
                                  color: Colors.grey[600],
                                  fontSize: 10,
                                  fontWeight: FontWeight.w500,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
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
      ),
    );
  }

  Future<void> callUserDeal() async {
    counterActive = 0;
    hasMoreActive = true;
    isApiComplete.value = false;
    userDeal.clear();
    await _fetchActiveDeals();
  }

  Future<void> _loadMoreActive() async {
    if (isLoadingActive) return;
    setState(() => isLoadingActive = true);
    counterActive += 10;
    await _fetchActiveDeals();
    setState(() => isLoadingActive = false);
  }

  Future<void> _fetchActiveDeals() async {
    bool internet = await MyApplication.checkInternet();
    if (internet) {
      try {
        ResponseUserDeal? response = await ApiCalls.callUserDeal(
          RequestUserDeal(
            userId: AppPrefs.userId,
            counter: counterActive.toString(),
            search: searchQuery,
          ),
        );
        if (response != null &&
            response.result!.toLowerCase().contains("pass")) {
          if (response.data != null && response.data!.isNotEmpty) {
            userDeal.addAll(response.data!);
            if (response.data!.length < 10) hasMoreActive = false;
          } else {
            hasMoreActive = false;
          }
        }

        // Auto-load more if content doesn't fill screen (common on large screens/tablets)
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (_scrollControllerActive.hasClients &&
              _scrollControllerActive.position.maxScrollExtent < 100 &&
              hasMoreActive &&
              !isLoadingActive) {
            _loadMoreActive();
          }
        });
      } finally {
        isApiComplete.value = true;
      }
    }
  }

  Future<void> callCrackedDeal() async {
    counterCracked = 0;
    hasMoreCracked = true;
    crackedDeal.clear();
    await _fetchCrackedDeals();
  }

  Future<void> _loadMoreCracked() async {
    if (isLoadingCracked) return;
    setState(() => isLoadingCracked = true);
    counterCracked += 10;
    await _fetchCrackedDeals();
    setState(() => isLoadingCracked = false);
  }

  Future<void> _fetchCrackedDeals() async {
    bool internet = await MyApplication.checkInternet();
    if (internet) {
      try {
        ResponseCrackedDeal? response = await ApiCalls.callCrackedDeal(
          RequestCrackedDeal(userId: AppPrefs.userId, counter: counterCracked),
        );
        if (response != null &&
            response.result!.toLowerCase().contains("pass")) {
          if (response.data != null && response.data!.isNotEmpty) {
            crackedDeal.addAll(response.data!);
            if (response.data!.length < 10) hasMoreCracked = false;
          } else {
            hasMoreCracked = false;
          }
        }

        // Auto-load more if content doesn't fill screen (common on large screens/tablets)
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (_scrollControllerCracked.hasClients &&
              _scrollControllerCracked.position.maxScrollExtent < 100 &&
              hasMoreCracked &&
              !isLoadingCracked) {
            _loadMoreCracked();
          }
        });
      } finally {
        setState(() {});
      }
    }
  }

  Widget _buildLoader() => hasMoreActive || hasMoreCracked
      ? Padding(
          padding: const EdgeInsets.all(20),
          child: Center(
            child: CircularProgressIndicator(
              strokeWidth: 3,
              color: primaryDark,
            ),
          ),
        )
      : const SizedBox();

  Widget _statusTag(String status) {
    bool isPending = status.toLowerCase() == "pending";
    bool isCracked = status.toLowerCase() == "cracked";
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: isCracked
            ? accentGold.withValues(alpha: 0.1)
            : (isPending
                  ? Colors.orange.withValues(alpha: 0.1)
                  : Colors.green.withValues(alpha: 0.1)),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        status.toUpperCase(),
        style: GoogleFonts.montserrat(
          color: isCracked
              ? Colors.teal
              : (isPending ? Colors.orange[800] : Colors.green[800]),
          fontSize: 8,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }

  Widget _buildEmptyState() => Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.confirmation_number_outlined,
          size: 70,
          color: accentGold.withValues(alpha: 0.2),
        ),
        const SizedBox(height: 16),
        Text(
          "No deals found",
          style: GoogleFonts.montserrat(
            color: primaryDark.withValues(alpha: 0.5),
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    ),
  );
}
