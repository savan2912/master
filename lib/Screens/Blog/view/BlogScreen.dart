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
  // Dummy data with safe types

  List<BlogsData> blogData=[];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: Column(
        children: [
          // 1. FIXED PREMIUM HEADER (Sticky)
          _buildStickyHeader(),

          // 2. SCROLLABLE CONTENT
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              physics: const BouncingScrollPhysics(),
              children: [
                const SizedBox(height: 30),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    children: [
                      Container(
                        width: 4,
                        height: 20,
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
                  padding: const EdgeInsets.only(top: 10, bottom: 40),
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: blogData.length,
                  itemBuilder: (context, index) {
                    return _buildPremiumBlogCard(blogData[index]);
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// --- FIXED HEADER ---
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
              Text(
                "Home",
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 12,
                  color: Colors.grey[400],
                  fontWeight: FontWeight.w600,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Icon(Icons.chevron_right_rounded, size: 14, color: Colors.grey[300]),
              ),
              Text(
                "Blog Articles",
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 12,
                  color: Colors.cyan,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// --- FEATURED BLOG ---
  Widget _buildFeaturedBlog() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      height: 240,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        image: const DecorationImage(
          image: NetworkImage('https://images.unsplash.com/photo-1542038784456-1ea8e935640e?q=80&w=2070'),
          fit: BoxFit.cover,
        ),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.transparent, Colors.black.withOpacity(0.9)],
          ),
        ),
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.cyan,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                "FEATURED",
                style: GoogleFonts.plusJakartaSans(
                  color: Colors.white,
                  fontSize: 9,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1,
                ),
              ),
            ),
            const SizedBox(height: 10),
            Text(
              "How Gotilo is Revolutionizing Local Search in 2026",
              style: GoogleFonts.plusJakartaSans(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// --- NULL-SAFE BLOG CARD ---
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
          // Image Section with Fallback
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
            child: Stack(
              children: [
                Image.network(
                  item.blogImage ?? "https://via.placeholder.com/800x500", // Safe Fallback
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
                      style: GoogleFonts.plusJakartaSans(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Content Section
          Padding(
            padding: const EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.calendar_month_outlined, size: 14, color: Colors.cyan),
                    const SizedBox(width: 6),
                    Text(
                      item.updatedAt?? "No Date",
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey[500],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Text(
                  item.blogTitle ?? "No Title Available",
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 17,
                    fontWeight: FontWeight.w800,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  item.blogDesc ?? "No description provided for this blog post.",
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 13,
                    color: Colors.grey[600],
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 15),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "CONTINUE READING",
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 11,
                        fontWeight: FontWeight.w900,
                        color: Colors.cyan,
                        letterSpacing: 0.5,
                      ),
                    ),
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

  Future<void> callBlogsData() async {
    _callBlogsData();
  }

  Future<void> _callBlogsData() async {
    MyApplication.checkInternet().then((internet) async {
          if(internet)
            {
              try{
                ResponseBlogsData? response= await ApiCalls.callBlogsData(
                    RequestBlogs(
                      counter: 0
                    ));
                if(response != null){
                  if(response.result!.isNotEmpty && response.result != null &&
                   response.result!.toLowerCase().contains("pass")){

                  }
                }
              }on Exception catch(e){
                log("$e");
              }catch(e){
                log("$e");
              }finally{

              }
            }else{
            SharedWidgets.showTopSnackBar(context, message: "No Internet Please turn on internet");
          }
    },);
  }
}