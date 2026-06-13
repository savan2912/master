import 'dart:developer';
import 'dart:ui';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gotilo_new/Api/Request/BecomeVendor/RequestBecomeVendor.dart';
import 'package:gotilo_new/Api/Request/CrackDeal/RequestCrackDeal.dart';
import 'package:gotilo_new/Api/Response/BecomeVendor/ResponseBecomeVendor.dart';
import 'package:gotilo_new/Api/Response/City/ResponseCity.dart';
import 'package:gotilo_new/Api/Response/CrackDeal/ResponseCrackDeal.dart';
import 'package:gotilo_new/CustomeWidgets/SharedWidgets.dart';
import 'package:gotilo_new/Screens/AllListing/AllListingDetailScreen.dart';
import 'package:gotilo_new/Screens/Search/SearchScreen.dart';
import 'package:gotilo_new/Screens/User/Dashboard/UserDashboardScreen.dart';
import 'package:gotilo_new/Screens/User/Deals/DealsScreen.dart';
import 'package:shimmer/shimmer.dart';
import '../Api/ApiCalls.dart';
import '../Api/Response/Home/ResponseHome.dart';
import '../Constant/AppPref.dart';
import '../MyApplication/MyApplication.dart';
import 'AllCollection/AllCollectionScreen.dart';
import 'AllCollection/CollectionDetailScreen.dart';
import 'Deals/DealsScreen.dart';
import 'HeritageHomeScreen.dart';
import 'LatestRelease/LatestReleaseScreen.dart';
import 'Login/view/LoginScreen.dart';
import 'LuxuryCardItem.dart';
import 'NewlyAddedListing/NewlyAddedListing.dart';
import 'OurFeaturedServices/OurFeaturedServicesScreen.dart';
import 'User/Account/AccountScreen.dart';

class HomeMainScreen extends StatefulWidget {
  const HomeMainScreen({super.key});
  @override
  State<HomeMainScreen> createState() => _HomeMainScreenState();
}

class _HomeMainScreenState extends State<HomeMainScreen> {
  ValueNotifier<bool> isApiComplete = ValueNotifier(false);
  ValueNotifier<bool> isDataAvailable = ValueNotifier(false);
  List<Sliders>? banner;
  List<Categories>? homeCollection;
  List<NearbyListings>? homeLatestRelease;
  List<LatestListings>? homeNearListing;
  List<Services>? homeService;
  List<NearbyDeals>? homeDeal;
  final bool _isSearching = false;
  final TextEditingController _searchController = TextEditingController();
  String selectedCityName = "Select City";
  int selectedCityId = 0;
  ValueNotifier<bool> isCitySelected = ValueNotifier(false);
  List<Cities> allCities = [];

  @override
  void initState() {
    MyApplication.determinePosition();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkInitialCity();
    });
    callHome();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: _buildHomeScreen());
  }

  Future<void> _checkInitialCity() async {
    await _callCity();
    selectedCityId = AppPrefs.cityId;
    selectedCityName = AppPrefs.cityName;

    if (selectedCityId == 0) {
      _showCitySelectionSheet();
    } else {
      isCitySelected.value = true;
      callHome();
    }
  }

  void _showCitySelectionSheet() {
    List<Cities> filteredCities = List.from(allCities);
    Get.bottomSheet(
      StatefulBuilder(
        builder: (context, setSheetState) {
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 25),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    height: 4,
                    width: 40,
                    margin: const EdgeInsets.only(bottom: 20),
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),

                Text(
                  "Select Your City",
                  style: GoogleFonts.montserrat(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    color: ModernHeritageApp.textDark,
                  ),
                ),
                const SizedBox(height: 15),
                Container(
                  height: 45,
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  decoration: BoxDecoration(
                    color: ModernHeritageApp.appBg,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: TextField(
                    onChanged: (value) {
                      setSheetState(() {
                        filteredCities = allCities
                            .where(
                              (city) => city.name
                                  .toString()
                                  .toLowerCase()
                                  .contains(value.toLowerCase()),
                            )
                            .toList();
                      });
                    },
                    decoration: InputDecoration(
                      hintText: "Search your city...",
                      hintStyle: GoogleFonts.montserrat(
                        fontSize: 12,
                        color: Colors.grey,
                      ),
                      prefixIcon: const Icon(
                        Icons.search,
                        size: 20,
                        color: ModernHeritageApp.primaryCyan,
                      ),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(vertical: 10),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Flexible(
                  child: filteredCities.isEmpty
                      ? Center(
                          child: Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Text(
                              "No city found",
                              style: GoogleFonts.montserrat(color: Colors.grey),
                            ),
                          ),
                        )
                      : ListView.builder(
                          shrinkWrap: true,
                          physics: const BouncingScrollPhysics(),
                          itemCount: filteredCities.length,
                          itemBuilder: (context, index) {
                            var city = filteredCities[index];
                            return _cityTile(
                              city.id ?? 0,
                              city.name ?? "Unknown",
                            );
                          },
                        ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          );
        },
      ),
      isDismissible: true,
      enableDrag: true,
    ).then((value) {
      if (!isCitySelected.value) {
        isCitySelected.value = true;
        callHome();
      }
    });
  }

  Widget _cityTile(int id, String name) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: const CircleAvatar(
        backgroundColor: ModernHeritageApp.appBg,
        child: Icon(
          Icons.location_city,
          color: ModernHeritageApp.primaryCyan,
          size: 18,
        ),
      ),
      title: Text(
        name,
        style: GoogleFonts.montserrat(
          fontWeight: FontWeight.w600,
          fontSize: 15,
        ),
      ),
      trailing: const Icon(
        Icons.arrow_forward_ios,
        size: 14,
        color: Colors.grey,
      ),
      onTap: () async {
        await AppPrefs.setCity(id, name);
        setState(() {
          selectedCityId = id;
          selectedCityName = name;
        });

        isCitySelected.value = true;
        Get.back();
        callHome();
      },
    );
  }

  Widget _buildHomeScreen() {
    return ValueListenableBuilder<bool>(
      valueListenable: isCitySelected,
      builder: (context, cityDone, child) {
        if (!cityDone) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(
                color: ModernHeritageApp.primaryCyan,
              ),
            ),
          );
        }
        return ValueListenableBuilder<bool>(
          valueListenable: isApiComplete,
          builder: (context, apiDone, child) {
            return RefreshIndicator(
              edgeOffset: kToolbarHeight,
              onRefresh: () async {
                await callHome();
              },
              displacement: 80,
              child: CustomScrollView(
                physics: const AlwaysScrollableScrollPhysics(
                  parent: BouncingScrollPhysics(),
                ),
                slivers: [
                  _buildProfessionalAppBar(),

                  if (!apiDone)
                    const SliverFillRemaining(
                      hasScrollBody: false,
                      child: Center(
                        child: CircularProgressIndicator(
                          color: ModernHeritageApp.primaryCyan,
                        ),
                      ),
                    )
                  else
                    ValueListenableBuilder<bool>(
                      valueListenable: isDataAvailable,
                      builder: (context, dataAvailable, child) {
                        if (!dataAvailable) {
                          return SliverFillRemaining(
                            hasScrollBody: false,
                            child: Center(
                              child: Text(
                                "No data available for $selectedCityName",
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          );
                        }

                        return SliverToBoxAdapter(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 10),
                              _buildPremiumImageSlider(),
                              const SizedBox(height: 40),
                              _buildSectionLabel(
                                "EXCLUSIVE DEALS",
                                    () => Get.to(() =>  DealsScreen(isHome: false,)),
                              ),
                              _buildExclusiveDeals(),
                              const SizedBox(height: 40),

                              _buildSectionLabel(
                                "CURATED COLLECTIONS",
                                () => Get.to(() => AllCollectionScreen(isHome: false,)),
                              ),
                              _buildPremiumBentoCollections(),
                              const SizedBox(height: 45),

                              _buildSectionLabel(
                                "LATEST RELEASES",
                                () => Get.to(() => const LatestReleaseScreen()),
                              ),
                              _buildLuxuryProductGallery(),
                              const SizedBox(height: 45),

                              _buildSectionLabel(
                                "NEWLY ADDED LISTING",
                                () => Get.to(() => const NewlyAddedListing()),
                              ),
                              _buildNewlyAddedListings(),
                              const SizedBox(height: 45),

                              _buildSectionLabel(
                                "OUR FEATURED SERVICES",
                                () => Get.to(
                                  () => const OurFeaturedServicesScreen(),
                                ),
                              ),
                              _buildFeaturedServices(),
                              const SizedBox(height: 45),
                              // gotiloPremiumCarousel(),
                              // const SizedBox(height: 45),


                              _buildHowItWorks(),
                              const SizedBox(height: 20),
                              _buildBecomeVendor(context),
                              const SizedBox(height: 150),
                            ],
                          ),
                        );
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

  Widget _buildProfessionalAppBar() {
    return SliverAppBar(
      expandedHeight: 140,
      pinned: true,
      automaticallyImplyLeading: false,
      backgroundColor: ModernHeritageApp.appBg,
      elevation: 0,
      title: _isSearching
          ? Container(
              height: 45,
              margin: const EdgeInsets.only(top: 10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                  ),
                ],
              ),
              child: TextField(
                controller: _searchController,
                autofocus: true,
                style: GoogleFonts.montserrat(
                  color: ModernHeritageApp.textDark,
                  fontSize: 14,
                ),
                decoration: InputDecoration(
                  hintText: "Search here...",
                  hintStyle: GoogleFonts.montserrat(
                    color: ModernHeritageApp.subtleGrey,
                    fontSize: 12,
                  ),
                  prefixIcon: const Icon(
                    Icons.search_rounded,
                    color: ModernHeritageApp.primaryCyan,
                    size: 20,
                  ),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(vertical: 10),
                ),
              ),
            )
          : Align(
              alignment: Alignment.centerLeft,
              child: GestureDetector(
                onTap: () => _showCitySelectionSheet(),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.location_on,
                      color: ModernHeritageApp.primaryCyan,
                      size: 14,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      selectedCityName.toUpperCase(),
                      style: GoogleFonts.montserrat(
                        color: ModernHeritageApp.primaryCyan,
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1.2,
                      ),
                    ),
                    const Icon(
                      Icons.keyboard_arrow_down,
                      color: ModernHeritageApp.subtleGrey,
                      size: 14,
                    ),
                  ],
                ),
              ),
            ),
      flexibleSpace: _isSearching
          ? null
          : FlexibleSpaceBar(
        centerTitle: true,
        titlePadding: const EdgeInsets.only(bottom: 10),
        expandedTitleScale: 1.1,
        title: SizedBox(
          height: 45,
          child: Image.asset(
            "assets/g_logo.png",
            fit: BoxFit.contain,
          ),
        ),
      ),

      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 5),
          child: IconButton(
            onPressed: () {
              Get.to(() => const SearchScreen());
            },
            icon: const Icon(Icons.search),
          ),
        ),
        if (!_isSearching)
          Padding(
            padding: const EdgeInsets.only(right: 15),
            child: InkWell(
              onTap: () {
                // Get.to(()=> AccountScreen());
                if (AppPrefs.userId != "") {
                  Get.to(() => const Userdashboardscreen());
                } else {
                  Get.to(() => const ModernLoginScreen());
                }
              },
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.person_2_outlined,
                  color: ModernHeritageApp.textDark,
                  size: 18,
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildPremiumImageSlider() {
    return ValueListenableBuilder(
      valueListenable: isApiComplete,
      builder: (context, apiDone, child) {
        return Visibility(
          visible: apiDone,
          replacement: _buildBannerShimmer(),
          child: ValueListenableBuilder(
            valueListenable: isDataAvailable,
            builder: (context, dataDone, child) {
              if (!dataDone || banner == null || banner!.isEmpty) {
                return const SizedBox(
                  height: 280,
                  child: Center(child: Text("No Data Available")),
                );
              }
              return SizedBox(
                height: 180,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.only(left: 25),
                  itemCount: banner!.length,
                  itemBuilder: (context, index) {
                    return Container(
                      width: 300,
                      margin: const EdgeInsets.only(right: 20),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF0D1B1E).withOpacity(0.08),
                            blurRadius: 20,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Stack(
                          fit: StackFit.expand,
                          children: [
                            CachedNetworkImage(
                              imageUrl: banner![index].image ?? "",
                              fadeOutDuration: const Duration(
                                milliseconds: 500,
                              ),
                              fadeInDuration: const Duration(milliseconds: 700),
                              fit: BoxFit.cover,
                              placeholder: (context, url) => _shimmerBox(),
                              errorWidget: (context, url, error) => Container(
                                color: Colors.grey[200],
                                child: const Icon(Icons.error),
                              ),
                            ),
                            Container(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [
                                    Colors.transparent,
                                    const Color(0xFF0D1B1E).withOpacity(0.7),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildBannerShimmer() {
    return SizedBox(
      height: 280,
      child: Shimmer.fromColors(
        baseColor: Colors.grey[300]!,
        highlightColor: Colors.grey[100]!,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.only(left: 25),
          itemCount: 3,
          itemBuilder: (_, __) => Container(
            width: 300,
            margin: const EdgeInsets.only(right: 20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(32),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPremiumBentoCollections() {
    if (homeCollection == null || homeCollection!.isEmpty) {
      return const SizedBox.shrink();
    }

    final List<List<Color>> gradients = [
      [const Color(0xFF1E2640), const Color(0xFF0F1424)],
      [const Color(0xFF281D3C), const Color(0xFF130A1E)],
      [const Color(0xFF102A2D), const Color(0xFF051214)],
      [const Color(0xFF232526), const Color(0xFF111111)],
      [const Color(0xFF2D1F1F), const Color(0xFF160E0E)],
      [const Color(0xFF17252A), const Color(0xFF0B1316)],
      [const Color(0xFF1A2332), const Color(0xFF0D131A)],
      [const Color(0xFF1C2826), const Color(0xFF0E1413)],
      [const Color(0xFF2D221E), const Color(0xFF17100E)],
      [const Color(0xFF1E1E24), const Color(0xFF111115)],
    ];


    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      itemCount: homeCollection!.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 14,
        mainAxisSpacing: 14,
        childAspectRatio: 0.82,
      ),
      itemBuilder: (context, index) {
        final category = homeCollection![index];
        final gradient = gradients[index % gradients.length];

        return GestureDetector(
          onTap: () {
            Get.to(
                  () => CollectionDetailScreen(
                categoryId: category.id,
                title: category.name,
              ),
            );
          },
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
                            child: category.icon!.contains('.svg')
                                ? SvgPicture.network(
                              category.icon!,
                              colorFilter: const ColorFilter.mode(
                                Colors.white,
                                BlendMode.srcIn,
                              ),
                              placeholderBuilder: (_) => _shimmerCircle(),
                            )
                                : CachedNetworkImage(
                              imageUrl: category.icon!,
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
                          category.name ?? "",
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
      },
    );
  }

  Widget _buildLuxuryProductGallery() {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: homeLatestRelease?.length,
      padding: const EdgeInsets.symmetric(horizontal: 25),
      itemBuilder: (context, index) {
        return LuxuryCardItem(product: homeLatestRelease![index], index: index);
      },
    );
  }

  Widget _buildSectionLabel(String text, VoidCallback onViewAllTap) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(25, 0, 25, 18),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            text,
            style: GoogleFonts.montserrat(
              color: ModernHeritageApp.textDark,
              fontSize: 12,
              fontWeight: FontWeight.w800,
              letterSpacing: 1.5,
            ),
          ),
          GestureDetector(
            onTap: onViewAllTap,
            child: Text(
              "VIEW ALL",
              style: GoogleFonts.montserrat(
                color: ModernHeritageApp.primaryCyan,
                fontSize: 10,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNewlyAddedListings() {
    if (homeNearListing == null || homeNearListing!.isEmpty) return const SizedBox.shrink();

    // Scroll full block kadhi ne simple Column mapping set kari didhi chhe
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10), // Aakha section mate exact spacing match
      child: Column(
        children: homeNearListing!.map((item) {
          return GestureDetector(
            onTap: () {
              Get.to(
                    () => AllListingDetailScreen(listId: item.id), // Direct loop item mathi j access
              );
            },
            child: Container(
              width: double.infinity, // Single wide block layout mate full width
              margin: const EdgeInsets.only(bottom: 20), // Niche na container sathe perfect visual gap spacing
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(35),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF0D1B1E).withOpacity(0.05),
                    blurRadius: 25,
                    offset: const Offset(0, 15),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(35),
                    ),
                    child: CachedNetworkImage(
                      fadeOutDuration: const Duration(milliseconds: 500),
                      fadeInDuration: const Duration(milliseconds: 700),
                      imageUrl: item.listingImage ?? "",
                      height: 200,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => _shimmerBox(),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.listingTitle ?? "",
                          style: GoogleFonts.montserrat(
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          item.description ?? "",
                          maxLines: 2, // Full width screen chhe aetle look rich lagva maxlines 2 kari didhi
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.montserrat(
                            fontSize: 11,
                            color: Colors.grey,
                          ),
                        ),
                        const SizedBox(height: 15),
                        Row(
                          children: [
                            const Icon(
                              Icons.location_on_rounded,
                              color: Colors.cyan,
                              size: 14,
                            ),
                            const SizedBox(width: 5),
                            Text(
                              item.cityName ?? "",
                              style: GoogleFonts.montserrat(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
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
          );
        }).toList(),
      ),
    );
  }

  Widget _buildFeaturedServices() {
    if (homeService == null) return const SizedBox.shrink();
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: homeService!.length,
      padding: const EdgeInsets.only(left: 55, right: 25, top: 25),
      itemBuilder: (context, index) {
        final service = homeService![index];
        return Stack(
          clipBehavior: Clip.none,
          children: [
            GestureDetector(
              onTap: () {
                Get.to(
                  () => CollectionDetailScreen(
                    categoryId: homeService?[index].id,
                    title: homeService?[index].name
                  ),
                );
              },
              child: Container(
                margin: const EdgeInsets.only(bottom: 45),
                padding: const EdgeInsets.only(
                  left: 70,
                  right: 20,
                  top: 25,
                  bottom: 25,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(35),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF0D1B1E).withOpacity(0.06),
                      blurRadius: 35,
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
                            service.name ?? "",
                            style: GoogleFonts.montserrat(
                              fontSize: 18,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            service.slug ?? "",
                            style: GoogleFonts.montserrat(
                              fontSize: 13,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Icon(
                      Icons.arrow_forward_ios_rounded,
                      color: Colors.cyan,
                      size: 22,
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              left: -40,
              top: 10,
              child: Container(
                height: 100,
                width: 100,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 5),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(50),
                  child: CachedNetworkImage(
                    fadeOutDuration: const Duration(milliseconds: 500),
                    fadeInDuration: const Duration(milliseconds: 700),
                    imageUrl: service.serviceImage ?? "",
                    fit: BoxFit.cover,
                    placeholder: (context, url) => _shimmerCircle(),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildExclusiveDeals() {
    if (homeDeal == null || homeDeal!.isEmpty) return const SizedBox.shrink();

    // Scroll full block kadhi nakhyo chhe jethi main home scroll ma locho na thay
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10), // Aakha group mate unified padding
      child: Column(
        children: homeDeal!.map((deal) {
          return Container(
            width: double.infinity, // Single block dynamic layout
            margin: const EdgeInsets.only(bottom: 20), // Each card vachhe niche ni side spacing
            decoration: BoxDecoration(
              color: ModernHeritageApp.cardColor,
              borderRadius: BorderRadius.circular(35),
              boxShadow: [
                BoxShadow(
                  color: ModernHeritageApp.textDark.withOpacity(0.08),
                  blurRadius: 25,
                  offset: const Offset(0, 15),
                ),
              ],
            ),
            child: Column(
              children: [
                Stack(
                  children: [
                    ClipRRect(
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(35),
                      ),
                      child: CachedNetworkImage(
                        fadeOutDuration: const Duration(milliseconds: 500),
                        fadeInDuration: const Duration(milliseconds: 700),
                        imageUrl: deal.templateImage ?? "",
                        height: 200, // Card custom size height fix layout mapping
                        width: double.infinity,
                        fit: BoxFit.cover,
                        placeholder: (context, url) => Shimmer.fromColors(
                          baseColor: Colors.grey[300]!,
                          highlightColor: Colors.grey[100]!,
                          child: Container(color: Colors.white),
                        ),
                        errorWidget: (context, url, error) => Container(
                          color: Colors.grey[200],
                          child: const Icon(
                            Icons.broken_image,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      top: 20,
                      left: 20,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.redAccent,
                          borderRadius: BorderRadius.circular(15),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.redAccent.withOpacity(0.3),
                              blurRadius: 10,
                            ),
                          ],
                        ),
                        child: Text(
                          deal.dealName ?? "OFFER",
                          style: GoogleFonts.montserrat(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 1,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        deal.dealDesc ?? "",
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.montserrat(
                          color: ModernHeritageApp.textDark,
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 15),
                      Container(
                        width: double.infinity,
                        height: 50,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [
                              ModernHeritageApp.primaryCyan,
                              ModernHeritageApp.accentCyan,
                            ],
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                          ),
                          borderRadius: BorderRadius.circular(18),
                          boxShadow: [
                            BoxShadow(
                              color: ModernHeritageApp.primaryCyan.withOpacity(
                                0.3,
                              ),
                              blurRadius: 12,
                              offset: const Offset(0, 6),
                            ),
                          ],
                        ),
                        child: ElevatedButton(
                          onPressed: () {
                            if (AppPrefs.userId != "") {
                              _callCrackDeal(dealId: deal.id.toString());
                            } else {
                              SharedWidgets.showTopSnackBar(
                                context,
                                message: "Login First",
                              );
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            shadowColor: Colors.transparent,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18),
                            ),
                          ),
                          child: Text(
                            "CRACK THE DEAL",
                            style: GoogleFonts.montserrat(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w800,
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
        }).toList(), // List of widgets ma pack kari didhu boss
      ),
    );
  }

  Widget _buildHowItWorks() {
    List<Map<String, String>> steps = [
      {
        "id": "1",
        "title": "Choose Location",
        "desc": "Enter your mobile number to get started.",
        "icon": "📍",
      },
      {
        "id": "2",
        "title": "Pick Category",
        "desc": "Select the most relevant category for your needs.",
        "icon": "📂",
      },
      {
        "id": "3",
        "title": "Explore Place",
        "desc": "Discover locations tailored to your specific needs.",
        "icon": "⭐",
      },
    ];

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            ModernHeritageApp.textDark,
            ModernHeritageApp.textDark.withOpacity(0.8),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(40),
        boxShadow: [
          BoxShadow(
            color: ModernHeritageApp.primaryCyan.withOpacity(0.15),
            blurRadius: 30,
            offset: const Offset(0, 15),
          ),
        ],
      ),
      child: Column(
        children: [
          RichText(
            text: TextSpan(
              style: GoogleFonts.montserrat(
                fontSize: 22,
                fontWeight: FontWeight.w800,
                color: Colors.white,
              ),
              children: const [
                TextSpan(text: "How Gotilo "),
                TextSpan(
                  text: "Works",
                  style: TextStyle(color: ModernHeritageApp.accentCyan),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Text(
            "Discover how Gotilo connects you with trusted businesses in just a few simple steps.",
            textAlign: TextAlign.center,
            style: GoogleFonts.montserrat(
              color: Colors.white.withOpacity(0.6),
              fontSize: 11,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 40),

          ...steps.map((step) {
            int index = steps.indexOf(step);
            return Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 50,
                      width: 50,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.05),
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: ModernHeritageApp.accentCyan.withOpacity(0.3),
                        ),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        step["icon"]!,
                        style: const TextStyle(fontSize: 20),
                      ),
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "${step["id"]}. ${step["title"]}",
                            style: GoogleFonts.montserrat(
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            step["desc"]!,
                            style: GoogleFonts.montserrat(
                              color: Colors.white.withOpacity(0.5),
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                if (index != steps.length - 1)
                  Padding(
                    padding: const EdgeInsets.only(left: 25, top: 5, bottom: 5),
                    child: Container(
                      height: 30,
                      width: 1,
                      color: ModernHeritageApp.accentCyan.withOpacity(0.2),
                    ),
                  ),
              ],
            );
          }),
        ],
      ),
    );
  }

  Widget _buildBecomeVendor(BuildContext context) { // context pass karvo padse bottom sheet mate boss
    List<Map<String, String>> vendorSteps = [
      {
        "id": "1",
        "title": "Call or WhatsApp Us",
        "desc": "+91 8382868288",
        "icon": "📞",
      },
      {
        "id": "2",
        "title": "Email Your Details",
        "desc": "info@gotilo.net",
        "icon": "✉️",
      },
    ];

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            ModernHeritageApp.textDark,
            ModernHeritageApp.textDark.withOpacity(0.8),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(40),
        boxShadow: [
          BoxShadow(
            color: ModernHeritageApp.primaryCyan.withOpacity(0.15),
            blurRadius: 30,
            offset: const Offset(0, 15),
          ),
        ],
      ),
      child: Column(
        children: [
          RichText(
            text: TextSpan(
              style: GoogleFonts.montserrat(
                fontSize: 22,
                fontWeight: FontWeight.w800,
                color: Colors.white,
              ),
              children: const [
                TextSpan(text: "Become a "),
                TextSpan(
                  text: "Vendor",
                  style: TextStyle(color: ModernHeritageApp.accentCyan),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Text(
            "Grow your business with Gotilo. Reach out to our team via phone or email to get listed today.",
            textAlign: TextAlign.center,
            style: GoogleFonts.montserrat(
              color: Colors.white.withOpacity(0.6),
              fontSize: 11,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 40),

          ...vendorSteps.map((step) {
            int index = vendorSteps.indexOf(step);
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      height: 50,
                      width: 50,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.05),
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: ModernHeritageApp.accentCyan.withOpacity(0.3),
                        ),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        step["icon"]!,
                        style: const TextStyle(fontSize: 20),
                      ),
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            step["title"]!,
                            style: GoogleFonts.montserrat(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            step["desc"]!,
                            style: GoogleFonts.montserrat(
                              color: ModernHeritageApp.accentCyan,
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                if (index != vendorSteps.length - 1)
                  Padding(
                    padding: const EdgeInsets.only(left: 25, top: 5, bottom: 5),
                    child: Container(
                      height: 30,
                      width: 1,
                      color: ModernHeritageApp.accentCyan.withOpacity(0.2),
                    ),
                  ),
              ],
            );
          }),

          const SizedBox(height: 30),

          // NEW: Send Inquiry Premium Button Integration
          Container(
            width: double.infinity,
            height: 52,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [
                  ModernHeritageApp.primaryCyan,
                  ModernHeritageApp.accentCyan,
                ],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: ModernHeritageApp.primaryCyan.withOpacity(0.3),
                  blurRadius: 12,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: ElevatedButton(
              onPressed: () => _showInquiryBottomSheet(context), // Bottom sheet function call
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                shadowColor: Colors.transparent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child: Text(
                "SEND INQUIRY",
                style: GoogleFonts.montserrat(
                  color: Colors.white,
                  fontSize: 13,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1.2,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

// NEW FUNCTION: Clean & Premium Bottom Sheet Form Setup
  void _showInquiryBottomSheet(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    final nameController = TextEditingController();
    final phoneController = TextEditingController();
    final emailController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true, // Keyboard aave tyre adjust thava mate essential chhe boss
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom, // Keyboard padding dynamic constraint
          ),
          child: Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(35)),
            ),
            padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
            child: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Top Notch Indicator Line
                  Center(
                    child: Container(
                      width: 50,
                      height: 5,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  const SizedBox(height: 25),

                  Text(
                    "Vendor Inquiry",
                    style: GoogleFonts.montserrat(
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                      color: ModernHeritageApp.textDark,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    "Fill your details and our team will connect with you.",
                    style: GoogleFonts.montserrat(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 25),

                  // Name Input Field
                  _buildTextField(
                    controller: nameController,
                    label: "Full Name",
                    hint: "Enter your full name",
                    icon: Icons.person_outline_rounded,
                    validator: (val) => val == null || val.trim().isEmpty ? "Please enter name" : null,
                  ),
                  const SizedBox(height: 18),

                  // Phone Input Field
                  _buildTextField(
                    controller: phoneController,
                    label: "Mobile Number",
                    hint: "Enter 10-digit number",
                    icon: Icons.phone_android_outlined,
                    keyboardType: TextInputType.phone,
                    maxLength: 10,
                    validator: (val) {
                      if (val == null || val.trim().isEmpty) return "Please enter mobile number";
                      if (val.trim().length != 10) return "Enter valid 10 digit number";
                      return null;
                    },
                  ),
                  const SizedBox(height: 18),

                  // Email Input Field
                  _buildTextField(
                    controller: emailController,
                    label: "Email Address",
                    hint: "Enter your email",
                    icon: Icons.email_outlined,
                    keyboardType: TextInputType.emailAddress,
                    validator: (val) {
                      if (val == null || val.trim().isEmpty) return "Please enter email";
                      if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(val.trim())) {
                        return "Enter a valid email address";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 30),

                  // Save / Submit Button
                  Container(
                    width: double.infinity,
                    height: 52,
                    decoration: BoxDecoration(
                      color: ModernHeritageApp.textDark,
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: ElevatedButton(
                      onPressed: () {
                        if (formKey.currentState!.validate()) {
                          // TODO: Tame tamari Inquiry API ahi call kari sako chho boss
                          debugPrint("Name: ${nameController.text}");
                          debugPrint("Phone: ${phoneController.text}");
                          debugPrint("Email: ${emailController.text}");
                          _callBecomeVendor(
                            name: nameController.text,
                            email: emailController.text,
                            number: phoneController.text,
                          );
                          Navigator.pop(context);


                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18),
                        ),
                      ),
                      child: Text(
                        "SAVE INQUIRY",
                        style: GoogleFonts.montserrat(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1,
                        ),
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

// Helper Widget: Safe Textfield Creator Reusable Design Pattern
  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    int? maxLength,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      maxLength: maxLength,
      validator: validator,
      style: GoogleFonts.montserrat(fontSize: 14, color: ModernHeritageApp.textDark, fontWeight: FontWeight.w600),
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        counterText: "", // Character limit label hide thay e mate
        labelStyle: GoogleFonts.montserrat(color: Colors.grey[600], fontSize: 13, fontWeight: FontWeight.w500),
        hintStyle: GoogleFonts.montserrat(color: Colors.grey[400], fontSize: 13),
        prefixIcon: Icon(icon, color: ModernHeritageApp.primaryCyan, size: 20),
        filled: true,
        fillColor: Colors.grey[50],
        contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(color: Colors.grey[200]!, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(color: ModernHeritageApp.primaryCyan, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(color: Colors.redAccent, width: 1),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(color: Colors.redAccent, width: 1.5),
        ),
      ),
    );
  }


  Widget gotiloPremiumCarousel() {
    final List<Map<String, String>> listingData = [
      {
        'title': 'The Grand Restaurant',
        'city': 'Rajkot',
        'category': 'Restaurant',
        'badge': '🔥 Trending',
        'image':
        'https://images.unsplash.com/photo-1517248135467-4c7edcad34c4?w=1600&q=100',
      },
      {
        'title': 'Luxury Spa Center',
        'city': 'Ahmedabad',
        'category': 'Beauty & Spa',
        'badge': '⭐ Popular',
        'image':
        'https://images.unsplash.com/photo-1544161515-4ab6ce6db874?w=1600&q=100',
      },
      {
        'title': 'Elite Gym Club',
        'city': 'Surat',
        'category': 'Fitness',
        'badge': '💪 Featured',
        'image':
        'https://images.unsplash.com/photo-1534438327276-14e5300c3a48?w=1600&q=100',
      },
      {
        'title': 'Royal Cafe',
        'city': 'Vadodara',
        'category': 'Cafe',
        'badge': '☕ Trending',
        'image':
        'https://images.unsplash.com/photo-1554118811-1e0d58224f24?w=1600&q=100',
      },
    ];

    final PageController pageController = PageController(
      viewportFraction: 0.82,
    );

    double currentPage = 0;

    return StatefulBuilder(
      builder: (context, setState) {
        pageController.addListener(() {
          if (pageController.position.haveDimensions) {
            setState(() {
              currentPage = pageController.page ?? 0;
            });
          }
        });

        return Column(
          children: [
            SizedBox(
              height: 350,
              child: PageView.builder(
                controller: pageController,
                clipBehavior: Clip.none,
                physics: const BouncingScrollPhysics(),
                itemCount: listingData.length,
                itemBuilder: (context, index) {
                  final item = listingData[index];

                  double diff = index - currentPage;

                  final scale =
                  (1 - (diff.abs() * 0.08))
                      .clamp(0.90, 1.0);

                  final opacity =
                  (1 - (diff.abs() * 0.22))
                      .clamp(0.72, 1.0);

                  final translateY =
                      diff.abs() * 14;

                  final rotate =
                      diff * -0.02;

                  return Transform(
                    transform: Matrix4.identity()
                      ..translate(0.0, translateY)
                      ..setEntry(3, 2, 0.001)
                      ..rotateZ(rotate)
                      ..scale(scale),
                    alignment: Alignment.center,
                    child: Opacity(
                      opacity: opacity,
                      child: Container(
                        margin: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 18,
                        ),
                        decoration: BoxDecoration(
                          borderRadius:
                          BorderRadius.circular(36),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black
                                  .withOpacity(0.20),
                              blurRadius: 35,
                              spreadRadius: 2,
                              offset:
                              const Offset(0, 18),
                            ),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius:
                          BorderRadius.circular(36),
                          child: Stack(
                            children: [
                              /// SHARP IMAGE
                              Positioned.fill(
                                child:
                                CachedNetworkImage(
                                  imageUrl:
                                  item['image']!,
                                  fit: BoxFit.cover,
                                  memCacheWidth:
                                  1600,
                                  fadeInDuration:
                                  const Duration(
                                    milliseconds:
                                    250,
                                  ),
                                  imageBuilder:
                                      (context,
                                      imageProvider) {
                                    return Container(
                                      decoration:
                                      BoxDecoration(
                                        image:
                                        DecorationImage(
                                          image:
                                          imageProvider,
                                          fit: BoxFit
                                              .cover,
                                          filterQuality:
                                          FilterQuality
                                              .high,
                                        ),
                                      ),
                                    );
                                  },
                                  placeholder:
                                      (context,
                                      url) =>
                                      Container(
                                        color: const Color(
                                            0xFF101418),
                                      ),
                                  errorWidget:
                                      (context,
                                      url,
                                      error) =>
                                      Container(
                                        color: Colors
                                            .grey[900],
                                        child:
                                        const Icon(
                                          Icons
                                              .image_not_supported,
                                          color: Colors
                                              .white54,
                                        ),
                                      ),
                                ),
                              ),

                              /// DARK PREMIUM OVERLAY
                              Positioned.fill(
                                child: Container(
                                  decoration:
                                  BoxDecoration(
                                    gradient:
                                    LinearGradient(
                                      begin:
                                      Alignment
                                          .topCenter,
                                      end:
                                      Alignment
                                          .bottomCenter,
                                      colors: [
                                        Colors.black
                                            .withOpacity(
                                            0.08),
                                        Colors
                                            .transparent,
                                        Colors.black
                                            .withOpacity(
                                            0.82),
                                      ],
                                      stops:
                                      const [
                                        0.0,
                                        0.45,
                                        1.0
                                      ],
                                    ),
                                  ),
                                ),
                              ),

                              /// BADGE
                              Positioned(
                                top: 22,
                                left: 22,
                                child: Container(
                                  padding:
                                  const EdgeInsets.symmetric(
                                    horizontal:
                                    14,
                                    vertical: 8,
                                  ),
                                  decoration:
                                  BoxDecoration(
                                    color: Colors
                                        .black
                                        .withOpacity(
                                        0.22),
                                    borderRadius:
                                    BorderRadius.circular(
                                        50),
                                    border:
                                    Border.all(
                                      color: Colors
                                          .white24,
                                    ),
                                  ),
                                  child: Text(
                                    item['badge']!,
                                    style:
                                    const TextStyle(
                                      color:
                                      Colors.white,
                                      fontWeight:
                                      FontWeight
                                          .w700,
                                    ),
                                  ),
                                ),
                              ),

                              /// GLASS INFO CARD
                              Positioned(
                                left: 18,
                                right: 18,
                                bottom: 18,
                                child: ClipRRect(
                                  borderRadius:
                                  BorderRadius.circular(
                                      28),
                                  child:
                                  BackdropFilter(
                                    filter:
                                    ImageFilter.blur(
                                      sigmaX: 18,
                                      sigmaY: 18,
                                    ),
                                    child:
                                    Container(
                                      padding:
                                      const EdgeInsets
                                          .all(
                                          18),
                                      decoration:
                                      BoxDecoration(
                                        color: Colors
                                            .white
                                            .withOpacity(
                                            0.10),
                                        borderRadius:
                                        BorderRadius.circular(
                                            28),
                                        border:
                                        Border.all(
                                          color: Colors
                                              .white
                                              .withOpacity(
                                              0.12),
                                        ),
                                      ),
                                      child:
                                      Column(
                                        crossAxisAlignment:
                                        CrossAxisAlignment
                                            .start,
                                        mainAxisSize:
                                        MainAxisSize
                                            .min,
                                        children: [
                                          Text(
                                            item[
                                            'title']!,
                                            maxLines:
                                            2,
                                            overflow:
                                            TextOverflow
                                                .ellipsis,
                                            style:
                                            const TextStyle(
                                              color:
                                              Colors
                                                  .white,
                                              fontSize:
                                              24,
                                              fontWeight:
                                              FontWeight
                                                  .w800,
                                              height:
                                              1.1,
                                            ),
                                          ),

                                          const SizedBox(
                                              height:
                                              14),

                                          Wrap(
                                            spacing: 8,
                                            runSpacing: 8,
                                            children: [
                                              /// CITY CHIP
                                              Container(
                                                padding: const EdgeInsets.symmetric(
                                                  horizontal: 12,
                                                  vertical: 8,
                                                ),
                                                decoration: BoxDecoration(
                                                  color: Colors.white.withOpacity(0.12),
                                                  borderRadius: BorderRadius.circular(40),
                                                ),
                                                child: Row(
                                                  mainAxisSize: MainAxisSize.min,
                                                  children: [
                                                    const Icon(
                                                      Icons.location_on_rounded,
                                                      size: 15,
                                                      color: Colors.white,
                                                    ),
                                                    const SizedBox(width: 4),
                                                    Flexible(
                                                      child: Text(
                                                        item['city']!,
                                                        overflow: TextOverflow.ellipsis,
                                                        style: const TextStyle(
                                                          color: Colors.white,
                                                          fontWeight: FontWeight.w600,
                                                          fontSize: 12,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),

                                              /// CATEGORY CHIP
                                              Container(
                                                padding: const EdgeInsets.symmetric(
                                                  horizontal: 12,
                                                  vertical: 8,
                                                ),
                                                decoration: BoxDecoration(
                                                  gradient: LinearGradient(
                                                    colors: [
                                                      const Color(0xFF00C6FF).withOpacity(0.25),
                                                      const Color(0xFF0072FF).withOpacity(0.25),
                                                    ],
                                                  ),
                                                  borderRadius: BorderRadius.circular(40),
                                                ),
                                                child: Text(
                                                  item['category']!,
                                                  overflow: TextOverflow.ellipsis,
                                                  style: const TextStyle(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: 12,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          )
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

            const SizedBox(height: 8),

            Row(
              mainAxisAlignment:
              MainAxisAlignment.center,
              children: List.generate(
                listingData.length,
                    (index) =>
                    AnimatedContainer(
                      duration:
                      const Duration(
                          milliseconds:
                          300),
                      margin:
                      const EdgeInsets.symmetric(
                        horizontal: 4,
                      ),
                      height: 7,
                      width:
                      currentPage.round() ==
                          index
                          ? 24
                          : 8,
                      decoration:
                      BoxDecoration(
                        gradient:
                        currentPage.round() ==
                            index
                            ? const LinearGradient(
                          colors: [
                            Color(
                                0xFF00C6FF),
                            Color(
                                0xFF0072FF),
                          ],
                        )
                            : null,
                        color:
                        currentPage.round() ==
                            index
                            ? null
                            : ModernHeritageApp.textDark,
                        borderRadius:
                        BorderRadius.circular(
                            30),
                      ),
                    ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _shimmerBox() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(color: Colors.white),
    );
  }

  Widget _shimmerCircle() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: const CircleAvatar(backgroundColor: Colors.white),
    );
  }

  Future<void> callHome() async {
    isDataAvailable.value = false;
    isApiComplete.value = false;
    _callHome();
  }

  Future<void> _callHome() async {
    try {
      bool internet = await MyApplication.checkInternet();

      if (!internet) {
        isDataAvailable.value = false;
        isApiComplete.value = true;
        return;
      }

      ResponseHome? response = await ApiCalls.callHome();

      if (response != null &&
          response.result != null &&
          response.result!.isNotEmpty &&
          response.result!.toLowerCase().contains("pass") &&
          response.data != null) {
        banner ??= [];
        banner!.clear();
        homeCollection ??= [];
        homeCollection!.clear();
        homeNearListing ??= [];
        homeNearListing!.clear();
        homeLatestRelease ??= [];
        homeLatestRelease!.clear();
        homeService ??= [];
        homeService!.clear();
        homeDeal ??= [];
        homeDeal!.clear();

        homeDeal!.addAll(response.data!.nearbyDeals!);
        banner!.addAll(response.data!.sliders!);
        homeCollection!.addAll(response.data!.categories!);
        homeNearListing!.addAll(response.data!.latestListings!);
        homeLatestRelease!.addAll(response.data!.nearbyListings!);
        homeService!.addAll(response.data!.services!);

        isDataAvailable.value = true;
      } else {
        banner ??= [];
        banner!.clear();
        homeCollection ??= [];
        homeCollection!.clear();
        homeNearListing ??= [];
        homeNearListing!.clear();
        homeLatestRelease ??= [];
        homeLatestRelease!.clear();
        homeService ??= [];
        homeService!.clear();
        homeDeal ??= [];
        homeDeal!.clear();

        isDataAvailable.value = false;
      }
    } catch (e) {
      log("HomeBanner Error: $e");
      banner ??= [];
      banner!.clear();
      homeCollection ??= [];
      homeCollection!.clear();
      homeNearListing ??= [];
      homeNearListing!.clear();
      homeLatestRelease ??= [];
      homeLatestRelease!.clear();
      homeService ??= [];
      homeService!.clear();
      homeDeal ??= [];
      homeDeal!.clear();
      isDataAvailable.value = false;
    } finally {
      isApiComplete.value = true;
      if (mounted) {
        setState(() {});
      }
    }
  }

  Future<void> callCity() async {
    _callCity();
  }

  Future<void> _callCity() async {
    try {
      bool internet = await MyApplication.checkInternet();

      if (!internet) {
        isDataAvailable.value = false;
        isApiComplete.value = true;
        return;
      }

      ResponseCity? response = await ApiCalls.callCity();
      if (response != null &&
          response.result != null &&
          response.result!.isNotEmpty &&
          response.result!.toLowerCase().contains("pass") &&
          response.cities != null) {
        allCities.clear();
        allCities.addAll(response.cities!);
      } else {
        allCities.clear();
      }
    } catch (e) {
      log("HomeBanner Error: $e");
      allCities.clear();
    } finally {
      if (mounted) {
        setState(() {});
      }
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
      allCities.clear();
    } finally {
      if (mounted) {
        setState(() {});
      }
    }
  }


  Future<void> _callBecomeVendor({String? name,String? number,String? email}) async {
    MyApplication.checkInternet().then((internet) async {
        if(internet){
          try{
            ResponseBecomeVendor? response = await ApiCalls.callBecomeVendor(RequestBecomeVendor(
              phone: number,
              name: name,
              email: email
            ));
            if(response != null){
              if(response.result!.isNotEmpty && response.result != null &&
              response.result!.toLowerCase().contains("pass")){
                SharedWidgets.showTopSnackBar(context, message: response.message!);
              }
            }
          }on Exception catch(e){
            log("$e");
          }catch(e){
            log("$e");
          }
        }
    },);
  }
}