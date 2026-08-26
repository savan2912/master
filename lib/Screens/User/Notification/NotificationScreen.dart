import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gotilo_new/CustomeWidgets/CustomAppbar.dart';
import 'package:gotilo_new/Screens/HeritageHomeScreen.dart';
import 'package:intl/intl.dart'; // Date formatting માટે
import 'package:gotilo_new/Api/ApiCalls.dart';
import 'package:gotilo_new/Api/Request/User/Notification/RequestNotification.dart';
import 'package:gotilo_new/Api/Response/User/Notification/ResponseNotification.dart';
import 'package:gotilo_new/Constant/AppPref.dart';
import 'package:gotilo_new/CustomeWidgets/SharedWidgets.dart';
import 'package:gotilo_new/MyApplication/MyApplication.dart';
import '../../../CustomeWidgets/CustomDrawer.dart';
import '../../../CustomeWidgets/CustomLoader.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  final Color primaryDark = const Color(0xFF0F172A);
  final Color accentCyan = const Color(0xFF00E5FF);
  final Color cardColor = const Color(0xFF1E293B);

  ValueNotifier<bool> isDataAvailable = ValueNotifier(false);
  ValueNotifier<bool> isApiComplete = ValueNotifier(false);
  List<NotificationData> notificationData = [];
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    callNotification();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: ModernHeritageApp.appBg,
      drawer: const CustomDrawer(initialRoute: 'all.notifications'),
      appBar: CustomAppBar(
          title: "Notification",
          showAction: false,
          onMenuTap: () => _scaffoldKey.currentState?.openDrawer(),
      ),

      body: RefreshIndicator(
        onRefresh: () async => callNotification(),
        color: accentCyan,
        backgroundColor: cardColor,
        child: ValueListenableBuilder(
          valueListenable: isApiComplete,
          builder: (context, apiDone, child) {
            if (!apiDone) {
              return const Center(child: CustomLoader(message: "Loading Notification..",));
            }

            return ValueListenableBuilder(
              valueListenable: isDataAvailable,
              builder: (context, dataExists, child) {
                if (!dataExists || notificationData.isEmpty) {
                  return _buildEmptyState();
                }

                return ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
                  physics: const BouncingScrollPhysics(),
                  itemCount: notificationData.length,
                  itemBuilder: (context, index) {
                    return _buildNotificationCard(notificationData[index]);
                  },
                );
              },
            );
          },
        ),
      ),
    );
  }


  Widget _buildNotificationCard(NotificationData data) {
    String formattedDate = data.sendDate ?? "Recent";
    try {
      DateTime dt = DateTime.parse(data.sendDate!);
      formattedDate = DateFormat('dd MMM, hh:mm a').format(dt);
    } catch (_) {}

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: SharedWidgets.cardBoxDecoration(),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(25),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(18.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: cardColor.withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(Icons.notifications_active_outlined, color: primaryDark, size: 20),
                      ),
                      const SizedBox(width: 15),

                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              data.notificationTitle?.toUpperCase() ?? "NEW NOTIFICATION",
                              style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w800,
                                fontSize: 14,
                                color: Colors.black,
                                letterSpacing: 0.5,
                              ),
                            ),
                            Text(
                              formattedDate,
                              style: GoogleFonts.poppins(fontSize: 10, color: Colors.black),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),
                  Text(
                    data.notificationDesc ?? "No description available.",
                    style: GoogleFonts.poppins(
                      fontSize: 13,
                      color: Colors.black.withOpacity(0.7),
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),

          ],
        ),
      ),
    );
  }


  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.notifications_none_rounded, size: 80, color: accentCyan.withOpacity(0.2)),
          const SizedBox(height: 20),
          Text(
            "NO NOTIFICATIONS YET",
            style: GoogleFonts.montserrat(
              color: Colors.white54,
              fontSize: 14,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> callNotification() async {
    notificationData.clear();
    isApiComplete.value = false;
    _callNotification();
  }

  Future<void> _callNotification() async {
    bool internet = await MyApplication.checkInternet();
    if (internet) {
      try {
        ResponseNotification? response = await ApiCalls.callNotification(
          RequestNotification(userId: AppPrefs.userId ?? ""),
        );
        if (response != null && response.result != null) {
          if (response.result!.toLowerCase().contains("pass")) {
            notificationData.addAll(response.data!);
            isDataAvailable.value = true;
          } else {
            isDataAvailable.value = false;
          }
        }
      } catch (e) {
        log("Error: $e");
        isDataAvailable.value = false;
      } finally {
        isApiComplete.value = true;
      }
    } else {
      SharedWidgets.showTopSnackBar(context, message: "No Internet Available",title:"fail");
      isApiComplete.value = true;
    }
  }
}