import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:gotilo_new/Api/ApiCalls.dart';
import 'package:gotilo_new/Api/Request/AllListings/RequestBookHotelRoom.dart';
import 'package:gotilo_new/Api/Request/AllListings/RequestReserveRoomAdd.dart' as Req;
import 'package:gotilo_new/Api/Response/AllListings/ResponseBookHotelRoom.dart' hide Hotel, Rooms, PlanFeatures, DateWisePrices;
import 'package:gotilo_new/Api/Response/AllListings/ResponseReserveRoomAdd.dart' as Res;
import 'package:gotilo_new/CustomeWidgets/SharedWidgets.dart';
import 'package:gotilo_new/MyApplication/MyApplication.dart';
import 'package:gotilo_new/Screens/AllListing/AllList/FinalBookScreen.dart';
import 'package:intl/intl.dart';
import 'package:gotilo_new/Api/Response/AllListings/ResponseReserveBook.dart';
import 'package:gotilo_new/CustomeWidgets/CustomAppbar.dart';

class HotelDetailScreenForBook extends StatefulWidget {
  final HotelDesign? hotelDesign;

  const HotelDetailScreenForBook({super.key, this.hotelDesign});

  @override
  State<HotelDetailScreenForBook> createState() =>
      _HotelDetailScreenForBookState();
}

class _HotelDetailScreenForBookState extends State<HotelDetailScreenForBook> {
  int _currentImageIndex = 0;
  final PageController _pageController = PageController();

  // Selected Room and Plan State
  Plans? selectedPlan;
  Rooms? selectedRoom;

  // Selected Occupancy Details
  int selectedAdults = 1;
  int selectedChildren = 0;
  int selectedExtraMattressCount = 0;

  // API Call Response Data Hold Variable
  Res.ResponseReserveRoomAdd? _reserveRoomAddResponse;
  bool _isLoading = false;

  // Helper method to format raw date string
  String _formatDate(String? dateStr) {
    if (dateStr == null || dateStr.isEmpty) return '-';
    try {
      DateTime dt = DateTime.parse(dateStr);
      return DateFormat('dd MMM, yyyy (EEE)').format(dt);
    } catch (e) {
      return dateStr;
    }
  }

  // Helper method to strip HTML tags
  String _stripHtml(String? htmlString) {
    if (htmlString == null || htmlString.isEmpty) return '';

    String parsed = htmlString
        .replaceAll(RegExp(r'<br\s*/?>', caseSensitive: false), '\n')
        .replaceAll(RegExp(r'</p>', caseSensitive: false), '\n\n');

    parsed = parsed.replaceAll(RegExp(r'<[^>]*>'), '');
    return parsed.trim();
  }

  // Precise Pricing Calculation
  Map<String, dynamic> _calculateDetailedPricing(Hotel? hotel) {
    final stay = widget.hotelDesign?.stay;
    int totalNights = stay?.totalNights ?? 1;

    // 1. Room Base Price calculation
    int roomPrice = (selectedPlan?.totalAmount ??
        ((selectedPlan?.pricePerNight ?? 0) * totalNights))
        .toInt();

    // 2. Mattress Charge calculation
    double extraBedChargePerNight =
        double.tryParse(selectedRoom?.extraBedCharge?.toString() ?? '0') ?? 0;
    int mattressCharge =
    (extraBedChargePerNight * selectedExtraMattressCount * totalNights)
        .toInt();

    // 3. Grand Total calculation
    int grandTotal = roomPrice + mattressCharge;

    // Override with API response grand total if API returns valid summary
    if (_reserveRoomAddResponse?.data?.summary?.grandTotal != null &&
        _reserveRoomAddResponse!.data!.summary!.grandTotal! > 0) {
      grandTotal = _reserveRoomAddResponse!.data!.summary!.grandTotal!;
    }

    return {
      'roomPrice': roomPrice,
      'mattressCharge': mattressCharge,
      'subTotal': roomPrice,
      'grandTotal': grandTotal,
      'totalNights': totalNights,
      'totalRooms': _reserveRoomAddResponse?.data?.summary?.totalRooms ?? 1,
      'capacity': _reserveRoomAddResponse?.data?.summary?.capacity ??
          (selectedAdults + selectedChildren),
    };
  }

  // Bottom Sheet displaying detailed price breakup
  void _showBookingSummaryBottomSheet(Hotel? hotel) {
    final pricing = _calculateDetailedPricing(hotel);
    final stay = widget.hotelDesign?.stay;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top Drag Handle Indicator
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Booking & Price Details",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close_rounded, color: Colors.grey),
                    onPressed: () => Navigator.pop(context),
                  )
                ],
              ),
              const Divider(height: 1),
              const SizedBox(height: 16),

              // Booking Overview Card
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.blue.shade100),
                ),
                child: Column(
                  children: [
                    _buildSummaryInfoRow("Selected Room", selectedRoom?.roomName ?? "Standard Room", isBold: true),
                    const SizedBox(height: 6),
                    _buildSummaryInfoRow("Selected Plan", selectedPlan?.planName ?? "Base Plan"),
                    const SizedBox(height: 6),
                    _buildSummaryInfoRow("Stay Duration", "${_formatDate(stay?.checkin)} ➔ ${_formatDate(stay?.checkout)}"),
                    const SizedBox(height: 6),
                    _buildSummaryInfoRow("Occupancy", "$selectedAdults Adults, $selectedChildren Children | $selectedExtraMattressCount Mattress"),
                  ],
                ),
              ),

              const SizedBox(height: 20),
              const Text("Fare Breakdown", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
              const SizedBox(height: 12),

              // Room Price
              _buildSummaryPriceRow("Room Base Price", "₹${pricing['roomPrice']}"),
              if (pricing['mattressCharge'] > 0) ...[
                const SizedBox(height: 8),
                // Mattress Price
                _buildSummaryPriceRow("Mattress Total (${pricing['totalNights']} Nights)", "₹${pricing['mattressCharge']}"),
              ],

              const Padding(
                padding: EdgeInsets.symmetric(vertical: 12.0),
                child: Divider(thickness: 1, height: 1),
              ),

              // FINAL TOTAL ROW
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Grand Total",
                        style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black87),
                      ),
                      Text("(Inclusive of all charges)", style: TextStyle(fontSize: 10, color: Colors.grey)),
                    ],
                  ),
                  Text(
                    "₹${pricing['grandTotal']}",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w900,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // PROCEED BUTTON
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context); // Close bottom sheet
                    _callBookHotelRoom();   // Call Book Hotel Room API
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).primaryColor,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text("PROCEED TO PAY", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                ),
              ),
              const SizedBox(height: 10),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSummaryInfoRow(String title, String value, {bool isBold = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: const TextStyle(fontSize: 12, color: Colors.black54)),
        Expanded(
          child: Text(
            value,
            textAlign: TextAlign.end,
            style: TextStyle(
              fontSize: 12,
              fontWeight: isBold ? FontWeight.bold : FontWeight.w600,
              color: Colors.black87,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSummaryPriceRow(String label, String amount) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(fontSize: 13, color: Colors.black87)),
        Text(
          amount,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }

  // API Call to Add Reserve Room
  Future<void> _callReserveRoomAdd() async {
    final stay = widget.hotelDesign?.stay;
    final hotel = widget.hotelDesign?.hotel;

    if (selectedRoom == null || selectedPlan == null) return;

    bool internet = await MyApplication.checkInternet();
    if (!internet) {
      if (mounted) {
        SharedWidgets.showTopSnackBar(
          context,
          message: "No Internet Connection",
          title: "fail",
        );
      }
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      double perNightPrice = double.tryParse(
          selectedPlan?.pricePerNight?.toString() ?? '0') ??
          0;

      double planTotalAmount = double.tryParse(
          selectedPlan?.totalAmount?.toString() ??
              selectedPlan?.pricePerNight?.toString() ??
              '0') ??
          0;

      double extraBedChargePerNight =
          double.tryParse(selectedRoom?.extraBedCharge?.toString() ?? '0') ??
              0;

      int totalNights = stay?.totalNights ?? 1;

      // Rooms Payload Creation
      Req.Rooms roomData = Req.Rooms(
        roomId: selectedRoom?.roomId,
        roomName: selectedRoom?.roomName,
        planId: selectedPlan?.planId,
        planName: selectedPlan?.planName,
        adults: selectedAdults,
        childs: selectedChildren,
        mattress: selectedExtraMattressCount,
        basePrice: perNightPrice.toInt(),
        pricePerUnit: perNightPrice.toInt(),
        totalPrice: planTotalAmount.toInt(),
        mattressPricePerUnit: extraBedChargePerNight.toInt(),
        mattressTotal: (extraBedChargePerNight * selectedExtraMattressCount * totalNights).toInt(),
        quantity: 1,
        planFeatures: selectedPlan?.feature != null
            ? [
          Req.PlanFeatures(
            name: selectedPlan?.planName ?? '',
            description: selectedPlan?.feature ?? '',
          )
        ]
            : [],
      );

      // Reserve Request Payload Creation
      Req.RequestReserveRoomAdd requestBody = Req.RequestReserveRoomAdd(
        listingId: hotel?.listingId,
        checkin: stay?.checkin,
        checkout: stay?.checkout,
        adults: stay?.adults ?? selectedAdults,
        childs: stay?.childs ?? selectedChildren,
        rooms: [roomData],
      );

      Res.ResponseReserveRoomAdd? response =
      await ApiCalls.callReserveRoomAdd(requestBody);

      if (response != null && response.result != null) {
        if (response.result!.toLowerCase().contains("pass")) {
          setState(() {
            _reserveRoomAddResponse = response;
          });
          if (mounted) {
            SharedWidgets.showTopSnackBar(
              context,
              message: response.message ?? "Room added successfully!",
            );
          }
        } else {
          if (mounted) {
            SharedWidgets.showTopSnackBar(
              context,
              message: response.message ?? "Failed to add room.",
              title: "fail",
            );
          }
        }
      }
    } on Exception catch (e) {
      log("Error during reserve room add: $e");
    } catch (e) {
      log("Error during reserve room add: $e");
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  // API Call to Final Book Hotel Room
  Future<void> _callBookHotelRoom() async {
    bool internet = await MyApplication.checkInternet();
    if (!internet) {
      if (mounted) {
        SharedWidgets.showTopSnackBar(context, message: "No Internet Connection", title: "fail");
      }
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final stay = widget.hotelDesign?.stay;
      final hotel = widget.hotelDesign?.hotel;

      final resData = _reserveRoomAddResponse?.data;
      List<SelectedRoomsData> selectedRoomsList = [];

      if (resData?.selectedRooms != null && resData!.selectedRooms!.isNotEmpty) {
        selectedRoomsList = resData.selectedRooms!.map((room) {
          return SelectedRoomsData(
            roomId: room.roomId,
            roomName: room.roomName,
            planId: room.planId,
            planName: room.planName,
            adults: room.adults,
            childs: room.childs,
            mattress: room.mattress,
            basePrice: room.basePrice,
            mattressPricePerUnit: room.mattressPricePerUnit,
            mattressTotal: room.mattressTotal,
            pricePerUnit: room.pricePerUnit,
            totalPrice: room.totalPrice,
            quantity: room.quantity,
            planFeatures: room.planFeatures?.map((f) => PlanFeatures(
              name: f.name,
              description: f.description,
            )).toList(),
            dateWisePrices: room.dateWisePrices?.map((d) => DateWisePrices(
              date: d.date,
              effectiveDate: d.effectiveDate,
              basePrice: d.basePrice,
              finalPrice: d.finalPrice,
            )).toList(),
          );
        }).toList();
      }

      RequestBookHotelRoom requestBody = RequestBookHotelRoom(
        listingId: hotel?.listingId,
        checkin: stay?.checkin,
        checkout: stay?.checkout,
        totalAdults: stay?.adults ?? selectedAdults,
        totalChilds: stay?.childs ?? selectedChildren,
        selectedRoomsData: selectedRoomsList,
      );

      ResponseBookHotelRoom? response = await ApiCalls.callBookHotelRoom(requestBody);

      if (response != null && response.result != null) {
        if (response.result!.toLowerCase().contains("pass")) {
          if (mounted) {
            Get.to(()=> FinalBookScreen(bookHotelRoomData: response.data,));
            SharedWidgets.showTopSnackBar(
              context,
              message: response.message ?? "Booking successful!",
              title: "pass",
            );
          }
        } else {
          if (mounted) {
            SharedWidgets.showTopSnackBar(
              context,
              message: response.message ?? "Booking failed",
              title: "fail",
            );
          }
        }
      }
    } on Exception catch (e) {
      log("Error during callBookHotelRoom: $e");
    } catch (e) {
      log("Error during callBookHotelRoom: $e");
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  // Occupancy Selection Dialog
  void _showOccupancyDialog(Rooms room, Plans plan) {
    int tempAdults = selectedRoom == room ? selectedAdults : 1;
    int tempChildren = selectedRoom == room ? selectedChildren : 0;
    int tempMattressCount = selectedRoom == room ? selectedExtraMattressCount : 0;

    int maxAdults = int.tryParse(room.maxAdults?.toString() ?? '4') ?? 4;
    int maxChildren = int.tryParse(room.maxChildren?.toString() ?? '2') ?? 2;
    double extraBedCharge = double.tryParse(room.extraBedCharge?.toString() ?? '0') ?? 0;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext ctx) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(18.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Occupancy",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1E293B),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close, color: Colors.grey),
                          onPressed: () => Navigator.of(context).pop(),
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Adults Dropdown
                    Text(
                      "Adults (Max $maxAdults)",
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade300),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<int>(
                          value: tempAdults <= maxAdults ? tempAdults : 1,
                          isExpanded: true,
                          items: List.generate(maxAdults, (i) => i + 1).map((val) {
                            return DropdownMenuItem<int>(
                              value: val,
                              child: Text("$val"),
                            );
                          }).toList(),
                          onChanged: (val) {
                            if (val != null) {
                              setDialogState(() => tempAdults = val);
                            }
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 14),

                    // Children Dropdown
                    Text(
                      "Children (Max $maxChildren)",
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade300),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<int>(
                          value: tempChildren <= maxChildren ? tempChildren : 0,
                          isExpanded: true,
                          items: List.generate(maxChildren + 1, (i) => i).map((val) {
                            return DropdownMenuItem<int>(
                              value: val,
                              child: Text("$val"),
                            );
                          }).toList(),
                          onChanged: (val) {
                            if (val != null) {
                              setDialogState(() => tempChildren = val);
                            }
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 14),

                    // Extra Mattress Dropdown
                    const Text(
                      "Extra Mattress",
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade300),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<int>(
                          value: tempMattressCount,
                          isExpanded: true,
                          items: [
                            const DropdownMenuItem<int>(
                              value: 0,
                              child: Text("No Mattress"),
                            ),
                            DropdownMenuItem<int>(
                              value: 1,
                              child: Text(
                                extraBedCharge > 0
                                    ? "1 Mattress (+₹${extraBedCharge.toInt()})"
                                    : "1 Mattress",
                              ),
                            ),
                            DropdownMenuItem<int>(
                              value: 2,
                              child: Text(
                                extraBedCharge > 0
                                    ? "2 Mattress (+₹${(extraBedCharge * 2).toInt()})"
                                    : "2 Mattress",
                              ),
                            ),
                          ],
                          onChanged: (val) {
                            if (val != null) {
                              setDialogState(() => tempMattressCount = val);
                            }
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Confirm Button trigger
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Theme.of(context).primaryColor,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        onPressed: () {
                          setState(() {
                            selectedRoom = room;
                            selectedPlan = plan;
                            selectedAdults = tempAdults;
                            selectedChildren = tempChildren;
                            selectedExtraMattressCount = tempMattressCount;
                          });
                          Navigator.of(context).pop();

                          // Trigger API call upon confirmation
                          _callReserveRoomAdd();
                        },
                        child: const Text(
                          "CONFIRM",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 14),
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

  @override
  Widget build(BuildContext context) {
    final data = widget.hotelDesign;

    if (data == null) {
      return const Scaffold(
        appBar: CustomAppBar(
          title: "Hotel Booking",
          showAction: false,
          showBackButton: true,
        ),
        body: Center(child: Text("No Data Available")),
      );
    }

    final hotel = data.hotel;
    final stay = data.stay;

    return Scaffold(
      backgroundColor: const Color(0xFFF4F6F8),
      appBar: CustomAppBar(
        title: hotel?.title ?? "Hotel Details",
        showAction: false,
        showBackButton: true,
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (data.gallery != null && data.gallery!.isNotEmpty)
              _buildGallerySlider(data.gallery!),

            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHotelOverviewCard(hotel),
                  const SizedBox(height: 16),

                  if (stay != null) _buildStayDetailsCard(stay),
                  const SizedBox(height: 20),

                  if (hotel?.overview != null && hotel!.overview!.isNotEmpty) ...[
                    _buildSectionHeader("About Hotel", Icons.info_outline_rounded),
                    const SizedBox(height: 10),
                    _buildCardWrapper(
                      child: Text(
                        _stripHtml(hotel.overview),
                        style: TextStyle(color: Colors.grey[800], height: 1.5, fontSize: 13),
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],

                  if (data.amenities != null && data.amenities!.isNotEmpty) ...[
                    _buildSectionHeader("Hotel Facilities & Amenities", Icons.stars_rounded),
                    const SizedBox(height: 10),
                    _buildAmenitiesList(data.amenities!),
                    const SizedBox(height: 20),
                  ],

                  if (data.rooms != null && data.rooms!.isNotEmpty) ...[
                    _buildSectionHeader("Available Rooms & Rates", Icons.king_bed_rounded),
                    const SizedBox(height: 10),
                    ...data.rooms!.map((room) => _buildDetailedRoomCard(room)),
                    const SizedBox(height: 20),
                  ],

                  if (data.additionalServices != null) ...[
                    _buildSectionHeader("Services & Extras", Icons.room_service_rounded),
                    const SizedBox(height: 10),
                    _buildAdditionalServices(data.additionalServices!),
                    const SizedBox(height: 20),
                  ],

                  if (hotel?.rulesAndRegulations != null && hotel!.rulesAndRegulations!.isNotEmpty) ...[
                    _buildSectionHeader("Policies & House Rules", Icons.policy_rounded),
                    const SizedBox(height: 10),
                    _buildPoliciesCard(hotel),
                    const SizedBox(height: 20),
                  ],

                  if (data.contentProvider != null || data.providerDetails != null) ...[
                    _buildSectionHeader("Hosted By", Icons.person_pin_rounded),
                    const SizedBox(height: 10),
                    _buildDetailedContactCard(data.contentProvider, data.providerDetails, data.socialLinks),
                    const SizedBox(height: 30),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomBookingBar(hotel),
    );
  }

  // --- UI COMPONENTS ---

  Widget _buildGallerySlider(List<Gallery> gallery) {
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        SizedBox(
          height: 250,
          child: PageView.builder(
            controller: _pageController,
            itemCount: gallery.length,
            onPageChanged: (index) {
              setState(() {
                _currentImageIndex = index;
              });
            },
            itemBuilder: (context, index) {
              final imgUrl = gallery[index].image;
              return Image.network(
                imgUrl ?? '',
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  color: Colors.grey[300],
                  child: const Icon(Icons.hotel, size: 60, color: Colors.grey),
                ),
              );
            },
          ),
        ),
        IgnorePointer(
          child: Container(
            height: 250,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withOpacity(0.1),
                  Colors.black.withOpacity(0.5),
                ],
              ),
            ),
          ),
        ),
        Positioned(
          bottom: 12,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              gallery.length,
                  (index) => AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                margin: const EdgeInsets.symmetric(horizontal: 3),
                width: _currentImageIndex == index ? 18 : 6,
                height: 6,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                  color: _currentImageIndex == index
                      ? Colors.white
                      : Colors.white.withOpacity(0.4),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildHotelOverviewCard(Hotel? hotel) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 10,
              offset: const Offset(0, 4))
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  hotel?.title ?? '',
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    letterSpacing: -0.5,
                  ),
                ),
              ),
              if (hotel?.starRating != null)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.amber[800],
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.star, color: Colors.white, size: 14),
                      const SizedBox(width: 4),
                      Text(
                        hotel?.starRating ?? '0.0',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(Icons.location_on_rounded, size: 16, color: Colors.redAccent),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  hotel?.address?.replaceAll('\r\n', ', ') ?? '',
                  style: TextStyle(color: Colors.grey[600], fontSize: 13),
                ),
              ),
            ],
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 12.0),
            child: Divider(height: 1, thickness: 0.8),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildHeaderTimingBadge(Icons.access_time_filled_rounded, "Check-In", hotel?.checkIn ?? '-'),
              Container(height: 25, width: 1, color: Colors.grey[300]),
              _buildHeaderTimingBadge(Icons.more_time_rounded, "Check-Out", hotel?.checkOut ?? '-'),
              Container(height: 25, width: 1, color: Colors.grey[300]),
              _buildHeaderTimingBadge(Icons.restaurant_rounded, "Food Type", hotel?.foodType?.toUpperCase() ?? '-'),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildHeaderTimingBadge(IconData icon, String title, String value) {
    return Column(
      children: [
        Icon(icon, size: 18, color: Theme.of(context).primaryColor),
        const SizedBox(height: 4),
        Text(title, style: const TextStyle(fontSize: 10, color: Colors.grey)),
        Text(value, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget _buildStayDetailsCard(Stay stay) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.blue.shade900, Colors.indigo.shade700],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
              color: Colors.blue.withOpacity(0.2),
              blurRadius: 10,
              offset: const Offset(0, 4))
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildDateColumn("CHECK-IN", _formatDate(stay.checkin)),
              const Icon(Icons.arrow_forward_rounded, color: Colors.white54, size: 20),
              _buildDateColumn("CHECK-OUT", _formatDate(stay.checkout)),
            ],
          ),
          const Divider(color: Colors.white24, height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildStayPill(Icons.nights_stay_rounded, "${stay.totalNights ?? 0} Nights"),
              _buildStayPill(Icons.person_rounded, "${stay.adults ?? 0} Adults"),
              if (stay.childs != null && stay.childs != 0)
                _buildStayPill(Icons.child_care_rounded, "${stay.childs} Children"),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildDateColumn(String label, String formattedDate) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: Colors.white60, fontSize: 10, fontWeight: FontWeight.bold)),
        const SizedBox(height: 4),
        Text(formattedDate, style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget _buildStayPill(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, color: Colors.amberAccent, size: 16),
        const SizedBox(width: 6),
        Text(text, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 12)),
      ],
    );
  }

  Widget _buildAmenitiesList(List<Amenities> amenities) {
    return Wrap(
      spacing: 8.0,
      runSpacing: 8.0,
      children: amenities.map((item) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (item.icon != null && item.icon!.isNotEmpty)
                Image.network(item.icon!, width: 16, height: 16, errorBuilder: (_, __, ___) => const Icon(Icons.check_circle_rounded, size: 16, color: Colors.teal))
              else
                const Icon(Icons.check_circle_rounded, size: 16, color: Colors.teal),
              const SizedBox(width: 6),
              Text(
                item.name ?? '',
                style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildDetailedRoomCard(Rooms room) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (room.images != null && room.images!.isNotEmpty)
            SizedBox(
              height: 130,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.all(8),
                itemCount: room.images!.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.network(
                        room.images![index],
                        width: 170,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Container(
                          width: 170,
                          color: Colors.grey[200],
                          child: const Icon(Icons.hotel),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

          Padding(
            padding: const EdgeInsets.all(14.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  room.roomName ?? '',
                  style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                ),
                if (room.description != null && room.description!.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(
                    _stripHtml(room.description),
                    style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                  ),
                ],
                const SizedBox(height: 8),

                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: [
                    if (room.roomType != null) _buildChip("Type: ${room.roomType}"),
                    if (room.roomSize != null) _buildChip("Size: ${room.roomSize}"),
                    if (room.bedType != null) _buildChip("Bed: ${room.bedType}"),
                    if (room.maxAdults != null) _buildChip("Max Adults: ${room.maxAdults}"),
                    if (room.maxChildren != null) _buildChip("Max Child: ${room.maxChildren}"),
                    if (room.viewType != null) _buildChip("View: ${room.viewType}"),
                  ],
                ),

                if (room.extraBedCharge != null && room.extraBedCharge != 0) ...[
                  const SizedBox(height: 8),
                  Text("Extra Bed Charge: ₹${room.extraBedCharge}/night",
                      style: TextStyle(fontSize: 11, color: Colors.grey[700], fontWeight: FontWeight.w500)),
                ],

                const SizedBox(height: 12),
                const Divider(height: 1),
                const SizedBox(height: 10),

                const Text("Select Plan & Rate:", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                const SizedBox(height: 8),

                if (room.plans != null)
                  ...room.plans!.map((plan) => _buildPlanSelectionTile(room, plan)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChip(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(label, style: TextStyle(fontSize: 11, color: Colors.blue.shade900, fontWeight: FontWeight.w500)),
    );
  }

  Widget _buildPlanSelectionTile(Rooms room, Plans plan) {
    final bool isSelected = selectedPlan == plan && selectedRoom == room;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isSelected ? Colors.blue.shade50.withOpacity(0.5) : Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isSelected ? Theme.of(context).primaryColor : Colors.grey.shade300,
          width: isSelected ? 1.5 : 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      plan.planName ?? 'Standard Plan',
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                    ),
                    if (plan.feature != null && plan.feature!.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 2.0),
                        child: Text(
                          "✓ ${_stripHtml(plan.feature)}",
                          style: const TextStyle(color: Colors.green, fontSize: 11, fontWeight: FontWeight.w600),
                        ),
                      ),
                  ],
                ),
              ),

              ElevatedButton(
                onPressed: () {
                  _showOccupancyDialog(room, plan);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: isSelected ? Colors.green : Theme.of(context).primaryColor,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                ),
                child: Text(
                  isSelected ? "SELECTED ✓" : "ADD +",
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                ),
              )
            ],
          ),

          const SizedBox(height: 8),

          Row(
            children: [
              Text(
                "₹${plan.totalAmount ?? plan.pricePerNight ?? 0}",
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: Colors.black),
              ),
              const SizedBox(width: 8),
              if (plan.pricePerNight != null)
                Text(
                  "(₹${plan.pricePerNight} / night)",
                  style: TextStyle(fontSize: 11, color: Colors.grey[600]),
                ),
            ],
          ),

          if (isSelected) ...[
            const SizedBox(height: 6),
            Text(
              "Occupancy: $selectedAdults Adults, $selectedChildren Children" +
                  (selectedExtraMattressCount > 0
                      ? " | $selectedExtraMattressCount Extra Mattress"
                      : ""),
              style: TextStyle(
                fontSize: 11,
                color: Colors.blue.shade800,
                fontWeight: FontWeight.w600,
              ),
            ),
          ]
        ],
      ),
    );
  }

  Widget _buildAdditionalServices(AdditionalServices services) {
    final List<Widget> serviceWidgets = [];

    if (services.hotelServices != null) {
      for (var s in services.hotelServices!) {
        serviceWidgets.add(_buildServiceTile(s.title, s.description, s.price, "Hotel Service"));
      }
    }
    if (services.roomServices != null) {
      for (var s in services.roomServices!) {
        serviceWidgets.add(_buildServiceTile(s.title, s.description, s.price, "Room Service"));
      }
    }

    if (serviceWidgets.isEmpty) return const SizedBox.shrink();

    return Column(children: serviceWidgets);
  }

  Widget _buildServiceTile(String? title, String? description, String? price, String category) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _stripHtml(title),
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      category,
                      style: TextStyle(fontSize: 10, color: Theme.of(context).primaryColor, fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ),
              if (price != null && price.isNotEmpty && double.tryParse(price) != 0)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    "₹$price",
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.black87),
                  ),
                ),
            ],
          ),
          if (description != null && description.isNotEmpty) ...[
            const SizedBox(height: 6),
            Text(
              _stripHtml(description),
              style: TextStyle(fontSize: 12, color: Colors.grey[700], height: 1.3),
            ),
          ]
        ],
      ),
    );
  }

  Widget _buildPoliciesCard(Hotel? hotel) {
    return _buildCardWrapper(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (hotel?.rulesAndRegulations != null) ...[
            const Text("House Rules & Regulations", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
            const SizedBox(height: 4),
            Text(_stripHtml(hotel!.rulesAndRegulations), style: TextStyle(color: Colors.grey[800], fontSize: 12, height: 1.4)),
          ],
        ],
      ),
    );
  }

  Widget _buildDetailedContactCard(ContentProvider? cp, ProviderDetails? pd, SocialLinks? social) {
    return _buildCardWrapper(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (cp != null)
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: CircleAvatar(
                backgroundColor: Colors.blue.shade100,
                child: Icon(Icons.person, color: Theme.of(context).primaryColor),
              ),
              title: Text(cp.name ?? 'Property Host', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
              subtitle: Text("Email: ${cp.email ?? 'N/A'}", style: const TextStyle(fontSize: 11)),
            ),
          if (pd != null) ...[
            const Divider(),
            if (pd.phone != null)
              _buildContactRow(Icons.phone, "Phone", pd.phone!),
            if (pd.address != null)
              _buildContactRow(Icons.location_city, "Address", _stripHtml(pd.address)),
          ],
          if (social != null) ...[
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: [
                if (social.facebook != null && social.facebook!.isNotEmpty) const Icon(Icons.facebook, color: Colors.blue, size: 20),
                if (social.instagram != null && social.instagram!.isNotEmpty) const Icon(Icons.camera_alt, color: Colors.pink, size: 20),
              ],
            )
          ]
        ],
      ),
    );
  }

  Widget _buildContactRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Icon(icon, size: 16, color: Colors.grey[600]),
          const SizedBox(width: 8),
          Text("$label: ", style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
          Expanded(child: Text(value, style: TextStyle(fontSize: 12, color: Colors.grey[800]))),
        ],
      ),
    );
  }

  // Bottom Navigation Bar with Grand Total
  Widget _buildBottomBookingBar(Hotel? hotel) {
    final pricing = _calculateDetailedPricing(hotel);
    final int grandTotal = pricing['grandTotal'];

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 15,
            offset: const Offset(0, -4),
          )
        ],
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (_reserveRoomAddResponse?.data != null)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                margin: const EdgeInsets.only(bottom: 8),
                decoration: BoxDecoration(
                  color: Colors.green.shade50,
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(color: Colors.green.shade200),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.check_circle_rounded, color: Colors.green, size: 16),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        "Selected: ${selectedRoom?.roomName ?? 'Room'} | Total Capacity: ${pricing['capacity']} Persons",
                        style: const TextStyle(fontSize: 11, color: Colors.green, fontWeight: FontWeight.bold),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                InkWell(
                  onTap: () => _showBookingSummaryBottomSheet(hotel),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Text(
                            "Grand Total",
                            style: TextStyle(fontSize: 11, color: Colors.grey, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(width: 4),
                          Icon(Icons.info_outline_rounded, size: 13, color: Theme.of(context).primaryColor),
                        ],
                      ),
                      Text(
                        "₹$grandTotal",
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w900,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
                ElevatedButton(
                  onPressed: _isLoading
                      ? null
                      : () {
                    if (selectedPlan == null) {
                      SharedWidgets.showTopSnackBar(
                        context,
                        message: "કૃપા કરીને પહેલા રૂમ અને પ્લાન પસંદ કરો!",
                        title: "fail",
                      );
                    } else {
                      _showBookingSummaryBottomSheet(hotel);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).primaryColor,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    elevation: 2,
                  ),
                  child: _isLoading
                      ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                  )
                      : const Row(
                    children: [
                      Text("BOOK NOW", style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                      SizedBox(width: 4),
                      Icon(Icons.arrow_forward_rounded, size: 16),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title, IconData icon) {
    return Row(
      children: [
        Icon(icon, size: 20, color: Theme.of(context).primaryColor),
        const SizedBox(width: 8),
        Text(
          title,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, letterSpacing: -0.3),
        ),
      ],
    );
  }

  Widget _buildCardWrapper({required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: child,
    );
  }
}