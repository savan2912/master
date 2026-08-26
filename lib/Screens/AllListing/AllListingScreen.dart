import 'dart:async';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gotilo_new/Api/Request/SubCategoryList/RequestSubCategoryList.dart';
import 'package:gotilo_new/Api/Response/SubCategoryList/ResponseSubCategoryList.dart';
import 'package:gotilo_new/Constant/AppPref.dart';
import 'package:gotilo_new/Screens/AllListing/AllListingDetailScreen.dart';
import '../../Api/ApiCalls.dart';
import '../../Api/Request/Fav/RequestAddFav.dart';
import '../../Api/Response/Fav/ResponseAddFav.dart';
import '../../CustomeWidgets/SharedWidgets.dart';
import '../../MyApplication/MyApplication.dart';

class AllListingScreen extends StatefulWidget {
  final int? subCategoryId;
  const AllListingScreen({super.key, this.subCategoryId});

  @override
  State<AllListingScreen> createState() => _AllListingScreenState();
}

class _AllListingScreenState extends State<AllListingScreen> {
  bool isSearching = false;
  bool isLoading = false;
  bool isMoreLoading = false;
  bool hasMoreData = true;
  bool isFav = false;

  final TextEditingController searchController = TextEditingController();
  final ScrollController scrollController = ScrollController();
  Timer? _debounce;

  List<SubCategoryList> allListings = [];
  int currentCounter = 0;

  @override
  void initState() {
    super.initState();
    _callSubCategoryList(isFirstTime: true);
    scrollController.addListener(() {
      if (scrollController.position.pixels >=
          scrollController.position.maxScrollExtent - 200) {
        if (!isMoreLoading && hasMoreData && !isLoading) {
          _callSubCategoryList(isFirstTime: false);
        }
      }
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    searchController.dispose();
    scrollController.dispose();
    super.dispose();
  }

  void _onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      _callSubCategoryList(isFirstTime: true);
    });
  }

  Future<void> _callSubCategoryList({required bool isFirstTime}) async {
    if (isFirstTime) {
      setState(() {
        isLoading = true;
        currentCounter = 0;
        allListings.clear();
        hasMoreData = true;
      });
    } else {
      setState(() {
        isMoreLoading = true;
      });
    }

    try {
      bool internet = await MyApplication.checkInternet();
      if (!internet) return;

      ResponseSubCategoryList? response = await ApiCalls.callSubCategoryList(
        RequestSubCategoryList(
          userID: AppPrefs.userId=="" ? 0 :int.parse(AppPrefs.userId),
          counter: currentCounter,
          search: searchController.text.trim(),
          cityID: AppPrefs.cityId,
          subCategoryId: widget.subCategoryId ?? 0,
        ),
      );

      if (response != null &&
          response.data != null &&
          response.data!.isNotEmpty) {
        setState(() {
          for (var newItem in response.data!) {
            bool alreadyExists = allListings.any(
              (existingItem) => existingItem.id == newItem.id,
            );
            if (!alreadyExists) {
              allListings.add(newItem);
            }
          }

          currentCounter += 10;
          if (response.data!.length < 10) {
            hasMoreData = false;
          }
        });
      } else {
        setState(() {
          hasMoreData = false;
        });
      }
    } catch (e) {
      log("Error: $e");
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
          isMoreLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F8FB),
      body: CustomScrollView(
        controller: scrollController,
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverAppBar(
            expandedHeight: 130,
            collapsedHeight: 80,
            toolbarHeight: 75,
            pinned: true,
            backgroundColor: const Color(0xFFF6F8FB),
            elevation: 0,
            scrolledUnderElevation: 0,
            leading: IconButton(
              icon: const Icon(
                Icons.arrow_back_ios_new,
                color: Color(0xFF0D1B1E),
                size: 18,
              ),
              onPressed: () => Navigator.pop(context),
            ),
            centerTitle: true,
            flexibleSpace: FlexibleSpaceBar(
              centerTitle: true,
              expandedTitleScale: 1.0,
              titlePadding: EdgeInsets.only(
                bottom: isSearching ? 15 : 20,
                left: 0,
                right: 0,
              ),
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
                          border: Border.all(
                            color: const Color(0xFFE9ECEF),
                            width: 1.2,
                          ),
                        ),
                        child: TextField(
                          controller: searchController,
                          autofocus: true,
                          onChanged: _onSearchChanged,
                          textAlignVertical: TextAlignVertical.center,
                          style: GoogleFonts.montserrat(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                          decoration: InputDecoration(
                            hintText: "Search...",
                            hintStyle: GoogleFonts.montserrat(
                              fontSize: 12,
                              color: Colors.grey,
                            ),
                            border: InputBorder.none,
                            prefixIcon: const Icon(
                              Icons.search_rounded,
                              size: 18,
                              color: Color(0xFF0D1B1E),
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 10,
                            ),
                            isDense: true,
                          ),
                        ),
                      )
                    : Text(
                        "EXPLORE ALL",
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
                icon: Icon(
                  isSearching ? Icons.close_rounded : Icons.search_rounded,
                  color: const Color(0xFF0D1B1E),
                ),
                onPressed: () {
                  setState(() {
                    isSearching = !isSearching;
                    if (!isSearching) {
                      searchController.clear();
                      _callSubCategoryList(isFirstTime: true);
                    }
                  });
                },
              ),
              const SizedBox(width: 5),
            ],
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(25, 10, 25, 5),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Discover Places",
                    style: GoogleFonts.montserrat(
                      fontSize: 28,
                      fontWeight: FontWeight.w900,
                      color: const Color(0xFF0D1B1E),
                      letterSpacing: -1,
                    ),
                  ),
                  const SizedBox(height: 5),
                  if (!isLoading)
                    Row(
                      children: [
                        Text(
                          "Showing ",
                          style: GoogleFonts.montserrat(
                            color: Colors.grey[600],
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          "${allListings.length} results",
                          style: GoogleFonts.montserrat(
                            color: const Color(0xFF6C63FF),
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                ],
              ),
            ),
          ),
          isLoading
              ? const SliverFillRemaining(
                  child: Center(
                    child: CircularProgressIndicator(color: Color(0xFF6C63FF)),
                  ),
                )
              : allListings.isEmpty
              ? const SliverFillRemaining(
                  child: Center(child: Text("No data found")),
                )
              : SliverPadding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 25,
                  ),
                  sliver: SliverGrid(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisSpacing: 18,
                          crossAxisSpacing: 18,
                          mainAxisExtent: 260,
                        ),
                    delegate: SliverChildBuilderDelegate(
                      (context, index) =>
                          _buildBentoListingCard(allListings[index]),
                      childCount: allListings.length,
                    ),
                  ),
                ),
          if (isMoreLoading)
            const SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 20),
                child: Center(
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Color(0xFF6C63FF),
                  ),
                ),
              ),
            ),

          const SliverToBoxAdapter(child: SizedBox(height: 50)),
        ],
      ),
    );
  }

  Widget _buildBentoListingCard(SubCategoryList item) {
    return GestureDetector(
      onTap: () => Get.to(() => AllListingDetailScreen(listId: item.id)),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(25),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF0D1B1E).withOpacity(0.04),
              blurRadius: 15,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 5,
              child: Container(
                margin: const EdgeInsets.all(8),
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child:
                            (item.imageLink != null &&
                                item.imageLink!.isNotEmpty)
                            ? Image.network(
                                item.imageLink!,
                                fit: BoxFit.cover,
                                errorBuilder: (c, e, s) => Container(
                                  color: Colors.grey[100],
                                  child: const Icon(Icons.image),
                                ),
                              )
                            : Container(
                                color: Colors.grey[100],
                                child: const Icon(Icons.image),
                              ),
                      ),
                    ),
                    Positioned(
                      top: 8,
                      right: 8,
                      child: Column(
                        children: [
                          _buildGlassActionButton(
                            icon: item.isFavourite== 1 ? Icons.favorite_outlined : Icons.favorite_border_rounded,
                            onTap: () {
                              callAddFav(id: item.id.toString());
                            },
                          ),

                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              flex: 4,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(15, 2, 15, 12),
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
                            letterSpacing: 1.2,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          item.title ?? "No Title",
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.montserrat(
                            fontWeight: FontWeight.w800,
                            fontSize: 13,
                            color: const Color(0xFF0D1B1E),
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
                            const Icon(
                              Icons.star_rounded,
                              color: Colors.orange,
                              size: 16,
                            ),
                            const SizedBox(width: 2),
                            Text(
                              item.rating ?? "0.0",
                              style: GoogleFonts.montserrat(
                                fontWeight: FontWeight.w800,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFFEBF2),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            item.cityName ?? "City",
                            style: GoogleFonts.montserrat(
                              color: const Color(0xFFFF4081),
                              fontWeight: FontWeight.w900,
                              fontSize: 10,
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

  Widget _buildGlassActionButton({
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.3),
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white.withOpacity(0.2), width: 0.5),
        ),
        child: Icon(icon, color: Colors.white, size: 16),
      ),
    );
  }


  Future<void> callAddFav({String? id="0"}) async {
    MyApplication.checkInternet().then((internet) async {
      if(internet){
        try{
          ResponseAddFav? response= await ApiCalls.callAddFav(RequestAddFav(
              listingId:id,
              userId: AppPrefs.userId == "" ? 0 :int.parse(AppPrefs.userId)
          ));
          if(response != null){
            if(response.result!.isNotEmpty && response.result != null &&
                response.result!.toLowerCase().contains("pass")){
              SharedWidgets.showTopSnackBar(context, message: response.message!,title: "pass");
              _callSubCategoryList(isFirstTime: true);
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
