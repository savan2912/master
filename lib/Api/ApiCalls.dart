
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:gotilo_new/Api/Response/Banner/ResponseBanner.dart';
import 'package:gotilo_new/Api/Response/Home/ResponseHomeCollection.dart';
import 'package:gotilo_new/Api/Response/Home/ResponseHomeLatestRelease.dart';
import 'package:gotilo_new/Api/Response/Home/ResponseHomeService.dart';
import 'package:gotilo_new/Api/Response/LatestListing/ResponseHomeLatestListing.dart';

import 'ApiList.dart';
import 'ApiUtils.dart';
import 'package:stack_trace/stack_trace.dart';

import 'Response/Home/ResponseHome.dart';
import 'Response/Home/ResponseHomeDeal.dart';

class ApiCalls {
  static const bool _showLocationLogs = true;

  static Dio _getDio() {
    final dio = Dio();

    dio.httpClientAdapter = IOHttpClientAdapter()
      ..onHttpClientCreate = (HttpClient client) {
        client.badCertificateCallback =
            (X509Certificate cert, String host, int port) => true;
        return client;
      };

    return dio;
  }

  //TODO: App Setting
  static Future<ResponseBanner?> callHomeBanner()
  async {
    //TODO: STEP 1 : HERE CHANGES REQUEST AND RESPONSE MODEL NAME
    String TAG =
        (_showLocationLogs == true ? Trace.current().frames[0].location : "") +
            Trace.current().frames[0].member!;
    FormData formData = FormData.fromMap(
        ApiUtils.getRequestMapForDio());
    try {
      log("Request URL = ${ApiList.urlHomeBanner}", name: TAG);
      log("Request Data= ${formData.fields}", name: TAG);
      //TODO: STEP 2 : HERE CHANGES REQUEST URL
      Response response =
          await _getDio().get(ApiList.urlHomeBanner, data: formData);
      log("Response status or statusCode  = ${response.statusCode}", name: TAG);
      if (response.statusCode == HttpStatus.ok) {
        if (response.data != null) {
          log("Response Data = ${response.data}", name: TAG);
          //TODO: STEP 3 : HERE CHANGES RESPONSE MODEL NAME
          return ResponseBanner.fromJson(response.data);
        } else {
          log("Response data = null", name: TAG);
          return null;
        }
      } else {
        return null;
      }
    } on Exception catch (e) {
      log("Error = $e", name: TAG);
    }
    return null;
  }

  static Future<ResponseHomeCollection?> callHomeCollection()
  async {
    //TODO: STEP 1 : HERE CHANGES REQUEST AND RESPONSE MODEL NAME
    String TAG =
        (_showLocationLogs == true ? Trace.current().frames[0].location : "") +
            Trace.current().frames[0].member!;
    FormData formData = FormData.fromMap(
        ApiUtils.getRequestMapForDio());
    try {
      log("Request URL = ${ApiList.urlHomeCollection}", name: TAG);
      log("Request Data= ${formData.fields}", name: TAG);
      //TODO: STEP 2 : HERE CHANGES REQUEST URL
      Response response =
      await _getDio().get(ApiList.urlHomeCollection, data: formData);
      log("Response status or statusCode  = ${response.statusCode}", name: TAG);
      if (response.statusCode == HttpStatus.ok) {
        if (response.data != null) {
          log("Response Data = ${response.data}", name: TAG);
          //TODO: STEP 3 : HERE CHANGES RESPONSE MODEL NAME
          return ResponseHomeCollection.fromJson(response.data);
        } else {
          log("Response data = null", name: TAG);
          return null;
        }
      } else {
        return null;
      }
    } on Exception catch (e) {
      log("Error = $e", name: TAG);
    }
    return null;
  }

  static Future<ResponseHomeNearListing?> callHomeLatestListing()
  async {
    //TODO: STEP 1 : HERE CHANGES REQUEST AND RESPONSE MODEL NAME
    String TAG =
        (_showLocationLogs == true ? Trace.current().frames[0].location : "") +
            Trace.current().frames[0].member!;
    FormData formData = FormData.fromMap(
        ApiUtils.getRequestMapForDio());
    try {
      log("Request URL = ${ApiList.urlHomeLatestListing}", name: TAG);
      log("Request Data= ${formData.fields}", name: TAG);
      //TODO: STEP 2 : HERE CHANGES REQUEST URL
      Response response =
      await _getDio().get(ApiList.urlHomeLatestListing, data: formData);
      log("Response status or statusCode  = ${response.statusCode}", name: TAG);
      if (response.statusCode == HttpStatus.ok) {
        if (response.data != null) {
          log("Response Data = ${response.data}", name: TAG);
          //TODO: STEP 3 : HERE CHANGES RESPONSE MODEL NAME
          return ResponseHomeNearListing.fromJson(response.data);
        } else {
          log("Response data = null", name: TAG);
          return null;
        }
      } else {
        return null;
      }
    } on Exception catch (e) {
      log("Error = $e", name: TAG);
    }
    return null;
  }

  static Future<ResponseHomeLatestRelease?> callHomeLatestRelease()
  async {
    //TODO: STEP 1 : HERE CHANGES REQUEST AND RESPONSE MODEL NAME
    String TAG =
        (_showLocationLogs == true ? Trace.current().frames[0].location : "") +
            Trace.current().frames[0].member!;
    FormData formData = FormData.fromMap(
        ApiUtils.getRequestMapForDio());
    try {
      log("Request URL = ${ApiList.urlHomeLatestRelease}", name: TAG);
      log("Request Data= ${formData.fields}", name: TAG);
      //TODO: STEP 2 : HERE CHANGES REQUEST URL
      Response response =
      await _getDio().get(ApiList.urlHomeLatestRelease, data: formData);
      log("Response status or statusCode  = ${response.statusCode}", name: TAG);
      if (response.statusCode == HttpStatus.ok) {
        if (response.data != null) {
          log("Response Data = ${response.data}", name: TAG);
          //TODO: STEP 3 : HERE CHANGES RESPONSE MODEL NAME
          return ResponseHomeLatestRelease.fromJson(response.data);
        } else {
          log("Response data = null", name: TAG);
          return null;
        }
      } else {
        return null;
      }
    } on Exception catch (e) {
      log("Error = $e", name: TAG);
    }
    return null;
  }

  static Future<ResponseHomeService?> callHomeService()
  async {
    //TODO: STEP 1 : HERE CHANGES REQUEST AND RESPONSE MODEL NAME
    String TAG =
        (_showLocationLogs == true ? Trace.current().frames[0].location : "") +
            Trace.current().frames[0].member!;
    FormData formData = FormData.fromMap(
        ApiUtils.getRequestMapForDio());
    try {
      log("Request URL = ${ApiList.urlHomeService}", name: TAG);
      log("Request Data= ${formData.fields}", name: TAG);
      //TODO: STEP 2 : HERE CHANGES REQUEST URL
      Response response =
      await _getDio().get(ApiList.urlHomeService, data: formData);
      log("Response status or statusCode  = ${response.statusCode}", name: TAG);
      if (response.statusCode == HttpStatus.ok) {
        if (response.data != null) {
          log("Response Data = ${response.data}", name: TAG);
          //TODO: STEP 3 : HERE CHANGES RESPONSE MODEL NAME
          return ResponseHomeService.fromJson(response.data);
        } else {
          log("Response data = null", name: TAG);
          return null;
        }
      } else {
        return null;
      }
    } on Exception catch (e) {
      log("Error = $e", name: TAG);
    }
    return null;
  }

  static Future<ResponseHomeDeal?> callHomeDeal()
  async {
    //TODO: STEP 1 : HERE CHANGES REQUEST AND RESPONSE MODEL NAME
    String TAG =
        (_showLocationLogs == true ? Trace.current().frames[0].location : "") +
            Trace.current().frames[0].member!;
    FormData formData = FormData.fromMap(
        ApiUtils.getRequestMapForDio());
    try {
      log("Request URL = ${ApiList.urlHomeDeal}", name: TAG);
      log("Request Data= ${formData.fields}", name: TAG);
      //TODO: STEP 2 : HERE CHANGES REQUEST URL
      Response response =
      await _getDio().get(ApiList.urlHomeDeal, data: formData);
      log("Response status or statusCode  = ${response.statusCode}", name: TAG);
      if (response.statusCode == HttpStatus.ok) {
        if (response.data != null) {
          log("Response Data = ${response.data}", name: TAG);
          //TODO: STEP 3 : HERE CHANGES RESPONSE MODEL NAME
          return ResponseHomeDeal.fromJson(response.data);
        } else {
          log("Response data = null", name: TAG);
          return null;
        }
      } else {
        return null;
      }
    } on Exception catch (e) {
      log("Error = $e", name: TAG);
    }
    return null;
  }


  static Future<ResponseHome?> callHome()
  async {
    //TODO: STEP 1 : HERE CHANGES REQUEST AND RESPONSE MODEL NAME
    String TAG =
        (_showLocationLogs == true ? Trace.current().frames[0].location : "") +
            Trace.current().frames[0].member!;
    FormData formData = FormData.fromMap(
        ApiUtils.getRequestMapForDio());
    try {
      log("Request URL = ${ApiList.urlHome}", name: TAG);
      log("Request Data= ${formData.fields}", name: TAG);
      //TODO: STEP 2 : HERE CHANGES REQUEST URL
      Response response =
      await _getDio().get(ApiList.urlHome, data: formData);
      log("Response status or statusCode  = ${response.statusCode}", name: TAG);
      if (response.statusCode == HttpStatus.ok) {
        if (response.data != null) {
          log("Response Data = ${response.data}", name: TAG);
          //TODO: STEP 3 : HERE CHANGES RESPONSE MODEL NAME
          return ResponseHome.fromJson(response.data);
        } else {
          log("Response data = null", name: TAG);
          return null;
        }
      } else {
        return null;
      }
    } on Exception catch (e) {
      log("Error = $e", name: TAG);
    }
    return null;
  }


}
