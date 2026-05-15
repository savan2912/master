import 'dart:developer';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gotilo_new/Api/ApiCalls.dart';
import 'package:gotilo_new/Api/Request/User/MyOrder/RequestMyOrder.dart';
import 'package:gotilo_new/Api/Request/User/MyOrder/RequestMyOrderDetail.dart';
import 'package:gotilo_new/Api/Response/User/MyOrder/ResponseMyOrder.dart';
import 'package:gotilo_new/Api/Response/User/MyOrder/ResponseMyOrderDetail.dart';
import 'package:gotilo_new/Constant/AppPref.dart';
import 'package:gotilo_new/CustomeWidgets/CustomAppbar.dart';
import 'package:gotilo_new/CustomeWidgets/SharedWidgets.dart';
import 'package:gotilo_new/MyApplication/MyApplication.dart';
import 'package:intl/intl.dart';

import '../../../CustomeWidgets/CustomDrawer.dart';
import '../../../CustomeWidgets/CustomLoader.dart';

class MyOrderScreen extends StatefulWidget {
  const MyOrderScreen({super.key});

  @override
  State<MyOrderScreen> createState() => _MyOrderScreenState();
}

class _MyOrderScreenState extends State<MyOrderScreen> {
  final List<MyOrder> _myOrdersList = []; // મુખ્ય લિસ્ટ
  MyOrderDetail? myOrderDetail;

  final ScrollController _scrollController = ScrollController();
  ValueNotifier<bool> isInitialLoading = ValueNotifier(true);

  // Pagination Variables
  int _counter = 0;
  final int _limit = 10;
  bool _isFetching = false;
  bool _hasMore = true;

  String loadingToken = "";
  final Color primaryDark = const Color(0xFF1A1C1E);
  final Color accentGold = const Color(0xFFC5A358);
  final Color surfaceLight = const Color(0xFFF8F9FA);
  final Color statusGreen = const Color(0xFF2D6A4F);
  final Color iconBg = const Color(0xFF0F172A);
  final Color icon = const Color(0xFF1E293B);

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _fetchOrders(); // પહેલીવાર ડેટા લોડ કરવા

    // સ્ક્રોલ લિસનર એડ કર્યું
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 200) {
        if (!_isFetching && _hasMore) {
          _fetchOrders();
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
      backgroundColor: surfaceLight,
      drawer: const CustomDrawer(initialRoute: 'user.orders'),
      appBar: CustomAppBar(
        title: "MY ORDERS",
        showAction: false,
        onMenuTap: () => _scaffoldKey.currentState?.openDrawer(),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          setState(() {
            _counter = 0;
            _myOrdersList.clear();
            _hasMore = true;
            isInitialLoading.value = true;
          });
          await _fetchOrders();
        },
        color: icon,
        child: ValueListenableBuilder(
          valueListenable: isInitialLoading,
          builder: (context, loading, child) {
            if (loading) {
              return const Center(child: CustomLoader(message: "Loading My Orders.."));
            }

            if (_myOrdersList.isEmpty) {
              return _buildEmptyState();
            }

            return ListView.builder(
              controller: _scrollController, // કંટ્રોલર એટેચ કર્યું
              padding: const EdgeInsets.symmetric(vertical: 12),
              physics: const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
              itemCount: _myOrdersList.length + (_hasMore ? 1 : 0),
              itemBuilder: (context, index) {
                if (index < _myOrdersList.length) {
                  return myOrderDesign(_myOrdersList[index]);
                } else {
                  // નીચે લોડર બતાવવા માટે
                  return const Padding(
                    padding: EdgeInsets.symmetric(vertical: 30),
                    child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
                  );
                }
              },
            );
          },
        ),
      ),
    );
  }

  Future<void> _fetchOrders() async {
    if (_isFetching) return;

    _isFetching = true;

    bool internet = await MyApplication.checkInternet();
    if (internet) {
      try {
        log("Fetching Orders: Counter = $_counter");
        ResponseMyOrder? response = await ApiCalls.callMyOrder(
          RequestMyOrder(userId: AppPrefs.userId, counter: _counter.toString()),
        );

        if (response != null && response.result!.toLowerCase().contains("pass")) {
          if (response.data != null && response.data!.isNotEmpty) {
            setState(() {
              _myOrdersList.addAll(response.data!);
              _counter += _limit; // નેક્સ્ટ પેજ માટે કાઉન્ટર વધાર્યું
              _isFetching = false;
            });
          } else {
            setState(() {
              _hasMore = false; // હવે ડેટા નથી
              _isFetching = false;
            });
          }
        } else {
          setState(() {
            _hasMore = false;
            _isFetching = false;
          });
        }
      } catch (e) {
        log("Order API Error: $e");
        setState(() => _isFetching = false);
      } finally {
        isInitialLoading.value = false;
      }
    } else {
      setState(() => _isFetching = false);
      isInitialLoading.value = false;
      SharedWidgets.showTopSnackBar(context, message: "No Internet Connection");
    }
  }

  // --- બાકીના Designs (Card, Sheet, Details) સેમ જ રહેશે ---

  Widget myOrderDesign(MyOrder item) {
    String displayDate = "N/A";
    try {
      displayDate = DateFormat('dd MMM, yyyy').format(DateTime.parse(item.orderDate!));
    } catch (_) {}

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.withOpacity(0.1)),
        boxShadow: [
          BoxShadow(
            color: primaryDark.withOpacity(0.04),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: primaryDark.withOpacity(0.02),
              borderRadius: const BorderRadius.only(topLeft: Radius.circular(16), topRight: Radius.circular(16)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(Icons.calendar_month_outlined, size: 16, color: iconBg),
                    const SizedBox(width: 8),
                    Text(displayDate,
                        style: GoogleFonts.montserrat(fontWeight: FontWeight.w600, fontSize: 12, color: primaryDark.withOpacity(0.7))),
                  ],
                ),
                _statusTag(item.status ?? "Pending"),
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: iconBg,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(Icons.restaurant_menu_rounded, color: surfaceLight, size: 22),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.listingTitle ?? "Cafe/Restaurant",
                            style: GoogleFonts.montserrat(
                                fontWeight: FontWeight.w700,
                                fontSize: 15,
                                color: primaryDark
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            "Token: ${item.tokenNumber}",
                            style: GoogleFonts.montserrat(
                                color: iconBg,
                                fontWeight: FontWeight.w600,
                                fontSize: 13
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 40,
                      width: 40,
                      child: loadingToken == item.tokenNumber
                          ? Center(
                        child: SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.5,
                            color: icon,
                          ),
                        ),
                      )
                          : GestureDetector(
                        onTap: () async {
                          setState(() => loadingToken = item.tokenNumber!);
                          await callMyOrderDetail(tokenNumber: item.tokenNumber);
                          setState(() => loadingToken = "");
                          _showOrderDetailsSheet();
                        },
                        child: Icon(
                          CupertinoIcons.eye_fill,
                          color: icon,
                          size: 26,
                        ),
                      ),
                    ),
                  ],
                ),

                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 12),
                  child: Divider(height: 1, thickness: 0.5),
                ),

                Row(
                  children: [
                    Icon(Icons.near_me_outlined, size: 14, color: iconBg),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        item.address ?? "Address not available",
                        style: GoogleFonts.montserrat(
                            fontSize: 11,
                            color: Colors.grey[500],
                            fontWeight: FontWeight.w500
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _statusTag(String status) {
    bool isDone = status.toLowerCase() == "approved" || status.toLowerCase() == "pass";
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
      decoration: BoxDecoration(
        color: isDone ? statusGreen.withOpacity(0.1) : accentGold.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        status.toUpperCase(),
        style: GoogleFonts.montserrat(
            color: isDone ? statusGreen : CupertinoColors.systemYellow,
            fontSize: 9,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.5
        ),
      ),
    );
  }

  void _showOrderDetailsSheet() {
    if (myOrderDetail == null) return;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _orderDetailsSheet(),
    );
  }

  Widget _orderDetailsSheet() {
    return Container(
      height: MediaQuery.of(context).size.height * 0.75,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(topLeft: Radius.circular(24), topRight: Radius.circular(24)),
      ),
      child: Column(
        children: [
          const SizedBox(height: 12),
          Container(height: 4, width: 40, decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(10))),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Order Summary", style: GoogleFonts.montserrat(fontSize: 18, fontWeight: FontWeight.w700, color: primaryDark)),
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Icon(Icons.close_rounded, color: primaryDark),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: myOrderDetail?.products?.length ?? 0,
              itemBuilder: (context, index) => _buildProductListItem(myOrderDetail!.products![index]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductListItem(Products item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: surfaceLight,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(
              "${item.image}",
              height: 50, width: 50, fit: BoxFit.cover,
              errorBuilder: (c, e, s) => Container(color: Colors.grey[200], child: Icon(Icons.image_not_supported_outlined, color: Colors.grey[400])),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("${item.name}", style: GoogleFonts.montserrat(fontWeight: FontWeight.w600, fontSize: 13, color: primaryDark), maxLines: 1),
                Text("Quantity: ${item.quantity}", style: GoogleFonts.montserrat(fontSize: 11, color: Colors.grey[600])),
              ],
            ),
          ),
          Text("₹${item.price}", style: GoogleFonts.montserrat(fontWeight: FontWeight.w700, color: primaryDark, fontSize: 14)),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.receipt_long_outlined, size: 80, color: accentGold.withOpacity(0.2)),
          const SizedBox(height: 16),
          Text("No orders yet", style: GoogleFonts.montserrat(color: primaryDark.withOpacity(0.5), fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }

  Future<void> callMyOrderDetail({String? tokenNumber}) async {
    bool internet = await MyApplication.checkInternet();
    if (internet) {
      try {
        ResponseMyOrderDetail? response = await ApiCalls.callMyOrderDetail(RequestMyOrderDetail(tokenNumber: tokenNumber));
        if (response != null && response.result!.toLowerCase().contains("pass")) {
          myOrderDetail = response.data!;
        }
      } catch (e) {
        log("Detail API Error: $e");
      }
    }
  }
}