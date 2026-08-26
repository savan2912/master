import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gotilo_new/Api/ApiCalls.dart';
import 'package:gotilo_new/Api/Request/Blog/RequestBlogDetail.dart';
import 'package:gotilo_new/Api/Response/Blog/ResponseBlogDetail.dart';
import 'package:gotilo_new/CustomeWidgets/SharedWidgets.dart';
import 'package:gotilo_new/MyApplication/MyApplication.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';

class BlogDetailScreen extends StatefulWidget {
  final int? blogid;
  const BlogDetailScreen({super.key, this.blogid});

  @override
  State<BlogDetailScreen> createState() => _BlogDetailScreenState();
}

class _BlogDetailScreenState extends State<BlogDetailScreen> {
  ValueNotifier<bool> isDataAvailable = ValueNotifier(false);
  ValueNotifier<bool> isApiAvailable = ValueNotifier(false);
  BlogDetail? blogData;

  static const Color primaryCyan = Color(0xFF00ACC1);
  static const Color textDark = Color(0xFF0D1B1E);

  String formattedDate = "";

  @override
  void initState() {
    super.initState();
    _callBlogDetail();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: ValueListenableBuilder(
        valueListenable: isApiAvailable,
        builder: (context, apiDone, child) {
          if (!apiDone) {
            return _buildMainShimmer();
          }

          return ValueListenableBuilder(
            valueListenable: isDataAvailable,
            builder: (context, dataExist, child) {
              if (!dataExist) {
                return const Center(
                  child: Text("No blog details found", style: TextStyle(color: textDark)),
                );
              }

              return CustomScrollView(
                physics: const BouncingScrollPhysics(),
                slivers: [
                  SliverAppBar(
                    expandedHeight: 400,
                    pinned: true,
                    stretch: true,
                    backgroundColor: textDark,
                    leading: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: CircleAvatar(
                        backgroundColor: Colors.black.withOpacity(0.3),
                        child: IconButton(
                          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 18),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ),
                    ),
                    flexibleSpace: FlexibleSpaceBar(
                      stretchModes: const [
                        StretchMode.zoomBackground,
                        StretchMode.blurBackground
                      ],
                      background: Stack(
                        fit: StackFit.expand,
                        children: [
                          Image.network(
                            blogData!.blogImage!,
                            fit: BoxFit.cover,
                            loadingBuilder: (context, child, loadingProgress) {
                              if (loadingProgress == null) return child;
                              return Shimmer.fromColors(
                                baseColor: Colors.grey[900]!,
                                highlightColor: Colors.grey[800]!,
                                child: Container(color: Colors.black),
                              );
                            },
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                color: Colors.grey[900],
                                child: const Icon(Icons.broken_image, color: Colors.white, size: 50),
                              );
                            },
                          ),
                          Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  Colors.transparent,
                                  Colors.black.withOpacity(0.8),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  SliverToBoxAdapter(
                    child: Container(
                      transform: Matrix4.translationValues(0, -30, 0),
                      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 30),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(35),
                          topRight: Radius.circular(35),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                decoration: BoxDecoration(
                                  color: primaryCyan.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Text(
                                  "LATEST UPDATE",
                                  style: GoogleFonts.montserrat(
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                    color: primaryCyan,
                                    letterSpacing: 1,
                                  ),
                                ),
                              ),
                              Text(
                                formattedDate,
                                style: GoogleFonts.montserrat(
                                  fontSize: 12,
                                  color: Colors.grey[500],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          Text(
                            blogData!.blogTitle!,
                            style: GoogleFonts.playfairDisplay(
                              fontSize: 30,
                              fontWeight: FontWeight.w900,
                              color: textDark,
                              height: 1.2,
                            ),
                          ),
                          const SizedBox(height: 20),
                          Row(
                            children: [
                              const CircleAvatar(
                                radius: 18,
                                backgroundColor: primaryCyan,
                                child: Icon(Icons.person, color: Colors.white, size: 20),
                              ),
                              const SizedBox(width: 12),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Gotilo Team",
                                    style: GoogleFonts.montserrat(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: textDark,
                                    ),
                                  ),
                                  Text(
                                    "5 min read",
                                    style: GoogleFonts.montserrat(
                                      fontSize: 12,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const Divider(height: 40, thickness: 1, color: Color(0xFFEEEEEE)),
                          Text(
                            blogData!.blogDesc!,
                            style: GoogleFonts.montserrat(
                              fontSize: 16,
                              color: textDark.withOpacity(0.8),
                              height: 1.8,
                              letterSpacing: 0.3,
                            ),
                          ),
                          const SizedBox(height: 50),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildMainShimmer() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Column(
        children: [
          Container(height: 400, color: Colors.white),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                Container(height: 30, color: Colors.white),
                const SizedBox(height: 10),
                Container(height: 20, width: 150, color: Colors.white),
                const SizedBox(height: 30),
                Container(height: 100, color: Colors.white),
              ],
            ),
          )
        ],
      ),
    );
  }

  Future<void> _callBlogDetail() async {
    bool internet = await MyApplication.checkInternet();
    if (internet) {
      try {
        ResponseBlogDetail? response = await ApiCalls.callBlogDetail(RequestBlogDetail(
            blogId: widget.blogid ?? 0
        ));

        if (response != null && response.result != null &&
            response.result!.toLowerCase().contains("pass")) {

          blogData = response.data!;

          if (blogData?.createdAt != null) {
            DateTime dt = DateTime.parse(blogData!.createdAt!);
            formattedDate = DateFormat('dd MMM, yyyy').format(dt);
          }

          isDataAvailable.value = true;
        }
      } catch (e) {
        log("Error Fetching Blog: $e");
        isDataAvailable.value = false;
      } finally {
        isApiAvailable.value = true;
      }
    } else {
      SharedWidgets.showTopSnackBar(context, message: "No Internet Available",title:"fail");
      isApiAvailable.value = true;
    }
  }
}