import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gotilo_new/Api/ApiCalls.dart';
import 'package:gotilo_new/Api/Request/Blog/RequestBlogsData.dart';
import 'package:gotilo_new/Api/Response/Blog/ResponseBlogData.dart';
import 'package:gotilo_new/CustomeWidgets/SharedWidgets.dart';
import 'package:gotilo_new/MyApplication/MyApplication.dart';
import 'package:shimmer/shimmer.dart';
import 'package:intl/intl.dart';

import 'BlogDetailScreen.dart';

class BlogScreen extends StatefulWidget {
  const BlogScreen({super.key});
  @override
  State<BlogScreen> createState() => _BlogScreenState();
}

class _BlogScreenState extends State<BlogScreen> {
  List<Blogs> allBlogs = [];

  final ScrollController _scrollController = ScrollController();

  int _counter = 0;
  final int _limit = 10;
  bool _isFetching = false;
  bool _hasMore = true;
  bool _isInitialLoading = true;

  @override
  void initState() {
    super.initState();
    _callBlogsData();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 200) {
        if (!_isFetching && _hasMore) {
          _callBlogsData();
        }
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _callBlogsData() async {
    if (_isFetching) return;

    setState(() {
      _isFetching = true;
    });

    bool internet = await MyApplication.checkInternet();
    if (internet) {
      try {
        log("Fetching Blog Data: Counter = $_counter");

        ResponseBlogsData? response = await ApiCalls.callBlogsData(
          RequestBlogs(counter: _counter),
        );

        if (response != null && response.result != null &&
            response.result!.toLowerCase().contains("pass")) {

          if (response.data != null && response.data!.blogs != null && response.data!.blogs!.isNotEmpty) {
            setState(() {
              // મુખ્ય ફેરફાર: અહિં નવો ડેટા જૂના લિસ્ટમાં ઉમેરવામાં આવે છે
              allBlogs.addAll(response.data!.blogs!);

              _counter = _counter + _limit;
              _isFetching = false;
              _isInitialLoading = false;
            });
          } else {
            setState(() {
              _hasMore = false;
              _isFetching = false;
              _isInitialLoading = false;
            });
          }
        } else {
          setState(() {
            _isFetching = false;
            _isInitialLoading = false;
          });
        }
      } catch (e) {
        log("API Error: $e");
        setState(() {
          _isFetching = false;
          _isInitialLoading = false;
        });
      }
    } else {
      setState(() {
        _isFetching = false;
        _isInitialLoading = false;
      });
      SharedWidgets.showTopSnackBar(context, message: "No Internet! Please check your connection.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: Column(
        children: [
          _buildStickyHeader(),
          Expanded(
            child: _isInitialLoading
                ? _buildSkeletonList()
                : RefreshIndicator(
              onRefresh: () async {
                setState(() {
                  _counter = 0;
                  allBlogs.clear(); // રિફ્રેશ વખતે ડેટા ક્લિયર કરવો જરૂરી છે
                  _hasMore = true;
                });
                await _callBlogsData();
              },
              color: Colors.cyan,
              child: ListView(
                controller: _scrollController,
                padding: EdgeInsets.zero,
                physics: const BouncingScrollPhysics(),
                children: [
                  const SizedBox(height: 30),
                  _buildSectionTitle(),
                  ListView.builder(
                    shrinkWrap: true,
                    padding: const EdgeInsets.only(top: 10),
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: allBlogs.length, // use allBlogs
                    itemBuilder: (context, index) {
                      return _buildPremiumBlogCard(allBlogs[index]);
                    },
                  ),
                  // જો હજુ ડેટા લોડ થતો હોય તો નીચે પ્રોગ્રેસ બાર બતાવવો
                  if (_isFetching && _hasMore)
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 20),
                      child: Center(
                        child: CircularProgressIndicator(
                          color: Colors.cyan,
                          strokeWidth: 3,
                        ),
                      ),
                    ),
                  const SizedBox(height: 50),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ... બાકીના બધા Widgets (StickyHeader, SectionTitle, PremiumBlogCard, Skeleton) સેમ જ રહેશે ...
  // ફક્ત _buildPremiumBlogCard માં 'allBlogs' નો ડેટા પાસ થશે.

  Widget _buildSectionTitle() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          Container(
            width: 4, height: 20,
            decoration: BoxDecoration(
              color: Colors.cyan,
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          const SizedBox(width: 10),
          Text(
            "Latest Updates",
            style: GoogleFonts.plusJakartaSans(
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStickyHeader() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 15,
        bottom: 20,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            "OUR BLOG",
            style: GoogleFonts.montserrat(
              fontSize: 22,
              fontWeight: FontWeight.w900,
              color: Colors.black,
              letterSpacing: 1.5,
            ),
          ),
          const SizedBox(height: 5),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Home", style: GoogleFonts.plusJakartaSans(fontSize: 12, color: Colors.grey[400])),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Icon(Icons.chevron_right_rounded, size: 14, color: Colors.grey[300]),
              ),
              Text("Blog Articles", style: GoogleFonts.plusJakartaSans(fontSize: 12, color: Colors.cyan, fontWeight: FontWeight.w700)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPremiumBlogCard(Blogs item) {
    String displayDate = item.updatedAt ?? "No Date";
    try {
      if(item.updatedAt != null) {
        DateTime dt = DateTime.parse(item.updatedAt!);
        displayDate = DateFormat('dd MMM, yyyy').format(dt);
      }
    } catch (e) {
      displayDate = item.updatedAt ?? "";
    }

    return GestureDetector(
      onTap: () {
        Get.to(() => BlogDetailScreen(blogid: item.id));
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.02),
              blurRadius: 15,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
              child: Stack(
                children: [
                  Image.network(
                    item.blogImage ?? "",
                    height: 180,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Shimmer.fromColors(
                        baseColor: Colors.grey[200]!,
                        highlightColor: Colors.white,
                        child: Container(height: 180, color: Colors.white),
                      );
                    },
                    errorBuilder: (context, error, stackTrace) => Container(
                      height: 180,
                      color: Colors.grey[100],
                      child: const Icon(Icons.broken_image_outlined, color: Colors.grey, size: 40),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    left: 0,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: const BoxDecoration(
                        color: Colors.cyan,
                        borderRadius: BorderRadius.only(topRight: Radius.circular(12)),
                      ),
                      child: Text(
                        "GENERAL",
                        style: GoogleFonts.plusJakartaSans(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w800),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.calendar_month_outlined, size: 14, color: Colors.cyan),
                      const SizedBox(width: 6),
                      Text(displayDate, style: GoogleFonts.plusJakartaSans(fontSize: 11, fontWeight: FontWeight.w600, color: Colors.grey[500])),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(item.blogTitle ?? "No Title", style: GoogleFonts.plusJakartaSans(fontSize: 17, fontWeight: FontWeight.w800, color: Colors.black)),
                  const SizedBox(height: 8),
                  Text(
                    item.blogDesc ?? "No description available.",
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.plusJakartaSans(fontSize: 13, color: Colors.grey[600], height: 1.5),
                  ),
                  const SizedBox(height: 15),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("CONTINUE READING", style: GoogleFonts.plusJakartaSans(fontSize: 11, fontWeight: FontWeight.w900, color: Colors.cyan)),
                      const Icon(Icons.arrow_forward_rounded, size: 16, color: Colors.cyan),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSkeletonList() {
    return ListView.builder(
      padding: const EdgeInsets.only(top: 30),
      itemCount: 3,
      itemBuilder: (context, index) => Shimmer.fromColors(
        baseColor: Colors.grey[300]!,
        highlightColor: Colors.grey[100]!,
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          height: 300,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
        ),
      ),
    );
  }
}