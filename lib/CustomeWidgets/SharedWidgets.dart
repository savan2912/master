
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shimmer/shimmer.dart';

import '_TopSnackBarWidget.dart';

class SharedWidgets {
  static Timer? _debounce;

  static PreferredSizeWidget customAppBar({
    String? title,
    bool searchVisible = false,
    bool showProfile = false,
    bool showDrawer = false,
    bool centerTitle = true,
    bool showSignInIcon = false,
    bool showJoinUsIcon = false,
    bool showCenterImage = false,
    String? centerImagePath,
    bool showSearch = false,
    TextEditingController? searchController,
    VoidCallback? onSearchTap,
    VoidCallback? onCloseSearch,
    Function(String value)? onSearchChanged,
    VoidCallback? onProfileTap,
    VoidCallback? onDrawerTap,
    VoidCallback? onSignInTap,
    VoidCallback? onJoinUsTap,
    bool isFilterShow = false,
    VoidCallback? onFilterTap,
    bool isCartShow = false,
    VoidCallback? onCartTap,
    Color? backgroundColor,
    Gradient? gradient,
    Color? iconColor,
  })
  {
     assert(
       !(showProfile && showDrawer),
       "Cannot show both profile and drawer at same time",
     );
      final Color defaultIconColor = iconColor ?? Colors.white;
      return PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: Container(
          decoration: BoxDecoration(
            color: gradient == null ? backgroundColor ?? Colors.blue : null,
            gradient: gradient,
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(20),
              bottomRight: Radius.circular(20),
            ),
          ),
          child: AppBar(
            elevation: 0,
            backgroundColor: Colors.transparent,
            iconTheme: const IconThemeData(color: Colors.white),
            leadingWidth: (!showCenterImage && centerImagePath != null && !showSearch) ? 130 : 50,
            leading: (showSearch && searchVisible)
                ? IconButton(
              icon: Icon(Icons.arrow_back, color: defaultIconColor),
              onPressed: onCloseSearch,
            )
                : showProfile
                ? IconButton(
              onPressed: onProfileTap,
              icon: Icon(Icons.person, size: 28, color: defaultIconColor),
            )
                : showDrawer
                ? IconButton(
              icon: Icon(Icons.menu, size: 28, color: defaultIconColor),
              onPressed: onDrawerTap,
            )
            // 👇 અહીં ખાસ ધ્યાન આપજો: જો title હોય તો એનો મતલબ કે આ બીજી કોઈ સ્ક્રીન છે,
            // તો ત્યાં Flutter ને જાતે Back button બતાવવા દેવું (null રિટર્ન કરીને)
                : (title != null && title.isNotEmpty)
                ? null // આનાથી Flutter ડિફોલ્ટ Back Button બતાવશે
                : (!showCenterImage)
                ? Padding(
              padding: const EdgeInsets.only(left: 10, top: 6, bottom: 6),
              child: Container(
                height: 48,
                width: 140,
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 6,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: centerImagePath == null
                    ? buildProfessionalShimmer()
                    : SvgPicture.network(
                  centerImagePath,
                  fit: BoxFit.contain,
                  placeholderBuilder: (context) => buildProfessionalShimmer(),
                ),
              ),
            )
                : null,
            title: showSearch && searchVisible
                ? Container(
              height: 42,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              child: TextField(
                controller: searchController,
                autofocus: true,
                onChanged: onSearchChanged,
                decoration: const InputDecoration(
                  hintText: "Search...",
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(horizontal: 12),
                ),
              ),
            )
                : showCenterImage
                ? Container(
              height: 48,
              width: 140,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 6,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Image.asset(centerImagePath ?? "", fit: BoxFit.contain),
            )
                : Text(
              title ?? "",
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            centerTitle: centerTitle,
            actions: showSearch && searchVisible
                ? [
              IconButton(
                icon: Icon(Icons.close, color: defaultIconColor),
                onPressed: onCloseSearch,
              ),
              ]
                : [
              if (searchVisible)
                IconButton(
                  onPressed: onSearchTap,
                  icon: SvgPicture.asset("assets/search.svg", height: 26, width: 26, color: defaultIconColor),
                ),
              if (isCartShow)
                IconButton(
                  onPressed: onCartTap,
                  icon: Stack(
                    children: [
                      Icon(Icons.shopping_cart_outlined, color: defaultIconColor, size: 28),
                    ],
                  ),
                ),

              if (showSignInIcon)
                IconButton(
                  onPressed: onSignInTap,
                  icon: SvgPicture.asset("assets/login.svg", height: 28, width: 28, color: defaultIconColor),
                ),
              if (showJoinUsIcon)
                IconButton(
                  onPressed: onJoinUsTap,
                  icon: SvgPicture.asset("assets/join_us.svg", height: 28, width: 28, color: defaultIconColor),
                ),
              if (isFilterShow)
                IconButton(
                  onPressed: onFilterTap,
                  icon: SvgPicture.asset("assets/filter.svg", height: 26, width: 26, color: defaultIconColor),
                ),
            ],
          ),
        ));
    }

  static Widget buildProfessionalShimmer() {
    return Center(
      child: Shimmer.fromColors(
        baseColor: Colors.grey[300]!,
        highlightColor: Colors.grey[100]!,
        period: const Duration(milliseconds: 1500),
        direction: ShimmerDirection.ttb,
        child: Container(
          width: 80,
          height: 20,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10), // થોડું રાઉન્ડ શેપ
          ),
        ),
      ),
    );
  }
  static void showTopSnackBar(
      BuildContext context, {
        required String message,
        String? title="",
        Duration duration = const Duration(seconds: 3),
      })
  {
    final overlay = Overlay.of(context);
    late OverlayEntry overlayEntry;
    overlayEntry = OverlayEntry(
      builder: (context) {
        return TopSnackBarWidget(
          title:title!,
          message: message,
          duration: duration,
          onDismissed: () {
            overlayEntry.remove();
          },
        );
      },
    );
    overlay.insert(overlayEntry);
  }

  static Widget customBottomNavBar({
    required int currentIndex,
    required List<IconData> icons,
    required Function(int) onTap,
    Gradient? gradient,
  })
  {
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 0, 20, 20),
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(40),
        gradient: gradient ??
            const LinearGradient(
              colors: [
                Color(0xFF6C63FF),
                Color(0xFFFF6584),
              ],
            ),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(icons.length, (index) {
          final isSelected = index == currentIndex;

          return GestureDetector(
            onTap: () => onTap(index),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 350),
              curve: Curves.easeOutCubic,
              padding: EdgeInsets.all(isSelected ? 14 : 10),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isSelected
                    ? Colors.white.withOpacity(0.25)
                    : Colors.transparent,
              ),
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 350),
                transitionBuilder: (child, animation) {
                  return ScaleTransition(scale: animation, child: child);
                },
                child: Icon(
                  icons[index],
                  key: ValueKey<int>(index),
                  color: isSelected ? Colors.white : Colors.white70,
                  size: isSelected ? 28 : 24,
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  static Widget customCurvedBottomNavBar({
    required int currentIndex,
    required List<String> svgPaths,
    required List<String> labels,
    required Function(int) onTap,
    Gradient? gradient,
  })
  {
    return Container(
      margin: const EdgeInsets.fromLTRB(0, 0, 0, 0,),

      padding: const EdgeInsets.symmetric(
        vertical: 10,
        horizontal: 20,
      ),

      decoration: BoxDecoration(
        gradient: gradient ??
            const LinearGradient(
              colors: [
                Color(0xFF6C63FF),
                Color(0xFFFF6584),
              ],
            ),

        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(28),
          topRight: Radius.circular(28),
        ),

        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 10,
            offset: Offset(0, -3),
          ),
        ],
      ),

      child: SafeArea(
        top: false,
        child: Row(
          mainAxisAlignment:
          MainAxisAlignment.spaceAround,
          children: List.generate(
            svgPaths.length,
                (index) {
              final isSelected = index == currentIndex;
              return GestureDetector(
                onTap: () => onTap(index),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 350),
                  curve: Curves.easeOutCubic,
                  padding: EdgeInsets.symmetric(
                    horizontal: isSelected ? 14 : 0,
                    vertical: 8,
                  ),

                  decoration: BoxDecoration(
                    color: isSelected ? Colors.white.withOpacity(0.18) : Colors.transparent,
                    borderRadius: BorderRadius.circular(30),
                  ),

                  child: Column(
                    mainAxisSize:
                    MainAxisSize.min,
                    children: [
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          if (isSelected)
                            Positioned(
                              bottom: 0,
                              child: Container(
                                width: 40,
                                height: 20,
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.25),
                                  borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(20),
                                    topRight: Radius.circular(20),
                                  ),
                                ),
                              ),
                            ),

                          AnimatedScale(
                            scale: isSelected ? 1.15 : 1,
                            duration: const Duration(milliseconds: 250),
                            child: SvgPicture.asset(
                              svgPaths[index],
                              width: isSelected ? 28 : 24,
                              height: isSelected ? 28 : 24,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        labels[index],
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: isSelected ? 12 : 11,
                          fontWeight:
                          isSelected ? FontWeight.w600 : FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  static Widget buttonBg({
    required String text,
    required VoidCallback onPressed,
    double borderRadius = 30,
    EdgeInsetsGeometry? padding,
    Gradient? gradient,
    TextStyle? textStyle,
    double? width,
    double? height,
  })
  {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        gradient: gradient ??
            const LinearGradient(
              colors: [Color(0xFF6C63FF), Color(0xFFFF6584)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
          ),
          padding: padding ?? const EdgeInsets.symmetric(horizontal: 30, vertical: 14),
        ),
        child: Text(
          text,
          style: textStyle ?? const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
           ),
      ),
    );
  }

  static cardBoxDecoration({Color? bgColor}) {
    return BoxDecoration(
      color: bgColor ?? Colors.white,
      borderRadius: BorderRadius.circular(18),
      boxShadow: [
        BoxShadow(
          offset: const Offset(0, 1.5),
          color: Colors.grey.withOpacity(0.4),
          spreadRadius: 1.0,
          blurRadius: 3.0,
        )
      ],
    );
  }


  static Widget gradientText({
    required String text,
    Gradient? gradient,
    TextStyle? style,
    TextAlign? textAlign,
  })
  {
    return ShaderMask(
      shaderCallback: (bounds) {
        return (gradient ??
            const LinearGradient(
              colors: [Color(0xFF6C63FF), Color(0xFFFF6584)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ))
            .createShader(Rect.fromLTWH(0, 0, bounds.width, bounds.height));
      },
      child: Text(
        text,
        textAlign: textAlign ?? TextAlign.start,
        style: (style ?? const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)).copyWith(color: Colors.white),
      ),
    );
  }
}

