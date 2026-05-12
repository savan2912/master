import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gotilo_new/Api/ApiCalls.dart';
import 'package:gotilo_new/Api/Request/User/Profile/RequestDeleteAddress.dart';
import 'package:gotilo_new/Api/Request/User/Profile/RequestProfile.dart';
import 'package:gotilo_new/Api/Request/User/Profile/RequestProfileAddress.dart';
import 'package:gotilo_new/Api/Request/User/Profile/RequestUpdateProfile.dart';
import 'package:gotilo_new/Api/Response/User/Profile/ResponseDeleteAddress.dart';
import 'package:gotilo_new/Api/Response/User/Profile/ResponseEditAddress.dart';
import 'package:gotilo_new/Api/Response/User/Profile/ResponseProfile.dart';
import 'package:gotilo_new/Api/Response/User/Profile/ResponseProfileAddress.dart';
import 'package:gotilo_new/Api/Response/User/Profile/ResponseUpdateProfile.dart';
import 'package:gotilo_new/Constant/AppPref.dart';
import 'package:gotilo_new/CustomeWidgets/SharedWidgets.dart';
import 'package:gotilo_new/MyApplication/MyApplication.dart';
import 'package:image_picker/image_picker.dart';
import '../../../Api/Request/User/Profile/RequestEditAddress.dart';
import '../../../CustomeWidgets/CustomAppbar.dart';
import '../../../CustomeWidgets/CustomCameraScreen.dart';
import '../../../CustomeWidgets/CustomDrawer.dart';
import '../../../CustomeWidgets/CustomLoader.dart';
import '../ChangePassword/ChangePassword.dart';
import 'MapScreen.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> with SingleTickerProviderStateMixin {
  final Color bgWhite = const Color(0xFFFFFFFF);
  final Color surfaceWhite = const Color(0xFFF9FAFB);
  final Color textBlack = const Color(0xFF111827);
  final Color premiumGold = const Color(0xFFC5A059);
  final Color softShadow = const Color(0xFFE5E7EB);
  final Color dangerRed = const Color(0xFFEF4444);

  ProfileData? profileData;
  late TabController _tabController;
  File? imageFile;
  bool isLoading = true;
  bool isEditingAddress = false;
  bool isEditingProfile = false;
  String currentEditAddressId = "";

  final ImagePicker _picker = ImagePicker();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  List<ProfileAddress> profileAddress = [];

  // Profile Controllers
  final TextEditingController _fNameController = TextEditingController();
  final TextEditingController _lNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();

  // Address Controllers
  final TextEditingController _latController = TextEditingController();
  final TextEditingController _lngController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _pincodeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _callProfile();
    _callProfileAddress();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) {
        setState(() {
          isEditingAddress = false;
          isEditingProfile = false;
          currentEditAddressId = "";
        });
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _fNameController.dispose();
    _lNameController.dispose();
    _emailController.dispose();
    _mobileController.dispose();
    _latController.dispose();
    _lngController.dispose();
    _addressController.dispose();
    _pincodeController.dispose();
    super.dispose();
  }



  Future<void> _callProfile() async {
    setState(() => isLoading = true);
    bool internet = await MyApplication.checkInternet();
    if (internet) {
      try {
        ResponseProfile? response = await ApiCalls.callProfile(RequestProfile(userId: AppPrefs.userId ?? ""));
        if (response != null && response.result!.toLowerCase().contains("pass")) {
          setState(() {
            profileData = response.data!;
            _fNameController.text = profileData?.fName ?? "";
            _lNameController.text = profileData?.lName ?? "";
            _emailController.text = profileData?.email ?? "";
            _mobileController.text = profileData?.mobile ?? "";
          });
        }
      } catch (e) { log("API Error: $e"); }
      finally { setState(() => isLoading = false); }
    } else {
      setState(() => isLoading = false);
      SharedWidgets.showTopSnackBar(context, message: "No Internet Available");
    }
  }

  Future<void> _updateProfile() async {
    if (_fNameController.text.isEmpty) {
      SharedWidgets.showTopSnackBar(context, message: "First name is required");
      return;
    }

    setState(() => isLoading = true);
    try {
      ResponseUpdateProfile? response = await ApiCalls.callUpdateProfile(
          RequestUpdateProfile(
            id: AppPrefs.userId=="" ? 0 :int.parse(AppPrefs.userId),
            fName: _fNameController.text,
            lName: _lNameController.text,
            email: _emailController.text,
            phone: _mobileController.text,
          ),
          imageFile?.path
      );

      if (response != null && response.result!.toLowerCase().contains("pass")) {
        SharedWidgets.showTopSnackBar(context, message: response.message ?? "Profile Updated!");
        setState(() {
          isEditingProfile = false;
          imageFile = null;
        });
        _callProfile();
      }
    } catch (e) { log("Update Error: $e"); }
    finally { setState(() => isLoading = false); }
  }

  Future<void> _callProfileAddress() async {
    bool internet = await MyApplication.checkInternet();
    if (internet) {
      try {
        ResponseProfileAddress? response = await ApiCalls.callProfileAddress(RequestProfileAddress(
          userId: AppPrefs.userId,
          search: "",
          counter: "0",
        ));
        if (response != null && response.result!.toLowerCase().contains("pass")) {
          setState(() {
            profileAddress.clear();
            profileAddress.addAll(response.data!);
          });
        }
      } catch (e) { log("Address API Error: $e"); }
    }
  }

  Future<void> _deleteAddress(String addressId) async {
    bool internet = await MyApplication.checkInternet();
    if (internet) {
      try {
        ResponseDeleteAddress? response = await ApiCalls.callDeleteAddress(
            RequestDeleteAddress(userId: AppPrefs.userId, addressId: addressId)
        );
        if (response != null && response.result!.toLowerCase().contains("pass")) {
          SharedWidgets.showTopSnackBar(context, message: response.message!);
          _callProfileAddress();
        }
      } catch (e) { log("Delete Error: $e"); }
    }
  }

  Future<void> _saveAddress() async {
    if (_addressController.text.isEmpty || _pincodeController.text.isEmpty) {
      SharedWidgets.showTopSnackBar(context, message: "Please fill all details");
      return;
    }

    bool internet = await MyApplication.checkInternet();
    if (internet) {
      ResponseEditAddress? response = await ApiCalls.callEditAddress(
          RequestEditAddress(
              userId: AppPrefs.userId,
              addressId: currentEditAddressId,
              latitude: _latController.text,
              address: _addressController.text,
              longitude: _lngController.text,
              pincode: _pincodeController.text
          )
      );
      if (response != null && response.result!.toLowerCase().contains("pass")) {
        SharedWidgets.showTopSnackBar(context, message: response.message!);
        setState(() {
          isEditingAddress = false;
          currentEditAddressId = "";
        });
        _callProfileAddress();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: surfaceWhite,
      appBar: CustomAppBar(
        title: "Account Settings",
        onMenuTap: () => _scaffoldKey.currentState?.openDrawer(),
        onActionTap: () => Get.to(() => const ChangePassword()),
      ),
      drawer: const CustomDrawer(initialRoute: 'user.setting'),
      body: isLoading
          ? const CustomLoader(message: "Wait a moment...")
          : SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            const SizedBox(height: 25),
            _buildLuxuryHeader(),
            const SizedBox(height: 35),
            _buildPremiumToggle(),
            const SizedBox(height: 15),
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 400),
              child: _tabController.index == 0
                  ? _buildProfileContent(key: const ValueKey(0))
                  : isEditingAddress
                  ? _buildAddressForm(key: const ValueKey(1))
                  : _buildAddressListing(key: const ValueKey(2)),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileContent({Key? key}) {
    return Padding(
      key: key,
      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Profile Information",
                  style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w800, fontSize: 16, color: textBlack)),
              TextButton.icon(
                onPressed: () => setState(() => isEditingProfile = !isEditingProfile),
                icon: Icon(isEditingProfile ? Icons.close : Icons.edit_rounded, color: premiumGold, size: 18),
                label: Text(isEditingProfile ? "Cancel" : "Edit",
                    style: GoogleFonts.plusJakartaSans(color: premiumGold, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
          const SizedBox(height: 15),
          _buildInfoField("First Name", _fNameController, Icons.person_rounded, isEditingProfile),
          const SizedBox(height: 16),
          _buildInfoField("Last Name", _lNameController, Icons.face_rounded, isEditingProfile),
          const SizedBox(height: 16),
          _buildInfoField("Email Address", _emailController, Icons.email_rounded, isEditingProfile, keyboardType: TextInputType.emailAddress),
          const SizedBox(height: 16),
          _buildInfoField("Phone Number", _mobileController, Icons.phone_iphone_rounded, isEditingProfile, keyboardType: TextInputType.phone),

          if (isEditingProfile) ...[
            const SizedBox(height: 35),
            _buildGradientButton("UPDATE PROFILE", onTap: _updateProfile),
          ],
        ],
      ),
    );
  }

  Widget _buildInfoField(String title, TextEditingController controller, IconData icon, bool isEditable, {TextInputType? keyboardType}) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: bgWhite,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: isEditable ? premiumGold.withOpacity(0.4) : Colors.transparent),
        boxShadow: [BoxShadow(color: softShadow.withOpacity(0.3), blurRadius: 10)],
      ),
      child: Row(
        children: [
          Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(color: surfaceWhite, borderRadius: BorderRadius.circular(12)),
              child: Icon(icon, color: premiumGold, size: 20)
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: GoogleFonts.plusJakartaSans(fontSize: 10, color: Colors.grey.shade500, fontWeight: FontWeight.bold)),
                TextField(
                  controller: controller,
                  enabled: isEditable,
                  keyboardType: keyboardType,
                  style: GoogleFonts.plusJakartaSans(fontSize: 14, fontWeight: FontWeight.bold, color: textBlack),
                  decoration: const InputDecoration(
                    isDense: true,
                    contentPadding: EdgeInsets.only(top: 5),
                    border: InputBorder.none,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLuxuryHeader() {
    return Column(
      children: [
        Center(
          child: Stack(
            alignment: Alignment.center,
            children: [
              Container(
                height: 150, width: 150,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(colors: [premiumGold.withOpacity(0.12), Colors.transparent]),
                ),
              ),
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: premiumGold.withOpacity(0.3))),
                child: CircleAvatar(
                  radius: 60,
                  backgroundColor: surfaceWhite,
                  backgroundImage: imageFile != null
                      ? FileImage(imageFile!)
                      : (profileData?.image != null && profileData!.image!.isNotEmpty)
                      ? NetworkImage(profileData!.image!) as ImageProvider
                      : null,
                  child: (imageFile == null && (profileData?.image == null || profileData!.image!.isEmpty))
                      ? Icon(Icons.person_outline_rounded, size: 50, color: textBlack.withOpacity(0.1))
                      : null,
                ),
              ),
              Positioned(
                bottom: 5, right: 5,
                child: GestureDetector(
                  onTap: () => showImagePickerOptions(),
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(color: textBlack, shape: BoxShape.circle, border: Border.all(color: Colors.white, width: 2)),
                    child: const Icon(Icons.camera_alt_rounded, color: Colors.white, size: 18),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 15),
        Text("${profileData?.fName ?? 'Loading...'} ${profileData?.lName ?? ''}",
            style: GoogleFonts.plusJakartaSans(fontSize: 24, fontWeight: FontWeight.w800, color: textBlack)),
      ],
    );
  }

  Widget _buildPremiumToggle() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 35),
      height: 54,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(color: surfaceWhite, borderRadius: BorderRadius.circular(30), border: Border.all(color: softShadow)),
      child: TabBar(
        controller: _tabController,
        indicator: BoxDecoration(color: textBlack, borderRadius: BorderRadius.circular(26)),
        labelColor: Colors.white,
        unselectedLabelColor: Colors.grey.shade500,
        labelStyle: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.bold, fontSize: 14),
        indicatorSize: TabBarIndicatorSize.tab,
        dividerColor: Colors.transparent,
        tabs: const [Tab(text: "Profile"), Tab(text: "Addresses")],
      ),
    );
  }

  Widget _buildAddressListing({Key? key}) {
    return Padding(
      key: key,
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Saved Locations", style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w800, fontSize: 16, color: textBlack)),
              TextButton.icon(
                onPressed: () {
                  setState(() {
                    _addressController.clear();
                    _pincodeController.clear();
                    _latController.clear();
                    _lngController.clear();
                    currentEditAddressId = "";
                    isEditingAddress = true;
                  });
                },
                icon: Icon(Icons.add_location_alt_outlined, color: premiumGold, size: 18),
                label: Text("Add New", style: GoogleFonts.plusJakartaSans(color: premiumGold, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
          const SizedBox(height: 10),
          profileAddress.isEmpty ? _buildEmptyAddressState() : ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: profileAddress.length,
            separatorBuilder: (context, index) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final addr = profileAddress[index];
              return Container(
                decoration: BoxDecoration(
                  color: bgWhite, borderRadius: BorderRadius.circular(20), border: Border.all(color: softShadow),
                ),
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                  leading: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(color: surfaceWhite, borderRadius: BorderRadius.circular(12)),
                    child: Icon(Icons.location_on_rounded, color: premiumGold),
                  ),
                  title: Text(addr.address ?? "Address",
                      maxLines: 1, overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.bold, fontSize: 14)),
                  subtitle: Text("Pincode: ${addr.pincode ?? "-"}", style: TextStyle(fontSize: 12)),
                  trailing: PopupMenuButton(
                    icon: Icon(Icons.more_vert_rounded, color: textBlack.withOpacity(0.3)),
                    itemBuilder: (context) => [
                      PopupMenuItem(
                        onTap: () {
                          Future.delayed(Duration.zero, () {
                            setState(() {
                              _addressController.text = addr.address ?? "";
                              _pincodeController.text = addr.pincode ?? "";
                              _latController.text = addr.latitude ?? "";
                              _lngController.text = addr.longitude ?? "";
                              currentEditAddressId = addr.id.toString();
                              isEditingAddress = true;
                            });
                          });
                        },
                        child: const Text("Edit"),
                      ),
                      PopupMenuItem(
                        onTap: () => _showDeleteDialog(addr.id.toString()),
                        child: Text("Delete", style: TextStyle(color: dangerRed)),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildAddressForm({Key? key}) {
    return Padding(
      key: key,
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          IconButton(onPressed: () => setState(() => isEditingAddress = false), icon: const Icon(Icons.arrow_back_ios, size: 18)),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(child: _buildCoordinateInput("Latitude", _latController)),
              const SizedBox(width: 12),
              Expanded(child: _buildCoordinateInput("Longitude", _lngController)),
              const SizedBox(width: 12),
              GestureDetector(
                onTap: _pickAddressFromMap,
                child: Container(
                  height: 55, width: 55,
                  decoration: BoxDecoration(color: textBlack, borderRadius: BorderRadius.circular(15)),
                  child: const Icon(Icons.map_rounded, color: Colors.white),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          _buildLabel("Full Address"),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            decoration: BoxDecoration(color: bgWhite, borderRadius: BorderRadius.circular(18), border: Border.all(color: softShadow)),
            child: TextField(
              controller: _addressController,
              maxLines: 3,
              style: GoogleFonts.plusJakartaSans(fontSize: 14),
              decoration: const InputDecoration(border: InputBorder.none, hintText: "House no, Street..."),
            ),
          ),
          const SizedBox(height: 20),
          _buildLabel("Pincode"),
          Container(
            height: 55,
            padding: const EdgeInsets.symmetric(horizontal: 15),
            decoration: BoxDecoration(color: bgWhite, borderRadius: BorderRadius.circular(15), border: Border.all(color: softShadow)),
            child: TextField(
              controller: _pincodeController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(border: InputBorder.none, icon: Icon(Icons.pin_drop_outlined, color: premiumGold)),
            ),
          ),
          const SizedBox(height: 20),
          _buildGradientButton(currentEditAddressId.isEmpty ? "SAVE ADDRESS" : "UPDATE ADDRESS", onTap: _saveAddress),
        ],
      ),
    );
  }

  Widget _buildEmptyAddressState() {
    return Center(
      child: Column(
        children: [
          const SizedBox(height: 30),
          Icon(Icons.location_off_outlined, color: Colors.grey.shade300, size: 60),
          Text("No addresses yet", style: GoogleFonts.plusJakartaSans(color: Colors.grey)),
        ],
      ),
    );
  }

  Widget _buildGradientButton(String text, {required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: double.infinity, height: 60,
        decoration: BoxDecoration(color: textBlack, borderRadius: BorderRadius.circular(20)),
        child: Center(child: Text(text, style: GoogleFonts.plusJakartaSans(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 16))),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(left: 5, bottom: 8),
      child: Text(text, style: GoogleFonts.plusJakartaSans(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.grey.shade600)),
    );
  }

  Widget _buildCoordinateInput(String label, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLabel(label),
        Container(
          height: 55,
          decoration: BoxDecoration(color: bgWhite, borderRadius: BorderRadius.circular(15), border: Border.all(color: softShadow)),
          child: TextField(
            controller: controller, readOnly: true, textAlign: TextAlign.center,
            style: GoogleFonts.plusJakartaSans(fontSize: 12, fontWeight: FontWeight.bold),
            decoration: const InputDecoration(border: InputBorder.none),
          ),
        ),
      ],
    );
  }

  void _showDeleteDialog(String id) {
    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text("Delete?"),
        content: const Text("Are you sure?"),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("No")),
          ElevatedButton(onPressed: () { Navigator.pop(context); _deleteAddress(id); },
              style: ElevatedButton.styleFrom(backgroundColor: dangerRed), child: const Text("Yes, Delete", style: TextStyle(color: Colors.white))),
        ],
      ),
    );
  }

  void showImagePickerOptions() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => Container(
        padding: const EdgeInsets.all(30),
        decoration: const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.vertical(top: Radius.circular(35))),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("Update Photo", style: GoogleFonts.plusJakartaSans(fontSize: 18, fontWeight: FontWeight.w800)),
            const SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildSheetIcon(Icons.camera_alt_rounded, "Camera", _getFromCamera),
                _buildSheetIcon(Icons.photo_library_rounded, "Gallery", _getFromGallery),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSheetIcon(IconData icon, String label, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Column(
        children: [
          Container(padding: const EdgeInsets.all(18), decoration: BoxDecoration(color: surfaceWhite, shape: BoxShape.circle), child: Icon(icon, size: 28)),
          const SizedBox(height: 8),
          Text(label, style: GoogleFonts.plusJakartaSans(fontSize: 12, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Future<void> _getFromCamera() async {
    Navigator.pop(context);
    final File? img = await Navigator.push(context, MaterialPageRoute(builder: (_) => const CustomCameraScreen()));
    if (img != null) setState(() => imageFile = img);
  }

  Future<void> _getFromGallery() async {
    Navigator.pop(context);
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) setState(() => imageFile = File(pickedFile.path));
  }

  Future<void> _pickAddressFromMap() async {
    final result = await Navigator.push(context, MaterialPageRoute(builder: (context) => const MapScreen()));
    if (result != null && result is Map<String, dynamic>) {
      setState(() {
        _addressController.text = result['address'] ?? "";
        _latController.text = result['lat'].toString();
        _lngController.text = result['lng'].toString();
      });
    }
  }
}