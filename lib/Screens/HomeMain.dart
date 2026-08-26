import 'dart:developer';
import 'dart:ui';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gotilo_new/Api/Request/BecomeVendor/RequestBecomeVendor.dart';
import 'package:gotilo_new/Api/Request/CrackDeal/RequestCrackDeal.dart';
import 'package:gotilo_new/Api/Response/City/ResponseCity.dart';
import 'package:gotilo_new/Api/Response/Home/ResponseAppLogo.dart';
import 'package:gotilo_new/CustomeWidgets/SharedWidgets.dart';
import 'package:gotilo_new/Screens/AllListing/AllListingDetailScreen.dart';
import 'package:gotilo_new/Screens/Search/SearchScreen.dart';
import 'package:gotilo_new/Screens/User/Dashboard/UserDashboardScreen.dart';
import 'package:gotilo_new/Screens/User/Deals/DealsScreen.dart';
import 'package:marquee/marquee.dart';
import 'package:shimmer/shimmer.dart';
import 'package:url_launcher/url_launcher.dart';
import '../Api/ApiCalls.dart';
import '../Api/Request/Enquiry/RequestAddEnquiry.dart';
import '../Api/Response/Enquiry/ResponseAddEnquiry.dart';
import '../Api/Response/Home/ResponseHome.dart';
import '../Constant/AppPref.dart';
import '../MyApplication/MyApplication.dart';
import 'AllCollection/AllCollectionScreen.dart';
import 'AllCollection/CollectionDetailScreen.dart';
import 'Deals/DealsScreen.dart';
import 'LatestRelease/LatestReleaseScreen.dart';
import 'Login/view/LoginScreen.dart';
import 'NewlyAddedListing/NewlyAddedListing.dart';
import 'OurFeaturedServices/OurFeaturedServicesScreen.dart';

class _T {

  static const bg       = Color(0xFFF5F6FA);
  static const white    = Color(0xFFFFFFFF);
  static const surface2 = Color(0xFFF0F2F8);

  static const cyan     = Color(0xFF7fabb9);
  static const cyanDim  = Color(0xFF00968C);
  static const cyanBg   = Color(0xFFE6F9F8);

  static const amber    = Color(0xFFF59E0B);
  static const red      = Color(0xFFEF4444);
  static const redBg    = Color(0xFFFFF0F0);

  static const textHi   = Color(0xFF0D1117);
  static const textMid  = Color(0xFF6B7280);
  static const textLow  = Color(0xFFB0B8C8);

  static const border   = Color(0xFFE5E8EF);
  static const borderFocus = Color(0xFF00B8AD);
}

// ─────────────────────────────────────────────────────────────────────────────

class HomeMainScreen extends StatefulWidget {
  const HomeMainScreen({super.key});
  @override
  State<HomeMainScreen> createState() => _HomeMainScreenState();
}

class _HomeMainScreenState extends State<HomeMainScreen>
    with TickerProviderStateMixin {

  ValueNotifier<bool> isApiComplete   = ValueNotifier(false);
  ValueNotifier<bool> isDataAvailable = ValueNotifier(false);
  ValueNotifier<bool> isCitySelected  = ValueNotifier(false);

  List<Sliders>?        banner;
  List<Categories>?     homeCollection;
  List<NearbyListings>? homeLatestRelease;
  List<LatestListings>? homeNearListing;
  List<Services>?       homeService;
  List<NearbyDeals>?    homeDeal;

  final TextEditingController _searchController = TextEditingController();
  String selectedCityName = "Select City";
  int    selectedCityId   = 0;
  List<Cities> allCities  = [];

  final PageController _bannerCtrl = PageController(viewportFraction: 0.90);
  int _bannerPage = 0;

  final TextEditingController _emailController  = TextEditingController();
  final TextEditingController _numberController = TextEditingController();
  final TextEditingController _messageController= TextEditingController();
  final TextEditingController _fNameController  = TextEditingController();
  final TextEditingController _lNameController  = TextEditingController();

  String? _appLogo;

  @override
  void initState() {
    super.initState();
    callAppLogo();
    MyApplication.determinePosition();
    WidgetsBinding.instance.addPostFrameCallback((_) => _checkInitialCity());
  }

  @override
  void dispose() {
    _bannerCtrl.dispose();
    _searchController.dispose();
    super.dispose();
  }

  // ══════════════════════════════════════════════════════════════
  //  CITY
  // ══════════════════════════════════════════════════════════════
  Future<void> _checkInitialCity() async {
    await _callCity();

    selectedCityId = AppPrefs.cityId;
    selectedCityName =
    AppPrefs.cityName.isNotEmpty ? AppPrefs.cityName : "Select City";

    if (!mounted) return;

    if (selectedCityId == 0) {
      if (allCities.isNotEmpty) {
        _showCitySheet();
      } else {
        isCitySelected.value = true;
        callHome();
      }
    } else {
      isCitySelected.value = true;
      callHome();
    }
  }
  Future<void> _onCityTap() async {
    if (allCities.isEmpty) {
      await _callCity();
    }

    if (!mounted) return;

    if (allCities.isNotEmpty) {
      _showCitySheet();
    } else {
      SharedWidgets.showTopSnackBar(context, message: "City list not found",title: "fail");
    }
  }
  void _showCitySheet() {
    if (allCities.isEmpty) {
      SharedWidgets.showTopSnackBar(context, message: "City list not found",title: "fail");
      return;
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      useSafeArea: true,
      builder: (ctx) => _CitySelectionSheet(
        allCities: allCities,
        onCitySelected: (id, name) async {
          await AppPrefs.setCity(id, name);
          setState(() {
            selectedCityId = id;
            selectedCityName = name;
          });
          isCitySelected.value = true;
          callHome();
        },
      ),
    ).then((_) {
      if (!isCitySelected.value) {
        isCitySelected.value = true;
        callHome();
      }
    });
  }

  // ══════════════════════════════════════════════════════════════
  //  BUILD
  // ══════════════════════════════════════════════════════════════
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ));
    return SafeArea(
      bottom: true,
      child: Scaffold(
        backgroundColor: _T.bg,
        body: _buildBody(),
      ),
    );
  }

  Widget _buildBody() {
    return ValueListenableBuilder<bool>(
      valueListenable: isCitySelected,
      builder: (_, cityOk, __) {
        if (!cityOk) return const Center(child: _PulseLoader());
        return ValueListenableBuilder<bool>(
          valueListenable: isApiComplete,
          builder: (_, apiDone, __) {
            return RefreshIndicator(
              color: _T.cyan,
              backgroundColor: _T.white,
              edgeOffset: kToolbarHeight + 40,
              onRefresh: callHome,
              child: CustomScrollView(
                physics: const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
                slivers: [
                  _buildAppBar(),
                  if (!apiDone)
                    const SliverFillRemaining(
                        hasScrollBody: false,
                        child: Center(child: _PulseLoader()))
                  else
                    ValueListenableBuilder<bool>(
                      valueListenable: isDataAvailable,
                      builder: (_, dataOk, __) {
                        if (!dataOk) {
                          return SliverFillRemaining(
                            hasScrollBody: false,
                            child: Center(
                              child: Column(mainAxisSize: MainAxisSize.min, children: [
                                const Icon(Icons.cloud_off_rounded, color: _T.textLow, size: 52),
                                const SizedBox(height: 14),
                                Text("No data for $selectedCityName",
                                    style: GoogleFonts.montserrat(
                                        color: _T.textMid, fontSize: 15)),
                              ]),
                            ),
                          );
                        }
                        return SliverToBoxAdapter(child: _buildContent());
                      },
                    ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 30),
        _buildBanner(),
        const SizedBox(height: 40),
        _sectionHeader("COLLECTIONS", () => Get.to(() => const AllCollectionScreen(isHome: false))),
        _buildCollections(),
        const SizedBox(height: 40),
        _sectionHeader("HOT DEALS", () => Get.to(() => DealsScreen(isHome: false))),
        _buildDeals(),
        const SizedBox(height: 40),
        _sectionHeader("LATEST RELEASES", () => Get.to(() => const LatestReleaseScreen())),
        _buildLatestRelease(context),
        const SizedBox(height: 40),
        _sectionHeader("NEWLY ADDED", () => Get.to(() => const NewlyAddedListing())),
        _buildNewlyAdded(),
        const SizedBox(height: 40),
        _sectionHeader("FEATURED SERVICES", () => Get.to(() => const OurFeaturedServicesScreen())),
        _buildServices(),
        const SizedBox(height: 40),
        _buildHowItWorks(),
        const SizedBox(height: 16),
        _buildBecomeVendor(),
        const SizedBox(height: 120),
      ],
    );
  }

  // ══════════════════════════════════════════════════════════════
  //  APP BAR
  // ══════════════════════════════════════════════════════════════

  Widget _buildAppBar() {
    return SliverAppBar(
      expandedHeight: 130,
      pinned: true,
      automaticallyImplyLeading: false,
      backgroundColor: _T.white,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      shadowColor: Colors.black12,
      systemOverlayStyle: SystemUiOverlayStyle.dark,
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1),
        child: Container(height: 1, color: _T.border),
      ),
      title: GestureDetector(
        onTap: _onCityTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          decoration: BoxDecoration(
            color: _T.cyanBg,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(mainAxisSize: MainAxisSize.min, children: [
            const Icon(Icons.location_on_rounded, color: _T.cyan, size: 13),
            const SizedBox(width: 4),
            Text(selectedCityName.toUpperCase(),
                style: GoogleFonts.montserrat(
                    color: _T.cyan, fontSize: 10, fontWeight: FontWeight.w700, letterSpacing: 1.4)),
            const SizedBox(width: 2),
            const Icon(Icons.keyboard_arrow_down_rounded, color: _T.cyan, size: 14),
          ]),
        ),
      ),
      flexibleSpace: FlexibleSpaceBar(
        centerTitle: true,
        titlePadding: const EdgeInsets.only(bottom: 12),
        background: Container(color: _T.white),
        title: SizedBox(
          height: 34,
          child: _appLogo != null && _appLogo!.isNotEmpty
              ? CachedNetworkImage(
            imageUrl: _appLogo!,
            fit: BoxFit.contain,
            placeholder: (context, url) => Shimmer.fromColors(
              baseColor: _T.surface2,
              highlightColor: _T.white,
              child: Container(
                width: 100,
                height: 34,
                decoration: BoxDecoration(
                  color: _T.surface2,
                  borderRadius: BorderRadius.circular(6),
                ),
              ),
            ),
            errorWidget: (context, url, error) => Image.asset(
              "assets/g_logo.png",
              fit: BoxFit.contain,
            ),
          )
              : Shimmer.fromColors(
            baseColor: _T.surface2,
            highlightColor: _T.white,
            child: Container(
              width: 100,
              height: 34,
              decoration: BoxDecoration(
                color: _T.surface2,
                borderRadius: BorderRadius.circular(6),
              ),
            ),
          ),
        ),
      ),
      actions: [
        IconButton(
          onPressed: () => Get.to(() => const SearchScreen()),
          icon: const Icon(Icons.search_rounded, color: _T.textHi, size: 22),
        ),
        GestureDetector(
          onTap: () {
            if (AppPrefs.userId != "") {
              Get.to(() => const Userdashboardscreen());
            } else {
              Get.to(() => const ModernLoginScreen());
            }
          },
          child: Container(
            margin: const EdgeInsets.only(right: 14, top: 10, bottom: 10),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
            decoration: BoxDecoration(
              color: _T.textHi,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(mainAxisSize: MainAxisSize.min, children: [
              const Icon(Icons.person_outline_rounded, color: _T.white, size: 14),
              const SizedBox(width: 5),
              Text(AppPrefs.userId != "" ? "Me" : "Login",
                  style: GoogleFonts.montserrat(
                      color: _T.white, fontSize: 11, fontWeight: FontWeight.w700)),
            ]),
          ),
        ),
      ],
    );
  }

  // ══════════════════════════════════════════════════════════════
  //  BANNER
  // ══════════════════════════════════════════════════════════════

  /*Widget _buildBanner() {
    if (banner == null || banner!.isEmpty) {
      return Shimmer.fromColors(
        baseColor: _T.surface2,
        highlightColor: _T.white,
        child: Container(
          height: 280,
          margin: const EdgeInsets.symmetric(horizontal: 18),
          decoration: BoxDecoration(
            color: _T.surface2,
            borderRadius: BorderRadius.circular(24),
          ),
        ),
      );
    }

    return Column(
      children: [
        SizedBox(
          height: 280,
          child: PageView.builder(
            controller: _bannerCtrl,
            onPageChanged: (i) {
              setState(() => _bannerPage = i);
            },
            physics: const BouncingScrollPhysics(),
            clipBehavior: Clip.none,
            itemCount: banner!.length,
            itemBuilder: (_, i) {
              final active = i == _bannerPage;

              return AnimatedBuilder(
                animation: _bannerCtrl,
                builder: (context, child) {
                  double page = i.toDouble();

                  if (_bannerCtrl.position.haveDimensions) {
                    page = _bannerCtrl.page ?? _bannerPage.toDouble();
                  }

                  final delta = (page - i).clamp(-1.0, 1.0);

                  // Smooth modern carousel effect
                  final scale = 1.0 - (delta.abs() * 0.055);
                  final opacity = 1.0 - (delta.abs() * 0.10);

                  return Transform.scale(
                    scale: scale,
                    child: Opacity(
                      opacity: opacity,
                      child: child,
                    ),
                  );
                },

                child: Padding(
                  padding: EdgeInsets.only(
                    left: i == 0 ? 18 : 7,
                    right: i == banner!.length - 1 ? 18 : 7,
                  ),

                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(24),

                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(24),

                        // NO BLACK SHADOW
                        border: Border.all(
                          color: active
                              ? _T.cyan.withOpacity(0.65)
                              : Colors.white.withOpacity(0.10),
                          width: active ? 1.4 : 1,
                        ),
                      ),

                      child: Stack(
                        fit: StackFit.expand,
                        children: [

                          // =====================================================
                          // FULL IMAGE
                          // =====================================================
                          Hero(
                            tag: 'banner_${banner![i].image}',

                            child: CachedNetworkImage(
                              imageUrl: banner![i].image ?? "",

                              // IMPORTANT:
                              // Full image visible inside banner
                              fit: BoxFit.cover,

                              alignment: Alignment.center,

                              placeholder: (_, __) => _shimmerBox(),

                              errorWidget: (_, __, ___) {
                                return Container(
                                  color: _T.surface2,
                                  child: const Center(
                                    child: Icon(
                                      Icons.image_not_supported_outlined,
                                      color: _T.textLow,
                                      size: 36,
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),

                          // =====================================================
                          // VERY LIGHT TOP GLASS EFFECT
                          // No dark bottom overlay
                          // =====================================================
                          Positioned(
                            top: 0,
                            left: 0,
                            right: 0,
                            child: Container(
                              height: 75,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [
                                    Colors.black.withOpacity(0.20),
                                    Colors.transparent,
                                  ],
                                ),
                              ),
                            ),
                          ),

                          // =====================================================
                          // TOP RIGHT PAGE INDICATOR
                          // =====================================================
                          Positioned(
                            top: 14,
                            right: 14,

                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 11,
                                vertical: 6,
                              ),

                              decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.28),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: Colors.white.withOpacity(0.25),
                                  width: 0.8,
                                ),
                              ),

                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.photo_outlined,
                                    size: 13,
                                    color: Colors.white.withOpacity(0.95),
                                  ),

                                  const SizedBox(width: 5),

                                  Text(
                                    "${i + 1}/${banner!.length}",
                                    style: GoogleFonts.montserrat(
                                      color: Colors.white,
                                      fontSize: 11,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),

                          // =====================================================
                          // TITLE
                          // Light glass container instead of black gradient
                          // =====================================================
                          if (banner![i].title != null &&
                              banner![i].title!.isNotEmpty)
                            Positioned(
                              left: 16,
                              right: 16,
                              bottom: 14,

                              child: Align(
                                alignment: Alignment.bottomLeft,

                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 13,
                                    vertical: 9,
                                  ),

                                  decoration: BoxDecoration(
                                    color: Colors.black.withOpacity(0.25),
                                    borderRadius: BorderRadius.circular(14),
                                    border: Border.all(
                                      color: Colors.white.withOpacity(0.14),
                                      width: 0.7,
                                    ),
                                  ),

                                  child: Text(
                                    banner![i].title!,

                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,

                                    style: GoogleFonts.montserrat(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w800,
                                      height: 1.2,

                                      shadows: const [
                                        Shadow(
                                          color: Colors.black54,
                                          blurRadius: 5,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),

        // ===============================================================
        // MODERN PAGE INDICATORS
        // ===============================================================
        const SizedBox(height: 13),

        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            banner!.length,
                (i) {
              final active = i == _bannerPage;

              return AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeOutCubic,

                margin: const EdgeInsets.symmetric(horizontal: 3),

                height: 6,
                width: active ? 24 : 6,

                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),

                  gradient: active
                      ? LinearGradient(
                    colors: [
                      _T.cyan,
                      _T.cyan.withOpacity(0.55),
                    ],
                  )
                      : null,

                  color: active ? null : _T.border,

                  // Small glow only on indicator
                  boxShadow: active
                      ? [
                    BoxShadow(
                      color: _T.cyan.withOpacity(0.35),
                      blurRadius: 7,
                      spreadRadius: 0,
                    ),
                  ]
                      : [],
                ),
              );
            },
          ),
        ),
      ],
    );
  }*/
  Widget _buildBanner() {
    return Column(
      children: [
        SizedBox(
          height: 400,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 9),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(24),
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(
                    color: _T.cyan.withOpacity(0.65),
                    width: 1.4,
                  ),
                ),
                child: Image.asset(
                  'assets/banner.png',
                  fit: BoxFit.fill,
                  alignment: Alignment.center,
                ),
              ),
            ),
          ),
        ),

        const SizedBox(height: 13),

        // Static indicator for testing
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 6,
              width: 24,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: _T.cyan,
              ),
            ),
          ],
        ),
      ],
    );
  }
  // ══════════════════════════════════════════════════════════════
  //  SECTION HEADER
  // ══════════════════════════════════════════════════════════════

  Widget _sectionHeader(String title, VoidCallback onViewAll) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 4, height: 20,
            decoration: BoxDecoration(
                color: _T.cyan, borderRadius: BorderRadius.circular(4)),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(title,
                style: GoogleFonts.poppins(
                    color: _T.textHi, fontSize: 15,
                    fontWeight: FontWeight.w800,letterSpacing: 0.9)),
          ),
          GestureDetector(
            onTap: onViewAll,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
              decoration: BoxDecoration(
                color: const Color(0xFF162c3b),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text("VIEW ALL",
                  style: GoogleFonts.montserrat(
                      color: _T.cyan, fontSize: 9,
                      fontWeight: FontWeight.w800, letterSpacing: 1.2)),
            ),
          ),
        ],
      ),
    );
  }

  // ══════════════════════════════════════════════════════════════
  //  DEALS  (horizontal scroll cards)
  // ══════════════════════════════════════════════════════════════
  Widget _buildDeals() {
    if (homeDeal == null || homeDeal!.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16), // સહેજ માર્જિન એડજસ્ટ કર્યું
      child: ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: homeDeal!.length,
        padding: EdgeInsets.zero,
        itemBuilder: (_, i) {
          final deal = homeDeal![i];
          return Container(
            width: double.infinity,
            margin: const EdgeInsets.only(bottom: 16), // કાર્ડ વચ્ચેની સ્પેસ સહેજ ઓછી કરી
            decoration:SharedWidgets.cardBoxDecoration(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ════════════ IMAGE & HIGH-HIGHLIGHTED TAG ════════════
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(10)),
                  child: Stack(
                    children: [
                      CachedNetworkImage(
                        imageUrl: deal.templateImage ?? "",
                        height: 145, // <--- કાર્ડ નાનું કરવા ઈમેજની હાઇટ ઘટાડી
                        width: double.infinity,
                        fit: BoxFit.cover,
                        placeholder: (_, __) => _shimmerBox(),
                        errorWidget: (_, __, ___) => Container(height: 145, color: _T.surface2),
                      ),
                      // ફૂલ હાઇલાઇટ કરેલું પ્રીમિયમ રેડ ટેગ
                      Positioned(
                        top: 10,
                        left: 10,
                        right: 10,
                        child: Align(
                          alignment: Alignment.topLeft,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6), // સ્લાઈટ નાનું કર્યું
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
                                    width: 140, // કાર્ડની સાઈઝ મુજબ વિડ્થ એડજસ્ટ કરી
                                    child: Marquee(
                                      text: (deal.dealName ?? "OFFER").toUpperCase(),
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

                // ════════════ CONTENT DETAILS ════════════
                Padding(
                  padding: const EdgeInsets.all(14), // <--- પેડિંગ ઘટાડીને કમ્પેક્ટ કર્યું
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        deal.dealDesc ?? "",
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.roboto(
                          color: _T.textHi,
                          fontSize: 15, // સાઈઝ સહેજ નાની કરી
                          fontWeight: FontWeight.w800,
                          height: 1.3,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Container(height: 1, color: _T.cyan.withOpacity(0.5)),
                      const SizedBox(height: 10),

                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            margin: const EdgeInsets.only(top: 2),
                            height: 16,
                            width: 16,
                            child: SvgPicture.asset(
                                "assets/ic_shopper.svg",
                                colorFilter: const ColorFilter.mode(_T.cyanDim, BlendMode.srcIn)
                            ),
                          ),
                          const SizedBox(width: 6),
                          Expanded(
                            child: Text(
                              deal.listingTitle ?? "Shop Name",
                              maxLines: 1, // ટાઈટલ એક લાઈનમાં સેટ કર્યું જેથી વધુ જગ્યા ન રોકે
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
                      Container(height: 1, color: _T.cyan.withOpacity(0.5)),
                      const SizedBox(height: 10),

                      // ૨. ડેટ અને ટાઇમ સેક્શન
                      Row(
                        children: [
                          Expanded(
                            child: Row(
                              children: [
                                SizedBox(
                                  height: 13,
                                  width: 13,
                                  child: SvgPicture.asset("assets/ic_calendar.svg", colorFilter: const ColorFilter.mode(_T.textMid, BlendMode.srcIn)),
                                ),
                                const SizedBox(width: 6),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text("START DATE", style: GoogleFonts.montserrat(fontSize: 8, fontWeight: FontWeight.w700, color: _T.textLow, letterSpacing: 0.5)),
                                      Text(
                                        deal.startDate ?? "-",
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
                          Container(width: 1, height: 22, color: _T.border), // હાઇટ સહેજ ઘટાડી
                          const SizedBox(width: 10),
                          Expanded(
                            child: Row(
                              children: [
                                SizedBox(
                                  height: 13,
                                  width: 13,
                                  child: SvgPicture.asset("assets/ic_calendar.svg", colorFilter: const ColorFilter.mode(_T.red, BlendMode.srcIn)),
                                ),
                                const SizedBox(width: 6),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text("END DATE", style: GoogleFonts.montserrat(fontSize: 8, fontWeight: FontWeight.w700, color: _T.red.withOpacity(0.7), letterSpacing: 0.5)),
                                      Text(
                                        deal.endDate ?? "-",
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

                      // ૩. લોકેશન ચિહ્ન
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: _T.bg,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SizedBox(
                              height: 12,
                              width: 12,
                              child: SvgPicture.asset("assets/ic_location.svg", colorFilter: const ColorFilter.mode(_T.cyan, BlendMode.srcIn)),
                            ),
                            const SizedBox(width: 4),
                            Flexible(
                              child: Text(
                                deal.cityName ?? "Location",
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

                      // ════════════ CRACK BUTTON ════════════
                      GestureDetector(
                        onTap: () {
                          if (AppPrefs.userId != "") {
                            _callCrackDeal(dealId: deal.id.toString());
                          } else {
                            SharedWidgets.showTopSnackBar(context, message: "Login First",title: "fail");
                          }
                        },
                        child: Container(
                          height: 42, // બટનની હાઇટ 48 માંથી 42 કરી
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
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  // ══════════════════════════════════════════════════════════════
  //  COLLECTIONS GRID
  // ══════════════════════════════════════════════════════════════
  Widget _buildCollections() {
    if (homeCollection == null || homeCollection!.isEmpty) return const SizedBox.shrink();

    final List<Color> palette = [
      const Color(0xFF00B8AD), const Color(0xFFF59E0B), const Color(0xFF8B5CF6),
      const Color(0xFFEF4444), const Color(0xFF10B981), const Color(0xFF3B82F6),
      const Color(0xFFF97316), const Color(0xFFEC4899), const Color(0xFF06B6D4),
      const Color(0xFF84CC16),
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3, crossAxisSpacing: 12,
        mainAxisSpacing: 12, childAspectRatio: 0.72,
      ),
      itemCount: homeCollection!.length,
      itemBuilder: (_, i) {
        final cat = homeCollection![i];
        final color = palette[i % palette.length];
        return GestureDetector(
          onTap: () => Get.to(() =>
              CollectionDetailScreen(categoryId: cat.id, title: cat.name)),
          child: Container(
            decoration: SharedWidgets.cardBoxDecoration(),
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Center(
                    child: Container(
                      height: 60, width: 60,
                      decoration: BoxDecoration(
                        color: color.withOpacity(0.10),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: color.withOpacity(0.18)),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: (cat.icon ?? "").contains('.svg')
                            ? SvgPicture.network(cat.icon!,
                            fit: BoxFit.contain,
                            colorFilter:
                            ColorFilter.mode(color, BlendMode.srcIn),
                            placeholderBuilder: (_) => _shimmerCircle())
                            : CachedNetworkImage(
                          imageUrl: cat.icon!,
                          fit: BoxFit.contain,
                          color: color,
                          placeholder: (_, __) => _shimmerCircle(),
                          errorWidget: (_, __, ___) =>
                              Icon(Icons.category_rounded, color: color, size: 22),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  height: 16,
                  width: 90,
                  child: Marquee(
                    text: cat.name ?? "",
                    style: GoogleFonts.poppins(
                      color: _T.textHi,
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                    ),
                    scrollAxis: Axis.horizontal,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    blankSpace: 15.0,
                    velocity: 25.0,
                    pauseAfterRound: const Duration(seconds: 1),
                    startPadding: 0.0,
                    accelerationDuration: const Duration(seconds: 1),
                    accelerationCurve: Curves.linear,
                    decelerationDuration: const Duration(milliseconds: 500),
                    decelerationCurve: Curves.easeOut,
                  ),
                ),
                const SizedBox(height: 4),
                Row(children: [
                  Text("Explore",
                      style: GoogleFonts.montserrat(
                          color: _T.textMid, fontSize: 9, fontWeight: FontWeight.w500)),
                  const SizedBox(width: 2),
                  Icon(Icons.arrow_forward_rounded, color: color, size: 9),
                ]),
              ],
            ),
          ),
        );
      },
    );
  }

  // ══════════════════════════════════════════════════════════════
  //  LATEST RELEASE
  // ══════════════════════════════════════════════════════════════
  Widget _buildLatestRelease(BuildContext context) {
    if (homeLatestRelease == null || homeLatestRelease!.isEmpty) {
      return const SizedBox.shrink();
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: homeLatestRelease!.length,
      padding: const EdgeInsets.fromLTRB(18, 14, 18, 18),
      itemBuilder: (_, i) {
        final item = homeLatestRelease![i];
        final String phoneNumber = item.mobileNo ?? "";
        final String whatsappNumber = item.mobileNo ?? "";

        // ચેક કરવા માટે કે dealName ખાલી તો નથી ને
        final String dealName = item.dealName?.trim() ?? "";
        final bool hasDealName = dealName.isNotEmpty;

        return GestureDetector(
          onTap: () => Get.to(() => AllListingDetailScreen(listId: item.id)),
          child: Container(
            margin: const EdgeInsets.only(bottom: 24),
            decoration: SharedWidgets.cardBoxDecoration(),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Container(
                color: Colors.white,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    // ================= IMAGE & BADGES SECTION =================
                    Stack(
                      children: [
                        SizedBox(
                          height: 220,
                          width: double.infinity,
                          child: CachedNetworkImage(
                            imageUrl: item.listingImage ?? "",
                            fit: BoxFit.cover,
                            fadeInDuration: const Duration(milliseconds: 300),
                            placeholder: (_, __) => Shimmer.fromColors(
                              baseColor: Colors.grey.shade200,
                              highlightColor: Colors.grey.shade100,
                              child: Container(color: Colors.white),
                            ),
                            errorWidget: (_, __, ___) => Container(
                              color: const Color(0xFFF3F4F6),
                              child: const Icon(
                                Icons.image_not_supported_outlined,
                                color: Color(0xFFD1D5DB),
                                size: 34,
                              ),
                            ),
                          ),
                        ),
                        Positioned.fill(
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  Colors.black.withOpacity(0.10),
                                  Colors.transparent,
                                  Colors.black.withOpacity(0.45),
                                ],
                                stops: const [0.0, 0.45, 1.0],
                              ),
                            ),
                          ),
                        ),
                        if (hasDealName)
                          Positioned(
                            top: 14,
                            left: 14,
                            child: Container(
                              width: 200,
                              height: 28,
                              padding: const EdgeInsets.symmetric(horizontal: 10),
                              decoration: BoxDecoration(
                                color: const Color(0xFFFF3B30),
                                borderRadius: BorderRadius.circular(6),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.15),
                                    blurRadius: 6,
                                    offset: const Offset(0, 3),
                                  ),
                                ],
                              ),
                              alignment: Alignment.centerLeft,
                              child: dealName.length > 12
                                  ? Marquee(
                                text: dealName.toUpperCase(),
                                style: GoogleFonts.poppins(
                                  color: Colors.white,
                                  fontSize: 11,
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: 0.8,
                                ),
                                scrollAxis: Axis.horizontal,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                blankSpace: 30.0,
                                velocity: 35.0,
                                pauseAfterRound: const Duration(seconds: 1),
                                startPadding: 0.0,
                              )
                                  : Text(
                                dealName.toUpperCase(),
                                style: GoogleFonts.poppins(
                                  color: Colors.white,
                                  fontSize: 11,
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: 0.8,
                                ),
                              ),
                            ),
                          ),

                        Positioned(
                          top: 14,
                          right: 14,
                          child: Container(
                            height: 42,
                            width: 42,
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.92),
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.10),
                                  blurRadius: 14,
                                  offset: const Offset(0, 6),
                                ),
                              ],
                            ),
                            child: const Icon(
                              Icons.arrow_outward_rounded,
                              color: Color(0xFF0D1B1E),
                              size: 20,
                            ),
                          ),
                        ),
                        Positioned(
                          left: 16,
                          bottom: 16,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFF0b151c).withOpacity(0.45),
                              borderRadius: BorderRadius.circular(30),
                              border: Border.all(
                                color: const Color(0xFF0b151c).withOpacity(0.30),
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(
                                  Icons.location_on_rounded,
                                  color: Colors.white,
                                  size: 15,
                                ),
                                const SizedBox(width: 5),
                                Text(
                                  (item.cityName ?? "CITY").toUpperCase(),
                                  style: GoogleFonts.montserrat(
                                    color: Colors.white,
                                    fontSize: 10.5,
                                    fontWeight: FontWeight.w800,
                                    letterSpacing: 1.2,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),

                    // ================= CONTENT SECTION =================
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.fromLTRB(18, 18, 18, 18),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.listingTitle ?? "",
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.poppins(
                              color: const Color(0xFF0D1B1E),
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              height: 1.28,
                              letterSpacing: 1,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Container(height: 1, color: _T.cyan.withOpacity(0.5)),
                          const SizedBox(height: 10),
                          Text(
                            item.description ?? "",
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.lato(
                              color: const Color(0xFF6B7280),
                              fontSize: 12.5,
                              fontWeight: FontWeight.w600,
                              height: 1.6,
                            ),
                          ),
                          const SizedBox(height: 18),
                          Row(
                            children: [
                              Expanded(
                                child: GestureDetector(
                                  onTap: () async {
                                    if (whatsappNumber.isNotEmpty) {
                                      final cleanNumber = whatsappNumber.startsWith('+') || whatsappNumber.startsWith('91')
                                          ? whatsappNumber
                                          : '91$whatsappNumber';
                                      final Uri whatsappUri = Uri.parse("https://wa.me/$cleanNumber");
                                      if (await canLaunchUrl(whatsappUri)) {
                                        await launchUrl(whatsappUri, mode: LaunchMode.externalApplication);
                                      } else {
                                        Get.snackbar("Error", "Could not launch WhatsApp");
                                      }
                                    } else {
                                      Get.snackbar("Alert", "WhatsApp number not available");
                                    }
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(vertical: 10),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF25D366).withOpacity(0.08),
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(color: const Color(0xFF25D366).withOpacity(0.2), width: 1),
                                    ),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        SvgPicture.asset(
                                          "assets/wp.svg",
                                          height: 16,
                                          width: 16,
                                        ),
                                        const SizedBox(width: 6),
                                        Text(
                                          "WhatsApp",
                                          style: GoogleFonts.poppins(
                                            color: const Color(0xFF25D366),
                                            fontSize: 11,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: GestureDetector(
                                  onTap: () async {
                                    if (phoneNumber.isNotEmpty) {
                                      final Uri launchUri = Uri(scheme: 'tel', path: phoneNumber);
                                      if (await canLaunchUrl(launchUri)) {
                                        await launchUrl(launchUri);
                                      } else {
                                        Get.snackbar("Error", "Could not open Dial Pad");
                                      }
                                    } else {
                                      Get.snackbar("Alert", "Phone number not available");
                                    }
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(vertical: 10),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF007AFF).withOpacity(0.08),
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(color: const Color(0xFF007AFF).withOpacity(0.2), width: 1),
                                    ),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        SvgPicture.asset(
                                          "assets/call.svg",
                                          height: 15,
                                          width: 15,
                                          colorFilter: const ColorFilter.mode(Color(0xFF007AFF), BlendMode.srcIn),
                                        ),
                                        const SizedBox(width: 6),
                                        Text(
                                          "Call Now",
                                          style: GoogleFonts.poppins(
                                            color: const Color(0xFF007AFF),
                                            fontSize: 11,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: GestureDetector(
                                  onTap: () {
                                    showModalBottomSheet(
                                      context: context,
                                      isScrollControlled: true,
                                      backgroundColor: Colors.white,
                                      shape: const RoundedRectangleBorder(
                                        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                                      ),
                                      builder: (context) => inquiryBottomSheet(context, item.id),
                                    );
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(vertical: 10),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFFF9500).withOpacity(0.08),
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(color: const Color(0xFFFF9500).withOpacity(0.2), width: 1),
                                    ),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        SvgPicture.asset(
                                          "assets/inquiry.svg",
                                          height: 15,
                                          width: 15,
                                          colorFilter: const ColorFilter.mode(Color(0xFFFF9500), BlendMode.srcIn),
                                        ),
                                        const SizedBox(width: 6),
                                        Text(
                                          "Inquiry",
                                          style: GoogleFonts.poppins(
                                            color: const Color(0xFFFF9500),
                                            fontSize: 11,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                          const SizedBox(height: 10),
                          Container(height: 1, color: _T.cyan.withOpacity(0.5)),
                          const SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Explore details",
                                style: GoogleFonts.montserrat(
                                  color: const Color(0xFF0D1B1E).withOpacity(0.55),
                                  fontSize: 11.5,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 14,
                                  vertical: 10,
                                ),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF0D1B1E),
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      "View",
                                      style: GoogleFonts.montserrat(
                                        color: Colors.white,
                                        fontSize: 11.5,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                    const SizedBox(width: 6),
                                    const Icon(
                                      Icons.arrow_forward_rounded,
                                      color: Colors.white,
                                      size: 15,
                                    ),
                                  ],
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
            ),
          ),
        );
      },
    );
  }
  // ══════════════════════════════════════════════════════════════
  //  NEWLY ADDED
  // ══════════════════════════════════════════════════════════════
  Widget _buildNewlyAdded() {
    if (homeNearListing == null || homeNearListing!.isEmpty) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18),
      child: Column(
        children: homeNearListing!.map((item) {
          return GestureDetector(
            onTap: () => Get.to(() => AllListingDetailScreen(listId: item.id)),
            child: Container(
              width: double.infinity,
              margin: const EdgeInsets.only(bottom: 14),
              decoration: BoxDecoration(
                color: _T.white,
                borderRadius: BorderRadius.circular(22),
                border: Border.all(color: _T.border),
                boxShadow: [
                  BoxShadow(
                      color: Colors.black.withOpacity(0.07),
                      blurRadius: 18,
                      offset: const Offset(0, 5))
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(22)),
                    child: CachedNetworkImage(
                      imageUrl: item.listingImage ?? "",
                      height: 195,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      fadeInDuration: const Duration(milliseconds: 350),
                      placeholder: (_, __) => _shimmerBox(),
                      errorWidget: (_, __, ___) =>
                          Container(height: 195, color: _T.surface2),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(18),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(item.listingTitle ?? "",
                            style: GoogleFonts.roboto(
                                color: _T.textHi, fontSize: 18,
                                fontWeight: FontWeight.w800)),
                        const SizedBox(height: 10),
                        Container(height: 1, color: _T.cyan),
                        const SizedBox(height: 10),
                        Text(item.description ?? "",
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.poppins(
                                color: _T.textMid, fontSize: 12, height: 1.5)),
                        const SizedBox(height: 12),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 5),
                          decoration: BoxDecoration(
                            color: _T.cyanBg,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(mainAxisSize: MainAxisSize.min, children: [
                            const Icon(Icons.location_on_rounded,
                                color: _T.cyan, size: 12),
                            const SizedBox(width: 4),
                            Text(item.cityName ?? "",
                                style: GoogleFonts.montserrat(
                                    color: _T.cyan, fontSize: 10,
                                    fontWeight: FontWeight.w700)),
                          ]),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
  // ══════════════════════════════════════════════════════════════
  //  SERVICES
  // ══════════════════════════════════════════════════════════════
  Widget _buildServices() {
    if (homeService == null || homeService!.isEmpty) {
      return const SizedBox.shrink();
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: homeService!.length,
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 18),
      itemBuilder: (_, i) {
        final svc = homeService![i];
        return GestureDetector(
          onTap: () => Get.to(
                () => CollectionDetailScreen(
              categoryId: svc.id,
              title: svc.name,
            ),
          ),
          child: Container(
            margin: const EdgeInsets.only(bottom: 18),
            decoration: SharedWidgets.cardBoxDecoration(),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(18),
                    child: SizedBox(
                      height: 96,
                      width: 96,
                      child: CachedNetworkImage(
                        imageUrl: svc.serviceImage ?? "",
                        fit: BoxFit.cover,
                        placeholder: (_, __) => _shimmerCircle(),
                        errorWidget: (_, __, ___) => Container(
                          color: const Color(0xFFF3F4F6),
                          child: const Icon(
                            Icons.broken_image_outlined,
                            color: Colors.grey,
                            size: 24,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: SizedBox(
                      height: 96,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  svc.name ?? "",
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: GoogleFonts.montserrat(
                                    color: const Color(0xFF0D1B1E),
                                    fontSize: 15.5,
                                    fontWeight: FontWeight.w800,
                                    height: 1.25,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Container(
                                height: 34,
                                width: 34,
                                decoration: BoxDecoration(
                                  color: const Color(0xFF0D1B1E),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: const Icon(
                                  Icons.arrow_forward_rounded,
                                  color: Colors.white,
                                  size: 18,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            (svc.slug != null && svc.slug!.trim().isNotEmpty)
                                ? svc.slug!
                                : "Explore this premium service collection.",
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.montserrat(
                              color: const Color(0xFF6B7280),
                              fontSize: 11.5,
                              fontWeight: FontWeight.w500,
                              height: 1.45,
                            ),
                          ),
                          const Spacer(),
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF00968C).withOpacity(0.10),
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                child: Text(
                                  "Service",
                                  style: GoogleFonts.montserrat(
                                    color: const Color(0xFF00968C),
                                    fontSize: 10.5,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                              const Spacer(),
                              Text(
                                "#${(i + 1).toString().padLeft(2, '0')}",
                                style: GoogleFonts.montserrat(
                                  color: const Color(0xFF0D1B1E).withOpacity(0.35),
                                  fontSize: 11,
                                  fontWeight: FontWeight.w700,
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
      },
    );
  }
  // ══════════════════════════════════════════════════════════════
  //  HOW IT WORKS
  // ══════════════════════════════════════════════════════════════
  Widget _buildHowItWorks() {
    final steps = [
      {"title": "Choose Location",  "desc": "Pick your city to discover nearby businesses.", "icon": "📍"},
      {"title": "Pick Category",    "desc": "Select a category that matches your needs.",    "icon": "📂"},
      {"title": "Explore Places",   "desc": "Browse curated listings for your location.",    "icon": "⭐"},
    ];
    return _infoCard(
      title: "How Gotilo", highlight: "Works",
      subtitle: "Discover how Gotilo connects you with trusted businesses in a few simple steps.",
      steps: steps, isVendor: false,
    );
  }
  // ══════════════════════════════════════════════════════════════
  //  BECOME VENDOR
  // ══════════════════════════════════════════════════════════════
  Widget _buildBecomeVendor() {
    final steps = [
      {"title": "Call or WhatsApp",  "desc": "+91 8382868288", "icon": "📞"},
      {"title": "Email Your Details","desc": "info@gotilo.net", "icon": "✉️"},
    ];
    return _infoCard(
      title: "Become a", highlight: "Vendor",
      subtitle: "Grow your business with Gotilo. Reach out to get listed today.",
      steps: steps, isVendor: true,
    );
  }
  Widget inquiryBottomSheet(BuildContext context,int? listId) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        left: 24,
        right: 24,
        top: 12,
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
        Center(
        child: Container(
        width: 45,
          height: 5,
          decoration: BoxDecoration(
            color: Colors.grey[300],
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
      const SizedBox(height: 20),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Let's Connect!",
                style: GoogleFonts.montserrat(
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  color: _T.cyan,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                "Fill the form to send an inquiry",
                style: GoogleFonts.montserrat(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
          Container(
            decoration: BoxDecoration(
              color: Colors.grey[100],
              shape: BoxShape.circle,
            ),
            child: IconButton(
              icon: const Icon(Icons.close, size: 20, color: Colors.black87),
              onPressed: () => Navigator.pop(context),
            ),
          ),
        ],
      ),
      const SizedBox(height: 25),
      Row(
        children: [
          Expanded(
            child: TextField(
              style: GoogleFonts.montserrat(fontSize: 14, color: Colors.black87),
              controller: _fNameController,
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.person_outline, color: Colors.grey[500], size: 20),
                labelText: "First Name",
                labelStyle: GoogleFonts.montserrat(color: Colors.grey[500], fontSize: 13),
                floatingLabelStyle: GoogleFonts.montserrat(color: _T.cyan, fontWeight: FontWeight.w600),
                filled: true,
                fillColor: Colors.grey[50],
                contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide(color: Colors.grey[200]!, width: 1.5),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: const BorderSide(color:_T.cyan, width: 2),
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: TextField(
              style: GoogleFonts.montserrat(fontSize: 14, color: Colors.black87),
              controller: _lNameController,
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.person_outline, color: Colors.grey[500], size: 20),
                labelText: "Last Name",
                labelStyle: GoogleFonts.montserrat(color: Colors.grey[500], fontSize: 13),
                floatingLabelStyle: GoogleFonts.montserrat(color: _T.cyan, fontWeight: FontWeight.w600),
                filled: true,
                fillColor: Colors.grey[50],
                contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide(color: Colors.grey[200]!, width: 1.5),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: const BorderSide(color: _T.cyan, width: 2),
                ),
              ),
            ),
          ),
        ],
      ),
      const SizedBox(height: 16),
      TextField(
        keyboardType: TextInputType.emailAddress,
        controller: _emailController,
        style: GoogleFonts.montserrat(fontSize: 14, color: Colors.black87),
        decoration: InputDecoration(
          prefixIcon: Icon(Icons.mail_outline, color: Colors.grey[500], size: 20),
          labelText: "Email Address",
          labelStyle: GoogleFonts.montserrat(color: Colors.grey[500], fontSize: 13),
          floatingLabelStyle: GoogleFonts.montserrat(color: _T.cyan, fontWeight: FontWeight.w600),
          filled: true,
          fillColor: Colors.grey[50],
          contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide(color: Colors.grey[200]!, width: 1.5),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color:_T.cyan, width: 2),
          ),
        ),
      ),
      const SizedBox(height: 16),
      TextField(
        keyboardType: TextInputType.phone,
        controller: _numberController,
        style: GoogleFonts.montserrat(fontSize: 14, color: Colors.black87),
        decoration: InputDecoration(
          prefixIcon: Icon(Icons.phone_android_outlined, color: Colors.grey[500], size: 20),
          labelText: "Mobile Number",
          labelStyle: GoogleFonts.montserrat(color: Colors.grey[500], fontSize: 13),
          floatingLabelStyle: GoogleFonts.montserrat(color: _T.cyan, fontWeight: FontWeight.w600),
          filled: true,
          fillColor: Colors.grey[50],
          contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide(color: Colors.grey[200]!, width: 1.5),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: _T.cyan, width: 2),
          ),
        ),
      ),
      const SizedBox(height: 16),
      TextField(
        maxLines: 3,
        controller: _messageController,
        style: GoogleFonts.montserrat(fontSize: 14, color: Colors.black87),
        decoration: InputDecoration(
          prefixIcon: Padding(
            padding: const EdgeInsets.only(bottom: 35),
            child: Icon(Icons.chat_bubble_outline, color: Colors.grey[500], size: 20),
          ),
          labelText: "Write us a message...",
          labelStyle: GoogleFonts.montserrat(color: Colors.grey[500], fontSize: 13),
          floatingLabelStyle: GoogleFonts.montserrat(color: _T.cyan, fontWeight: FontWeight.w600),
          filled: true,
          fillColor: Colors.grey[50],
          alignLabelWithHint: true,
          contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide(color: Colors.grey[200]!, width: 1.5),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: _T.cyan, width: 2),
          ),
        ),
      ),
      const SizedBox(height: 28),
            GestureDetector(
              onTap:() {
                  if(_fNameController.text != "" && _lNameController.text != "" && _numberController.text != ""
                  && _emailController.text != "" && _messageController.text != ""){
                    callAddEnquiry(listId:listId);
                  }else{
                    SharedWidgets.showTopSnackBar(context, message:"Please Fill All the filed",title: "fail");
                  }
                  },
              child: Container(
                height: 52,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(colors: [_T.cyan, _T.cyanDim]),
                  borderRadius: BorderRadius.circular(18),
                  boxShadow: [
                    BoxShadow(
                        color: _T.cyan.withOpacity(0.30),
                        blurRadius: 18,
                        offset: const Offset(0, 6))
                  ],
                ),
                alignment: Alignment.center,
                child: Text("SEND INQUIRY",
                    style: GoogleFonts.montserrat(
                        color: Colors.white, fontSize: 13,
                        fontWeight: FontWeight.w900, letterSpacing: 1.4)),
              ),
            ),
             const SizedBox(height: 30),
           ],
        ),
      ),
    );
  }

  Widget _infoCard({
    required String title,
    required String highlight,
    required String subtitle,
    required List<Map<String, String>> steps,
    required bool isVendor,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 18, vertical: 6),
      padding: const EdgeInsets.all(26),
      decoration:SharedWidgets.cardBoxDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40, height: 4,
            decoration: BoxDecoration(
                color: _T.cyan, borderRadius: BorderRadius.circular(4)),
          ),
          const SizedBox(height: 14),
          RichText(
            text: TextSpan(
              style: GoogleFonts.roboto(
                  fontSize: 24, fontWeight: FontWeight.w900,
                  color: _T.textHi, height: 1.1,letterSpacing: 1),
              children: [
                TextSpan(text: "$title "),
                TextSpan(text: highlight,
                    style: const TextStyle(color: _T.cyan)),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Text(subtitle,
              style: GoogleFonts.poppins(
                  color: _T.textMid, fontSize: 13, height: 1.6)),
          const SizedBox(height: 28),
          ...List.generate(steps.length, (i) {
            final s = steps[i];
            return Column(children: [
              Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
                Container(
                  height: 50, width: 50,
                  decoration: BoxDecoration(
                    color: _T.cyanBg,
                    shape: BoxShape.circle,
                    border: Border.all(color: _T.cyan.withOpacity(0.2)),
                  ),
                  alignment: Alignment.center,
                  child: Text(s["icon"]!, style: const TextStyle(fontSize: 21)),
                ),
                const SizedBox(width: 16),
                Expanded(child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(s["title"]!,
                        style: GoogleFonts.poppins(
                            color: _T.textHi, fontSize: 14,
                            fontWeight: FontWeight.w700)),
                    const SizedBox(height: 3),
                    Text(s["desc"]!,
                        style: GoogleFonts.poppins(
                            color: isVendor ? _T.cyan : _T.textMid,
                            fontSize: isVendor ? 14 : 12,
                            fontWeight: isVendor ? FontWeight.w700 : FontWeight.w400)),
                  ],
                )),
              ]),
              if (i != steps.length - 1)
                Padding(
                  padding: const EdgeInsets.only(left: 25, top: 4, bottom: 4),
                  child: Container(
                    height: 26, width: 1,
                    color: _T.border,
                  ),
                ),
            ]);
          }),

          if (isVendor) ...[
            const SizedBox(height: 26),
            GestureDetector(
              onTap: () => _showInquirySheet(context),
              child: Container(
                height: 52,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(colors: [_T.cyan, _T.cyanDim]),
                  borderRadius: BorderRadius.circular(18),
                  boxShadow: [
                    BoxShadow(
                        color: _T.cyan.withOpacity(0.30),
                        blurRadius: 18,
                        offset: const Offset(0, 6))
                  ],
                ),
                alignment: Alignment.center,
                child: Text("SEND INQUIRY",
                    style: GoogleFonts.montserrat(
                        color: Colors.white, fontSize: 13,
                        fontWeight: FontWeight.w900, letterSpacing: 1.4)),
              ),
            ),
          ],
        ],
      ),
    );
  }

  // ══════════════════════════════════════════════════════════════
  //  INQUIRY BOTTOM SHEET
  // ══════════════════════════════════════════════════════════════
  void _showInquirySheet(BuildContext context) {
    final formKey  = GlobalKey<FormState>();
    final nameCtrl  = TextEditingController();
    final phoneCtrl = TextEditingController();
    final emailCtrl = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(ctx).viewInsets.bottom),
        child: Container(
          decoration: const BoxDecoration(
            color: _T.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
          ),
          padding: const EdgeInsets.fromLTRB(24, 14, 24, 32),
          child: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    height: 4, width: 44,
                    decoration: BoxDecoration(
                        color: _T.border, borderRadius: BorderRadius.circular(10)),
                  ),
                ),
                const SizedBox(height: 26),
                Container(
                  width: 36, height: 4,
                  decoration: BoxDecoration(
                      color: _T.cyan, borderRadius: BorderRadius.circular(4)),
                ),
                const SizedBox(height: 12),
                Text("Vendor Inquiry",
                    style: GoogleFonts.montserrat(
                        fontSize: 22, fontWeight: FontWeight.w800, color: _T.textHi)),
                const SizedBox(height: 5),
                Text("Fill your details — our team will reach out shortly.",
                    style: GoogleFonts.montserrat(fontSize: 12, color: _T.textMid)),
                const SizedBox(height: 24),

                _lightTextField(
                  ctrl: nameCtrl, label: "Full Name",
                  hint: "Enter your full name", icon: Icons.person_outline_rounded,
                  validator: (v) =>
                  (v?.trim().isEmpty ?? true) ? "Please enter name" : null,
                ),
                const SizedBox(height: 14),
                _lightTextField(
                  ctrl: phoneCtrl, label: "Mobile Number",
                  hint: "Enter 10-digit number", icon: Icons.phone_android_outlined,
                  inputType: TextInputType.phone, maxLen: 10,
                  validator: (v) {
                    if (v == null || v.trim().isEmpty) return "Please enter mobile";
                    if (v.trim().length != 10) return "Enter valid 10-digit number";
                    return null;
                  },
                ),
                const SizedBox(height: 14),
                _lightTextField(
                  ctrl: emailCtrl, label: "Email Address",
                  hint: "Enter your email", icon: Icons.email_outlined,
                  inputType: TextInputType.emailAddress,
                  validator: (v) {
                    if (v == null || v.trim().isEmpty) return "Please enter email";
                    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(v.trim())) {
                      return "Enter a valid email";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 28),

                GestureDetector(
                  onTap: () {
                    if (formKey.currentState!.validate()) {
                      _callBecomeVendor(
                          name: nameCtrl.text,
                          email: emailCtrl.text,
                          number: phoneCtrl.text);
                      Navigator.pop(ctx);
                    }
                  },
                  child: Container(
                    height: 52,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(colors: [_T.cyan, _T.cyanDim]),
                      borderRadius: BorderRadius.circular(18),
                      boxShadow: [
                        BoxShadow(
                            color: _T.cyan.withOpacity(0.28),
                            blurRadius: 16,
                            offset: const Offset(0, 6))
                      ],
                    ),
                    alignment: Alignment.center,
                    child: Text("SAVE INQUIRY",
                        style: GoogleFonts.montserrat(
                            color: Colors.white, fontSize: 14,
                            fontWeight: FontWeight.w900, letterSpacing: 1.2)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _lightTextField({
    required TextEditingController ctrl,
    required String label,
    required String hint,
    required IconData icon,
    TextInputType inputType = TextInputType.text,
    int? maxLen,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: ctrl,
      keyboardType: inputType,
      maxLength: maxLen,
      validator: validator,
      style: GoogleFonts.montserrat(
          color: _T.textHi, fontSize: 14, fontWeight: FontWeight.w600),
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        counterText: "",
        labelStyle: GoogleFonts.montserrat(color: _T.textMid, fontSize: 13),
        hintStyle: GoogleFonts.montserrat(color: _T.textLow, fontSize: 13),
        prefixIcon: Icon(icon, color: _T.cyan, size: 20),
        filled: true,
        fillColor: _T.surface2,
        contentPadding:
        const EdgeInsets.symmetric(vertical: 15, horizontal: 18),
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(color: _T.border)),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(color: _T.borderFocus, width: 1.5)),
        errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(color: _T.red)),
        focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(color: _T.red, width: 1.5)),
      ),
    );
  }

  // ══════════════════════════════════════════════════════════════
  //  SHARED HELPERS
  // ══════════════════════════════════════════════════════════════
  Widget _searchInput({
    required String hint,
    required IconData icon,
    required ValueChanged<String> onChanged,
  }) {
    return Container(
      height: 46,
      decoration: BoxDecoration(
        color: _T.surface2,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: _T.border),
      ),
      child: TextField(
        onChanged: onChanged,
        style: GoogleFonts.montserrat(color: _T.textHi, fontSize: 13),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: GoogleFonts.montserrat(color: _T.textLow, fontSize: 12),
          prefixIcon: Icon(icon, color: _T.cyan, size: 18),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 12),
        ),
      ),
    );
  }

  Widget _shimmerBox() {
    return Shimmer.fromColors(
      baseColor: _T.surface2,
      highlightColor: _T.white,
      child: Container(color: _T.surface2),
    );
  }

  Widget _shimmerCircle() {
    return Shimmer.fromColors(
      baseColor: _T.surface2,
      highlightColor: _T.white,
      child: const CircleAvatar(backgroundColor: Color(0xFFF0F2F8)),
    );
  }

  // ══════════════════════════════════════════════════════════════
  //  API CALLS
  // ══════════════════════════════════════════════════════════════

  Future<void> callHome() async {
    isDataAvailable.value = false;
    isApiComplete.value = false;
    await _callHome();
  }

  Future<void> _callHome() async {
    try {
      if (!await MyApplication.checkInternet()) {
        isDataAvailable.value = false;
        isApiComplete.value = true;
        return;
      }
      final response = await ApiCalls.callHome();
      if (response != null &&
          (response.result ?? "").toLowerCase().contains("pass") &&
          response.data != null) {
        banner            = List.from(response.data!.sliders ?? []);
        homeCollection    = List.from(response.data!.categories ?? []);
        homeNearListing   = List.from(response.data!.latestListings ?? []);
        homeLatestRelease = List.from(response.data!.nearbyListings ?? []);
        homeService       = List.from(response.data!.services ?? []);
        homeDeal          = List.from(response.data!.nearbyDeals ?? []);
        isDataAvailable.value = true;
      } else {
        banner = homeCollection = null;
        homeNearListing = homeLatestRelease = null;
        homeService = null;
        homeDeal = null;
        isDataAvailable.value = false;
      }
    } catch (e) {
      log("_callHome: $e");
      isDataAvailable.value = false;
    } finally {
      isApiComplete.value = true;
      if (mounted) setState(() {});
    }
  }

  Future<void> _callCity() async {
    try {
      if (!await MyApplication.checkInternet()) return;

      ResponseCity? response = await ApiCalls.callCity();

      log("CITY RESPONSE => $response");
      log("CITY RESULT => ${response?.result}");
      log("CITY COUNT => ${response?.cities?.length}");

      if (response != null ) {
        if(response.result!.isNotEmpty && response.result != null &&
        response.result!.toLowerCase().contains("pass")){
          setState(() {
            allCities.addAll(response.cities!);
          });
          log("FINAL allCities => ${response.cities!.length}");
        }
      }
    } catch (e) {
      log("_callCity: $e");
    }
  }

  Future<void> _callCrackDeal({String? dealId = ""}) async {
    try {
      if (!await MyApplication.checkInternet()) return;
      final response = await ApiCalls.callCrackDeal(
          RequestCrackDeal(userId: AppPrefs.userId, dealId: dealId));
      if (response != null &&
          (response.result ?? "").toLowerCase().contains("pass")) {
        Get.to(() => const UserDealsScreen());
        SharedWidgets.showTopSnackBar(context, message: response.message!,title: "pass");
      } else {
        SharedWidgets.showTopSnackBar(context, message: response!.message!,title: "fail");
      }
    } catch (e) {
      log("_callCrackDeal: $e");
    } finally {
      if (mounted) setState(() {});
    }
  }

  Future<void> _callBecomeVendor(
      {String? name, String? number, String? email}) async {
    try {
      if (!await MyApplication.checkInternet()) return;
      final response = await ApiCalls.callBecomeVendor(
          RequestBecomeVendor(phone: number, name: name, email: email));
      if (response != null &&
          (response.result ?? "").toLowerCase().contains("pass")) {
        SharedWidgets.showTopSnackBar(context, message: response.message!,title: "pass");
      }else{
        SharedWidgets.showTopSnackBar(context, message: response!.message!,title: "fail");
      }
    } catch (e) {
      log("_callBecomeVendor: $e");
    }
  }

  Future<void> callAddEnquiry({int? listId}) async {
    MyApplication.checkInternet().then((internet) async {
      if(internet){
        try{
          ResponseAddEnquiry? response= await ApiCalls.callAddEnquiry(RequestAddEnquiry(
            listingId:listId,
            userId: AppPrefs.userId ?? "",
            email:   _emailController.text,
            phone:   _numberController.text,
            enquiry: _messageController.text,
            fName:   _fNameController.text,
            lName:   _lNameController.text,
          ));
          if(response != null){
            if(response.result!.isNotEmpty && response.result != null &&
                response.result!.toLowerCase().contains("pass")){
              SharedWidgets.showTopSnackBar(context, message: response.message!,title: "pass");
              Navigator.pop(context);
            }else{
              SharedWidgets.showTopSnackBar(context, message: response.message!,title: "fail");
            }
          }
        }on Exception catch(e){
          log("$e");
        }catch(e){
          log("$e");
        }finally{

        }
      }else{
        SharedWidgets.showTopSnackBar(context, message: "No Internet Available",title:"fail");
      }
    },);
  }

  Future<void> callAppLogo() async {
    MyApplication.checkInternet().then((internet) async {
      if(internet){
        try{
          ResponseAppLogo? response= await ApiCalls.callAppLogo();
          if(response != null){
            if(response.result!.isNotEmpty && response.result != null &&
                response.result!.toLowerCase().contains("pass")){
              _appLogo = response.data![0].logo;
              setState(() {});
            }else{
              SharedWidgets.showTopSnackBar(context, message: response.message!,title: "fail");
            }
          }
        }on Exception catch(e){
          log("$e");
        }catch(e){
          log("$e");
        }finally{

        }
      }else{
        SharedWidgets.showTopSnackBar(context, message: "No Internet Available",title:"fail");
      }
    },);
  }



}

class _PulseLoader extends StatefulWidget {
  const _PulseLoader();
  @override
  State<_PulseLoader> createState() => _PulseLoaderState();
}


class _CitySelectionSheet extends StatefulWidget {
  final List<Cities> allCities;
  final Function(int id, String name) onCitySelected;

  const _CitySelectionSheet({
    required this.allCities,
    required this.onCitySelected,
  });

  @override
  State<_CitySelectionSheet> createState() => _CitySelectionSheetState();
}

class _CitySelectionSheetState extends State<_CitySelectionSheet> {
  late List<Cities> filtered;
  final TextEditingController _searchCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    filtered = List.from(widget.allCities);

    log("BOTTOM SHEET CITY COUNT => ${widget.allCities.length}");
    for (final c in widget.allCities) {
      log("BOTTOM SHEET CITY => ${c.id} ${c.name}");
    }
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  void _onSearch(String val) {
    setState(() {
      filtered = widget.allCities
          .where((c) =>
          (c.name ?? "").toLowerCase().contains(val.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.85,
      ),
      decoration: const BoxDecoration(
        color: _T.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
      ),
      padding: const EdgeInsets.fromLTRB(24, 14, 24, 32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              height: 4, width: 44,
              decoration: BoxDecoration(
                color: _T.border,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          const SizedBox(height: 22),

          Text(
            "Select Your City",
            style: GoogleFonts.montserrat(
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: _T.textHi,
            ),
          ),
          const SizedBox(height: 14),
          Container(
            height: 46,
            decoration: BoxDecoration(
              color: _T.surface2,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: _T.border),
            ),
            child: TextField(
              controller: _searchCtrl,
              onChanged: _onSearch,
              style: GoogleFonts.montserrat(color: _T.textHi, fontSize: 13),
              decoration: InputDecoration(
                hintText: "Search city...",
                hintStyle: GoogleFonts.montserrat(
                    color: _T.textLow, fontSize: 12),
                prefixIcon: const Icon(Icons.search_rounded,
                    color: _T.cyan, size: 18),
                border: InputBorder.none,
                contentPadding:
                const EdgeInsets.symmetric(vertical: 12),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Flexible(
            child: filtered.isEmpty
                ? Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Text(
                  "No city found",
                  style: GoogleFonts.montserrat(color: _T.textMid),
                ),
              ),
            )
                : ListView.separated(
              shrinkWrap: true,
              physics: const BouncingScrollPhysics(),
              itemCount: filtered.length,
              separatorBuilder: (_, __) =>
              const Divider(color: _T.border, height: 1),
              itemBuilder: (_, i) {
                final city = filtered[i];
                return InkWell(
                  borderRadius: BorderRadius.circular(12),
                  onTap: () {
                    Navigator.pop(context);
                    widget.onCitySelected(
                        city.id ?? 0, city.name ?? "Unknown");
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 12, horizontal: 4),
                    child: Row(children: [
                      Container(
                        width: 36, height: 36,
                        decoration: const BoxDecoration(
                          color: _T.cyanBg,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.location_city_rounded,
                          color: _T.cyan,
                          size: 17,
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Text(
                          city.name ?? "",
                          style: GoogleFonts.montserrat(
                            color: _T.textHi,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      const Icon(
                        Icons.chevron_right_rounded,
                        size: 18,
                        color: _T.textLow,
                      ),
                    ]),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _PulseLoaderState extends State<_PulseLoader>
    with SingleTickerProviderStateMixin {
  late AnimationController _c;
  late Animation<double>   _scale;

  @override
  void initState() {
    super.initState();
    _c = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 800))
      ..repeat(reverse: true);
    _scale = Tween<double>(begin: 0.88, end: 1.0).animate(
        CurvedAnimation(parent: _c, curve: Curves.easeInOut));
  }

  @override
  void dispose() { _c.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _scale,
      child: Container(
        width: 50, height: 50,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: _T.cyanBg,
          boxShadow: [
            BoxShadow(
                color: _T.cyan.withOpacity(0.2), blurRadius: 20)
          ],
        ),
        child: const Center(
          child: SizedBox(
            width: 26, height: 26,
            child: CircularProgressIndicator(
                color: _T.cyan, strokeWidth: 2.5),
          ),
        ),
      ),
    );
  }
}