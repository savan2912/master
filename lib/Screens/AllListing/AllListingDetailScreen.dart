import 'dart:developer';
import 'dart:ui';
import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gotilo_new/Api/Request/AllListings/RequestSimilarListing.dart';
import 'package:gotilo_new/Api/Request/Cart/RequestAddCart.dart';
import 'package:gotilo_new/Api/Request/Enquiry/RequestAddEnquiry.dart';
import 'package:gotilo_new/Api/Request/Fav/RequestAddFav.dart';
import 'package:gotilo_new/Api/Request/Review/RequestAddReview.dart';
import 'package:gotilo_new/Api/Request/Review/RequestReview.dart';
import 'package:gotilo_new/Api/Request/Share/RequestShare.dart';
import 'package:gotilo_new/Api/Request/SubCategoryList/RequestSubCategoryListDetails.dart';
import 'package:gotilo_new/Api/Request/SubCategoryList/RequestSubCategoryProductList.dart';
import 'package:gotilo_new/Api/Response/AllListings/ResponseSimilarListing.dart';
import 'package:gotilo_new/Api/Response/Cart/ResponseAddCart.dart';
import 'package:gotilo_new/Api/Response/Enquiry/ResponseAddEnquiry.dart';
import 'package:gotilo_new/Api/Response/Fav/ResponseAddFav.dart';
import 'package:gotilo_new/Api/Response/Review/ResponseAddReview.dart';
import 'package:gotilo_new/Api/Response/Review/ResponseReview.dart';
import 'package:gotilo_new/Api/Response/Share/ResponseShare.dart';
import 'package:gotilo_new/Api/Response/SubCategoryList/ResponseSubCategoryProductList.dart';
import 'package:gotilo_new/Api/Response/SubCategoryList/ResponseSubcategoryListDetails.dart';
import 'package:gotilo_new/Constant/AppPref.dart';
import 'package:gotilo_new/Constant/Constants.dart';
import 'package:gotilo_new/CustomeWidgets/SharedWidgets.dart';
import 'package:gotilo_new/Screens/Product/ProductDetailScreen.dart';
import 'package:marquee/marquee.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../Api/ApiCalls.dart';
import '../../Api/Request/CrackDeal/RequestCrackDeal.dart';
import '../../Api/Response/CrackDeal/ResponseCrackDeal.dart';
import '../../MyApplication/MyApplication.dart';
import '../HeritageHomeScreen.dart';
import '../User/Deals/DealsScreen.dart';
import '../cart/CartScreen.dart';


const Color primaryColor = Color(0xFFF012BE);
const Color darkBlue = Color(0xFF1B2E3F);

class AllListingDetailScreen extends StatefulWidget {
  int? listId = 0;
  AllListingDetailScreen({super.key, this.listId});

  @override
  State<AllListingDetailScreen> createState() => _AllListingDetailScreenState();
}

class _AllListingDetailScreenState extends State<AllListingDetailScreen>
    with SingleTickerProviderStateMixin {
  ValueNotifier<bool> isDataAvailable = ValueNotifier(false);
  ValueNotifier<bool> isApiComplete = ValueNotifier(false);

  ValueNotifier<bool> isProductDataAvailable = ValueNotifier(false);
  ValueNotifier<bool> isProductApiComplete = ValueNotifier(false);

  late ScrollController _scrollController;
  late ScrollController _marqueeController;
  late TabController _tabController;
  late PageController _pageController;
  Timer? _marqueeTimer;

  List<Lisitngdeals> myDealsList = [];
  List<SimilarListing> similarList = [];

  bool _isSearching = false;
  final int _selectedDealIndex = 0;
  int _currentImageIndex = 0;
  final TextEditingController _searchController = TextEditingController();

  ListDetail? listDetail;
  int? isFav;
  final List<DetailImages> _bannerImages = [];
  List<Amenities> amenities = [];
  List<SubCategoryProductList> products = [];
  Vendor? vendor;

  List<ReviewData> reviewData=[];
  String? shareUrl;
  var allReview;
  double _currentRating = 0;
  TextEditingController searchController = TextEditingController();
  final TextEditingController _fNameController = TextEditingController();
  final TextEditingController _lNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _numberController = TextEditingController();
  final TextEditingController _messageController = TextEditingController();


  final TextEditingController _reviewTitle = TextEditingController();
  final TextEditingController _review = TextEditingController();


  Timer? _debouncer;
  int currentCounter = 0;
  bool isLoadMore = false;
  bool isSearching = false;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _marqueeController = ScrollController();
    _pageController = PageController();
    _tabController = TabController(length: 2, vsync: this);
    _callSubCategoryProductList();
    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) {
        setState(() {
          _isSearching = false;
          _searchController.clear();
        });
      }
    });
    _callSimilarListing();
    callReview();
    callShare();
    callSubCategoryListDetails();

    WidgetsBinding.instance.addPostFrameCallback((_) => _startMarquee());
  }

  Future<void> _launchPhone(String phoneNumber) async {
    final Uri url = Uri(scheme: 'tel', path: phoneNumber);
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    }
  }

  Future<void> _launchEmail(String email) async {
    final Uri url = Uri(scheme: 'mailto', path: email);
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    }
  }

  void _startMarquee() {
    _marqueeTimer = Timer.periodic(const Duration(seconds: 3), (timer) {
      if (_marqueeController.hasClients) {
        double maxScroll = _marqueeController.position.maxScrollExtent;
        if (maxScroll > 0) {
          _marqueeController.animateTo(
            _marqueeController.offset == 0 ? maxScroll : 0,
            duration: Duration(milliseconds: maxScroll.toInt() * 45),
            curve: Curves.linear,
          );
        }
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _marqueeController.dispose();
    _pageController.dispose();
    _tabController.dispose();
    _marqueeTimer?.cancel();
    _searchController.dispose();
    searchController.dispose();
    _debouncer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ModernHeritageApp.appBg,
      floatingActionButton: ValueListenableBuilder(
        valueListenable: isApiComplete,
        builder: (context, value, child) {
          return Visibility(
            visible: value,
            child: FloatingActionButton(
              onPressed: () => _showEnquiryModal(context),
              backgroundColor: primaryColor,
              elevation: 8,
              child: const Icon(
                Icons.chat_bubble_outline_rounded,
                color: Colors.white,
                size: 24,
              ),
            ),
          );
        },
      ),
      body: ValueListenableBuilder(
        valueListenable: isApiComplete,
        builder: (context, value, child) {
          return Visibility(
            visible: value,
            replacement: const Center(child: CircularProgressIndicator()),
            child: ValueListenableBuilder(
              valueListenable: isDataAvailable,
              builder: (context, value, child) {
                return Visibility(
                  visible: value,
                  replacement: const Center(child: Text("No data")),
                  child: NestedScrollView(
                    controller: _scrollController,
                    physics: const BouncingScrollPhysics(),
                    headerSliverBuilder: (context, innerBoxIsScrolled) {
                      return [
                        SliverAppBar(
                          expandedHeight: 280,
                          pinned: true,
                          stretch: true,
                          backgroundColor: darkBlue,
                          leadingWidth: _isSearching ? 20 : 60,
                          leading: _isSearching
                              ? const SizedBox.shrink()
                              : _buildHeaderButton(
                                  Icons.arrow_back_ios_new,
                                  () => Navigator.pop(context),
                                ),
                          centerTitle: true,
                          title: _isSearching
                              ? _buildPremiumSearchBar()
                              : ListenableBuilder(
                                  listenable: _scrollController,
                                  builder: (context, child) {
                                    double offset = _scrollController.hasClients
                                        ? _scrollController.offset
                                        : 0;
                                    double opacity = (offset / 180).clamp(
                                      0.0,
                                      1.0,
                                    );
                                    return Opacity(
                                      opacity: opacity,
                                      child: _buildMarqueeTitle(
                                        "${listDetail!.listingTitle}",
                                      ),
                                    );
                                  },
                                ),
                          actions: [
                            if (!_isSearching) ...[
                              if (_tabController.index == 1) ...[
                                _buildHeaderButton(Icons.add_shopping_cart, () {
                                  if(AppPrefs.userId != ""){
                                    Get.to(() =>  CartScreen(listingId: widget.listId,));
                                  }else{
                                    SharedWidgets.showTopSnackBar(context, message: "Please Login First");
                                  }

                                }),
                              ] else ...[
                                _buildHeaderButton(Icons.share_outlined, () {
                                  if(shareUrl != null && shareUrl != "") {
                                    _showCustomShareSheet(context,shareUrl!);
                                  }
                                }),
                                _buildHeaderButton(
                                  isFav == 1 ? Icons.favorite_outlined : Icons.favorite_border,
                                  () {
                                    if(AppPrefs.userId != ""){
                                      callAddFav();
                                    }else{
                                      SharedWidgets.showTopSnackBar(context, message: "Please Login First");
                                    }

                                  },
                                ),
                              ],
                            ],
                            const SizedBox(width: 8),
                          ],
                          flexibleSpace: FlexibleSpaceBar(
                            background: Stack(
                              fit: StackFit.expand,
                              children: [
                                PageView.builder(
                                  controller: _pageController,
                                  itemCount: _bannerImages.length,
                                  onPageChanged: (index) => setState(
                                    () => _currentImageIndex = index,
                                  ),
                                  itemBuilder: (context, index) {
                                    return Image.network(
                                      _bannerImages[index].imagePath!,
                                      fit: BoxFit.cover,
                                    );
                                  },
                                ),

                                const DecoratedBox(
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                      colors: [
                                        Colors.black45,
                                        Colors.transparent,
                                        Colors.black54,
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
                            color: ModernHeritageApp.appBg,
                            padding: const EdgeInsets.only(top: 20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 20,
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            _buildCategoryBadge("PREMIUM CAFE"),
                                            const SizedBox(height: 8),
                                            Text(
                                              "${listDetail!.listingTitle}",
                                              style: const TextStyle(
                                                color: darkBlue,
                                                fontSize: 26,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 15),
                                SizedBox(
                                  height: 65,
                                  child: ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 20,
                                    ),
                                    itemCount: _bannerImages.length,
                                    itemBuilder: (context, index) {
                                      bool isSelected =
                                          _currentImageIndex == index;
                                      return GestureDetector(
                                        onTap: () {
                                          if (mounted) {
                                            _pageController.animateToPage(
                                              index,
                                              duration: const Duration(
                                                milliseconds: 300,
                                              ),
                                              curve: Curves.easeInOut,
                                            );
                                          }
                                        },
                                        child: AnimatedContainer(
                                          duration: const Duration(
                                            milliseconds: 200,
                                          ),
                                          width: 65,
                                          margin: const EdgeInsets.only(
                                            right: 12,
                                          ),
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(
                                              12,
                                            ),
                                            border: Border.all(
                                              color: isSelected
                                                  ? primaryColor
                                                  : Colors.grey.shade300,
                                              width: 2,
                                            ),
                                            image: DecorationImage(
                                              image: NetworkImage(
                                                _bannerImages[index].imagePath!,
                                              ),
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                                const SizedBox(height: 10),
                              ],
                            ),
                          ),
                        ),

                        SliverPersistentHeader(
                          pinned: true,
                          delegate: _SliverAppBarDelegate(
                            height: 75,
                            child: Container(
                              color: Colors.white,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 12,
                              ),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: const Color(0xFFF1F5F9),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: TabBar(
                                  controller: _tabController,
                                  onTap: (index) => setState(
                                    () {},
                                  ),
                                  indicatorSize: TabBarIndicatorSize.tab,
                                  dividerColor: Colors.transparent,
                                  indicator: BoxDecoration(
                                    color: darkBlue,
                                    borderRadius: BorderRadius.circular(18),
                                  ),
                                  labelColor: Colors.white,
                                  unselectedLabelColor: const Color(0xFF64748B),
                                  labelStyle: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                  tabs: const [
                                    Tab(text: "Overview"),
                                    Tab(text: "Products"),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ];
                    },
                    body: TabBarView(
                      controller: _tabController,
                      children: [
                        _buildOverviewContent(),
                        _buildProductsContent(),
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),

    );
  }

  Future<void> _launchURL(String urlString) async {
    final Uri url = Uri.parse(urlString);

    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      throw Exception('Could not launch $url');
    }
  }

  void _showCustomShareSheet(BuildContext context, String url) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text("Share via", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _shareIcon(CupertinoIcons.phone, "WhatsApp", Colors.green, () {
                    Share.share(url);
                    Navigator.pop(context);
                  }),
                  _shareIcon(Icons.camera_alt_outlined, "Instagram", Colors.pink, () {
                    Share.share(url);
                    Navigator.pop(context);
                  }),
                  _shareIcon(Icons.facebook, "Facebook", Colors.blue, () {
                    Share.share(url);
                    Navigator.pop(context);
                  }),
                ],
              ),
            ],
          ),
        );
      },
    );
  }


  Widget _shareIcon(IconData icon, String label, Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          CircleAvatar(backgroundColor: color, child: Icon(icon, color: Colors.white)),
          const SizedBox(height: 5),
          Text(label, style: const TextStyle(fontSize: 12)),
        ],
      ),
    );
  }

  Widget _buildViewAllButton() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
      child: const Row(
        children: [
          Icon(Icons.photo_library_outlined, size: 14, color: darkBlue),
          SizedBox(width: 5),
          Text(
            "View all",
            style: TextStyle(
              color: darkBlue,
              fontSize: 10,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _circleNavButton(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: () {
        if (!mounted) return;
        onTap();
      },
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.5),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: Colors.black, size: 30),
      ),
    );
  }

  Widget _buildOverviewContent() {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: const Duration(milliseconds: 800),
      curve: Curves.easeOutQuart,
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(0, 50 * (1 - value)),
            child: child,
          ),
        );
      },
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildInfoRow(),
            if(myDealsList.isNotEmpty)
            const SizedBox(height: 35),
            if(myDealsList.isNotEmpty)
            _sectionHeader("Exclusive Deals"),
            const SizedBox(height: 15),
            if(myDealsList.isNotEmpty)
            _buildMyDealsList(myDealsList),
            if(amenities.isNotEmpty)
            const SizedBox(height: 40),
            if(amenities.isNotEmpty)
            _sectionHeader("Amenities"),
            const SizedBox(height: 15),
            if(amenities.isNotEmpty)
            _buildAmenitiesGrid(),
            const SizedBox(height: 40),
            if(vendor != null)
            _sectionHeader("Business Owner"),
            const SizedBox(height: 15),
            _buildVendorCard(),

            const SizedBox(height: 40),
            _sectionHeader("About Business"),
            const SizedBox(height: 12),
            Text(
              "${listDetail?.description}",
              style: TextStyle(
                color: Colors.grey[600],
                height: 1.6,
                fontSize: 15,
              ),
            ),
            if(listDetail?.address != "" && listDetail?.address != null)
            const SizedBox(height: 40),
            if(listDetail?.address != "" && listDetail?.address != null)
            _sectionHeader("Location"),
            if(listDetail?.address != "" && listDetail?.address != null)
            const SizedBox(height: 12),
            if(listDetail?.address != "" && listDetail?.address != null)
            _buildDetailCard(
              Icons.location_on_rounded,
              "${listDetail?.address}",
            ),
            const SizedBox(height: 12),
            _sectionHeader("Similar Listing"),
            similarListData(similarList),
            const SizedBox(height: 12),
            review(context),
            const SizedBox(height: 120),
          ],
        ),
      ),
    );
  }

  Widget similarListData(List<SimilarListing> items) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        return GestureDetector(
          onTap: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => AllListingDetailScreen(listId: items[index].id,),
              ),
            );
          },
          child: Card(
            color: Colors.white,
            margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            elevation: 2,
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      item.image ?? '',
                      width: 80,
                      height: 80,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(
                        width: 80,
                        height: 80,
                        color: Colors.white,
                        child: const Icon(Icons.image_not_supported),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),

                  // 2. Text Content (Title & Address)
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.listingTitle ?? 'No Title',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            const Icon(Icons.location_on, size: 14, color: Colors.grey),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                item.address ?? 'No Address',
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.grey[600],
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildAmenitiesGrid() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisSpacing: 15,
        crossAxisSpacing: 15,
        childAspectRatio: 1,
      ),
      itemCount: amenities.length,
      itemBuilder: (context, index) {
        final name = amenities[index].name ?? "";

        return Container(
          decoration: BoxDecoration(
            color: const Color(0xFFF8FAFC),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: const Color(0xFFF1F5F9)),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset("assets/amenities.svg", height: 50, width: 50),

              const SizedBox(height: 8),

              SizedBox(
                height: 16,
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final textPainter = TextPainter(
                      text: TextSpan(
                        text: name,
                        style: const TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF64748B),
                        ),
                      ),
                      maxLines: 1,
                      textDirection: TextDirection.ltr,
                    )..layout(maxWidth: constraints.maxWidth);
                    if (textPainter.didExceedMaxLines) {
                      return Marquee(
                        text: name,
                        style: const TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF64748B),
                        ),
                        scrollAxis: Axis.horizontal,
                        blankSpace: 20,
                        velocity: 25,
                        pauseAfterRound: const Duration(seconds: 1),
                        startPadding: 5,
                        accelerationDuration: const Duration(milliseconds: 500),
                        decelerationDuration: const Duration(milliseconds: 500),
                      );
                    }
                    return Text(
                      name,
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF64748B),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildMyDealsList(List<Lisitngdeals> dealsList) {

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,

      children: [

        SizedBox(
          height: 220,
          child: ListView.builder(
            itemCount: dealsList.length,
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.only(left: 20, right: 10),
            itemBuilder: (context, index) {

              return _buildModernDealCard(dealsList[index]);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildModernDealCard(Lisitngdeals dealData) {
    String title = dealData.dealName ?? "Special Offer";
    String desc = dealData.dealDesc ?? "No description available";
    String startDate = dealData.startDate ?? "";
    String endDate = dealData.endDate ?? "";

    print("title :- $title");

    return Container(
      width: 310,
      margin: const EdgeInsets.only(right: 15, bottom: 10, top: 5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        gradient: const LinearGradient(
          colors: [Color(0xFF0D1B1E), Color(0xFF1C2D31)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0D1B1E).withOpacity(0.12),
            blurRadius: 12,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            right: -10,
            top: -10,
            child: CircleAvatar(
              radius: 45,
              backgroundColor: Colors.white.withOpacity(0.04),
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(22),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFF6C63FF).withOpacity(0.2),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: const Color(0xFF6C63FF).withOpacity(0.3),
                        ),
                      ),
                      child: Text(
                        "ACTIVE",
                        style: GoogleFonts.montserrat(
                          color: const Color(0xFF8B84FF),
                          fontSize: 9,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 1,
                        ),
                      ),
                    ),
                    Text(
                      "Until: $endDate",
                      style: GoogleFonts.montserrat(
                        color: Colors.white60,
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),

                const Spacer(),

                Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.montserrat(
                    fontSize: 22,
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                    letterSpacing: -0.5,
                  ),
                ),

                const SizedBox(height: 6),

                Text(
                  desc,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.montserrat(
                    color: Colors.white.withOpacity(0.7),
                    fontSize: 12,
                    height: 1.4,
                    fontWeight: FontWeight.w500,
                  ),
                ),

                const Spacer(),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Started On",
                          style: TextStyle(color: Colors.white38, fontSize: 9),
                        ),
                        Text(
                          startDate,
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    GestureDetector(
                      onTap: () {
                        _callCrackDeal(dealId:dealData.id.toString() );
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 10,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(14),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.white.withOpacity(0.2),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Text(
                          "REDEEM",
                          style: GoogleFonts.montserrat(
                            color: const Color(0xFF0D1B1E),
                            fontSize: 10,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVendorCard() {
    String ownerPhone = "${vendor?.phone}";
    String ownerEmail = "${vendor?.email==null ? "" : vendor?.email}";

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(26),
        border: Border.all(color: const Color(0xFFF1F5F9)),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 15),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 28,
                backgroundColor: darkBlue.withOpacity(0.08),
                child: const Icon(Icons.person, color: darkBlue),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "${vendor?.name ?? listDetail?.listingTitle}",
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 17,
                      ),
                    ),
                    const Text(
                      "Founder & Owner",
                      style: TextStyle(color: Colors.grey, fontSize: 13),
                    ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () => _launchPhone(ownerPhone),
                child: _circleAction(Icons.call, Colors.green),
              ),
              const SizedBox(width: 10),
              GestureDetector(
                onTap: () => _launchEmail(ownerEmail),
                child: _circleAction(Icons.mail_rounded, Colors.blue),
              ),
            ],
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 12),
            child: Divider(color: Color(0xFFF1F5F9), thickness: 1),
          ),
          Row(
            children: [
              Icon(
                Icons.alternate_email_rounded,
                size: 16,
                color: darkBlue.withOpacity(0.4),
              ),
              const SizedBox(width: 10),
              if(ownerEmail != "")
              Text(
                ownerEmail,
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildProductsContent() {
    return Column(
      children: [
        _buildModernSearchBar(),

        Expanded(
          child: NotificationListener<ScrollNotification>(
            onNotification: (ScrollNotification scrollInfo) {
              if (!isLoadMore &&
                  scrollInfo.metrics.pixels >=
                      scrollInfo.metrics.maxScrollExtent &&
                  scrollInfo.metrics.pixels > 0 &&
                  products.length >= 10 &&
                  products.length % 10 == 0) {
                _callSubCategoryProductList(isPagination: true);
              }
              return false;
            },
            child: ValueListenableBuilder(
              valueListenable: isProductApiComplete,
              builder: (context, completed, _) {
                if (!completed && !isSearching && products.isEmpty) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (products.isEmpty) {
                  return const Center(child: Text("No products found"));
                }

                return GridView.builder(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.fromLTRB(18, 10, 18, 100),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.64,
                    crossAxisSpacing: 15,
                    mainAxisSpacing: 15,
                  ),
                  itemCount: products.length,
                  itemBuilder: (context, index) =>
                      _buildProductCard(products[index]),
                );
              },
            ),
          ),
        ),

        if (isLoadMore && products.isNotEmpty)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 10),
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
      ],
    );
  }

  Widget _buildProductCard(SubCategoryProductList product) {
    final String name = (product.name ?? "").trim().isEmpty
        ? "No Name"
        : product.name!;
    final String slug = (product.slug ?? "").trim().isEmpty
        ? "-"
        : product.slug!;
    final String imageUrl = product.thumbnail ?? "";

    final double price = (product.unitPrice ?? 0).toDouble();
    final double finalPrice = (product.discountedPrice ?? price).toDouble();

    final double discount = double.tryParse(product.discount?.toString() ?? "0") ?? 0;

    return GestureDetector(
      onTap: () {
        Get.to(() => ProductDetailScreen(
          productId: product.id.toString(),
          listId: widget.listId!,
        ));
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 15,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: Column(
            children: [
              Expanded(
                flex: 11,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    imageUrl.isNotEmpty
                        ? Image.network(
                      imageUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) =>
                          Container(
                            color: Colors.grey[100],
                            child: const Icon(Icons.broken_image),
                          ),
                    )
                        : Container(
                      color: Colors.grey[100],
                      child: const Icon(Icons.image),
                    ),

                    if (discount > 0)
                      Positioned(
                        top: 10,
                        right: 10,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.redAccent,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            "${discount % 1 == 0 ? discount.toInt() : discount.toStringAsFixed(1)}% OFF",
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              Expanded(
                flex: 9,
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 14,
                          color: Color(0xFF1E293B),
                          height: 1.2,
                        ),
                      ),
                      const SizedBox(height: 4),

                      Text(
                        slug,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(color: Colors.grey[400], fontSize: 10),
                      ),

                      const Spacer(),

                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                if (discount > 0)
                                  Text(
                                    "₹${price.toStringAsFixed(2)}",
                                    style: TextStyle(
                                      decoration: TextDecoration.lineThrough,
                                      color: Colors.grey[400],
                                      fontSize: 11,
                                    ),
                                  ),
                                Text(
                                  "₹${finalPrice.toStringAsFixed(2)}",
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w900,
                                    fontSize: 18,
                                    color: Color(0xFF0F172A),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          _buildAddButton(
                            onTap: () {
                              if (AppPrefs.userId != "") {
                                callAddCart(
                                    name: product.name,
                                    price: product.unitPrice,
                                    productid: product.id,
                                    qty: 1);
                              } else {
                                SharedWidgets.showTopSnackBar(context,
                                    message: "Please Login First");
                              }
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildModernSearchBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(18, 15, 18, 10),
      child: Container(
        height: 52,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: TextField(
          controller: searchController,
          onChanged: (val) {
            setState(() {
              isSearching = true;
              if (val.isEmpty) {
                products.clear();
                currentCounter = 0;
              }
            });

            if (_debouncer?.isActive ?? false) _debouncer!.cancel();
            _debouncer = Timer(const Duration(milliseconds: 500), () {
              _callSubCategoryProductList();
            });
          },
          decoration: InputDecoration(
            hintText: "Search products...",
            prefixIcon: isSearching
                ? const Padding(
                    padding: EdgeInsets.all(14),
                    child: SizedBox(
                      height: 10,
                      width: 10,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                  )
                : const Icon(Icons.search_rounded),
            suffixIcon: searchController.text.isNotEmpty
                ? IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () {
                      searchController.clear();
                      _callSubCategoryProductList();
                    },
                  )
                : const Icon(Icons.tune_rounded),
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(vertical: 15),
          ),
        ),
      ),
    );
  }

  void _showEnquiryModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Enquiry",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w900,
                      color: darkBlue,
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: Icon(
                      Icons.cancel_rounded,
                      color: darkBlue.withOpacity(0.5),
                    ),
                  ),
                ],
              ),
            ),
            const Divider(height: 1),
            Flexible(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildTextField("First Name", "Enter First Name",_fNameController),
                    _buildTextField("Last Name", "Enter Last Name",_lNameController),
                    _buildTextField("Email", "Enter Email",_emailController),
                    _buildTextField("Phone Number", "Enter Phone Number",_numberController),
                    _buildTextField(
                      "Write us a Message",
                      "Enter Enquiry Now",
                      _messageController,
                      maxLines: 3,
                    ),
                    const SizedBox(height: 20),
                    Align(
                      alignment: Alignment.centerRight,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                          if(_fNameController.text != "" && _numberController.text != "" && _emailController.text != ""){
                            callAddEnquiry();
                          }else{
                            SharedWidgets.showTopSnackBar(context, message: "Please fill Field");
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: darkBlue,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 25,
                            vertical: 15,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              "Enquiry",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(width: 8),
                            Icon(
                              Icons.arrow_circle_right_outlined,
                              color: Colors.white,
                              size: 18,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  Widget _buildTextField(String label, String hint,TextEditingController controller, {int maxLines = 1}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: darkBlue.withOpacity(0.8),
            ),
          ),
          const SizedBox(height: 8),
          TextField(
            maxLines: maxLines,
            controller:controller,
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: TextStyle(color: Colors.grey[400], fontSize: 13),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 15,
                vertical: 12,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: Colors.grey[300]!),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: darkBlue, width: 1.5),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPremiumSearchBar() {
    return Container(
      height: 48,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 10),
        ],
      ),
      child: TextField(
        controller: _searchController,
        autofocus: true,
        style: const TextStyle(
          color: darkBlue,
          fontSize: 15,
          fontWeight: FontWeight.w600,
        ),
        decoration: InputDecoration(
          hintText: "Search dishes...",
          hintStyle: TextStyle(color: darkBlue.withOpacity(0.4), fontSize: 14),
          prefixIcon: const Icon(
            Icons.search_rounded,
            color: darkBlue,
            size: 22,
          ),
          suffixIcon: IconButton(
            icon: const Icon(Icons.close_rounded, color: darkBlue),
            onPressed: () => setState(() => _isSearching = false),
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 12),
        ),
      ),
    );
  }

  Widget _buildInfoRow() {
    return Row(
      children: [
        if(listDetail?.rating != "" && listDetail?.rating != null && listDetail?.rating != "0.0")
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: _buildMiniStat(
            Icons.star_rounded,
            "${listDetail?.rating ?? 0}",
            "Rating",
            Colors.orange,
          ),
        ),
        if(listDetail?.openClose != "" && listDetail?.openClose != null)
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: _buildMiniStat(
            Icons.access_time_filled_rounded,
            "Open",
            "${listDetail?.openClose ?? 0}",
            Colors.blue,
          ),
        )
      ],
    );
  }

  Widget _buildMiniStat(IconData icon, String title, String sub, Color color) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.28,
      padding: const EdgeInsets.symmetric(vertical: 18),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(22),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 22),
          const SizedBox(height: 8),
          Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
          ),
          Text(sub, style: const TextStyle(color: Colors.grey, fontSize: 11)),
        ],
      ),
    );
  }

  Widget _buildDetailCard(IconData icon, String text) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(22),
      ),
      child: Row(
        children: [
          Icon(icon, size: 20, color: darkBlue),
          const SizedBox(width: 15),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAddButton({required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        height: 32,
        width: 65,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: primaryColor.withOpacity(0.3)),
        ),
        child: const Center(
          child: Text(
            "ADD",
            style: TextStyle(
              color: primaryColor,
              fontWeight: FontWeight.w900,
              fontSize: 11,
            ),
          ),
        ),
      ),
    );
  }

  Widget _circleAction(IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        shape: BoxShape.circle,
      ),
      child: Icon(icon, color: color, size: 20),
    );
  }

  Widget _buildHeaderButton(IconData icon, VoidCallback onTap) {
    return Container(
      margin: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.4),
        shape: BoxShape.circle,
      ),
      child: IconButton(
        icon: Icon(icon, color: Colors.white, size: 16),
        onPressed: onTap,
      ),
    );
  }

  Widget _buildCategoryBadge(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: primaryColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildMarqueeTitle(String text) {
    return SingleChildScrollView(
      controller: _marqueeController,
      scrollDirection: Axis.horizontal,
      physics: const NeverScrollableScrollPhysics(),
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 15,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _sectionHeader(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w900,
        color: darkBlue,
        letterSpacing: -0.5,
      ),
    );
  }

  Widget review(BuildContext context) {

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Reviews & Ratings",
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: const Color(0xFF1B2E3F),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.star_rounded, color: Colors.orange, size: 20),
                      const SizedBox(width: 5),
                      if(allReview != "" && allReview != null)
                      Text(
                        "$allReview",
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 13,
                          color: Colors.grey[600],
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              GestureDetector(
                onTap: () => _showAddReviewSheet(context),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1B2E3F),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    "+ Add Review",
                    style: GoogleFonts.plusJakartaSans(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),

        ListView.builder(
          itemCount: reviewData.length,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 16),
          itemBuilder: (context, index) {

            final item = reviewData[index];
            String originalDate = item.createdAt ?? "";


            String formattedDate = "";
            if (originalDate.isNotEmpty) {
              List<String> parts = originalDate.split("T")[0].split("-");
              if (parts.length == 3) {
                formattedDate = "${parts[2]}-${parts[1]}-${parts[0].substring(2)}";
              }
            }
            double rating = double.parse(item.rating.toString());

            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.grey.withOpacity(0.3)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: List.generate(5, (starIndex) {
                          return Icon(
                            starIndex < rating ? Icons.star_rounded : Icons.star_outline_rounded,
                            color: Colors.orange,
                            size: 16,
                          );
                        }),
                      ),
                      Text(
                        formattedDate,
                        style: GoogleFonts.plusJakartaSans(fontSize: 10, color: Colors.grey),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    item.title!,
                    style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.bold, fontSize: 14),
                  ),
                  Text(
                    item.review!,
                    style: GoogleFonts.plusJakartaSans(fontSize: 13, color: Colors.grey[600]),
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }

  void _showAddReviewSheet(BuildContext context) {
    _currentRating = 0;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => StatefulBuilder(
          builder: (context, setSheetState) {
            return Container(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom + 20,
                top: 20, left: 20, right: 20,
              ),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(child: Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(10)))),
                  const SizedBox(height: 20),
                  Text("Rate your experience", style: GoogleFonts.plusJakartaSans(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 15),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: List.generate(5, (index) {
                      num starValue = index + 1;
                      IconData icon;

                      if (_currentRating >= starValue) {
                        icon = Icons.star_rounded;
                      } else if (_currentRating >= starValue - 0.5) {
                        icon = Icons.star_half_rounded;
                      } else {
                        icon = Icons.star_outline_rounded;
                      }

                      return GestureDetector(
                        onTapDown: (details) {

                          double tapPos = details.localPosition.dx;
                          setSheetState(() {
                            if (tapPos < 17) {
                              _currentRating = starValue - 0.5;
                            } else {
                              _currentRating = starValue.toDouble();
                            }
                          });
                        },
                        child: Icon(
                          icon,
                          color: Colors.orange,
                          size: 40,
                        ),
                      );
                    }),
                  ),

                  if(_currentRating > 0)
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text("Rating: $_currentRating", style: TextStyle(color: Colors.orange, fontWeight: FontWeight.bold)),
                    ),

                  const SizedBox(height: 20),
                  _buildTextFieldReview("Review Title (e.g. Good Service)",_reviewTitle),
                  const SizedBox(height: 12),
                  _buildTextFieldReview("Write your review here...",_review, maxLines: 3),
                  const SizedBox(height: 25),

                  SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: ElevatedButton(
                      onPressed: () {
                        callAddReview();
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1B2E3F),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                      ),
                      child: Text("Submit Review", style: GoogleFonts.plusJakartaSans(color: Colors.white, fontWeight: FontWeight.bold)),
                    ),
                  ),
                ],
              ),
            );
          }
      ),
    );
  }

  Widget _buildTextFieldReview(String hint,TextEditingController controller, {int maxLines = 1}) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: GoogleFonts.plusJakartaSans(fontSize: 14, color: Colors.grey),
        filled: true,
        fillColor: Colors.grey[100],
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
      ),
    );
  }

  Future<void> callSubCategoryListDetails() async {
    isDataAvailable.value = false;
    isApiComplete.value = false;
    _callSubCategoryListDetails();
  }

  Future<void> _callSubCategoryListDetails() async {
    try {
      bool internet = await MyApplication.checkInternet();

      if (!internet) {
        isDataAvailable.value = false;
        isApiComplete.value = true;
        return;
      }

      ResponseSubcategoryListDetails? response =
          await ApiCalls.callSubCategoryListDetails(
            RequestSubCategoryListDetails(
              listId: widget.listId ?? 0,
              userID: AppPrefs.userId=="" ? 0 :  int.parse(AppPrefs.userId),
            ),
          );

      if (response != null &&
          response.result != null &&
          response.result!.isNotEmpty &&
          response.result!.toLowerCase().contains("pass") &&
          response.data != null) {
        _bannerImages.clear();
        myDealsList.clear();
        amenities.clear();
        isFav = response.data!.listDetail!.isFavourite!;
        listDetail = response.data!.listDetail;
        vendor = response.data!.listDetail!.vendor;
        myDealsList.addAll(response.data!.lisitngdeals!);
        _bannerImages.addAll(response.data!.detailImages!);
        amenities.addAll(response.data!.amenities!);

        isDataAvailable.value = true;
      } else {
        _bannerImages.clear();
        myDealsList.clear();
        amenities.clear();

        isDataAvailable.value = false;
      }
    } catch (e) {
      log("listing detail: $e");

      _bannerImages.clear();
      myDealsList.clear();
      amenities.clear();
      isDataAvailable.value = false;
    } finally {
      isApiComplete.value = true;
      if (mounted) {
        setState(() {});
      }
    }
  }

  void _stopLoaders() {
    isProductApiComplete.value = true;
    isLoadMore = false;
    isSearching = false;
    if (mounted) setState(() {});
  }

  Future<void> _callSubCategoryProductList({bool isPagination = false}) async {
    try {
      if (!isPagination) {
        currentCounter = 0;
        if (!isSearching) isProductApiComplete.value = false;
      } else {
        setState(() => isLoadMore = true);
      }

      bool internet = await MyApplication.checkInternet();
      if (!internet) {
        _stopLoaders();
        return;
      }

      var response = await ApiCalls.callSubCategoryProductList(
        RequestSubCategoryProductList(
          listingId: widget.listId ?? 0,
          counter: currentCounter,
          search: searchController.text.trim(),
        ),
      );

      if (response != null &&
          response.data != null &&
          response.data!.isNotEmpty) {
        if (isPagination) {
          products.addAll(response.data!);
        } else {
          products.clear();
          products.addAll(response.data!);
        }
        isProductDataAvailable.value = true;
        currentCounter += 10;
      } else {
        if (!isPagination) {
          products.clear();
          isProductDataAvailable.value = false;
        }
      }
    } catch (e) {
      log("API Error: $e");
    } finally {
      _stopLoaders();
    }
  }


  Future<void> callAddCart({int? productid, int? price, int? qty, String? name}) async {
    MyApplication.checkInternet().then((internet) async {
        if(internet){
          try{
            ResponseAddCart? response= await ApiCalls.callAddCart(RequestAddCart(
              userId: AppPrefs.userId,
              listingId: widget.listId ?? 0,
              productId: productid,
              productName: name,
              productPrice: price,
              quantity: qty
            ));
            if(response != null){
              if(response.result!.isNotEmpty && response.result != null &&
              response.result!.toLowerCase().contains("pass")){
                SharedWidgets.showTopSnackBar(context, message: response.message!);
              }
            }
          }on Exception catch(e){
            log("$e");
          }catch(e){
            log("$e");
          }finally{

          }
        }else{
          SharedWidgets.showTopSnackBar(context, message: "No Internet Available");
        }
    },);
  }


  Future<void> callAddEnquiry() async {
    MyApplication.checkInternet().then((internet) async {
      if(internet){
        try{
          ResponseAddEnquiry? response= await ApiCalls.callAddEnquiry(RequestAddEnquiry(
              listingId: widget.listId,
              userId: AppPrefs.userId ?? "",
              email: _emailController.text,
              phone: _numberController.text,
              enquiry: _messageController.text,
              fName: _fNameController.text,
              lName:_lNameController.text,
          ));
          if(response != null){
            if(response.result!.isNotEmpty && response.result != null &&
                response.result!.toLowerCase().contains("pass")){
              SharedWidgets.showTopSnackBar(context, message: response.message!);
            }
          }
        }on Exception catch(e){
          log("$e");
        }catch(e){
          log("$e");
        }finally{

        }
      }else{
        SharedWidgets.showTopSnackBar(context, message: "No Internet Available");
      }
    },);
  }


  Future<void> callAddFav() async {
    MyApplication.checkInternet().then((internet) async {
      if(internet){
        try{
          ResponseAddFav? response= await ApiCalls.callAddFav(RequestAddFav(
            listingId: widget.listId.toString(),
            userId: AppPrefs.userId=="" ? 0 : int.parse(AppPrefs.userId)
          ));
          if(response != null){
            if(response.result!.isNotEmpty && response.result != null &&
                response.result!.toLowerCase().contains("pass")){
              SharedWidgets.showTopSnackBar(context, message: response.message!);
              callSubCategoryListDetails();
            }
          }
        }on Exception catch(e){
          log("$e");
        }catch(e){
          log("$e");
        }finally{

        }
      }else{
        SharedWidgets.showTopSnackBar(context, message: "No Internet Available");
      }
    },);
  }


  Future<void> callReview() async {
    MyApplication.checkInternet().then((internet) async {
      if(internet){
        try{
          ResponseReview? response= await ApiCalls.callReview(RequestReview(
              listingId: widget.listId.toString(),
          ));
          if(response != null){
            if(response.result!.isNotEmpty && response.result != null &&
                response.result!.toLowerCase().contains("pass")){
                reviewData.addAll(response.data!);
                allReview = response.averageRating!;
                setState(() {});
            }
          }
        }on Exception catch(e){
          log("$e");
        }catch(e){
          log("$e"); 
        }finally{

        }
      }else{
        SharedWidgets.showTopSnackBar(context, message: "No Internet Available");
      }
    },);
  }

  Future<void> callAddReview() async {
    MyApplication.checkInternet().then((internet) async {
      if(internet){
        try{
          ResponseAddReview? response= await ApiCalls.callAddReview(RequestAddReview(
              listingId: widget.listId.toString(),
              userId:AppPrefs.userId,
              rating: _currentRating.toString(),
              review: _review.text,
              title: _reviewTitle.text,
          ));
          if(response != null){
            if(response.result!.isNotEmpty && response.result != null &&
                response.result!.toLowerCase().contains("pass")){
              SharedWidgets.showTopSnackBar(context, message: response.message!);
              callSubCategoryListDetails();
            }
          }
        }on Exception catch(e){
          log("$e");
        }catch(e){
          log("$e");
        }finally{

        }
      }else{
        SharedWidgets.showTopSnackBar(context, message: "No Internet Available");
      }
    },);
  }


  Future<void> callShare() async {
    MyApplication.checkInternet().then((internet) async {
      if(internet){
        try{
          ResponseShare? response= await ApiCalls.callShare(RequestShare(
            listId: widget.listId.toString(),
          ));
          if(response != null){
            if(response.result!.isNotEmpty && response.result != null &&
                response.result!.toLowerCase().contains("pass")){
              shareUrl=response.data?.webUrl!;
              setState(() {});
            }
          }
        }on Exception catch(e){
          log("$e");
        }catch(e){
          log("$e");
        }finally{

        }
      }else{
        SharedWidgets.showTopSnackBar(context, message: "No Internet Available");
      }
    },);
  }

  Future<void> _callCrackDeal({String? dealId=""}) async {
    try {
      bool internet = await MyApplication.checkInternet();
      if(internet)
      {
        ResponseCrackDeal? response = await ApiCalls.callCrackDeal(RequestCrackDeal(
            userId: AppPrefs.userId,
            dealId: dealId
        ));
        if (response != null &&
            response.result != null &&
            response.result!.isNotEmpty &&
            response.result!.toLowerCase().contains("pass")) {
          Get.to(()=> const UserDealsScreen());
          SharedWidgets.showTopSnackBar(context, message: response.message!);
        } else {
          SharedWidgets.showTopSnackBar(context, message: response!.message!);
        }
      }

    } catch (e) {
      log("HomeBanner Error: $e");
    } finally {
      if (mounted) {
        setState(() {});
      }
    }
  }


  Future<void> _callSimilarListing() async {
    try {
      bool internet = await MyApplication.checkInternet();
      if(internet)
      {
        ResponseSimilarListing? response = await ApiCalls.callSimilarListing(RequestSimilarListing(
             userId: AppPrefs.userId=="" ? 0 :int.parse(AppPrefs.userId),
             listId: widget.listId
        ));
        if (response != null &&
            response.result != null &&
            response.result!.isNotEmpty &&
            response.result!.toLowerCase().contains("pass")) {
            similarList.addAll(response.data!);
            setState(() {});
        } else {
          SharedWidgets.showTopSnackBar(context, message: response!.message!);
        }
      }

    } catch (e) {
      log("HomeBanner Error: $e");
    } finally {
      if (mounted) {
        setState(() {});
      }
    }
  }



}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  final Widget child;
  final double height;
  _SliverAppBarDelegate({required this.child, required this.height});
  @override
  double get minExtent => height;
  @override
  double get maxExtent => height;
  @override
  Widget build(context, offset, overlaps) => SizedBox.expand(child: child);
  @override
  bool shouldRebuild(old) => true;
}
