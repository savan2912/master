import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gotilo_new/Api/ApiCalls.dart';
import 'package:gotilo_new/Api/Request/User/Fav/RequestFavData.dart';
import 'package:gotilo_new/Api/Request/User/Fav/RequestFavDelete.dart';
import 'package:gotilo_new/Api/Response/User/Fav/ResponseFavData.dart';
import 'package:gotilo_new/Api/Response/User/Fav/ResponseFavDelete.dart';
import 'package:gotilo_new/Constant/AppPref.dart';
import 'package:gotilo_new/CustomeWidgets/CustomAppbar.dart';
import 'package:gotilo_new/CustomeWidgets/SharedWidgets.dart';
import 'package:gotilo_new/MyApplication/MyApplication.dart';
import 'package:gotilo_new/Screens/AllCollection/CollectionDetailScreen.dart';
import 'package:gotilo_new/Screens/AllListing/AllListingDetailScreen.dart';

import '../../../CustomeWidgets/CustomDrawer.dart';
import '../../../CustomeWidgets/CustomLoader.dart';

class FavouriteScreen extends StatefulWidget {
  const FavouriteScreen({super.key});

  @override
  State<FavouriteScreen> createState() => _FavouriteScreenState();
}

class _FavouriteScreenState extends State<FavouriteScreen> {
  List<FavData> favData = [];
  final Color primaryDark = const Color(0xFF0F172A);
  final Color bgLight = const Color(0xFFF8FAFC);

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final ScrollController _scrollController = ScrollController(); // Pagination માટે

  ValueNotifier<bool> isDataAvailable = ValueNotifier(false);
  ValueNotifier<bool> isApiComplete = ValueNotifier(false);
  ValueNotifier<bool> isLoadingMore = ValueNotifier(false); // વધારાનો ડેટા લોડ કરવા માટે

  int counter = 0; // શરૂઆત 0 થી
  bool hasMoreData = true; // જો API માં વધુ ડેટા ના હોય તો રોકવા માટે

  @override
  void initState() {
    super.initState();
    callFavData();

    // Scroll Listener: જ્યારે યુઝર છેલ્લે પહોંચે ત્યારે વધુ ડેટા ખેંચશે
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 200) {
        if (!isLoadingMore.value && hasMoreData) {
          _loadMoreData();
        }
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: bgLight,
      appBar: CustomAppBar(
        title: "My Favourites",
        showAction: false,
        onMenuTap: () => _scaffoldKey.currentState?.openDrawer(),
      ),
      drawer: const CustomDrawer(initialRoute: 'user.favourite'),
      body: ValueListenableBuilder(
        valueListenable: isApiComplete,
        builder: (context, apiDone, child) {
          if (!apiDone && counter == 0) {
            return const Center(child: CustomLoader(message: "Loading Favourites..",));
          }

          return ValueListenableBuilder(
            valueListenable: isDataAvailable,
            builder: (context, dataExist, child) {
              if (!dataExist) return _buildEmptyState();

              return RefreshIndicator(
                onRefresh: callFavData,
                color: primaryDark,
                child: ListView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  itemCount: favData.length + (hasMoreData ? 1 : 0),
                  itemBuilder: (context, index) {
                    if (index < favData.length) {
                      return _buildFavCard(favData[index], index);
                    } else {
                      // નીચે લોડિંગ ઇન્ડિકેટર બતાવવા માટે
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        child: Center(child: CircularProgressIndicator(strokeWidth: 2, color: primaryDark)),
                      );
                    }
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }

  // --- API CALLS ---

  // તાજો ડેટા (Refresh અથવા પેલી વાર)
  Future<void> callFavData() async {
    counter = 0;
    hasMoreData = true;
    isDataAvailable.value = false;
    isApiComplete.value = false;
    favData.clear();
    await _fetchData();
  }

  // Pagination માટે આગામી ડેટા
  Future<void> _loadMoreData() async {
    isLoadingMore.value = true;
    counter += 10; // 0 -> 10 -> 20 નો ગેપ
    await _fetchData();
    isLoadingMore.value = false;
  }

  Future<void> _fetchData() async {
    bool internet = await MyApplication.checkInternet();
    if (internet) {
      try {
        ResponseFavData? response = await ApiCalls.callFavData(RequestFavData(
            search: "",
            counter: counter.toString(), // ગતિશીલ કાઉન્ટર
            userId: AppPrefs.userId));

        if (response != null && response.result != null && response.result!.toLowerCase().contains("pass")) {
          if (response.data != null && response.data!.isNotEmpty) {
            favData.addAll(response.data!);
            isDataAvailable.value = true;

            // જો મળેલ ડેટા 10 થી ઓછો હોય, તો સમજવું કે હવે વધુ ડેટા નથી
            if (response.data!.length < 10) {
              hasMoreData = false;
            }
          } else {
            hasMoreData = false;
          }
        }
      } catch (e) {
        log("Fav Error: $e");
        if (counter == 0) isDataAvailable.value = false;
      } finally {
        isApiComplete.value = true;
        setState(() {});
      }
    } else {
      SharedWidgets.showTopSnackBar(context, message: "No Internet Available");
      isApiComplete.value = true;
    }
  }

  // --- DELETE LOGIC ---
  Future<void> _callFavDelete({String? itemId = ""}) async {
    bool internet = await MyApplication.checkInternet();
    if (internet) {
      try {
        ResponseFavDelete? response = await ApiCalls.callFavDelete(
            RequestFavDelete(userId: AppPrefs.userId, listingId: itemId));
        if (response != null && response.result!.toLowerCase().contains("pass")) {
          SharedWidgets.showTopSnackBar(context, message: response.message!);
          callFavData(); // ડિલીટ થયા પછી લિસ્ટ રીફ્રેશ કરો
        }
      } catch (e) {
        log("Delete Error: $e");
      }
    }
  }

  void _confirmDelete(FavData data, int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text("Remove Favourite", style: GoogleFonts.montserrat(fontWeight: FontWeight.w700)),
        content: Text("Are you sure you want to remove '${data.listingName}'?"),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () {
              Navigator.pop(context);
              _callFavDelete(itemId: data.listingId.toString());
            },
            child: const Text("Remove", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  // --- UI COMPONENTS ---
  Widget _buildFavCard(FavData data, int index) {
    return GestureDetector(
      onTap: () {
        Get.to(()=> AllListingDetailScreen(listId: data.listingId,));
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 15, offset: const Offset(0, 5))],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 120,
              child: AspectRatio(
                aspectRatio: 1,
                child: ClipRRect(
                  borderRadius: const BorderRadius.horizontal(left: Radius.circular(20)),
                  child: Image.network(
                    data.image ?? "",
                    fit: BoxFit.cover,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return const ShimmerLoading(width: 120, height: 120);
                    },
                    errorBuilder: (context, error, stackTrace) => Container(
                      color: Colors.grey[200],
                      child: const Icon(Icons.broken_image, color: Colors.grey),
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(data.listingName ?? "",
                              style: GoogleFonts.montserrat(fontWeight: FontWeight.w700, fontSize: 15, color: primaryDark),
                              maxLines: 1, overflow: TextOverflow.ellipsis),
                        ),
                        IconButton(
                          onPressed: () => _confirmDelete(data, index),
                          icon: const Icon(Icons.delete_outline, color: Colors.red, size: 20),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        const Icon(Icons.location_on, color: Colors.redAccent, size: 14),
                        const SizedBox(width: 4),
                        Text("${data.city}", style: GoogleFonts.montserrat(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.grey[700])),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(data.address ?? "", style: GoogleFonts.montserrat(fontSize: 11, color: Colors.grey[500]), maxLines: 2, overflow: TextOverflow.ellipsis),
                    const SizedBox(height: 10),
                    _buildRatingBadge(data.rating ?? "0.0"),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRatingBadge(String rating) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(color: Colors.amber.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.star_rounded, color: Colors.amber, size: 14),
          const SizedBox(width: 4),
          Text(rating, style: GoogleFonts.montserrat(fontSize: 12, fontWeight: FontWeight.w700, color: Colors.amber[900])),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.favorite_border_rounded, size: 80, color: Colors.grey[300]),
          const SizedBox(height: 15),
          Text("No favourites yet!", style: GoogleFonts.montserrat(fontSize: 16, color: Colors.grey)),
        ],
      ),
    );
  }
}

// --- SHIMMER WIDGET ---
class ShimmerLoading extends StatefulWidget {
  final double width;
  final double height;
  const ShimmerLoading({super.key, required this.width, required this.height});
  @override
  State<ShimmerLoading> createState() => _ShimmerLoadingState();
}

class _ShimmerLoadingState extends State<ShimmerLoading> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Color?> _colorAnimation;
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 800))..repeat(reverse: true);
    _colorAnimation = ColorTween(begin: Colors.grey[300], end: Colors.grey[100]).animate(_controller);
  }
  @override
  void dispose() { _controller.dispose(); super.dispose(); }
  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(animation: _colorAnimation, builder: (context, child) => Container(width: widget.width, height: widget.height, color: _colorAnimation.value));
  }
}