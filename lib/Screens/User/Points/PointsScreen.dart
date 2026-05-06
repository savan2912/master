import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gotilo_new/Api/ApiCalls.dart';
import 'package:gotilo_new/Api/Request/User/point/RequestUserPoint.dart';
import 'package:gotilo_new/Api/Response/User/point/ResponseUserPoint.dart';
import 'package:gotilo_new/Constant/AppPref.dart';
import 'package:gotilo_new/CustomeWidgets/SharedWidgets.dart';
import 'package:gotilo_new/MyApplication/MyApplication.dart';

import '../../../CustomeWidgets/CustomAppbar.dart';
import '../../../CustomeWidgets/CustomDrawer.dart';
import '../../../CustomeWidgets/CustomLoader.dart';
import 'PointDetailScreen.dart';

class PointsScreen extends StatefulWidget {
  const PointsScreen({super.key});

  @override
  State<PointsScreen> createState() => _PointsScreenState();
}

class _PointsScreenState extends State<PointsScreen> {
  final Color primaryDark = const Color(0xFF0F172A);
  final Color accentCyan = const Color(0xFF00E5FF);
  final Color bgLight = const Color(0xFFF8FAFC);

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  List<UserPoint> point = [];

  ValueNotifier<bool> isDataAvailable = ValueNotifier(false);
  ValueNotifier<bool> isApiComplete = ValueNotifier(false);

  @override
  void initState() {
    callPoint();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: bgLight,
      appBar: CustomAppBar(
        title: "My Rewards",
        showAction: false,
        onMenuTap: () => _scaffoldKey.currentState?.openDrawer(),
      ),
      drawer: const CustomDrawer(initialRoute: 'user.point'),
      body: ValueListenableBuilder(
        valueListenable: isApiComplete,
        builder: (context, apiDone, child) {
          if (!apiDone) {
            return const Center(child: CustomLoader(message: "Loading Point..",));
          }

          return ValueListenableBuilder(
            valueListenable: isDataAvailable,
            builder: (context, dataExist, child) {
              if (!dataExist) return _buildEmptyState();

              return RefreshIndicator(
                onRefresh: callPoint,
                color: primaryDark,
                child: CustomScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  slivers: [
                    SliverToBoxAdapter(child: _buildTotalSummaryCard()),

                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                        child: Text(
                          "Points Breakdown",
                          style: GoogleFonts.montserrat(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: primaryDark,
                          ),
                        ),
                      ),
                    ),

                    SliverList(
                      delegate: SliverChildBuilderDelegate(
                            (context, index) {
                          return _buildPointItem(point[index]);
                        },
                        childCount: point.length,
                      ),
                    ),
                    const SliverToBoxAdapter(child: SizedBox(height: 30)),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }


  Widget _buildTotalSummaryCard() {
    double grandTotal = 0;
    for (var p in point) {
      grandTotal += double.tryParse(p.actualPoints.toString()) ?? 0;
    }

    return Container(
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: primaryDark,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(color: primaryDark.withOpacity(0.3), blurRadius: 20, offset: const Offset(0, 10))
        ],
        gradient: LinearGradient(
          colors: [primaryDark, const Color(0xFF1E293B)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Available Balance",
                  style: GoogleFonts.montserrat(color: Colors.white70, fontSize: 14, fontWeight: FontWeight.w500)),
              const Icon(Icons.stars_rounded, color: Colors.amber, size: 28),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            grandTotal.toStringAsFixed(0),
            style: GoogleFonts.montserrat(color: Colors.white, fontSize: 42, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.08),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _summarySmallItem("Lifetime Earned", _sumKey('total')),
                Container(width: 1, height: 30, color: Colors.white12),
                _summarySmallItem("Total Redeemed", _sumKey('redeemed')),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _summarySmallItem(String label, String value) {
    return Column(
      children: [
        Text(label, style: GoogleFonts.montserrat(color: Colors.white60, fontSize: 11)),
        const SizedBox(height: 4),
        Text(value, style: GoogleFonts.montserrat(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w700)),
      ],
    );
  }


  Widget _buildPointItem(UserPoint data) {
    double total = double.tryParse(data.totalPoints.toString()) ?? 0;
    double redeemed = double.tryParse(data.redeemedPoints.toString()) ?? 0;
    double actual = double.tryParse(data.actualPoints.toString()) ?? 0;

    return GestureDetector(
      onTap: () {
        Get.to(()=> PointDetailScreen(listingId: data.listingId.toString(),));
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 15, offset: const Offset(0, 5)),
          ],
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(color: bgLight, shape: BoxShape.circle),
                    child: Icon(Icons.wallet_giftcard_rounded, color: primaryDark, size: 20),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      data.listings?.listingTitle ?? "Rewards",
                      style: GoogleFonts.montserrat(fontWeight: FontWeight.w700, fontSize: 14, color: primaryDark),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  _statusBadge(actual > 0 ? "Active" : "Completed"),
                ],
              ),
            ),

            Container(
              padding: const EdgeInsets.symmetric(vertical: 15),
              decoration: BoxDecoration(
                color: const Color(0xFFF1F5F9).withOpacity(0.5),
                borderRadius: const BorderRadius.vertical(bottom: Radius.circular(24)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _particularValue("Earned", total.toStringAsFixed(0), Colors.blueGrey),
                  _divider(),
                  _particularValue("Redeemed", redeemed.toStringAsFixed(0), Colors.redAccent),
                  _divider(),
                  _particularValue("Actual", actual.toStringAsFixed(0), Colors.green[600]!),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _particularValue(String label, String value, Color color) {
    return Column(
      children: [
        Text(label, style: GoogleFonts.montserrat(fontSize: 10, color: Colors.grey[600], fontWeight: FontWeight.w600)),
        const SizedBox(height: 4),
        Text(value, style: GoogleFonts.montserrat(fontSize: 16, fontWeight: FontWeight.w800, color: color)),
      ],
    );
  }

  Widget _divider() => Container(height: 25, width: 1, color: Colors.grey.withOpacity(0.2));

  Widget _statusBadge(String status) {
    bool isActive = status == "Active";
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: isActive ? Colors.green.withOpacity(0.1) : Colors.grey.withOpacity(0.1),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        status,
        style: GoogleFonts.montserrat(
          fontSize: 10,
          fontWeight: FontWeight.w700,
          color: isActive ? Colors.green[700] : Colors.grey[700],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.stars_rounded, size: 80, color: Colors.grey[300]),
          const SizedBox(height: 15),
          Text("No rewards points found", style: GoogleFonts.montserrat(fontSize: 16, color: Colors.grey)),
        ],
      ),
    );
  }

  String _sumKey(String key) {
    double count = 0;
    for (var p in point) {
      if (key == 'total') count += double.tryParse(p.totalPoints.toString()) ?? 0;
      if (key == 'redeemed') count += double.tryParse(p.redeemedPoints.toString()) ?? 0;
    }
    return count.toStringAsFixed(0);
  }

  Future<void> callPoint() async {
    isDataAvailable.value = false;
    isApiComplete.value = false;
    point.clear();
    await _callPoint();
  }

  Future<void> _callPoint() async {
    bool internet = await MyApplication.checkInternet();
    if (internet) {
      try {
        ResponseUserPoint? response = await ApiCalls.callUserPoint(RequestUserPoint(userId: AppPrefs.userId));
        if (response != null && response.result != null && response.result!.toLowerCase().contains("pass")) {
          point.addAll(response.data!);
          isDataAvailable.value = true;
        }
      } catch (e) {
        log("Point Error: $e");
        isDataAvailable.value = false;
      } finally {
        isApiComplete.value = true;
        if(mounted) setState(() {});
      }
    } else {
      SharedWidgets.showTopSnackBar(context, message: "No Internet Connection");
      isApiComplete.value = true;
    }
  }
}