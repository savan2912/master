import 'dart:developer';
import 'dart:ui';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gotilo_new/Api/Response/City/ResponseCity.dart';
import 'package:gotilo_new/CustomeWidgets/SharedWidgets.dart';
import 'package:gotilo_new/Screens/AllListing/AllListingDetailScreen.dart';
import 'package:gotilo_new/Screens/Search/SearchScreen.dart';
import 'package:gotilo_new/Screens/User/Dashboard/UserDashboardScreen.dart';
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
                                "CURATED COLLECTIONS",
                                () => Get.to(() => const AllCollectionScreen()),
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

                              _buildSectionLabel(
                                "EXCLUSIVE DEALS",
                                () => Get.to(() => const DealsScreen()),
                              ),
                              _buildExclusiveDeals(),
                              const SizedBox(height: 45),

                              _buildHowItWorks(),
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
              titlePadding: const EdgeInsets.only(bottom: 12),
              expandedTitleScale: 1.2,
              title: Text(
                "GOTILO",
                style: GoogleFonts.playfairDisplay(
                  color: ModernHeritageApp.textDark,
                  fontSize: 22,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 0.5,
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
                height: 280,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.only(left: 25),
                  itemCount: banner!.length,
                  itemBuilder: (context, index) {
                    return Container(
                      width: 300,
                      margin: const EdgeInsets.only(right: 20),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(32),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF0D1B1E).withOpacity(0.08),
                            blurRadius: 30,
                            offset: const Offset(0, 15),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(30),
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
    final List<Color> colors = [
      Colors.blueAccent,
      Colors.redAccent,
      Colors.greenAccent,
      Colors.orangeAccent,
      Colors.purpleAccent,
    ];

    if (homeCollection == null || homeCollection!.isEmpty)
      return const SizedBox.shrink();

    return SizedBox(
      height: 180,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.only(left: 25, right: 10),
        physics: const BouncingScrollPhysics(),
        itemCount: homeCollection!.length > 4 ? 4 : homeCollection!.length,
        itemBuilder: (context, index) {
          bool isLong = index % 2 == 0;
          Color circleColor = colors[index % colors.length];
          final category = homeCollection![index];

          return GestureDetector(
            onTap: () {
              Get.to(
                () => CollectionDetailScreen(
                  categoryId: homeCollection?[index].id,
                ),
              );
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 500),
              width: 150,
              margin: EdgeInsets.only(
                right: 18,
                top: isLong ? 0 : 25,
                bottom: isLong ? 25 : 0,
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(32),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF0D1B1E).withOpacity(0.05),
                    blurRadius: 25,
                    offset: const Offset(0, 12),
                  ),
                ],
              ),
              child: Stack(
                children: [
                  Positioned(
                    top: -25,
                    right: -25,
                    child: CircleAvatar(
                      radius: 50,
                      backgroundColor: circleColor.withOpacity(0.3),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(22),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 42,
                          width: 42,
                          child: category.icon!.contains('.svg')
                              ? SvgPicture.network(
                                  category.icon!,
                                  placeholderBuilder: (context) =>
                                      _shimmerCircle(),
                                )
                              : CachedNetworkImage(
                                  fadeOutDuration: const Duration(
                                    milliseconds: 500,
                                  ),
                                  fadeInDuration: const Duration(
                                    milliseconds: 700,
                                  ),
                                  imageUrl: category.icon!,
                                  placeholder: (context, url) =>
                                      _shimmerCircle(),
                                  errorWidget: (context, url, error) =>
                                      const Icon(Icons.category),
                                ),
                        ),
                        const Spacer(),
                        SizedBox(
                          width: double.infinity,
                          child: Text(
                            category.name ?? "",
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.montserrat(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFF0D1B1E),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
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
    if (homeNearListing == null) return const SizedBox.shrink();
    return SizedBox(
      height: 340,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.only(left: 25),
        itemCount: homeNearListing!.length,
        itemBuilder: (context, index) {
          final item = homeNearListing![index];
          return GestureDetector(
            onTap: () {
              Get.to(
                () =>
                    AllListingDetailScreen(listId: homeNearListing?[index].id),
              );
            },
            child: Container(
              width: 260,
              margin: const EdgeInsets.only(right: 20),
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
                          maxLines: 1,
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
        },
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

    return SizedBox(
      height: 380,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.only(left: 25),
        itemCount: homeDeal!.length,
        itemBuilder: (context, index) {
          final deal = homeDeal![index];
          return Container(
            width: 280,
            margin: const EdgeInsets.only(right: 20, bottom: 10),
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
                        height: 180,
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
                        maxLines: 1,
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
                            SharedWidgets.showTopSnackBar(
                              context,
                              message: "Login First",
                            );
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
        },
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
}
// W/WindowOnBackDispatcher(16564): OnBackInvokedCallback is not enabled for the application.
// W/WindowOnBackDispatcher(16564): Set 'android:enableOnBackInvokedCallback="true"' in the application manifest.