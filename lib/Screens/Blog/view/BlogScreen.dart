import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gotilo_new/Api/ApiCalls.dart';
import 'package:gotilo_new/Api/Request/Blog/RequestBlogsData.dart';
import 'package:gotilo_new/Api/Response/Blog/ResponseBlogData.dart';
import 'package:gotilo_new/CustomeWidgets/SharedWidgets.dart';
import 'package:gotilo_new/MyApplication/MyApplication.dart';

class BlogScreen extends StatefulWidget {
  const BlogScreen({super.key});

  @override
  State<BlogScreen> createState() => _BlogScreenState();
}

class _BlogScreenState extends State<BlogScreen> {
  // --- VARIABLES ---
  List<BlogsData> blogData = [];
  final ScrollController _scrollController = ScrollController();

  int _counter = 0;         // Starts at 0, then 10, 20, etc.
  final int _limit = 10;    // Darek vaar ketlo gap rakhvo chhe e
  bool _isFetching = false;  // API call chaludi hoy tyare true thase
  bool _hasMore = true;      // Jo data khatam thai jay to true thase

  @override
  void initState() {
    super.initState();
    _callBlogsData(); // Pehlo load

    // Scroll Listener: Pagination trigger karva mate
    _scrollController.addListener(() {
      // Jyaare user scroll karine end pase pahonche (200px baki hoy) tyare
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

  /// --- API CALL LOGIC (COUNTER: 0, 10, 20...) ---
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

          if (response.data != null && response.data!.isNotEmpty) {
            setState(() {
              blogData.addAll(response.data!);

              // --- COUNTER LOGIC ---
              // Agli vaar mate counter ma 10 add thase (0 -> 10 -> 20)
              _counter = _counter + _limit;

              _isFetching = false;
            });
          } else {
            // Jo API blank data ape to have baki nathi e set karvu
            setState(() {
              _hasMore = false;
              _isFetching = false;
            });
          }
        } else {
          setState(() => _isFetching = false);
        }
      } catch (e) {
        log("API Error: $e");
        setState(() => _isFetching = false);
      }
    } else {
      setState(() => _isFetching = false);
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
            child: ListView(
              controller: _scrollController, // Controller attach karvo jaruri chhe
              padding: EdgeInsets.zero,
              physics: const BouncingScrollPhysics(),
              children: [
                const SizedBox(height: 30),

                // Section Header
                Padding(
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
                ),

                // Blog List Builder
                ListView.builder(
                  shrinkWrap: true,
                  padding: const EdgeInsets.only(top: 10),
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: blogData.length,
                  itemBuilder: (context, index) {
                    return _buildPremiumBlogCard(blogData[index]);
                  },
                ),

                // --- BOTTOM PAGINATION LOADER ---
                if (_isFetching)
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 20),
                    child: Center(
                      child: CircularProgressIndicator(
                        color: Colors.cyan,
                        strokeWidth: 3,
                      ),
                    ),
                  ),

                // Bottom padding jethi last card loader ma na dabay
                const SizedBox(height: 50),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// --- HEADER UI ---
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

  /// --- BLOG CARD UI ---
  Widget _buildPremiumBlogCard(BlogsData item) {
    return Container(
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
                  item.blogImage ?? "https://via.placeholder.com/800x500",
                  height: 180,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    height: 180,
                    color: Colors.grey[100],
                    child: const Icon(Icons.broken_image_outlined, color: Colors.grey),
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
                    Text(item.updatedAt ?? "No Date", style: GoogleFonts.plusJakartaSans(fontSize: 11, fontWeight: FontWeight.w600, color: Colors.grey[500])),
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
    );
  }
}