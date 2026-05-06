import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gotilo_new/Screens/AllListing/AllListingDetailScreen.dart';
import 'package:shimmer/shimmer.dart';
import '../Api/Response/Home/ResponseHome.dart';

class LuxuryCardItem extends StatefulWidget {
  final NearbyListings product;
  final int index;

  const LuxuryCardItem({super.key, required this.product, required this.index});

  @override
  State<LuxuryCardItem> createState() => _LuxuryCardItemState();
}

class _LuxuryCardItemState extends State<LuxuryCardItem>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  bool _hasAnimated = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutBack,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        Future.delayed(const Duration(milliseconds: 200), () {
          if (mounted && !_hasAnimated) {
            _controller.forward();
            _hasAnimated = true;
          }
        });

        return AnimatedBuilder(
          animation: _animation,
          builder: (context, child) {
            return GestureDetector(
              onTap: () {
                Get.to(() => AllListingDetailScreen(listId: widget.product.id));
              },
              child: Container(
                height: 200,
                margin: const EdgeInsets.only(bottom: 30),
                child: Stack(
                  children: [
                    Align(
                      alignment: Alignment.centerRight,
                      child: Container(
                        width: double.infinity,
                        height: 160,
                        padding: const EdgeInsets.only(
                          left: 155,
                          right: 20,
                          top: 15,
                          bottom: 15,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(30),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 30,
                              offset: const Offset(0, 15),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              widget.product.listingTitle!,
                              style: GoogleFonts.montserrat(
                                color: const Color(0xFF0D1B1E),
                                fontSize: 14,
                                fontWeight: FontWeight.w900,
                                letterSpacing: 1.2,
                              ),
                            ),
                            const SizedBox(height: 12),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  widget.product.cityName!,
                                  style: GoogleFonts.montserrat(
                                    color: const Color(0xFF00ACC1),
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const Icon(
                                  Icons.arrow_forward_ios_rounded,
                                  size: 14,
                                  color: Color(0xFF0D1B1E),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),

                    Positioned(
                      left: 0,
                      top: 0,
                      bottom: 20,
                      child: Transform.translate(
                        offset: Offset(-40 * (1 - _animation.value), 0),
                        child: Transform.scale(
                          scale: 0.8 + (0.2 * _animation.value),
                          child: Opacity(
                            opacity: _animation.value.clamp(0.0, 1.0),
                            child: Container(
                              width: 135,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(25),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.15),
                                    blurRadius: 20,
                                    offset: const Offset(5, 10),
                                  ),
                                ],
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(25),
                                child: CachedNetworkImage(
                                  imageUrl: widget.product.listingImage ?? "",
                                  fit: BoxFit.cover,
                                  placeholder: (context, url) => _shimmerBox(),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
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
}
