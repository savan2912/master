import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:gotilo_new/CustomeWidgets/CustomAppbar.dart';
import '../../../Api/ApiCalls.dart';
import '../../../Api/Request/User/HotelBooking/RequestHotelBookingCancellationHistory.dart';
import '../../../Api/Response/User/HotelBooking/ResponseHotelBookingCancellationHistory.dart';
import '../../../Constant/AppPref.dart';
import '../../../CustomeWidgets/CustomDrawer.dart';
import '../../../CustomeWidgets/CustomLoader.dart';
import '../../../CustomeWidgets/SharedWidgets.dart';
import '../../../MyApplication/MyApplication.dart';
import 'HotelBookingDetailScreen.dart';

class HotelBookingCancellationHistory extends StatefulWidget {
  const HotelBookingCancellationHistory({super.key});

  @override
  State<HotelBookingCancellationHistory> createState() => _HotelBookingCancellationHistoryState();
}

class _HotelBookingCancellationHistoryState extends State<HotelBookingCancellationHistory> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final ScrollController _scrollController = ScrollController();

  List<HotelBookingCancellationHistoryData> hotelCancellation = [];
  ValueNotifier<bool> isDataAvailable = ValueNotifier(false);
  ValueNotifier<bool> isApiComplete = ValueNotifier(false);
  ValueNotifier<bool> isLoadingMore = ValueNotifier(false);

  int counter = 0;
  String searchQuery = "";

  @override
  void initState() {
    super.initState();
    _callHotelBookingCancellationHistory(isRefresh: true);

    _scrollController.addListener(() {
      if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 100) {
        if (!isLoadingMore.value && isDataAvailable.value) {
          _loadMoreData();
        }
      }
    });
  }

  void _loadMoreData() {
    counter += 10;
    isLoadingMore.value = true;
    _callHotelBookingCancellationHistory(isRefresh: false);
  }

  void _onSearch(String query) {
    searchQuery = query;
    counter = 0;
    isApiComplete.value = false;
    hotelCancellation.clear();
    _callHotelBookingCancellationHistory(isRefresh: true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: CustomAppBar(
        title: "Cancel History",
        showAction: false,
        showSearchIcon: true,
        onSearchChanged: (val) => _onSearch(val),
        onMenuTap: () => _scaffoldKey.currentState?.openDrawer(),
      ),
      drawer: const CustomDrawer(initialRoute: 'hotel.booking-cancel-hstory'),
      body: ValueListenableBuilder(
        valueListenable: isApiComplete,
        builder: (context, apiDone, child) {
          if (!apiDone && hotelCancellation.isEmpty) {
            return const Center(child: CustomLoader(message: "Loading Cancellation History..",));
          }

          return ValueListenableBuilder(
            valueListenable: isDataAvailable,
            builder: (context, hasData, child) {
              if (!hasData && hotelCancellation.isEmpty) {
                return _buildEmptyState();
              }

              return Column(
                children: [
                  Expanded(
                    child: RefreshIndicator(
                      onRefresh: () async {
                        counter = 0;
                        hotelCancellation.clear();
                        await _callHotelBookingCancellationHistory(isRefresh: true);
                      },
                      child: ListView.builder(
                        controller: _scrollController,
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                        itemCount: hotelCancellation.length,
                        physics: const AlwaysScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          return _buildModernCard(hotelCancellation[index]);
                        },
                      ),
                    ),
                  ),
                  ValueListenableBuilder(
                    valueListenable: isLoadingMore,
                    builder: (context, loading, child) {
                      return loading
                          ? const Padding(
                        padding: EdgeInsets.all(12.0),
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                          : const SizedBox.shrink();
                    },
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }


  Future<void> _callHotelBookingCancellationHistory({bool isRefresh = false}) async {
    bool internet = await MyApplication.checkInternet();
    if (internet) {
      try {
        ResponseHotelBookingCancellationHistory? response = await ApiCalls.callHotelBookingCancellationHistory(
          RequestHotelBookingCancellationHistory(
            counter: counter.toString(),
            search: searchQuery,
            userId: AppPrefs.userId,
          ),
        );

        if (response != null && response.result != null && response.result!.toLowerCase().contains("pass")) {
          if (response.data != null && response.data!.isNotEmpty) {
            if (isRefresh) {
              hotelCancellation = response.data!;
            } else {
              hotelCancellation.addAll(response.data!);
            }
            isDataAvailable.value = true;
          } else {
            if (isRefresh) {
              hotelCancellation.clear();
              isDataAvailable.value = false;
            }
          }
        } else {
          if (isRefresh) isDataAvailable.value = false;
        }
      } catch (e) {
        log("Error: $e");
      } finally {
        isApiComplete.value = true;
        isLoadingMore.value = false;
        if (mounted) setState(() {});
      }
    } else {
      SharedWidgets.showTopSnackBar(context, message: "No Internet Available",title:"fail");
      isApiComplete.value = true;
      isLoadingMore.value = false;
    }
  }

  Widget _buildModernCard(HotelBookingCancellationHistoryData data) {
    return GestureDetector(
      onTap: () {
        Get.to(()=> HotelBookingDetailScreen(bookingId: data.id.toString(),));
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                color: Colors.blueGrey.withOpacity(0.05),
                child: Row(
                  children: [
                    const CircleAvatar(
                      backgroundColor: Colors.blueAccent,
                      radius: 18,
                      child: Icon(Icons.hotel, color: Colors.white, size: 18),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        data.hotelName ?? "Unknown Hotel",
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    _statusBadge(data.status ?? "Cancelled"),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    _dateBlock("Check-in", data.checkIn ?? ""),
                    const Expanded(child: Icon(Icons.arrow_right_alt, color: Colors.grey)),
                    _dateBlock("Check-out", data.checkOut ?? ""),
                  ],
                ),
              ),
              const Divider(height: 1, indent: 16, endIndent: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        _smallIconInfo(Icons.meeting_room_outlined, "${data.totalRooms} Rooms"),
                        const SizedBox(width: 10),
                        _smallIconInfo(Icons.single_bed_outlined, "${data.totalMattress} Mat."),
                      ],
                    ),
                    Text(
                      "₹${data.amount}",
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: Colors.black87),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _dateBlock(String label, String date) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 11, color: Colors.grey)),
        const SizedBox(height: 4),
        Text(date, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.blueGrey)),
      ],
    );
  }

  Widget _statusBadge(String status) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.green.withOpacity(0.1),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: Colors.green.withOpacity(0.2)),
      ),
      child: Text(
        status.toUpperCase(),
        style: const TextStyle(color: Colors.green, fontSize: 10, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _smallIconInfo(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 16, color: Colors.blueGrey),
        const SizedBox(width: 4),
        Text(text, style: const TextStyle(fontSize: 12, color: Colors.blueGrey)),
      ],
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.history_outlined, size: 80, color: Colors.grey.withOpacity(0.3)),
          const SizedBox(height: 16),
          const Text("No cancellation records found", style: TextStyle(color: Colors.grey, fontSize: 16)),
        ],
      ),
    );
  }
}

