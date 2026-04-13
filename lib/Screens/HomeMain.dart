
import 'dart:developer';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:google_fonts/google_fonts.dart';

import '../Api/ApiCalls.dart';
import '../Api/Response/Home/ResponseHome.dart';
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
class HomeMainScreen extends StatefulWidget {
  const HomeMainScreen({super.key});
  @override
  State<HomeMainScreen> createState() => _HomeMainScreenState();
}

class _HomeMainScreenState extends State<HomeMainScreen> {

  ValueNotifier<bool> isApiComplete=ValueNotifier(false);
  ValueNotifier<bool> isDataAvailable=ValueNotifier(false);

  List<Sliders>? banner;
  List<Categories>?  homeCollection;
  List<NearbyListings>? homeLatestRelease;
  List<LatestListings>? homeNearListing;
  List<Services>?   homeService;
  List<NearbyDeals>? homeDeal;
  bool _isSearching = false;
  final TextEditingController _searchController = TextEditingController();


  @override
  void initState() {
   callHome();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildHomeScreen(),
    );
  }

  Widget _buildHomeScreen() {
    return ValueListenableBuilder<bool>(
      valueListenable: isApiComplete,
      builder: (context, apiDone, child) {
        return CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            // 1. AppBar હંમેશા દેખાશે
            _buildProfessionalAppBar(),

            // 2. લોડિંગ સ્ટેટ (જ્યારે API બાકી હોય)
            if (!apiDone)
              const SliverFillRemaining(
                hasScrollBody: false,
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              )

            // 3. ડેટા ચેક (જ્યારે API પૂરું થઈ જાય)
            else
              ValueListenableBuilder<bool>(
                valueListenable: isDataAvailable,
                builder: (context, dataAvailable, child) {
                  // જો ડેટા નથી (No Data State)
                  if (!dataAvailable) {
                    return const SliverFillRemaining(
                      hasScrollBody: false,
                      child: Center(
                        child: Text(
                          "No data available",
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                        ),
                      ),
                    );
                  }

                  // જો ડેટા છે (Main Content)
                  return SliverToBoxAdapter(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 10),
                        _buildPremiumImageSlider(),
                        const SizedBox(height: 40),

                        _buildSectionLabel("CURATED COLLECTIONS", () {
                          Get.to(() => const AllCollectionScreen());
                        }),
                        _buildPremiumBentoCollections(),
                        const SizedBox(height: 45),

                        _buildSectionLabel("LATEST RELEASES", () {
                          Get.to(() => const LatestReleaseScreen());
                        }),
                        _buildLuxuryProductGallery(),
                        const SizedBox(height: 45),

                        _buildSectionLabel("NEWLY ADDED LISTING", () {
                          Get.to(() => const NewlyAddedListing());
                        }),
                        _buildNewlyAddedListings(),
                        const SizedBox(height: 45),

                        _buildSectionLabel("OUR FEATURED SERVICES", () {
                          Get.to(() => const OurFeaturedServicesScreen());
                        }),
                        _buildFeaturedServices(),
                        const SizedBox(height: 45),

                        _buildSectionLabel("EXCLUSIVE DEALS", () {
                          Get.to(() => const DealsScreen());
                        }),
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
        );
      },
    );
  }
  Widget _buildProfessionalAppBar() {
    return SliverAppBar(
      expandedHeight: 120,
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
            BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)
          ],
        ),
        child: TextField(
          controller: _searchController,
          autofocus: true,
          style: GoogleFonts.montserrat(color: ModernHeritageApp.textDark, fontSize: 14),
          decoration: InputDecoration(
            hintText: "Search here...",
            hintStyle: GoogleFonts.montserrat(color: ModernHeritageApp.subtleGrey, fontSize: 12),
            prefixIcon: const Icon(Icons.search_rounded, color: ModernHeritageApp.primaryCyan, size: 20),
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(vertical: 10),
          ),
        ),
      )
          : null,

      flexibleSpace: _isSearching
          ? null
          : FlexibleSpaceBar(
        titlePadding: const EdgeInsets.only(left: 25, bottom: 15),
        title: Text(
          "GOTILO",
          style: GoogleFonts.playfairDisplay(
            color: ModernHeritageApp.textDark,
            fontSize: 24,
            fontWeight: FontWeight.w800,
            letterSpacing: -0.5,
          ),
        ),
        centerTitle: false,
      ),

      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 5),
          child: IconButton(
            onPressed: () {
              setState(() {
                _isSearching = !_isSearching;
                if (!_isSearching) _searchController.clear();
              });
            },
            icon: Icon(
              _isSearching ? Icons.close_rounded : Icons.search_rounded,
              color: ModernHeritageApp.textDark,
              size: 26,
            ),
          ),
        ),

        if (!_isSearching)
          Padding(
            padding: const EdgeInsets.only(right: 20, top: 8, bottom: 8),
            child: InkWell(
              onTap: () {
                Get.to(()=> const ModernLoginScreen());
              },
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)],
                  border: Border.all(color: ModernHeritageApp.appBg, width: 1.5),
                ),
                child: const Icon(Icons.person_2_outlined, color: ModernHeritageApp.textDark, size: 20),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildPremiumImageSlider() {
    List<Map<String, String>> banners = [
      {"img": "assets/banner1.png",
        "tag": "LIMITED", "title": "Precision Time"},
      {"img": "assets/banner2.png",
        "tag": "NEW", "title": "Minimalist Dial"},
    ];

    return ValueListenableBuilder(
        valueListenable: isApiComplete,
        builder: (context, value, child) {
          return Visibility(
            visible: value,
            replacement:const Center(child: CircularProgressIndicator(),),
            child: ValueListenableBuilder(
                valueListenable: isDataAvailable,
                builder: (context, value, child) {
                  return Visibility(
                    visible: value,
                    replacement:const Center(child: Text("No Data"),),
                    child: SizedBox(
                      height: 280,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.only(left: 25),
                        itemCount: banner?.length,
                        itemBuilder: (context, index) {
                          return Container(
                            width: 300,
                            margin: const EdgeInsets.only(right: 20),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(32),
                              boxShadow: [BoxShadow(color: ModernHeritageApp.textDark.withOpacity(0.08), blurRadius: 30, offset: const Offset(0, 15))],
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(30),
                              child: Stack(
                                fit: StackFit.expand,
                                children: [
                                  Image.network(banner![index].image!, fit: BoxFit.cover),
                                  Container(decoration: BoxDecoration(gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [Colors.transparent, ModernHeritageApp.textDark.withOpacity(0.7)]))),
                                  // Padding(
                                  //   padding: const EdgeInsets.all(25),
                                  //   child: Column(
                                  //     mainAxisAlignment: MainAxisAlignment.end,
                                  //     crossAxisAlignment: CrossAxisAlignment.start,
                                  //     children: [
                                  //       // Text(banners[index]["tag"]!, style: GoogleFonts.montserrat(color: ModernHeritageApp.accentCyan, fontSize: 10, fontWeight: FontWeight.w900, letterSpacing: 2)),
                                  //       // Text(banners[index]["title"]!, style: GoogleFonts.playfairDisplay(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
                                  //     ],
                                  //   ),
                                  // ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  );
                }
            ),
          );
        }
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

    return GestureDetector(
      onTap: () {
        Get.to(() => const CollectionDetailScreen());
      },
      child: SizedBox(
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

            return AnimatedContainer(
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
                  )
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(32),
                child: Stack(
                  clipBehavior: Clip.antiAlias,
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
                            child: category.icon!.contains('.svg') || category.icon!.endsWith('.svg')
                                ? SvgPicture.network(
                              category.icon!,
                              height: 42,
                              width: 42,
                              fit: BoxFit.contain,
                              colorFilter: const ColorFilter.mode(
                                Color(0xFF0D1B1E),
                                BlendMode.srcIn,
                              ),
                              placeholderBuilder: (_) => const Center(
                                child: CircularProgressIndicator(strokeWidth: 2),
                              ),
                            )
                                : Image.network(
                              category.icon!,
                              height: 42,
                              width: 42,
                              fit: BoxFit.contain,
                              errorBuilder: (_, __, ___) => const Icon(Icons.category_outlined),
                            ),
                          ),
                          const Spacer(),
                          Flexible(
                            child: Text(
                              category.name!,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.montserrat(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: const Color(0xFF0D1B1E),
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            );
          },
        ),
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
                  letterSpacing: 1.5
              )
          ),
          GestureDetector(
            onTap: onViewAllTap,
            child: Text(
                "VIEW ALL",
                style: GoogleFonts.montserrat(
                    color: ModernHeritageApp.primaryCyan,
                    fontSize: 10,
                    fontWeight: FontWeight.bold
                )
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNewlyAddedListings() {
    return SizedBox(
      height: 340,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.only(left: 25),
        itemCount: homeNearListing?.length,
        itemBuilder: (context, index) {
          return Container(
            width: 260,
            margin: const EdgeInsets.only(right: 20),
            decoration: BoxDecoration(
              color: ModernHeritageApp.cardColor,
              borderRadius: BorderRadius.circular(35),
              boxShadow: [
                BoxShadow(
                  color: ModernHeritageApp.textDark.withOpacity(0.05),
                  blurRadius: 25,
                  offset: const Offset(0, 15),
                )
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  children: [
                    ClipRRect(
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(35)),
                      child: Image.network(
                        homeNearListing![index].listingImage!,
                        height: 200,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ),

                    Positioned(
                      top: 15,
                      right: 15,
                      child: ClipRRect(
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: Colors.cyan.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(15),
                              border: Border.all(color: Colors.white.withOpacity(0.3)),
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.star_rounded, color: Colors.orangeAccent, size: 16),
                                const SizedBox(width: 4),
                                Text(
                                  homeNearListing![index].rating!,
                                  style: GoogleFonts.montserrat(color: Colors.cyan, fontSize: 12, fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
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
                        homeNearListing![index].listingTitle!,
                        style: GoogleFonts.montserrat(color: ModernHeritageApp.textDark, fontSize: 16, fontWeight: FontWeight.w800),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        homeNearListing![index].description!,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.montserrat(color: ModernHeritageApp.subtleGrey, fontSize: 11, fontWeight: FontWeight.w500),
                      ),
                      const SizedBox(height: 15),
                      Row(
                        children: [
                          const Icon(Icons.location_on_rounded, color: ModernHeritageApp.primaryCyan, size: 14),
                          const SizedBox(width: 5),
                          Expanded(
                            child: Text(
                              homeNearListing![index].cityName!,
                              style: GoogleFonts.montserrat(color: ModernHeritageApp.textDark.withOpacity(0.7), fontSize: 11, fontWeight: FontWeight.w600),
                            ),
                          ),
                        ],
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

  Widget _buildFeaturedServices() {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: homeService?.length,

      padding: const EdgeInsets.only(left: 55, right: 25, top: 25),
      itemBuilder: (context, index) {
        return Stack(
          clipBehavior: Clip.none,
          children: [

            Container(
              margin: const EdgeInsets.only(bottom: 45),
              padding: const EdgeInsets.only(left: 70, right: 20, top: 25, bottom: 25),
              decoration: BoxDecoration(
                color: ModernHeritageApp.cardColor,
                borderRadius: BorderRadius.circular(35),
                boxShadow: [
                  BoxShadow(
                    color: ModernHeritageApp.textDark.withOpacity(0.06),
                    blurRadius: 35,
                    offset: const Offset(0, 15),
                  )
                ],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          homeService![index].name!,
                          style: GoogleFonts.montserrat(
                            color: ModernHeritageApp.textDark,
                            fontSize: 18,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          homeService![index].slug!,
                          style: GoogleFonts.montserrat(
                            color: ModernHeritageApp.subtleGrey,
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            height: 1.4,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 10),
                  Icon(Icons.arrow_forward_ios_rounded, color: ModernHeritageApp.primaryCyan, size: 22),
                ],
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
                  boxShadow: [
                    BoxShadow(
                      color: ModernHeritageApp.primaryCyan.withOpacity(0.4),
                      blurRadius: 20,
                      spreadRadius: 3,
                    )
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(50),
                  child: Image.network(
                    homeService![index].serviceImage!,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildExclusiveDeals()
  {
    return SizedBox(
      height: 380,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.only(left: 25),
        itemCount: homeDeal?.length,
        itemBuilder: (context, index) {
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
                )
              ],
            ),
            child: Column(
              children: [
                Stack(
                  children: [
                    ClipRRect(
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(35)),
                      child: Image.network(
                        homeDeal![index].templateImage!,
                        height: 180,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Positioned(
                      top: 20,
                      left: 20,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                          color: Colors.redAccent,
                          borderRadius: BorderRadius.circular(15),
                          boxShadow: [BoxShadow(color: Colors.redAccent.withOpacity(0.3), blurRadius: 10)],
                        ),
                        child: Text(
                          homeDeal![index].dealName!,
                          style: GoogleFonts.montserrat(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w900, letterSpacing: 1),
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
                        homeDeal![index].dealDesc!,
                        style: GoogleFonts.montserrat(color: ModernHeritageApp.textDark, fontSize: 16, fontWeight: FontWeight.w800),
                      ),
                      const SizedBox(height: 5),
                      Container(
                        width: double.infinity,
                        height: 50,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [ModernHeritageApp.primaryCyan, ModernHeritageApp.accentCyan],
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                          ),
                          borderRadius: BorderRadius.circular(18),
                          boxShadow: [
                            BoxShadow(
                              color: ModernHeritageApp.primaryCyan.withOpacity(0.3),
                              blurRadius: 12,
                              offset: const Offset(0, 6),
                            )
                          ],
                        ),
                        child: ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            shadowColor: Colors.transparent,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
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

  Widget _buildHowItWorks()
  {
    List<Map<String, String>> steps = [
      {
        "id": "1",
        "title": "Choose Location",
        "desc": "Enter your mobile number to get started.",
        "icon": "📍"
      },
      {
        "id": "2",
        "title": "Pick Category",
        "desc": "Select the most relevant category for your needs.",
        "icon": "📂"
      },
      {
        "id": "3",
        "title": "Explore Place",
        "desc": "Discover locations tailored to your specific needs.",
        "icon": "⭐"
      },
    ];

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [ModernHeritageApp.textDark, ModernHeritageApp.textDark.withOpacity(0.8)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(40),
        boxShadow: [
          BoxShadow(
            color: ModernHeritageApp.primaryCyan.withOpacity(0.15),
            blurRadius: 30,
            offset: const Offset(0, 15),
          )
        ],
      ),
      child: Column(
        children: [
          RichText(
            text: TextSpan(
              style: GoogleFonts.montserrat(fontSize: 22, fontWeight: FontWeight.w800, color: Colors.white),
              children: const [
                TextSpan(text: "How Gotilo "),
                TextSpan(text: "Works", style: TextStyle(color: ModernHeritageApp.accentCyan)),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Text(
            "Discover how Gotilo connects you with trusted businesses in just a few simple steps.",
            textAlign: TextAlign.center,
            style: GoogleFonts.montserrat(color: Colors.white.withOpacity(0.6), fontSize: 11, height: 1.5),
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
                        border: Border.all(color: ModernHeritageApp.accentCyan.withOpacity(0.3)),
                      ),
                      alignment: Alignment.center,
                      child: Text(step["icon"]!, style: const TextStyle(fontSize: 20)),
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "${step["id"]}. ${step["title"]}",
                            style: GoogleFonts.montserrat(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            step["desc"]!,
                            style: GoogleFonts.montserrat(color: Colors.white.withOpacity(0.5), fontSize: 12),
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
          }).toList(),
        ],
      ),
    );
  }

  Future<void> callHome() async {
    isDataAvailable.value=false;
    isApiComplete.value=false;
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

        banner ??=[];
        banner!.clear();
        homeCollection ??=[];
        homeCollection!.clear();
        homeNearListing ??=[];
        homeNearListing!.clear();
        homeLatestRelease ??=[];
        homeLatestRelease!.clear();
        homeService ??=[];
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
        banner ??=[];
        banner!.clear();
        homeCollection ??=[];
        homeCollection!.clear();
        homeNearListing ??=[];
        homeNearListing!.clear();
        homeLatestRelease ??=[];
        homeLatestRelease!.clear();
        homeService ??=[];
        homeService!.clear();
        homeDeal ??= [];
        homeDeal!.clear();

        isDataAvailable.value = false;
      }

    } catch (e) {
      log("HomeBanner Error: $e");
      banner ??=[];
      banner!.clear();
      homeCollection ??=[];
      homeCollection!.clear();
      homeNearListing ??=[];
      homeNearListing!.clear();
      homeLatestRelease ??=[];
      homeLatestRelease!.clear();
      homeService ??=[];
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

}
