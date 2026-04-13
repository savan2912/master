import 'dart:ui';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:url_launcher/url_launcher.dart';
import '../cart/CartScreen.dart';

// --- GLOBAL COLORS ---
const Color primaryColor = Color(0xFFF012BE);
const Color darkBlue = Color(0xFF1B2E3F);

class AllListingDetailScreen extends StatefulWidget {
  const AllListingDetailScreen({super.key});

  @override
  State<AllListingDetailScreen> createState() => _AllListingDetailScreenState();
}

class _AllListingDetailScreenState extends State<AllListingDetailScreen> with SingleTickerProviderStateMixin {
  late ScrollController _scrollController;
  late ScrollController _marqueeController;
  late TabController _tabController;
  late PageController _pageController;
  Timer? _marqueeTimer;

  bool _isSearching = false;
  int _selectedDealIndex = 0;
  int _currentImageIndex = 0;
  final TextEditingController _searchController = TextEditingController();

  final List<String> _bannerImages = [
    'https://images.unsplash.com/photo-1554118811-1e0d58224f24?q=80&w=1000',
    'https://images.unsplash.com/photo-1517248135467-4c7edcad34c4?q=80&w=1000',
    'https://images.unsplash.com/photo-1559339352-11d035aa65de?q=80&w=1000',
    'https://images.unsplash.com/photo-1473093226795-af9932fe5856?q=80&w=1000',
  ];

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _marqueeController = ScrollController();
    _pageController = PageController();
    _tabController = TabController(length: 2, vsync: this);

    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) {
        setState(() {
          _isSearching = false;
          _searchController.clear();
        });
      }
    });

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
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showEnquiryModal(context),
        backgroundColor: primaryColor,
        elevation: 8,
        child: const Icon(Icons.chat_bubble_outline_rounded, color: Colors.white, size: 24),
      ),
      body: NestedScrollView(
        controller: _scrollController,
        physics: const BouncingScrollPhysics(),
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            // 1. Main Banner Image Section
            SliverAppBar(
              expandedHeight: 280,
              pinned: true,
              stretch: true,
              backgroundColor: darkBlue,
              leadingWidth: _isSearching ? 20 : 60,
              leading: _isSearching
                  ? const SizedBox.shrink()
                  : _buildHeaderButton(Icons.arrow_back_ios_new, () => Navigator.pop(context)),
              centerTitle: true,
              title: _isSearching
                  ? _buildPremiumSearchBar()
                  : ListenableBuilder(
                listenable: _scrollController,
                builder: (context, child) {
                  double offset = _scrollController.hasClients ? _scrollController.offset : 0;
                  double opacity = (offset / 180).clamp(0.0, 1.0);
                  return Opacity(
                    opacity: opacity,
                    child: _buildMarqueeTitle("Gotilo Cafe One Premium Lounge & Restro Rajkot"),
                  );
                },
              ),
              actions: [
                if (!_isSearching) ...[
                  if (_tabController.index == 1) ...[
                    _buildHeaderButton(Icons.search, () {
                      setState(() => _isSearching = true);
                    }),
                    _buildHeaderButton(Icons.add_shopping_cart, () {
                      Get.to(()=>const CartScreen());
                    }),
                  ] else ...[
                    _buildHeaderButton(Icons.share_outlined, () {}),
                    _buildHeaderButton(Icons.favorite_border, () {}),
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
                      onPageChanged: (index) => setState(() => _currentImageIndex = index),
                      itemBuilder: (context, index) {
                        return Image.network(_bannerImages[index], fit: BoxFit.cover);
                      },
                    ),

                    const DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [Colors.black45, Colors.transparent, Colors.black54],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            SliverToBoxAdapter(
              child: Container(
                color: Colors.white,
                padding: const EdgeInsets.only(top: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildCategoryBadge("PREMIUM CAFE"),
                              const SizedBox(height: 8),
                              const Text(
                                "Gotilo Cafe One",
                                style: TextStyle(color: darkBlue, fontSize: 26, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          _buildViewAllButton(),
                        ],
                      ),
                    ),
                    const SizedBox(height: 15),
                    SizedBox(
                      height: 65,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        itemCount: _bannerImages.length,
                        itemBuilder: (context, index) {
                          bool isSelected = _currentImageIndex == index;
                          return GestureDetector(
                            onTap: () {
                              if (mounted) {
                                _pageController.animateToPage(index,
                                    duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
                              }
                            },
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              width: 65,
                              margin: const EdgeInsets.only(right: 12),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                    color: isSelected ? primaryColor : Colors.grey.shade300,
                                    width: 2),
                                image: DecorationImage(
                                    image: NetworkImage(_bannerImages[index]),
                                    fit: BoxFit.cover),
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

            // 3. TabBar (Overview / Products)
            SliverPersistentHeader(
              pinned: true,
              delegate: _SliverAppBarDelegate(
                height: 75,
                child: Container(
                  color: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  child: Container(
                    decoration: BoxDecoration(color: const Color(0xFFF1F5F9), borderRadius: BorderRadius.circular(20)),
                    child: TabBar(
                      controller: _tabController,
                      onTap: (index) => setState(() {}), // Refresh logic on tab tap
                      indicatorSize: TabBarIndicatorSize.tab,
                      dividerColor: Colors.transparent,
                      indicator: BoxDecoration(color: darkBlue, borderRadius: BorderRadius.circular(18)),
                      labelColor: Colors.white,
                      unselectedLabelColor: const Color(0xFF64748B),
                      labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                      tabs: const [Tab(text: "Overview"), Tab(text: "Products")],
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
      bottomNavigationBar: _buildActionBottomBar(),
    );
  }




  Widget _buildViewAllButton() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(8)
      ),
      child: const Row(
        children: [
          Icon(Icons.photo_library_outlined, size: 14, color: darkBlue),
          SizedBox(width: 5),
          Text("View all", style: TextStyle(color: darkBlue, fontSize: 10, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
  Widget _circleNavButton(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: () {
        // Check if the state is still in the tree
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

  // --- OVERVIEW SECTION WITH HIGHLIGHT ANIMATION ---
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
            const SizedBox(height: 35),

            // --- DEAL SECTION ---
            _sectionHeader("Exclusive Deals"),
            const SizedBox(height: 15),
            _buildDealSelection(),
            const SizedBox(height: 20),
            _buildActiveDealCard(), // Deal Data Card

            const SizedBox(height: 40),
            _sectionHeader("Amenities"),
            const SizedBox(height: 15),
            _buildAmenitiesGrid(),

            const SizedBox(height: 40),
            _sectionHeader("Business Owner"),
            const SizedBox(height: 15),
            _buildVendorCard(),

            const SizedBox(height: 40),
            _sectionHeader("About Business"),
            const SizedBox(height: 12),
            Text(
              "Welcome to Gotilo Cafe One. Premium snacks and coffee in Rajkot with a modern vibe. We serve the best arabica beans.",
              style: TextStyle(color: Colors.grey[600], height: 1.6, fontSize: 15),
            ),

            const SizedBox(height: 40),
            _sectionHeader("Location"),
            const SizedBox(height: 12),
            _buildDetailCard(Icons.location_on_rounded, "150 Feet Ring Road, Rajkot"),
            const SizedBox(height: 120),
          ],
        ),
      ),
    );
  }

  // --- AMENITIES GRID ---
  Widget _buildAmenitiesGrid() {
    final List<Map<String, dynamic>> amenities = [
      {'icon': Icons.wifi_rounded, 'label': 'Free Wi-Fi'},
      {'icon': Icons.ac_unit_rounded, 'label': 'AC Room'},
      {'icon': Icons.local_florist_outlined, 'label': 'Garden View'},
      {'icon': Icons.local_parking_rounded, 'label': 'Valet Parking'},
      {'icon': Icons.music_note_rounded, 'label': 'Live Music'},
      {'icon': Icons.power_rounded, 'label': 'Charging Port'},
    ];

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
        return Container(
          decoration: BoxDecoration(
            color: const Color(0xFFF8FAFC),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: const Color(0xFFF1F5F9)),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(amenities[index]['icon'], color: darkBlue, size: 28),
              const SizedBox(height: 8),
              Text(
                amenities[index]['label'],
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: Color(0xFF64748B)),
              ),
            ],
          ),
        );
      },
    );
  }

  // --- DEAL SELECTION & ACTIVE DEAL CARD ---
  Widget _buildDealSelection() {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: const Color(0xFFF1F5F9),
        borderRadius: BorderRadius.circular(22),
      ),
      child: Row(
        children: [
          _dealOption(0, "SINGLE DEAL", Icons.person_outline_rounded),
          _dealOption(1, "MULTIPLE DEAL", Icons.groups_3_outlined),
        ],
      ),
    );
  }

  Widget _dealOption(int index, String title, IconData icon) {
    bool isSelected = _selectedDealIndex == index;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _selectedDealIndex = index),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            color: isSelected ? darkBlue : Colors.transparent,
            borderRadius: BorderRadius.circular(18),
            boxShadow: isSelected ? [BoxShadow(color: darkBlue.withOpacity(0.3), blurRadius: 10, offset: const Offset(0, 5))] : [],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: isSelected ? Colors.white : const Color(0xFF64748B), size: 18),
              const SizedBox(width: 8),
              Text(
                title,
                style: TextStyle(
                  color: isSelected ? Colors.white : const Color(0xFF64748B),
                  fontWeight: FontWeight.w900,
                  fontSize: 11,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActiveDealCard() {
    bool isSingle = _selectedDealIndex == 0;
    String title = isSingle ? "Solo Coffee Break" : "Squad Goals Combo";
    String price = isSingle ? "₹199" : "₹799";
    String desc = isSingle
        ? "Get 1 Cappuccino + 1 Butter Cookie at flat price."
        : "3 Cold Brews + 2 Large Fries + 1 Garlic Bread.";
    String discount = isSingle ? "20% OFF" : "35% OFF";

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [darkBlue.withOpacity(0.05), Colors.white],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(25),
        border: Border.all(color: darkBlue.withOpacity(0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(color: Colors.redAccent, borderRadius: BorderRadius.circular(8)),
                child: Text(discount, style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
              ),
              const Text("Valid till: 30th April", style: TextStyle(color: Colors.grey, fontSize: 11)),
            ],
          ),
          const SizedBox(height: 15),
          Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: darkBlue)),
          const SizedBox(height: 8),
          Text(desc, style: TextStyle(color: Colors.grey[600], fontSize: 13, height: 1.4)),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Special Price", style: TextStyle(color: Colors.grey, fontSize: 11)),
                  Text(price, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: primaryColor)),
                ],
              ),
              ElevatedButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Deal Cracked Successfully! 🎉"), backgroundColor: Colors.green),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: darkBlue,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  elevation: 5,
                ),
                child: const Text("CRACK DEAL", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12)),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // --- VENDOR CARD ---
  Widget _buildVendorCard() {
    const String ownerPhone = "+919876543210";
    const String ownerEmail = "contact@gotilo.com";

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(26),
          border: Border.all(color: const Color(0xFFF1F5F9)),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 15)]
      ),
      child: Column(
        children: [
          Row(
            children: [
              CircleAvatar(radius: 28, backgroundColor: darkBlue.withOpacity(0.08), child: const Icon(Icons.person, color: darkBlue)),
              const SizedBox(width: 15),
              const Expanded(
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text("Ravi Patel", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17)),
                  Text("Founder & Owner", style: TextStyle(color: Colors.grey, fontSize: 13)),
                ]),
              ),
              GestureDetector(onTap: () => _launchPhone(ownerPhone), child: _circleAction(Icons.call, Colors.green)),
              const SizedBox(width: 10),
              GestureDetector(onTap: () => _launchEmail(ownerEmail), child: _circleAction(Icons.mail_rounded, Colors.blue)),
            ],
          ),
          const Padding(padding: EdgeInsets.symmetric(vertical: 12), child: Divider(color: Color(0xFFF1F5F9), thickness: 1)),
          Row(
            children: [
              Icon(Icons.alternate_email_rounded, size: 16, color: darkBlue.withOpacity(0.4)),
              const SizedBox(width: 10),
              Text(ownerEmail, style: TextStyle(color: Colors.grey[600], fontSize: 14, fontWeight: FontWeight.w500)),
            ],
          )
        ],
      ),
    );
  }

  // --- PRODUCTS CONTENT ---
  Widget _buildProductsContent() {
    return GridView.builder(
      padding: const EdgeInsets.fromLTRB(18, 15, 18, 120),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, childAspectRatio: 0.68, crossAxisSpacing: 18, mainAxisSpacing: 18),
      itemCount: 8,
      itemBuilder: (context, index) {
        return Container(
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(28), border: Border.all(color: const Color(0xFFF1F5F9)), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 20, offset: const Offset(0, 10))]),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(flex: 5, child: Stack(children: [Container(margin: const EdgeInsets.all(8), decoration: BoxDecoration(borderRadius: BorderRadius.circular(22), image: const DecorationImage(image: AssetImage('assets/dry.png'), fit: BoxFit.cover))), Positioned(top: 15, left: 15, child: _vegBadge())])),
              Expanded(flex: 4, child: Padding(padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [const Text("Cold Brew", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: darkBlue)), const SizedBox(height: 4), Text("Premium Arabica", style: TextStyle(color: Colors.grey[500], fontSize: 11)), const Spacer(), Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [const Text("₹249", style: TextStyle(fontWeight: FontWeight.w900, fontSize: 17, color: darkBlue)), _buildAddButton()]), const SizedBox(height: 6)])))
            ],
          ),
        );
      },
    );
  }

  // --- MODAL & FORM ---
  void _showEnquiryModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        decoration: const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.vertical(top: Radius.circular(25))),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Enquiry", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: darkBlue)),
                  IconButton(onPressed: () => Navigator.pop(context), icon: Icon(Icons.cancel_rounded, color: darkBlue.withOpacity(0.5))),
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
                    _buildTextField("First Name", "Enter First Name"),
                    _buildTextField("Last Name", "Enter Last Name"),
                    _buildTextField("Email", "Enter Email"),
                    _buildTextField("Phone Number", "Enter Phone Number"),
                    _buildTextField("Write us a Message", "Enter Enquiry Now", maxLines: 3),
                    const SizedBox(height: 20),
                    Align(
                      alignment: Alignment.centerRight,
                      child: ElevatedButton(
                        onPressed: () => Navigator.pop(context),
                        style: ElevatedButton.styleFrom(backgroundColor: darkBlue, padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 15), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                        child: const Row(mainAxisSize: MainAxisSize.min, children: [Text("Enquiry", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)), SizedBox(width: 8), Icon(Icons.arrow_circle_right_outlined, color: Colors.white, size: 18)]),
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

  // --- SHARED UI HELPER METHODS ---
  Widget _buildTextField(String label, String hint, {int maxLines = 1}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: darkBlue.withOpacity(0.8))),
          const SizedBox(height: 8),
          TextField(
            maxLines: maxLines,
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: TextStyle(color: Colors.grey[400], fontSize: 13),
              contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
              enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: Colors.grey[300]!)),
              focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: darkBlue, width: 1.5)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPremiumSearchBar() {
    return Container(
      height: 48,
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(15), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 10)]),
      child: TextField(
        controller: _searchController,
        autofocus: true,
        style: const TextStyle(color: darkBlue, fontSize: 15, fontWeight: FontWeight.w600),
        decoration: InputDecoration(
          hintText: "Search dishes...",
          hintStyle: TextStyle(color: darkBlue.withOpacity(0.4), fontSize: 14),
          prefixIcon: const Icon(Icons.search_rounded, color: darkBlue, size: 22),
          suffixIcon: IconButton(icon: const Icon(Icons.close_rounded, color: darkBlue), onPressed: () => setState(() => _isSearching = false)),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 12),
        ),
      ),
    );
  }

  Widget _buildInfoRow() {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [_buildMiniStat(Icons.star_rounded, "4.8", "Rating", Colors.orange), _buildMiniStat(Icons.access_time_filled_rounded, "Open", "9am-11pm", Colors.blue), _buildMiniStat(Icons.verified_rounded, "Verified", "Business", Colors.green)]);
  }

  Widget _buildMiniStat(IconData icon, String title, String sub, Color color) {
    return Container(width: MediaQuery.of(context).size.width * 0.28, padding: const EdgeInsets.symmetric(vertical: 18), decoration: BoxDecoration(color: const Color(0xFFF8FAFC), borderRadius: BorderRadius.circular(22)), child: Column(children: [Icon(icon, color: color, size: 22), const SizedBox(height: 8), Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)), Text(sub, style: const TextStyle(color: Colors.grey, fontSize: 11))]));
  }

  Widget _buildDetailCard(IconData icon, String text) {
    return Container(padding: const EdgeInsets.all(20), decoration: BoxDecoration(color: const Color(0xFFF8FAFC), borderRadius: BorderRadius.circular(22)), child: Row(children: [Icon(icon, size: 20, color: darkBlue), const SizedBox(width: 15), Expanded(child: Text(text, style: const TextStyle(fontWeight: FontWeight.w500)))]));
  }

  Widget _buildAddButton() {
    return Container(height: 32, width: 65, decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10), border: Border.all(color: primaryColor.withOpacity(0.3))), child: const Center(child: Text("ADD", style: TextStyle(color: primaryColor, fontWeight: FontWeight.w900, fontSize: 11))));
  }

  Widget _circleAction(IconData icon, Color color) {
    return Container(padding: const EdgeInsets.all(10), decoration: BoxDecoration(color: color.withOpacity(0.1), shape: BoxShape.circle), child: Icon(icon, color: color, size: 20));
  }

  Widget _buildHeaderButton(IconData icon, VoidCallback onTap) {
    return Container(margin: const EdgeInsets.all(6), decoration: BoxDecoration(color: Colors.black.withOpacity(0.4), shape: BoxShape.circle), child: IconButton(icon: Icon(icon, color: Colors.white, size: 16), onPressed: onTap));
  }

  Widget _buildCategoryBadge(String text) {
    return Container(padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6), decoration: BoxDecoration(color: primaryColor, borderRadius: BorderRadius.circular(10)), child: Text(text, style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)));
  }

  Widget _buildMarqueeTitle(String text) {
    return SingleChildScrollView(controller: _marqueeController, scrollDirection: Axis.horizontal, physics: const NeverScrollableScrollPhysics(), child: Text(text, style: const TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold)));
  }

  Widget _sectionHeader(String title) {
    return Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: darkBlue, letterSpacing: -0.5));
  }

  Widget _buildActionBottomBar() {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 15, 20, 35),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: darkBlue.withOpacity(0.08),
            blurRadius: 30,
            offset: const Offset(0, -10),
          )
        ],
        borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
      ),
      child: Row(
        children: [
          // --- Left Side: Stats/Info ---
          const Expanded(
            flex: 2,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Exclusive",
                  style: TextStyle(color: primaryColor, fontSize: 12, fontWeight: FontWeight.w800, letterSpacing: 1),
                ),
                SizedBox(height: 2),
                Text(
                  "PREMIUM DEALS",
                  style: TextStyle(color: darkBlue, fontWeight: FontWeight.w900, fontSize: 15),
                ),
              ],
            ),
          ),

          // --- Right Side: Book Now Button ---
          Expanded(
            flex: 3,
            child: Container(
              height: 55,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(18),
                gradient: const LinearGradient(
                  colors: [darkBlue, Color(0xFF2C4A63)],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
                boxShadow: [
                  BoxShadow(
                    color: darkBlue.withOpacity(0.3),
                    blurRadius: 15,
                    offset: const Offset(0, 8),
                  )
                ],
              ),
              child: ElevatedButton(
                onPressed: () {
                  // Booking Logic
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "BOOK NOW",
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w900,
                          fontSize: 15,
                          letterSpacing: 1.5
                      ),
                    ),
                    SizedBox(width: 8),
                    Icon(Icons.bolt_rounded, color: Colors.yellow, size: 20), // "Bolt" icon for urgency
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _vegBadge() {
    return Container(padding: const EdgeInsets.all(3), decoration: BoxDecoration(color: Colors.white.withOpacity(0.9), borderRadius: BorderRadius.circular(4), border: Border.all(color: Colors.green, width: 1)), child: const Icon(Icons.circle, color: Colors.green, size: 7));
  }
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  final Widget child; final double height;
  _SliverAppBarDelegate({required this.child, required this.height});
  @override double get minExtent => height;
  @override double get maxExtent => height;
  @override Widget build(context, offset, overlaps) => SizedBox.expand(child: child);
  @override bool shouldRebuild(old) => true;
}