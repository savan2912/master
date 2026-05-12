import 'dart:async';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:gotilo_new/Api/ApiCalls.dart';
import 'package:gotilo_new/Api/Request/Search/RequestSearch.dart';
import 'package:gotilo_new/Api/Response/Search/ResponseSearch.dart';
import 'package:gotilo_new/MyApplication/MyApplication.dart';
import 'package:gotilo_new/Screens/AllListing/AllListingDetailScreen.dart';
import 'package:shimmer/shimmer.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();

  bool isLoading = true;
  bool isSearching = false;
  List<SearchData> searchResults = [];
  Timer? _debouncer;

  @override
  void initState() {
    super.initState();
    _callSearchData("");
  }

  @override
  void dispose() {
    _searchController.dispose();
    _debouncer?.cancel();
    super.dispose();
  }

  Future<void> _callSearchData(String query) async {
    bool internet = await MyApplication.checkInternet();
    if (internet) {
      try {
        if (query.isEmpty) {
          setState(() => isLoading = true);
        } else {
          setState(() => isSearching = true);
        }

        ResponseSearchData? response = await ApiCalls.callSearchData(
            RequestSearch(search: query)
        );

        setState(() {
          searchResults = response?.data ?? [];
        });
      } on Exception catch (e) {
        log("Exception: $e");
      } finally {
        setState(() {
          isLoading = false;
          isSearching = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: _buildAppBar(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!isLoading && !isSearching && searchResults.isNotEmpty)
            _buildSectionTitle(_searchController.text.isEmpty ? "Popular Choices" : "Found Results"),

          Expanded(
            child: isLoading
                ? _buildListShimmer()
                : _buildBodyContent(),
          ),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.black, size: 18),
        onPressed: () => Navigator.pop(context),
      ),
      titleSpacing: 0,
      title: Container(
        height: 44,
        margin: const EdgeInsets.only(right: 18),
        decoration: BoxDecoration(
          color: const Color(0xFFF1F5F9),
          borderRadius: BorderRadius.circular(12),
        ),
        child: TextField(
          controller: _searchController,
          onChanged: (val) {
            if (_debouncer?.isActive ?? false) _debouncer!.cancel();
            _debouncer = Timer(const Duration(milliseconds: 700), () => _callSearchData(val));
            setState(() {});
          },
          style: const TextStyle(fontSize: 15, color: Colors.black, fontWeight: FontWeight.w500),
          decoration: InputDecoration(
            hintText: "Explore premium services...",
            hintStyle: TextStyle(color: Colors.grey[500], fontSize: 14),
            prefixIcon: const Icon(Icons.search_rounded, color: Colors.cyan, size: 20),
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(vertical: 10),
          ),
        ),
      ),
    );
  }

  Widget _buildBodyContent() {
    if (isSearching) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(
              height: 45, width: 45,
              child: CircularProgressIndicator(
                strokeWidth: 3,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.cyan),
              ),
            ),
            const SizedBox(height: 20),
            Text("Searching for you...",
                style: TextStyle(color: Colors.grey[600], fontSize: 15, fontWeight: FontWeight.w500)),
          ],
        ),
      );
    }

    if (searchResults.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 120,
              width: 120,
              decoration: BoxDecoration(
                color: Colors.cyan.withOpacity(0.05),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.search_off_rounded, size: 60, color: Colors.cyan),
            ),
            const SizedBox(height: 25),
            const Text("No Results Found",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: Colors.black)),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Text("We couldn't find what you're looking for. Try another keyword.",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey[500], fontSize: 14, height: 1.5)),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
      physics: const BouncingScrollPhysics(),
      itemCount: searchResults.length,
      itemBuilder: (context, index) => _buildCleanCard(searchResults[index]),
    );
  }

  Widget _buildCleanCard(SearchData item) {
    return GestureDetector(
      onTap: () {
        Get.to(()=> AllListingDetailScreen(listId: item.listingId,));
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 15),
        height: 85,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 10,
              offset: const Offset(0, 4),
            )
          ],
        ),
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.all(12),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  width: 60, height: 60,
                  color: const Color(0xFFF1F5F9),
                  child: Image.network(
                    item.imageUrl ?? "",
                    fit: BoxFit.cover,
                    errorBuilder: (c, e, s) => const Icon(Icons.storefront_outlined, color: Colors.grey),
                  ),
                ),
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(item.categoryName?.toUpperCase() ?? "GENERAL",
                      style: const TextStyle(color: Colors.cyan, fontSize: 9, fontWeight: FontWeight.w900, letterSpacing: 1.0)),
                  const SizedBox(height: 2),
                  Text(item.listingTitle ?? "",
                      maxLines: 1, overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: Colors.black)),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.verified_user_rounded, size: 12, color: Colors.cyan),
                      const SizedBox(width: 4),
                      Text("Verified Service", style: TextStyle(color: Colors.grey[500], fontSize: 10)),
                    ],
                  ),
                ],
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(right: 15),
              child: Icon(Icons.arrow_forward_ios_rounded, size: 12, color: Color(0xFFCBD5E1)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildListShimmer() {
    return ListView.builder(
      padding: const EdgeInsets.all(18),
      itemCount: 8,
      itemBuilder: (context, index) => Shimmer.fromColors(
        baseColor: Colors.grey[200]!,
        highlightColor: Colors.white,
        child: Container(
          margin: const EdgeInsets.only(bottom: 15),
          height: 85,
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 18, 10),
      child: Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: Colors.black)),
    );
  }
}