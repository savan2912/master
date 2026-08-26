
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gotilo_new/Api/ApiCalls.dart';
import 'package:gotilo_new/Api/Request/User/Billing/RequestBillHistory.dart';
import 'package:gotilo_new/Api/Request/User/Billing/RequestBilling.dart';
import 'package:gotilo_new/Api/Response/User/Billing/ResponseBillHistory.dart';
import 'package:gotilo_new/Api/Response/User/Billing/ResponseBilling.dart';
import 'package:gotilo_new/Constant/AppPref.dart';
import 'package:gotilo_new/CustomeWidgets/CustomAppbar.dart';
import 'package:gotilo_new/CustomeWidgets/SharedWidgets.dart';
import 'package:gotilo_new/MyApplication/MyApplication.dart';
import 'package:gotilo_new/Screens/HeritageHomeScreen.dart';
import 'package:intl/intl.dart';
import '../../../CustomeWidgets/CustomDrawer.dart';
import '../../../CustomeWidgets/CustomLoader.dart';

class BillingScreen extends StatefulWidget {
  const BillingScreen({super.key});

  @override
  State<BillingScreen> createState() => _BillingScreenState();
}

class _BillingScreenState extends State<BillingScreen> {
  BillHistory? billHistory;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final ScrollController _scrollController = ScrollController();

  List<UserBilling> billing = [];
  int counter = 0;
  String searchQuery = "";
  String startDate = "";
  String endDate = "";

  bool isLoading = false;
  bool hasMore = true;
  ValueNotifier<bool> isApiComplete = ValueNotifier(false);

  String loadingBillId = "";

  final Color bgLight = const Color(0xFFF8FAFC);
  final Color primaryDark = const Color(0xFF1E293B);

  @override
  void initState() {
    super.initState();
    callBilling();

    _scrollController.addListener(() {
      if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 100) {
        if (!isLoading && hasMore) _loadMore();
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
      backgroundColor: ModernHeritageApp.appBg,
      appBar: CustomAppBar(
        title: "BILLING HISTORY",
        showSearchIcon: true,
        showFilterIcon: true,
        onSearchChanged: (val) {
          searchQuery = val;
          callBilling();
        },
        onFilterTap: () => _showFilterBottomSheet(),
        showAction: false,
        onMenuTap: () => _scaffoldKey.currentState?.openDrawer(),
      ),
      drawer: const CustomDrawer(initialRoute: 'user.billing'),
      body: RefreshIndicator(
        onRefresh: () async => callBilling(),
        color: primaryDark,
        child: ValueListenableBuilder(
          valueListenable: isApiComplete,
          builder: (context, done, child) {
            if (!done && counter == 0) {
              return const Center(child: CustomLoader(message: "Loading Billing..",));
            }
            if (billing.isEmpty) return _buildEmptyState();
            return ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              itemCount: billing.length + (hasMore ? 1 : 0),
              itemBuilder: (context, index) {
                if (index < billing.length) {
                  return _buildBillingCard(billing[index]);
                } else {
                  return _buildLoader();
                }
              },
            );
          },
        ),
      ),
    );
  }

  Widget _buildBillingCard(UserBilling item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 18),
      decoration: SharedWidgets.cardBoxDecoration(),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Stack(
          children: [
            // Positioned(
            //   left: 0, top: 0, bottom: 0,
            //   child: Container(width: 5, color: primaryDark),
            // ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: primaryDark.withOpacity(0.05),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Icon(Icons.receipt_long_outlined, color: primaryDark, size: 24),
                      ),
                      const SizedBox(width: 15),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item.listingTitle ?? "Unknown Service",
                              style: GoogleFonts.montserrat(
                                color: primaryDark,
                                fontWeight: FontWeight.w800,
                                fontSize: 15,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                Icon(Icons.calendar_today_rounded, size: 12, color: Colors.grey[400]),
                                const SizedBox(width: 5),
                                Text(
                                  item.billDate ?? "N/A",
                                  style: GoogleFonts.montserrat(
                                    color: Colors.grey[500],
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      loadingBillId == item.action
                          ? SizedBox(
                        height: 28,
                        width: 28,
                        child: CircularProgressIndicator(
                            strokeWidth: 2.5, color: primaryDark),
                      )
                          : IconButton(
                        onPressed: () async {
                          setState(() => loadingBillId = item.action.toString() ?? "");
                          await _callBillHistory(billId: item.action.toString());
                          setState(() => loadingBillId = "");

                          if (billHistory != null) {
                            _showDetailBottomSheet(billHistory!);
                          }
                        },
                        icon: Icon(Icons.arrow_circle_right_outlined,
                            color: primaryDark.withOpacity(0.6), size: 28),
                        visualDensity: VisualDensity.compact,
                      ),
                    ],
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 12),
                    child: Divider(color: Color(0xFFF1F5F9), thickness: 1.5),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "PAYMENT MODE",
                            style: GoogleFonts.montserrat(
                              color: Colors.grey[400],
                              fontSize: 9,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 1,
                            ),
                          ),
                          const SizedBox(height: 2),
                          _statusBadge(item.paymentMode ?? "N/A"),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            "PAID AMOUNT",
                            style: GoogleFonts.montserrat(
                              color: Colors.grey[400],
                              fontSize: 9,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 1,
                            ),
                          ),
                          Text(
                            "₹${item.paidAmount}",
                            style: GoogleFonts.montserrat(
                              color: primaryDark,
                              fontWeight: FontWeight.w900,
                              fontSize: 18,
                            ),
                          ),
                        ],
                      ),
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

  Widget _statusBadge(String text) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 6, height: 6,
          decoration: const BoxDecoration(color: Colors.green, shape: BoxShape.circle),
        ),
        const SizedBox(width: 6),
        Text(
          text.toUpperCase(),
          style: GoogleFonts.montserrat(color: primaryDark, fontWeight: FontWeight.w700, fontSize: 12),
        ),
      ],
    );
  }

  Future<void> callBilling() async {
    setState(() {
      counter = 0;
      billing.clear();
      hasMore = true;
      isApiComplete.value = false;
    });
    await _fetchData();
  }

  Future<void> _loadMore() async {
    if (isLoading) return;
    setState(() {
      isLoading = true;
      counter += 10;
    });
    await _fetchData();
    setState(() => isLoading = false);
  }

  Future<void> _fetchData() async {
    bool internet = await MyApplication.checkInternet();
    if (internet) {
      try {
        ResponseBilling? response = await ApiCalls.callBilling(RequestBilling(
            userId: AppPrefs.userId,
            counter: counter.toString(),
            search: searchQuery,
            startDate: startDate,
            endDate: endDate));

        if (response != null && response.result!.toLowerCase().contains("pass")) {
          if (counter == 0) billing.clear();

          if (response.data != null && response.data!.isNotEmpty) {
            billing.addAll(response.data!);
            if (response.data!.length < 10) hasMore = false;
          } else {
            hasMore = false;
          }
        }
      } catch (e) { log("Error: $e"); }
      finally { isApiComplete.value = true; setState(() {}); }
    }
  }

  void _showDetailBottomSheet(BillHistory data) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Bill History", style: GoogleFonts.montserrat(fontWeight: FontWeight.bold, fontSize: 18, color: primaryDark)),
                  IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(Icons.cloud_circle_sharp, color: Color(0xFF1E293B))),
                ],
              ),
              const Divider(thickness: 1),
              const SizedBox(height: 10),
              Container(
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(8)
                ),
                child: Column(
                  children: [
                    _buildRow("Customer Name:", data.username ?? "N/A"),
                    _buildRow("Deal Name:", data.dealname ?? "N/A"),
                    _buildRow("Reward Name:", data.rewardTitle ?? "N/A"),
                    _buildRow("Payment Type:", data.paymentType ?? "N/A"),
                    _buildRow("Products:", data.product ?? "N/A", isMultiLine: true),
                    _buildRow("Sub Total:", data.subtotal ?? "0.00"),
                    _buildRow("Discount:", data.discount ?? "0.00"),
                    _buildRow("Tax:", data.tax ?? "0.00"),
                    _buildRow("Total:", data.total ?? "0.00", isLast: true),
                  ],
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }

  Widget _buildRow(String label, String value, {bool isLast = false, bool isMultiLine = false}) {
    return Container(
      decoration: BoxDecoration(
          border: Border(bottom: isLast ? BorderSide.none : BorderSide(color: Colors.grey.shade300))
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 120,
            padding: const EdgeInsets.all(12),
            color: Colors.grey.shade50,
            child: Text(label, style: GoogleFonts.montserrat(fontWeight: FontWeight.bold, fontSize: 13, color: primaryDark)),
          ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(12),
              child: Text(value, style: GoogleFonts.montserrat(fontSize: 13, color: Colors.grey.shade700)),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _callBillHistory({String? billId = ""}) async {
    bool internet = await MyApplication.checkInternet();
    if (internet) {
      try {
        ResponseBillHistory? response = await ApiCalls.callBillHistory(RequestBillHistory(cashierBillsId: billId));
        if (response != null && response.result!.toLowerCase().contains("pass")) {
          billHistory = response.data!;
        }
      } catch (e) { log("$e"); }
    } else {
      SharedWidgets.showTopSnackBar(context, message: "No Internet Available",title:"fail");
    }
  }

  void _showFilterBottomSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(25))),
      builder: (context) {
        return StatefulBuilder(builder: (context, setST) {
          return Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(child: Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(10)))),
                const SizedBox(height: 20),
                Text("Filter by Date", style: GoogleFonts.montserrat(color: primaryDark, fontWeight: FontWeight.w800, fontSize: 18)),
                const SizedBox(height: 20),
                _datePickerTile("From Date", startDate, (date) => setST(() => startDate = date)),
                const SizedBox(height: 12),
                _datePickerTile("To Date", endDate, (date) => setST(() => endDate = date)),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity, height: 55,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: primaryDark, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16))),
                    onPressed: () { Navigator.pop(context); callBilling(); },
                    child: Text("APPLY FILTER", style: GoogleFonts.montserrat(color: Colors.white, fontWeight: FontWeight.bold)),
                  ),
                ),
                Center(
                  child: TextButton(
                    onPressed: () { setST(() { startDate = ""; endDate = ""; }); Navigator.pop(context); callBilling(); },
                    child: Text("Reset All", style: TextStyle(color: Colors.grey[600], fontWeight: FontWeight.w600)),
                  ),
                )
              ],
            ),
          );
        });
      },
    );
  }

  Widget _datePickerTile(String label, String value, Function(String) onSelected) {
    return GestureDetector(
      onTap: () async {
        DateTime? picked = await showDatePicker(context: context, initialDate: DateTime.now(), firstDate: DateTime(2022), lastDate: DateTime.now());
        if (picked != null) onSelected(DateFormat('yyyy-MM-dd').format(picked));
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(color: bgLight, borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.grey.withOpacity(0.1))),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(value.isEmpty ? label : value, style: TextStyle(color: value.isEmpty ? Colors.grey[500] : primaryDark, fontWeight: FontWeight.w600)),
            Icon(Icons.calendar_month_rounded, color: primaryDark, size: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildLoader() => const Padding(padding: EdgeInsets.all(15), child: Center(child: CircularProgressIndicator()));

  Widget _buildEmptyState() => Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.layers_clear_outlined, size: 80, color: Colors.grey[300]),
        const SizedBox(height: 16),
        Text("No history found", style: GoogleFonts.montserrat(color: Colors.grey[400], fontWeight: FontWeight.w600)),
      ],
    ),
  );
}
