
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:gotilo_new/Api/ApiCalls.dart';
import 'package:gotilo_new/Api/Response/Home/ResponseHomeEventAvailable.dart';
import 'package:gotilo_new/MyApplication/MyApplication.dart';
import '../CustomeWidgets/SharedWidgets.dart';

class EventHomeScreen extends StatefulWidget {
  const EventHomeScreen({super.key});

  @override
  State<EventHomeScreen> createState() => _EventHomeScreenState();
}

class _EventHomeScreenState extends State<EventHomeScreen> {

  HomeEventList? homeEventList;

  @override
  void initState() {
    _callHomeEventList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold();
  }

  Future<void> _callHomeEventList() async {
    bool? internet = await MyApplication.checkInternet();
    if(internet){
      try{
        ResponseHomeEventAvailable? response = await ApiCalls.callHomeEventAvailable();
        if(response != null){
          if(response.result!.isNotEmpty && response.result != null &&
          response.result!.toLowerCase().contains("pass")){
            homeEventList = response.data!;
            setState(() {});
          }
        }
      }on Exception catch(e){
        log("$e");
      }catch(e){
        log("$e");
      }
    }else{
      SharedWidgets.showTopSnackBar(context, message: "No Internet Connection", title: "fail");
    }
  }
}
