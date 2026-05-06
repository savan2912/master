import 'dart:async'; // Debounce માટે જરૂરી
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gotilo_new/Api/ApiCalls.dart';
import 'package:gotilo_new/Api/Request/User/point/RequestPointDetail.dart';
import 'package:gotilo_new/Api/Response/User/point/ResponsePointDetail.dart';
import 'package:gotilo_new/Constant/AppPref.dart';
import 'package:gotilo_new/CustomeWidgets/CustomAppbar.dart';
import 'package:gotilo_new/CustomeWidgets/SharedWidgets.dart';
import 'package:gotilo_new/MyApplication/MyApplication.dart';

class PointDetailScreen extends StatefulWidget {
  final String? listingId;
  const PointDetailScreen({super.key, this.listingId});

  @override
  State<PointDetailScreen> createState() => _PointDetailScreenState();
}

class _PointDetailScreenState extends State<PointDetailScreen> {
  final Color primaryDark = const Color(0xFF1E293B);
  final Color bgLight = const Color(0xFFF1F5F9);
  final Color accentBlue = const Color(0xFF3B82F6);

  List<PointDetail> pointDetail = [];
  final ScrollController _scrollController = ScrollController();

  Timer? _debounce;

  ValueNotifier<bool> isDataAvailable = ValueNotifier(false);
  ValueNotifier<bool> isApiComplete = ValueNotifier(false);
  ValueNotifier<bool> isLoadingMore = ValueNotifier(false);

  int counter = 0;
  bool hasMoreData = true;
  String searchQuery = "";

  @override
  void initState() {
    super.initState();
    callPointDetail();

    _scrollController.addListener(() {
      if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 100) {
        if (!isLoadingMore.value && hasMoreData && pointDetail.length >= 10 && pointDetail.length % 10 == 0) {
          _loadMoreData();
        }
      }
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _scrollController.dispose();
    super.dispose();
  }


  void _onSearchChanged(String val) {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      searchQuery = val;
      callPointDetail();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgLight,
      appBar: CustomAppBar(
        title: "Point Detail",
        showBackButton: true,
        showMenu: false,
        showAction: false,
        showSearchIcon: true,
        onSearchChanged: _onSearchChanged,
      ),
      body: ValueListenableBuilder(
        valueListenable: isApiComplete,
        builder: (context, apiDone, child) {
          if (!apiDone && counter == 0) {
            return const Center(child: CircularProgressIndicator(color: Color(0xFF1E293B)));
          }

          return ValueListenableBuilder(
            valueListenable: isDataAvailable,
            builder: (context, dataExist, child) {
              if (!dataExist) return _buildEmptyState();

              return RefreshIndicator(
                onRefresh: callPointDetail,
                color: accentBlue,
                child: ListView.builder(
                  controller: _scrollController,
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.fromLTRB(16, 20, 16, 20),
                  itemCount: pointDetail.length + (isLoadingMore.value ? 1 : 0),
                  itemBuilder: (context, index) {
                    if (index < pointDetail.length) {
                      return _buildTimelineCard(pointDetail[index], index);
                    } else {
                      return const Padding(
                        padding: EdgeInsets.symmetric(vertical: 20),
                        child: Center(child: CircularProgressIndicator(strokeWidth: 3)),
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

  Widget _buildTimelineCard(PointDetail data, int index) {
    return IntrinsicHeight(
      child: Row(
        children: [
          Column(
            children: [
              Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                  color: accentBlue,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 2),
                  boxShadow: [BoxShadow(color: accentBlue.withOpacity(0.3), blurRadius: 4)],
                ),
              ),
              Expanded(
                child: Container(
                  width: 2,
                  color: index == pointDetail.length - 1 ? Colors.transparent : Colors.grey[300],
                ),
              ),
            ],
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Container(
              margin: const EdgeInsets.only(bottom: 24),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10, offset: const Offset(0, 4)),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        data.date ?? "",
                        style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w600, color: Colors.grey[500]),
                      ),
                      if (data.paidAmount != null && data.paidAmount != "0")
                        Text(
                          "₹${data.paidAmount}",
                          style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w800, color: primaryDark),
                        ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    data.listingName ?? "Unknown Store",
                    style: GoogleFonts.montserrat(fontSize: 15, fontWeight: FontWeight.w700, color: primaryDark),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      _buildMiniTag(Icons.add_circle_outline, "+${data.earnedPoints} Earned", Colors.green),
                      const SizedBox(width: 8),
                      _buildMiniTag(Icons.remove_circle_outline, "-${data.redeemedPoints} Used", Colors.red),
                    ],
                  ),
                  if (data.rewardTitle != null && data.rewardTitle!.isNotEmpty) ...[
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.amber.withOpacity(0.08),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.redeem, size: 14, color: Colors.amber),
                          const SizedBox(width: 6),
                          Expanded(
                            child: Text(
                              "${data.rewardTitle} (${data.rewardDiscount})",
                              style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w600, color: Colors.amber[900]),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMiniTag(IconData icon, String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        children: [
          Icon(icon, size: 12, color: color),
          const SizedBox(width: 4),
          Text(label, style: GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.w700, color: color)),
        ],
      ),
    );
  }
  Future<void> callPointDetail() async {
    counter = 0;
    hasMoreData = true;
    setState(() {
      pointDetail.clear();
      isApiComplete.value = false;
      isDataAvailable.value = false;
    });

    await _fetchPointDetail();
  }

  Future<void> _loadMoreData() async {
    setState(() { isLoadingMore.value = true; });
    counter += 10;
    await _fetchPointDetail();
    setState(() { isLoadingMore.value = false; });
  }

  Future<void> _fetchPointDetail() async {
    bool internet = await MyApplication.checkInternet();
    if (internet) {
      try {
        ResponsePointDetail? response = await ApiCalls.callPointDetail(RequestPointDetail(
          userId: AppPrefs.userId,
          counter: counter.toString(),
          search: searchQuery,
          listingId: widget.listingId,
        ));

        if (response != null && response.result != null && response.result!.toLowerCase().contains("pass")) {
          if (response.data != null && response.data!.isNotEmpty) {
            if (counter == 0) pointDetail.clear();
            for (var item in response.data!) {

              bool isDuplicate = pointDetail.any((element) => element.date == item.date && element.listingName == item.listingName && element.earnedPoints == item.earnedPoints);
              if (!isDuplicate) {
                pointDetail.add(item);
              }
            }

            isDataAvailable.value = pointDetail.isNotEmpty;
            if (response.data!.length < 10) hasMoreData = false;

          } else {
            hasMoreData = false;
            if (counter == 0) isDataAvailable.value = false;
          }
        }
      } catch (e) {
        log("Point Detail Error: $e");
      } finally {
        isApiComplete.value = true;
        if (mounted) setState(() {});
      }
    } else {
      SharedWidgets.showTopSnackBar(context, message: "No Internet Available");
      isApiComplete.value = true;
    }
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.history_toggle_off, size: 80, color: Colors.grey[300]),
          const SizedBox(height: 16),
          Text("No transactions found", style: GoogleFonts.montserrat(fontSize: 16, color: Colors.grey[600], fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }
}