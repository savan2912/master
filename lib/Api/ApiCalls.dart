
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:gotilo_new/Api/Request/AllCollection/RequestAllCollection.dart';
import 'package:gotilo_new/Api/Request/AllCollection/RequestCollectionDetails.dart';
import 'package:gotilo_new/Api/Request/AllCollection/RequestCollectionProductListings.dart';
import 'package:gotilo_new/Api/Request/AllDeals/RequestAllDeals.dart';
import 'package:gotilo_new/Api/Request/AllLatestRelease/RequestAllLatestRelease.dart';
import 'package:gotilo_new/Api/Request/AllListings/RequestAllListings.dart';
import 'package:gotilo_new/Api/Request/AllListings/RequestSimilarListing.dart';
import 'package:gotilo_new/Api/Request/AllNewlyAdded/RequestAllNewlyAdded.dart';
import 'package:gotilo_new/Api/Request/AllService/RequestAllService.dart';
import 'package:gotilo_new/Api/Request/Blog/RequestBlogDetail.dart';
import 'package:gotilo_new/Api/Request/Cart/RequestAddCart.dart';
import 'package:gotilo_new/Api/Request/Cart/RequestCartAddress.dart';
import 'package:gotilo_new/Api/Request/Cart/RequestCartDelete.dart';
import 'package:gotilo_new/Api/Request/Cart/RequestCartItem.dart';
import 'package:gotilo_new/Api/Request/Cart/RequestUpdateCart.dart';
import 'package:gotilo_new/Api/Request/CrackDeal/RequestCrackDeal.dart';
import 'package:gotilo_new/Api/Request/Enquiry/RequestAddEnquiry.dart';
import 'package:gotilo_new/Api/Request/Fav/RequestAddFav.dart';
import 'package:gotilo_new/Api/Request/Login/RequestLogin.dart';
import 'package:gotilo_new/Api/Request/Logout/RequestLogout.dart';
import 'package:gotilo_new/Api/Request/Otp/RequestResetPassword.dart';
import 'package:gotilo_new/Api/Request/Otp/RequestSendOtp.dart';
import 'package:gotilo_new/Api/Request/Otp/RequestVerifyOtp.dart';
import 'package:gotilo_new/Api/Request/PlaceOrder/RequestPlaceOrder.dart';
import 'package:gotilo_new/Api/Request/Product/RequestProductDetail.dart';
import 'package:gotilo_new/Api/Request/Register/RequestRegister.dart';
import 'package:gotilo_new/Api/Request/Review/RequestAddReview.dart';
import 'package:gotilo_new/Api/Request/Review/RequestReview.dart';
import 'package:gotilo_new/Api/Request/Search/RequestSearch.dart';
import 'package:gotilo_new/Api/Request/Share/RequestShare.dart';
import 'package:gotilo_new/Api/Request/SubCategoryList/RequestSubCategoryList.dart';
import 'package:gotilo_new/Api/Request/SubCategoryList/RequestSubCategoryListDetails.dart';
import 'package:gotilo_new/Api/Request/SubCategoryList/RequestSubCategoryProductList.dart';
import 'package:gotilo_new/Api/Request/User/Billing/RequestBillHistory.dart';
import 'package:gotilo_new/Api/Request/User/Billing/RequestBilling.dart';
import 'package:gotilo_new/Api/Request/User/BookingHistory/RequestBookingHistory.dart';
import 'package:gotilo_new/Api/Request/User/BookingHistory/RequestBookingHistoryDetail.dart';
import 'package:gotilo_new/Api/Request/User/Dashboard/RequestUserDashboard.dart';
import 'package:gotilo_new/Api/Request/User/Deal/RequestCrackedDeal.dart';
import 'package:gotilo_new/Api/Request/User/Deal/RequestUserDeal.dart';
import 'package:gotilo_new/Api/Request/User/Fav/RequestFavData.dart';
import 'package:gotilo_new/Api/Request/User/Fav/RequestFavDelete.dart';
import 'package:gotilo_new/Api/Request/User/HotelBooking/RequestHotelBooking.dart';
import 'package:gotilo_new/Api/Request/User/HotelBooking/RequestHotelBookingCancellation.dart';
import 'package:gotilo_new/Api/Request/User/HotelBooking/RequestHotelBookingCancellationHistory.dart';
import 'package:gotilo_new/Api/Request/User/HotelBooking/RequestHotelBookingDetail.dart';
import 'package:gotilo_new/Api/Request/User/HotelBooking/RequestHotelBookingRoomHistory.dart';
import 'package:gotilo_new/Api/Request/User/HotelBooking/RequestHotelBookingRoomPricePlan.dart';
import 'package:gotilo_new/Api/Request/User/HotelBooking/RequestHotelBookingServiceHistory.dart';
import 'package:gotilo_new/Api/Request/User/MyOrder/RequestMyOrder.dart';
import 'package:gotilo_new/Api/Request/User/MyOrder/RequestMyOrderDetail.dart';
import 'package:gotilo_new/Api/Request/User/Notification/RequestNotification.dart';
import 'package:gotilo_new/Api/Request/User/Profile/RequestChangePassword.dart';
import 'package:gotilo_new/Api/Request/User/Profile/RequestDeleteAddress.dart';
import 'package:gotilo_new/Api/Request/User/Profile/RequestEditAddress.dart';
import 'package:gotilo_new/Api/Request/User/Profile/RequestProfile.dart';
import 'package:gotilo_new/Api/Request/User/Profile/RequestProfileAddress.dart';
import 'package:gotilo_new/Api/Request/User/Profile/RequestUpdateProfile.dart';
import 'package:gotilo_new/Api/Request/User/point/RequestPointDetail.dart';
import 'package:gotilo_new/Api/Request/User/point/RequestUserPoint.dart';
import 'package:gotilo_new/Api/Response/AllCollection/ResponseAllCollection.dart';
import 'package:gotilo_new/Api/Response/AllCollection/ResponseCollectionDetails.dart';
import 'package:gotilo_new/Api/Response/AllCollection/ResponseCollectionProductList.dart';
import 'package:gotilo_new/Api/Response/AllDeals/ResponseAllDeals.dart';
import 'package:gotilo_new/Api/Response/AllLatestRelease/ResponseAllLatestRelease.dart';
import 'package:gotilo_new/Api/Response/AllListings/ResponseAllListings.dart';
import 'package:gotilo_new/Api/Response/AllListings/ResponseSimilarListing.dart';
import 'package:gotilo_new/Api/Response/AllNewlyAdded/ResponseAllNewlyAdded.dart';
import 'package:gotilo_new/Api/Response/AllService/ResponseAllService.dart';
import 'package:gotilo_new/Api/Response/Banner/ResponseBanner.dart';
import 'package:gotilo_new/Api/Response/Blog/ResponseBlogData.dart';
import 'package:gotilo_new/Api/Response/Blog/ResponseBlogDetail.dart';
import 'package:gotilo_new/Api/Response/Cart/ResponseAddCart.dart';
import 'package:gotilo_new/Api/Response/Cart/ResponseCartAddress.dart';
import 'package:gotilo_new/Api/Response/Cart/ResponseCartDelete.dart';
import 'package:gotilo_new/Api/Response/Cart/ResponseCartItem.dart';
import 'package:gotilo_new/Api/Response/Cart/ResponseUpdateCart.dart';
import 'package:gotilo_new/Api/Response/CrackDeal/ResponseCrackDeal.dart';
import 'package:gotilo_new/Api/Response/Enquiry/ResponseAddEnquiry.dart';
import 'package:gotilo_new/Api/Response/Fav/ResponseAddFav.dart';
import 'package:gotilo_new/Api/Response/Home/ResponseHomeCollection.dart';
import 'package:gotilo_new/Api/Response/Home/ResponseHomeLatestRelease.dart';
import 'package:gotilo_new/Api/Response/Home/ResponseHomeService.dart';
import 'package:gotilo_new/Api/Response/LatestListing/ResponseHomeLatestListing.dart';
import 'package:gotilo_new/Api/Response/Login/ResponseLogin.dart';
import 'package:gotilo_new/Api/Response/Logout/ResponseLogout.dart';
import 'package:gotilo_new/Api/Response/Otp/ResponseLoginOtp.dart';
import 'package:gotilo_new/Api/Response/Otp/ResponseResetPassword.dart';
import 'package:gotilo_new/Api/Response/Otp/ResponseSendOtp.dart';
import 'package:gotilo_new/Api/Response/PlaceOrder/ResponsePlaceOrder.dart';
import 'package:gotilo_new/Api/Response/PrisePlan/ResponsePrisePlan.dart';
import 'package:gotilo_new/Api/Response/Product/ResponseProductDetail.dart';
import 'package:gotilo_new/Api/Response/Register/ResponseRegister.dart';
import 'package:gotilo_new/Api/Response/Review/ResponseAddReview.dart';
import 'package:gotilo_new/Api/Response/Review/ResponseReview.dart';
import 'package:gotilo_new/Api/Response/Search/ResponseSearch.dart';
import 'package:gotilo_new/Api/Response/Share/ResponseShare.dart';
import 'package:gotilo_new/Api/Response/SubCategoryList/ResponseSubCategoryList.dart';
import 'package:gotilo_new/Api/Response/SubCategoryList/ResponseSubCategoryProductList.dart';
import 'package:gotilo_new/Api/Response/SubCategoryList/ResponseSubcategoryListDetails.dart';
import 'package:gotilo_new/Api/Response/User/Billing/ResponseBillHistory.dart';
import 'package:gotilo_new/Api/Response/User/Billing/ResponseBilling.dart';
import 'package:gotilo_new/Api/Response/User/BookingHistory/ResponseBookingHistory.dart';
import 'package:gotilo_new/Api/Response/User/BookingHistory/ResponseBookingHistoryDetail.dart';
import 'package:gotilo_new/Api/Response/User/Dashboard/ResponseUserDashboard.dart';
import 'package:gotilo_new/Api/Response/User/Deal/ResponseCrackedDeal.dart';
import 'package:gotilo_new/Api/Response/User/Deal/ResponseUserDeal.dart';
import 'package:gotilo_new/Api/Response/User/Fav/ResponseFavData.dart';
import 'package:gotilo_new/Api/Response/User/Fav/ResponseFavDelete.dart';
import 'package:gotilo_new/Api/Response/User/HotelBooking/ResponseHotelBooking.dart';
import 'package:gotilo_new/Api/Response/User/HotelBooking/ResponseHotelBookingCancellation.dart';
import 'package:gotilo_new/Api/Response/User/HotelBooking/ResponseHotelBookingCancellationHistory.dart';
import 'package:gotilo_new/Api/Response/User/HotelBooking/ResponseHotelBookingDetail.dart';
import 'package:gotilo_new/Api/Response/User/HotelBooking/ResponseHotelBookingRoomHistory.dart';
import 'package:gotilo_new/Api/Response/User/HotelBooking/ResponseHotelBookingRoomPricePlan.dart';
import 'package:gotilo_new/Api/Response/User/MyOrder/ResponseMyOrder.dart';
import 'package:gotilo_new/Api/Response/User/MyOrder/ResponseMyOrderDetail.dart';
import 'package:gotilo_new/Api/Response/User/Notification/ResponseNotification.dart';
import 'package:gotilo_new/Api/Response/User/Profile/ResponseChangePassword.dart';
import 'package:gotilo_new/Api/Response/User/Profile/ResponseDeleteAddress.dart';
import 'package:gotilo_new/Api/Response/User/Profile/ResponseEditAddress.dart';
import 'package:gotilo_new/Api/Response/User/Profile/ResponseProfileAddress.dart';
import 'package:gotilo_new/Api/Response/User/Profile/ResponseUpdateProfile.dart';
import 'package:gotilo_new/Api/Response/User/point/ResponsePointDetail.dart';
import 'package:gotilo_new/Api/Response/User/point/ResponseUserPoint.dart';

import 'ApiList.dart';
import 'ApiUtils.dart';
import 'package:stack_trace/stack_trace.dart';

import 'Request/Blog/RequestBlogsData.dart';
import 'Request/Otp/RequestLoginOtp.dart';
import 'Request/User/Menu/RequestMenu.dart';
import 'Response/AboutUs/ResponseAboutUs.dart';
import 'Response/City/ResponseCity.dart';
import 'Response/Home/ResponseHome.dart';
import 'Response/Home/ResponseHomeDeal.dart';
import 'Response/Otp/ResponseVerifyOtp.dart';
import 'Response/User/HotelBooking/ResponseHotelBookingServiceHistory.dart';
import 'Response/User/Menu/ResponseMenu.dart';
import 'Response/User/Profile/ResponseProfile.dart';

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


  static Future<ResponsePrisePlan?> callPrisePlan()
  async {
    //TODO: STEP 1 : HERE CHANGES REQUEST AND RESPONSE MODEL NAME
    String TAG =
        (_showLocationLogs == true ? Trace.current().frames[0].location : "") +
            Trace.current().frames[0].member!;
    FormData formData = FormData.fromMap(
        ApiUtils.getRequestMapForDio());
    try {
      log("Request URL = ${ApiList.urlPrisePlan}", name: TAG);
      log("Request Data= ${formData.fields}", name: TAG);
      //TODO: STEP 2 : HERE CHANGES REQUEST URL
      Response response =
      await _getDio().get(ApiList.urlPrisePlan, data: formData);
      log("Response status or statusCode  = ${response.statusCode}", name: TAG);
      if (response.statusCode == HttpStatus.ok) {
        if (response.data != null) {
          log("Response Data = ${response.data}", name: TAG);
          //TODO: STEP 3 : HERE CHANGES RESPONSE MODEL NAME
          return ResponsePrisePlan.fromJson(response.data);
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



  static Future<ResponseAboutUs?> callAboutUs()
  async {
    //TODO: STEP 1 : HERE CHANGES REQUEST AND RESPONSE MODEL NAME
    String TAG =
        (_showLocationLogs == true ? Trace.current().frames[0].location : "") +
            Trace.current().frames[0].member!;
    FormData formData = FormData.fromMap(
        ApiUtils.getRequestMapForDio());
    try {
      log("Request URL = ${ApiList.urlAboutUs}", name: TAG);
      log("Request Data= ${formData.fields}", name: TAG);
      //TODO: STEP 2 : HERE CHANGES REQUEST URL
      Response response =
      await _getDio().get(ApiList.urlAboutUs, data: formData);
      log("Response status or statusCode  = ${response.statusCode}", name: TAG);
      if (response.statusCode == HttpStatus.ok) {
        if (response.data != null) {
          log("Response Data = ${response.data}", name: TAG);
          //TODO: STEP 3 : HERE CHANGES RESPONSE MODEL NAME
          return ResponseAboutUs.fromJson(response.data);
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
        (_showLocationLogs == true ? Trace.current().frames[0].location : "")
            +
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

  static Future<ResponseCity?> callCity()
  async {
    //TODO: STEP 1 : HERE CHANGES REQUEST AND RESPONSE MODEL NAME
    String TAG =
        (_showLocationLogs == true ? Trace.current().frames[0].location : "") +
            Trace.current().frames[0].member!;
    FormData formData = FormData.fromMap(
        ApiUtils.getRequestMapForDio());
    try {
      log("Request URL = ${ApiList.urlCity}", name: TAG);
      log("Request Data= ${formData.fields}", name: TAG);
      //TODO: STEP 2 : HERE CHANGES REQUEST URL
      Response response =
      await _getDio().get(ApiList.urlCity, data: formData);
      log("Response status or statusCode  = ${response.statusCode}", name: TAG);
      if (response.statusCode == HttpStatus.ok) {
        if (response.data != null) {
          log("Response Data = ${response.data}", name: TAG);
          //TODO: STEP 3 : HERE CHANGES RESPONSE MODEL NAME
          return ResponseCity.fromJson(response.data);
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

  static Future<ResponseAllCollection?> callAllCollection(RequestAllCollection model)
  async {
    //TODO: STEP 1 : HERE CHANGES REQUEST AND RESPONSE MODEL NAME
    String TAG =
        (_showLocationLogs == true ? Trace.current().frames[0].location : "") +
            Trace.current().frames[0].member!;
    FormData formData = FormData.fromMap(
        ApiUtils.getRequestMapForDio(requestString: jsonEncode(model)));
    try {
      log("Request URL = ${ApiList.urlAllCollection}", name: TAG);
      log("Request Data= ${formData.fields}", name: TAG);
      //TODO: STEP 2 : HERE CHANGES REQUEST URL
      Response response =
      await _getDio().post(ApiList.urlAllCollection, data: formData);
      log("Response status or statusCode  = ${response.statusCode}", name: TAG);
      if (response.statusCode == HttpStatus.ok) {
        if (response.data != null) {
          log("Response Data = ${response.data}", name: TAG);
          //TODO: STEP 3 : HERE CHANGES RESPONSE MODEL NAME
          return ResponseAllCollection.fromJson(response.data);
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

  static Future<ResponseAllLatestRelease?> callAllLatestRelease(RequestAllLatestRelease model)
  async {
    //TODO: STEP 1 : HERE CHANGES REQUEST AND RESPONSE MODEL NAME
    String TAG =
        (_showLocationLogs == true ? Trace.current().frames[0].location : "") +
            Trace.current().frames[0].member!;
    FormData formData = FormData.fromMap(
        ApiUtils.getRequestMapForDio(requestString: jsonEncode(model)));
    try {
      log("Request URL = ${ApiList.urlAllLatestRelease}", name: TAG);
      log("Request Data= ${formData.fields}", name: TAG);
      //TODO: STEP 2 : HERE CHANGES REQUEST URL
      Response response =
      await _getDio().post(ApiList.urlAllLatestRelease, data: formData);
      log("Response status or statusCode  = ${response.statusCode}", name: TAG);
      if (response.statusCode == HttpStatus.ok) {
        if (response.data != null) {
          log("Response Data = ${response.data}", name: TAG);
          //TODO: STEP 3 : HERE CHANGES RESPONSE MODEL NAME
          return ResponseAllLatestRelease.fromJson(response.data);
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

  static Future<ResponseAllNewlyAdded?> callAllNewlyAdded(RequestAllNewlyAdded model)
  async {
    //TODO: STEP 1 : HERE CHANGES REQUEST AND RESPONSE MODEL NAME
    String TAG =
        (_showLocationLogs == true ? Trace.current().frames[0].location : "") +
            Trace.current().frames[0].member!;
    FormData formData = FormData.fromMap(
        ApiUtils.getRequestMapForDio(requestString: jsonEncode(model)));
    try {
      log("Request URL = ${ApiList.urlAllNewlyAdded}", name: TAG);
      log("Request Data= ${formData.fields}", name: TAG);
      //TODO: STEP 2 : HERE CHANGES REQUEST URL
      Response response =
      await _getDio().post(ApiList.urlAllNewlyAdded, data: formData);
      log("Response status or statusCode  = ${response.statusCode}", name: TAG);
      if (response.statusCode == HttpStatus.ok) {
        if (response.data != null) {
          log("Response Data = ${response.data}", name: TAG);
          //TODO: STEP 3 : HERE CHANGES RESPONSE MODEL NAME
          return ResponseAllNewlyAdded.fromJson(response.data);
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

  static Future<ResponseAllService?> callAllService(RequestAllService model)
  async {
    //TODO: STEP 1 : HERE CHANGES REQUEST AND RESPONSE MODEL NAME
    String TAG =
        (_showLocationLogs == true ? Trace.current().frames[0].location : "") +
            Trace.current().frames[0].member!;
    FormData formData = FormData.fromMap(
        ApiUtils.getRequestMapForDio(requestString: jsonEncode(model)));
    try {
      log("Request URL = ${ApiList.urlAllService}", name: TAG);
      log("Request Data= ${formData.fields}", name: TAG);
      //TODO: STEP 2 : HERE CHANGES REQUEST URL
      Response response =
      await _getDio().post(ApiList.urlAllService, data: formData);
      log("Response status or statusCode  = ${response.statusCode}", name: TAG);
      if (response.statusCode == HttpStatus.ok) {
        if (response.data != null) {
          log("Response Data = ${response.data}", name: TAG);
          //TODO: STEP 3 : HERE CHANGES RESPONSE MODEL NAME
          return ResponseAllService.fromJson(response.data);
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


  static Future<ResponseAllDeals?> callAllDeals(RequestAllDeals model)
  async {
    //TODO: STEP 1 : HERE CHANGES REQUEST AND RESPONSE MODEL NAME
    String TAG =
        (_showLocationLogs == true ? Trace.current().frames[0].location : "") +
            Trace.current().frames[0].member!;
    FormData formData = FormData.fromMap(
        ApiUtils.getRequestMapForDio(requestString: jsonEncode(model)));
    try {
      log("Request URL = ${ApiList.urlAllDeals}", name: TAG);
      log("Request Data= ${formData.fields}", name: TAG);
      //TODO: STEP 2 : HERE CHANGES REQUEST URL
      Response response =
      await _getDio().post(ApiList.urlAllDeals, data: formData);
      log("Response status or statusCode  = ${response.statusCode}", name: TAG);
      if (response.statusCode == HttpStatus.ok) {
        if (response.data != null) {
          log("Response Data = ${response.data}", name: TAG);
          //TODO: STEP 3 : HERE CHANGES RESPONSE MODEL NAME
          return ResponseAllDeals.fromJson(response.data);
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

  static Future<ResponseCollectionDetail?> callCollectionDetail(RequestCollectionDetail model)
  async {
    //TODO: STEP 1 : HERE CHANGES REQUEST AND RESPONSE MODEL NAME
    String TAG =
        (_showLocationLogs == true ? Trace.current().frames[0].location : "") +
            Trace.current().frames[0].member!;
    FormData formData = FormData.fromMap(
        ApiUtils.getRequestMapForDio(requestString: jsonEncode(model)));
    try {
      log("Request URL = ${ApiList.urlCollectionDetail}", name: TAG);
      log("Request Data= ${formData.fields}", name: TAG);
      //TODO: STEP 2 : HERE CHANGES REQUEST URL
      Response response =
      await _getDio().post(ApiList.urlCollectionDetail, data: formData);
      log("Response status or statusCode  = ${response.statusCode}", name: TAG);
      if (response.statusCode == HttpStatus.ok) {
        if (response.data != null) {
          log("Response Data = ${response.data}", name: TAG);
          //TODO: STEP 3 : HERE CHANGES RESPONSE MODEL NAME
          return ResponseCollectionDetail.fromJson(response.data);
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

  static Future<ResponseCollectionProductList?> callCollectionProductList(RequestCollectionProductListings model)
  async {
    //TODO: STEP 1 : HERE CHANGES REQUEST AND RESPONSE MODEL NAME
    String TAG =
        (_showLocationLogs == true ? Trace.current().frames[0].location : "") +
            Trace.current().frames[0].member!;
    FormData formData = FormData.fromMap(
        ApiUtils.getRequestMapForDio(requestString: jsonEncode(model)));
    try {
      log("Request URL = ${ApiList.urlCollectionProductList}", name: TAG);
      log("Request Data= ${formData.fields}", name: TAG);
      //TODO: STEP 2 : HERE CHANGES REQUEST URL
      Response response =
      await _getDio().post(ApiList.urlCollectionProductList, data: formData);
      log("Response status or statusCode  = ${response.statusCode}", name: TAG);
      if (response.statusCode == HttpStatus.ok) {
        if (response.data != null) {
          log("Response Data = ${response.data}", name: TAG);
          //TODO: STEP 3 : HERE CHANGES RESPONSE MODEL NAME
          return ResponseCollectionProductList.fromJson(response.data);
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




  static Future<ResponseAllListing?> callAllListings(RequestAllListings model)
  async {
    //TODO: STEP 1 : HERE CHANGES REQUEST AND RESPONSE MODEL NAME
    String TAG =
        (_showLocationLogs == true ? Trace.current().frames[0].location : "") +
            Trace.current().frames[0].member!;
    FormData formData = FormData.fromMap(
        ApiUtils.getRequestMapForDio(requestString: jsonEncode(model)));
    try {
      log("Request URL = ${ApiList.urlAllListings}", name: TAG);
      log("Request Data= ${formData.fields}", name: TAG);
      //TODO: STEP 2 : HERE CHANGES REQUEST URL
      Response response =
      await _getDio().post(ApiList.urlAllListings, data: formData);
      log("Response status or statusCode  = ${response.statusCode}", name: TAG);
      if (response.statusCode == HttpStatus.ok) {
        if (response.data != null) {
          log("Response Data = ${response.data}", name: TAG);
          //TODO: STEP 3 : HERE CHANGES RESPONSE MODEL NAME
          return ResponseAllListing.fromJson(response.data);
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


  static Future<ResponseSubCategoryList?> callSubCategoryList(RequestSubCategoryList model)
  async {
    //TODO: STEP 1 : HERE CHANGES REQUEST AND RESPONSE MODEL NAME
    String TAG =
        (_showLocationLogs == true ? Trace.current().frames[0].location : "") +
            Trace.current().frames[0].member!;
    FormData formData = FormData.fromMap(
        ApiUtils.getRequestMapForDio(requestString: jsonEncode(model)));
    try {
      log("Request URL = ${ApiList.urlSubCategoryList}", name: TAG);
      log("Request Data= ${formData.fields}", name: TAG);
      //TODO: STEP 2 : HERE CHANGES REQUEST URL
      Response response =
      await _getDio().post(ApiList.urlSubCategoryList, data: formData);
      log("Response status or statusCode  = ${response.statusCode}", name: TAG);
      if (response.statusCode == HttpStatus.ok) {
        if (response.data != null) {
          log("Response Data = ${response.data}", name: TAG);
          //TODO: STEP 3 : HERE CHANGES RESPONSE MODEL NAME
          return ResponseSubCategoryList.fromJson(response.data);
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


  static Future<ResponseSubcategoryListDetails?> callSubCategoryListDetails (RequestSubCategoryListDetails model)
  async {
    //TODO: STEP 1 : HERE CHANGES REQUEST AND RESPONSE MODEL NAME
    String TAG =
        (_showLocationLogs == true ? Trace.current().frames[0].location : "") +
            Trace.current().frames[0].member!;
    FormData formData = FormData.fromMap(
        ApiUtils.getRequestMapForDio(requestString: jsonEncode(model)));
    try {
      log("Request URL = ${ApiList.urlSubCategoryListDetails}", name: TAG);
      log("Request Data= ${formData.fields}", name: TAG);
      //TODO: STEP 2 : HERE CHANGES REQUEST URL
      Response response =
      await _getDio().post(ApiList.urlSubCategoryListDetails, data: formData);
      log("Response status or statusCode  = ${response.statusCode}", name: TAG);
      if (response.statusCode == HttpStatus.ok) {
        if (response.data != null) {
          log("Response Data = ${response.data}", name: TAG);
          //TODO: STEP 3 : HERE CHANGES RESPONSE MODEL NAME
          return ResponseSubcategoryListDetails.fromJson(response.data);
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



  static Future<ResponseSubcategoryProductList?> callSubCategoryProductList (RequestSubCategoryProductList model)
  async {
    //TODO: STEP 1 : HERE CHANGES REQUEST AND RESPONSE MODEL NAME
    String TAG =
        (_showLocationLogs == true ? Trace.current().frames[0].location : "") +
            Trace.current().frames[0].member!;
    FormData formData = FormData.fromMap(
        ApiUtils.getRequestMapForDio(requestString: jsonEncode(model)));
    try {
      log("Request URL = ${ApiList.urlSubCategoryProductList}", name: TAG);
      log("Request Data= ${formData.fields}", name: TAG);
      //TODO: STEP 2 : HERE CHANGES REQUEST URL
      Response response =
      await _getDio().post(ApiList.urlSubCategoryProductList, data: formData);
      log("Response status or statusCode  = ${response.statusCode}", name: TAG);
      if (response.statusCode == HttpStatus.ok) {
        if (response.data != null) {
          log("Response Data = ${response.data}", name: TAG);
          //TODO: STEP 3 : HERE CHANGES RESPONSE MODEL NAME
          return ResponseSubcategoryProductList.fromJson(response.data);
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


  static Future<ResponseSearchData?> callSearchData (RequestSearch model)
  async {
    //TODO: STEP 1 : HERE CHANGES REQUEST AND RESPONSE MODEL NAME
    String TAG =
        (_showLocationLogs == true ? Trace.current().frames[0].location : "") +
            Trace.current().frames[0].member!;
    FormData formData = FormData.fromMap(
        ApiUtils.getRequestMapForDio(requestString: jsonEncode(model)));
    try {
      log("Request URL = ${ApiList.urlSearch}", name: TAG);
      log("Request Data= ${formData.fields}", name: TAG);
      //TODO: STEP 2 : HERE CHANGES REQUEST URL
      Response response =
      await _getDio().post(ApiList.urlSearch, data: formData);
      log("Response status or statusCode  = ${response.statusCode}", name: TAG);
      if (response.statusCode == HttpStatus.ok) {
        if (response.data != null) {
          log("Response Data = ${response.data}", name: TAG);
          //TODO: STEP 3 : HERE CHANGES RESPONSE MODEL NAME
          return ResponseSearchData.fromJson(response.data);
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


  static Future<ResponseBlogsData?> callBlogsData (RequestBlogs model)
  async {
    //TODO: STEP 1 : HERE CHANGES REQUEST AND RESPONSE MODEL NAME
    String TAG =
        (_showLocationLogs == true ? Trace.current().frames[0].location : "") +
            Trace.current().frames[0].member!;
    FormData formData = FormData.fromMap(
        ApiUtils.getRequestMapForDio(requestString: jsonEncode(model)));
    try {
      log("Request URL = ${ApiList.urlBlogs}", name: TAG);
      log("Request Data= ${formData.fields}", name: TAG);
      //TODO: STEP 2 : HERE CHANGES REQUEST URL
      Response response =
      await _getDio().post(ApiList.urlBlogs, data: formData);
      log("Response status or statusCode  = ${response.statusCode}", name: TAG);
      if (response.statusCode == HttpStatus.ok) {
        if (response.data != null) {
          log("Response Data = ${response.data}", name: TAG);
          //TODO: STEP 3 : HERE CHANGES RESPONSE MODEL NAME
          return ResponseBlogsData.fromJson(response.data);
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



  static Future<ResponseSimilarListing?> callSimilarListing (RequestSimilarListing model)
  async {
    //TODO: STEP 1 : HERE CHANGES REQUEST AND RESPONSE MODEL NAME
    String TAG =
        (_showLocationLogs == true ? Trace.current().frames[0].location : "") +
            Trace.current().frames[0].member!;
    FormData formData = FormData.fromMap(
        ApiUtils.getRequestMapForDio(requestString: jsonEncode(model)));
    try {
      log("Request URL = ${ApiList.urlSimilarListing}", name: TAG);
      log("Request Data= ${formData.fields}", name: TAG);
      //TODO: STEP 2 : HERE CHANGES REQUEST URL
      Response response =
      await _getDio().post(ApiList.urlSimilarListing, data: formData);
      log("Response status or statusCode  = ${response.statusCode}", name: TAG);
      if (response.statusCode == HttpStatus.ok) {
        if (response.data != null) {
          log("Response Data = ${response.data}", name: TAG);
          //TODO: STEP 3 : HERE CHANGES RESPONSE MODEL NAME
          return ResponseSimilarListing.fromJson(response.data);
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




  static Future<ResponseLogin?> callLogin (RequestLogin model)
  async {
    //TODO: STEP 1 : HERE CHANGES REQUEST AND RESPONSE MODEL NAME
    String TAG =
        (_showLocationLogs == true ? Trace.current().frames[0].location : "") +
            Trace.current().frames[0].member!;
    FormData formData = FormData.fromMap(
        ApiUtils.getRequestMapForDio(requestString: jsonEncode(model)));
    try {
      log("Request URL = ${ApiList.urlLogin}", name: TAG);
      log("Request Data= ${formData.fields}", name: TAG);
      //TODO: STEP 2 : HERE CHANGES REQUEST URL
      Response response =
      await _getDio().post(ApiList.urlLogin, data: formData,/*options: Options(
        headers: {
          "Accept": "application/json",
          "Content-Type": "multipart/form-data",
        },
      ),*/);
      log("Response status or statusCode  = ${response.statusCode}", name: TAG);
      if (response.statusCode == HttpStatus.ok) {
        if (response.data != null) {
          log("Response Data = ${response.data}", name: TAG);
          //TODO: STEP 3 : HERE CHANGES RESPONSE MODEL NAME
          return ResponseLogin.fromJson(response.data);
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


  static Future<ResponseLoginOtp?> callLoginOtp (RequestLoginOtp model)
  async {
    //TODO: STEP 1 : HERE CHANGES REQUEST AND RESPONSE MODEL NAME
    String TAG =
        (_showLocationLogs == true ? Trace.current().frames[0].location : "") +
            Trace.current().frames[0].member!;
    FormData formData = FormData.fromMap(
        ApiUtils.getRequestMapForDio(requestString: jsonEncode(model)));
    try {
      log("Request URL = ${ApiList.urlLoginOtp}", name: TAG);
      log("Request Data= ${formData.fields}", name: TAG);
      //TODO: STEP 2 : HERE CHANGES REQUEST URL
      Response response =
      await _getDio().post(ApiList.urlLoginOtp, data: formData);
      log("Response status or statusCode  = ${response.statusCode}", name: TAG);
      if (response.statusCode == HttpStatus.ok) {
        if (response.data != null) {
          log("Response Data = ${response.data}", name: TAG);
          //TODO: STEP 3 : HERE CHANGES RESPONSE MODEL NAME
          return ResponseLoginOtp.fromJson(response.data);
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



  static Future<ResponseRegister?> callRegister (RequestRegister model)
  async {
    //TODO: STEP 1 : HERE CHANGES REQUEST AND RESPONSE MODEL NAME
    String TAG =
        (_showLocationLogs == true ? Trace.current().frames[0].location : "") +
            Trace.current().frames[0].member!;
    FormData formData = FormData.fromMap(
        ApiUtils.getRequestMapForDio(requestString: jsonEncode(model)));
    try {
      log("Request URL = ${ApiList.urlRegister}", name: TAG);
      log("Request Data= ${formData.fields}", name: TAG);
      //TODO: STEP 2 : HERE CHANGES REQUEST URL
      Response response =
      await _getDio().post(ApiList.urlRegister, data: formData);
      log("Response status or statusCode  = ${response.statusCode}", name: TAG);
      if (response.statusCode == HttpStatus.ok) {
        if (response.data != null) {
          log("Response Data = ${response.data}", name: TAG);
          //TODO: STEP 3 : HERE CHANGES RESPONSE MODEL NAME
          return ResponseRegister.fromJson(response.data);
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


  static Future<ResponseLogout?> callLogout (RequestLogout model)
  async {
    //TODO: STEP 1 : HERE CHANGES REQUEST AND RESPONSE MODEL NAME
    String TAG =
        (_showLocationLogs == true ? Trace.current().frames[0].location : "") +
            Trace.current().frames[0].member!;
    FormData formData = FormData.fromMap(
        ApiUtils.getRequestMapForDio(requestString: jsonEncode(model)));
    try {
      log("Request URL = ${ApiList.urlLogout}", name: TAG);
      log("Request Data= ${formData.fields}", name: TAG);
      //TODO: STEP 2 : HERE CHANGES REQUEST URL
      Response response =
      await _getDio().post(ApiList.urlLogout, data: formData);
      log("Response status or statusCode  = ${response.statusCode}", name: TAG);
      if (response.statusCode == HttpStatus.ok) {
        if (response.data != null) {
          log("Response Data = ${response.data}", name: TAG);
          //TODO: STEP 3 : HERE CHANGES RESPONSE MODEL NAME
          return ResponseLogout.fromJson(response.data);
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

  static Future<ResponseBlogDetail?> callBlogDetail (RequestBlogDetail model)
  async {
    //TODO: STEP 1 : HERE CHANGES REQUEST AND RESPONSE MODEL NAME
    String TAG =
        (_showLocationLogs == true ? Trace.current().frames[0].location : "") +
            Trace.current().frames[0].member!;
    FormData formData = FormData.fromMap(
        ApiUtils.getRequestMapForDio(requestString: jsonEncode(model)));
    try {
      log("Request URL = ${ApiList.urlBlogDetail}", name: TAG);
      log("Request Data= ${formData.fields}", name: TAG);
      //TODO: STEP 2 : HERE CHANGES REQUEST URL
      Response response =
      await _getDio().post(ApiList.urlBlogDetail, data: formData);
      log("Response status or statusCode  = ${response.statusCode}", name: TAG);
      if (response.statusCode == HttpStatus.ok) {
        if (response.data != null) {
          log("Response Data = ${response.data}", name: TAG);
          //TODO: STEP 3 : HERE CHANGES RESPONSE MODEL NAME
          return ResponseBlogDetail.fromJson(response.data);
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


  static Future<ResponseAddCart?> callAddCart (RequestAddCart model)
  async {
    //TODO: STEP 1 : HERE CHANGES REQUEST AND RESPONSE MODEL NAME
    String TAG =
        (_showLocationLogs == true ? Trace.current().frames[0].location : "") +
            Trace.current().frames[0].member!;
    FormData formData = FormData.fromMap(
        ApiUtils.getRequestMapForDio(requestString: jsonEncode(model)));
    try {
      log("Request URL = ${ApiList.urlAddCart}", name: TAG);
      log("Request Data= ${formData.fields}", name: TAG);
      //TODO: STEP 2 : HERE CHANGES REQUEST URL
      Response response =
      await _getDio().post(ApiList.urlAddCart, data: formData);
      log("Response status or statusCode  = ${response.statusCode}", name: TAG);
      if (response.statusCode == HttpStatus.ok) {
        if (response.data != null) {
          log("Response Data = ${response.data}", name: TAG);
          //TODO: STEP 3 : HERE CHANGES RESPONSE MODEL NAME
          return ResponseAddCart.fromJson(response.data);
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


  static Future<ResponseAddEnquiry?> callAddEnquiry (RequestAddEnquiry model)
  async {
    //TODO: STEP 1 : HERE CHANGES REQUEST AND RESPONSE MODEL NAME
    String TAG =
        (_showLocationLogs == true ? Trace.current().frames[0].location : "") +
            Trace.current().frames[0].member!;
    FormData formData = FormData.fromMap(
        ApiUtils.getRequestMapForDio(requestString: jsonEncode(model)));
    try {
      log("Request URL = ${ApiList.urlAddEnquiry}", name: TAG);
      log("Request Data= ${formData.fields}", name: TAG);
      //TODO: STEP 2 : HERE CHANGES REQUEST URL
      Response response =
      await _getDio().post(ApiList.urlAddEnquiry, data: formData);
      log("Response status or statusCode  = ${response.statusCode}", name: TAG);
      if (response.statusCode == HttpStatus.ok) {
        if (response.data != null) {
          log("Response Data = ${response.data}", name: TAG);
          //TODO: STEP 3 : HERE CHANGES RESPONSE MODEL NAME
          return ResponseAddEnquiry.fromJson(response.data);
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


  static Future<ResponseProductDetail?> callProductDetail (RequestProductDetail model)
  async {
    //TODO: STEP 1 : HERE CHANGES REQUEST AND RESPONSE MODEL NAME
    String TAG =
        (_showLocationLogs == true ? Trace.current().frames[0].location : "") +
            Trace.current().frames[0].member!;
    FormData formData = FormData.fromMap(
        ApiUtils.getRequestMapForDio(requestString: jsonEncode(model)));
    try {
      log("Request URL = ${ApiList.urlProductDetail}", name: TAG);
      log("Request Data= ${formData.fields}", name: TAG);
      //TODO: STEP 2 : HERE CHANGES REQUEST URL
      Response response =
      await _getDio().post(ApiList.urlProductDetail, data: formData);
      log("Response status or statusCode  = ${response.statusCode}", name: TAG);
      if (response.statusCode == HttpStatus.ok) {
        if (response.data != null) {
          log("Response Data = ${response.data}", name: TAG);
          //TODO: STEP 3 : HERE CHANGES RESPONSE MODEL NAME
          return ResponseProductDetail.fromJson(response.data);
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


  static Future<ResponseCartItem?> callCartItem (RequestCartItem model)
  async {
    //TODO: STEP 1 : HERE CHANGES REQUEST AND RESPONSE MODEL NAME
    String TAG =
        (_showLocationLogs == true ? Trace.current().frames[0].location : "") +
            Trace.current().frames[0].member!;
    FormData formData = FormData.fromMap(
        ApiUtils.getRequestMapForDio(requestString: jsonEncode(model)));
    try {
      log("Request URL = ${ApiList.urlCartItem}", name: TAG);
      log("Request Data= ${formData.fields}", name: TAG);
      //TODO: STEP 2 : HERE CHANGES REQUEST URL
      Response response =
      await _getDio().post(ApiList.urlCartItem, data: formData);
      log("Response status or statusCode  = ${response.statusCode}", name: TAG);
      if (response.statusCode == HttpStatus.ok) {
        if (response.data != null) {
          log("Response Data = ${response.data}", name: TAG);
          //TODO: STEP 3 : HERE CHANGES RESPONSE MODEL NAME
          return ResponseCartItem.fromJson(response.data);
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


  static Future<ResponseUpdateCart?> callCartUpdateCart (RequestUpdateCart model)
  async {
    //TODO: STEP 1 : HERE CHANGES REQUEST AND RESPONSE MODEL NAME
    String TAG =
        (_showLocationLogs == true ? Trace.current().frames[0].location : "") +
            Trace.current().frames[0].member!;
    FormData formData = FormData.fromMap(
        ApiUtils.getRequestMapForDio(requestString: jsonEncode(model)));
    try {
      log("Request URL = ${ApiList.urlUpdateCart}", name: TAG);
      log("Request Data= ${formData.fields}", name: TAG);
      //TODO: STEP 2 : HERE CHANGES REQUEST URL
      Response response =
      await _getDio().post(ApiList.urlUpdateCart, data: formData);
      log("Response status or statusCode  = ${response.statusCode}", name: TAG);
      if (response.statusCode == HttpStatus.ok) {
        if (response.data != null) {
          log("Response Data = ${response.data}", name: TAG);
          //TODO: STEP 3 : HERE CHANGES RESPONSE MODEL NAME
          return ResponseUpdateCart.fromJson(response.data);
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


  static Future<ResponseCartAddress?> callCartAddress (RequestCartAddress model)
  async {
    //TODO: STEP 1 : HERE CHANGES REQUEST AND RESPONSE MODEL NAME
    String TAG =
        (_showLocationLogs == true ? Trace.current().frames[0].location : "") +
            Trace.current().frames[0].member!;
    FormData formData = FormData.fromMap(
        ApiUtils.getRequestMapForDio(requestString: jsonEncode(model)));
    try {
      log("Request URL = ${ApiList.urlCartAddress}", name: TAG);
      log("Request Data= ${formData.fields}", name: TAG);
      //TODO: STEP 2 : HERE CHANGES REQUEST URL
      Response response =
      await _getDio().post(ApiList.urlCartAddress, data: formData);
      log("Response status or statusCode  = ${response.statusCode}", name: TAG);
      if (response.statusCode == HttpStatus.ok) {
        if (response.data != null) {
          log("Response Data = ${response.data}", name: TAG);
          //TODO: STEP 3 : HERE CHANGES RESPONSE MODEL NAME
          return ResponseCartAddress.fromJson(response.data);
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



  static Future<ResponseCartDelete?> callCartDelete (RequestCartDelete model)
  async {
    //TODO: STEP 1 : HERE CHANGES REQUEST AND RESPONSE MODEL NAME
    String TAG =
        (_showLocationLogs == true ? Trace.current().frames[0].location : "") +
            Trace.current().frames[0].member!;
    FormData formData = FormData.fromMap(
        ApiUtils.getRequestMapForDio(requestString: jsonEncode(model)));
    try {
      log("Request URL = ${ApiList.urlCartDelete}", name: TAG);
      log("Request Data= ${formData.fields}", name: TAG);
      //TODO: STEP 2 : HERE CHANGES REQUEST URL
      Response response =
      await _getDio().post(ApiList.urlCartDelete, data: formData);
      log("Response status or statusCode  = ${response.statusCode}", name: TAG);
      if (response.statusCode == HttpStatus.ok) {
        if (response.data != null) {
          log("Response Data = ${response.data}", name: TAG);
          //TODO: STEP 3 : HERE CHANGES RESPONSE MODEL NAME
          return ResponseCartDelete.fromJson(response.data);
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



  static Future<ResponsePlaceOrder?> callPlaceOrder (RequestPlaceOrder model)
  async {
    //TODO: STEP 1 : HERE CHANGES REQUEST AND RESPONSE MODEL NAME
    String TAG =
        (_showLocationLogs == true ? Trace.current().frames[0].location : "") +
            Trace.current().frames[0].member!;
    FormData formData = FormData.fromMap(
        ApiUtils.getRequestMapForDio(requestString: jsonEncode(model)));
    try {
      log("Request URL = ${ApiList.urlPlaceOrder}", name: TAG);
      log("Request Data= ${formData.fields}", name: TAG);
      //TODO: STEP 2 : HERE CHANGES REQUEST URL
      Response response =
      await _getDio().post(ApiList.urlPlaceOrder, data: formData);
      log("Response status or statusCode  = ${response.statusCode}", name: TAG);
      if (response.statusCode == HttpStatus.ok) {
        if (response.data != null) {
          log("Response Data = ${response.data}", name: TAG);
          //TODO: STEP 3 : HERE CHANGES RESPONSE MODEL NAME
          return ResponsePlaceOrder.fromJson(response.data);
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


  static Future<ResponseSendOtp?> callSendOtp (RequestSendOtp model)
  async {
    //TODO: STEP 1 : HERE CHANGES REQUEST AND RESPONSE MODEL NAME
    String TAG =
        (_showLocationLogs == true ? Trace.current().frames[0].location : "") +
            Trace.current().frames[0].member!;
    FormData formData = FormData.fromMap(
        ApiUtils.getRequestMapForDio(requestString: jsonEncode(model)));
    try {
      log("Request URL = ${ApiList.urlSendOtp}", name: TAG);
      log("Request Data= ${formData.fields}", name: TAG);
      //TODO: STEP 2 : HERE CHANGES REQUEST URL
      Response response =
      await _getDio().post(ApiList.urlSendOtp, data: formData);
      log("Response status or statusCode  = ${response.statusCode}", name: TAG);
      if (response.statusCode == HttpStatus.ok) {
        if (response.data != null) {
          log("Response Data = ${response.data}", name: TAG);
          //TODO: STEP 3 : HERE CHANGES RESPONSE MODEL NAME
          return ResponseSendOtp.fromJson(response.data);
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



  static Future<ResponseVerifyOtp?> callVerifyOtp (RequestVerifyOtp model)
  async {
    //TODO: STEP 1 : HERE CHANGES REQUEST AND RESPONSE MODEL NAME
    String TAG =
        (_showLocationLogs == true ? Trace.current().frames[0].location : "") +
            Trace.current().frames[0].member!;
    FormData formData = FormData.fromMap(
        ApiUtils.getRequestMapForDio(requestString: jsonEncode(model)));
    try {
      log("Request URL = ${ApiList.urlVerifyOtp}", name: TAG);
      log("Request Data= ${formData.fields}", name: TAG);
      //TODO: STEP 2 : HERE CHANGES REQUEST URL
      Response response =
      await _getDio().post(ApiList.urlVerifyOtp, data: formData);
      log("Response status or statusCode  = ${response.statusCode}", name: TAG);
      if (response.statusCode == HttpStatus.ok) {
        if (response.data != null) {
          log("Response Data = ${response.data}", name: TAG);
          //TODO: STEP 3 : HERE CHANGES RESPONSE MODEL NAME
          return ResponseVerifyOtp.fromJson(response.data);
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


  static Future<ResponseResetPassword?> callResetPassword (RequestResetPassword model)
  async {
    //TODO: STEP 1 : HERE CHANGES REQUEST AND RESPONSE MODEL NAME
    String TAG =
        (_showLocationLogs == true ? Trace.current().frames[0].location : "") +
            Trace.current().frames[0].member!;
    FormData formData = FormData.fromMap(
        ApiUtils.getRequestMapForDio(requestString: jsonEncode(model)));
    try {
      log("Request URL = ${ApiList.urlResetPassword}", name: TAG);
      log("Request Data= ${formData.fields}", name: TAG);
      //TODO: STEP 2 : HERE CHANGES REQUEST URL
      Response response =
      await _getDio().post(ApiList.urlResetPassword, data: formData);
      log("Response status or statusCode  = ${response.statusCode}", name: TAG);
      if (response.statusCode == HttpStatus.ok) {
        if (response.data != null) {
          log("Response Data = ${response.data}", name: TAG);
          //TODO: STEP 3 : HERE CHANGES RESPONSE MODEL NAME
          return ResponseResetPassword.fromJson(response.data);
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


  static Future<ResponseAddFav?> callAddFav (RequestAddFav model)
  async {
    //TODO: STEP 1 : HERE CHANGES REQUEST AND RESPONSE MODEL NAME
    String TAG =
        (_showLocationLogs == true ? Trace.current().frames[0].location : "") +
            Trace.current().frames[0].member!;
    FormData formData = FormData.fromMap(
        ApiUtils.getRequestMapForDio(requestString: jsonEncode(model)));
    try {
      log("Request URL = ${ApiList.urlAddFav}", name: TAG);
      log("Request Data= ${formData.fields}", name: TAG);
      //TODO: STEP 2 : HERE CHANGES REQUEST URL
      Response response =
      await _getDio().post(ApiList.urlAddFav, data: formData);
      log("Response status or statusCode  = ${response.statusCode}", name: TAG);
      if (response.statusCode == HttpStatus.ok) {
        if (response.data != null) {
          log("Response Data = ${response.data}", name: TAG);
          //TODO: STEP 3 : HERE CHANGES RESPONSE MODEL NAME
          return ResponseAddFav.fromJson(response.data);
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


  static Future<ResponseReview?> callReview (RequestReview model)
  async {
    //TODO: STEP 1 : HERE CHANGES REQUEST AND RESPONSE MODEL NAME
    String TAG =
        (_showLocationLogs == true ? Trace.current().frames[0].location : "") +
            Trace.current().frames[0].member!;
    FormData formData = FormData.fromMap(
        ApiUtils.getRequestMapForDio(requestString: jsonEncode(model)));
    try {
      log("Request URL = ${ApiList.urlReview}", name: TAG);
      log("Request Data= ${formData.fields}", name: TAG);
      //TODO: STEP 2 : HERE CHANGES REQUEST URL
      Response response =
      await _getDio().post(ApiList.urlReview, data: formData);
      log("Response status or statusCode  = ${response.statusCode}", name: TAG);
      if (response.statusCode == HttpStatus.ok) {
        if (response.data != null) {
          log("Response Data = ${response.data}", name: TAG);
          //TODO: STEP 3 : HERE CHANGES RESPONSE MODEL NAME
          return ResponseReview.fromJson(response.data);
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


  static Future<ResponseAddReview?> callAddReview (RequestAddReview model)
  async {
    //TODO: STEP 1 : HERE CHANGES REQUEST AND RESPONSE MODEL NAME
    String TAG =
        (_showLocationLogs == true ? Trace.current().frames[0].location : "") +
            Trace.current().frames[0].member!;
    FormData formData = FormData.fromMap(
        ApiUtils.getRequestMapForDio(requestString: jsonEncode(model)));
    try {
      log("Request URL = ${ApiList.urlAddReview}", name: TAG);
      log("Request Data= ${formData.fields}", name: TAG);
      //TODO: STEP 2 : HERE CHANGES REQUEST URL
      Response response =
      await _getDio().post(ApiList.urlAddReview, data: formData);
      log("Response status or statusCode  = ${response.statusCode}", name: TAG);
      if (response.statusCode == HttpStatus.ok) {
        if (response.data != null) {
          log("Response Data = ${response.data}", name: TAG);
          //TODO: STEP 3 : HERE CHANGES RESPONSE MODEL NAME
          return ResponseAddReview.fromJson(response.data);
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


  static Future<ResponseShare?> callShare (RequestShare model)
  async {
    //TODO: STEP 1 : HERE CHANGES REQUEST AND RESPONSE MODEL NAME
    String TAG =
        (_showLocationLogs == true ? Trace.current().frames[0].location : "") +
            Trace.current().frames[0].member!;
    FormData formData = FormData.fromMap(
        ApiUtils.getRequestMapForDio(requestString: jsonEncode(model)));
    try {
      log("Request URL = ${ApiList.urlShare}", name: TAG);
      log("Request Data= ${formData.fields}", name: TAG);
      //TODO: STEP 2 : HERE CHANGES REQUEST URL
      Response response =
      await _getDio().post(ApiList.urlShare, data: formData);
      log("Response status or statusCode  = ${response.statusCode}", name: TAG);
      if (response.statusCode == HttpStatus.ok) {
        if (response.data != null) {
          log("Response Data = ${response.data}", name: TAG);
          //TODO: STEP 3 : HERE CHANGES RESPONSE MODEL NAME
          return ResponseShare.fromJson(response.data);
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


  static Future<ResponseCrackDeal?> callCrackDeal (RequestCrackDeal model)
  async {
    //TODO: STEP 1 : HERE CHANGES REQUEST AND RESPONSE MODEL NAME
    String TAG =
        (_showLocationLogs == true ? Trace.current().frames[0].location : "") +
            Trace.current().frames[0].member!;
    FormData formData = FormData.fromMap(
        ApiUtils.getRequestMapForDio(requestString: jsonEncode(model)));
    try {
      log("Request URL = ${ApiList.urlCrackDeal}", name: TAG);
      log("Request Data= ${formData.fields}", name: TAG);
      //TODO: STEP 2 : HERE CHANGES REQUEST URL
      Response response =
      await _getDio().post(ApiList.urlCrackDeal, data: formData);
      log("Response status or statusCode  = ${response.statusCode}", name: TAG);
      if (response.statusCode == HttpStatus.ok) {
        if (response.data != null) {
          log("Response Data = ${response.data}", name: TAG);
          //TODO: STEP 3 : HERE CHANGES RESPONSE MODEL NAME
          return ResponseCrackDeal.fromJson(response.data);
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







  // Todo User API
  static Future<ResponseUserDashboard?> callUserDashboard (RequestUserDashboard model)
  async {
    //TODO: STEP 1 : HERE CHANGES REQUEST AND RESPONSE MODEL NAME
    String TAG =
        (_showLocationLogs == true ? Trace.current().frames[0].location : "") +
            Trace.current().frames[0].member!;
    FormData formData = FormData.fromMap(
        ApiUtils.getRequestMapForDio(requestString: jsonEncode(model)));
    try {
      log("Request URL = ${ApiList.urlUserDashboard}", name: TAG);
      log("Request Data= ${formData.fields}", name: TAG);
      //TODO: STEP 2 : HERE CHANGES REQUEST URL
      Response response =
      await _getDio().post(ApiList.urlUserDashboard, data: formData);
      log("Response status or statusCode  = ${response.statusCode}", name: TAG);
      if (response.statusCode == HttpStatus.ok) {
        if (response.data != null) {
          log("Response Data = ${response.data}", name: TAG);
          //TODO: STEP 3 : HERE CHANGES RESPONSE MODEL NAME
          return ResponseUserDashboard.fromJson(response.data);
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

  static Future<ResponseMenu?> callMenu (RequestMenu model)
  async {
    //TODO: STEP 1 : HERE CHANGES REQUEST AND RESPONSE MODEL NAME
    String TAG =
        (_showLocationLogs == true ? Trace.current().frames[0].location : "") +
            Trace.current().frames[0].member!;
    FormData formData = FormData.fromMap(
        ApiUtils.getRequestMapForDio(requestString: jsonEncode(model)));
    try {
      log("Request URL = ${ApiList.urlMenu}", name: TAG);
      log("Request Data= ${formData.fields}", name: TAG);
      //TODO: STEP 2 : HERE CHANGES REQUEST URL
      Response response =
      await _getDio().post(ApiList.urlMenu, data: formData);
      log("Response status or statusCode  = ${response.statusCode}", name: TAG);
      if (response.statusCode == HttpStatus.ok) {
        if (response.data != null) {
          log("Response Data = ${response.data}", name: TAG);
          //TODO: STEP 3 : HERE CHANGES RESPONSE MODEL NAME
          return ResponseMenu.fromJson(response.data);
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

  static Future<ResponseNotification?> callNotification (RequestNotification model)
  async {
    //TODO: STEP 1 : HERE CHANGES REQUEST AND RESPONSE MODEL NAME
    String TAG =
        (_showLocationLogs == true ? Trace.current().frames[0].location : "") +
            Trace.current().frames[0].member!;
    FormData formData = FormData.fromMap(
        ApiUtils.getRequestMapForDio(requestString: jsonEncode(model)));
    try {
      log("Request URL = ${ApiList.urlNotification}", name: TAG);
      log("Request Data= ${formData.fields}", name: TAG);
      //TODO: STEP 2 : HERE CHANGES REQUEST URL
      Response response =
      await _getDio().post(ApiList.urlNotification, data: formData);
      log("Response status or statusCode  = ${response.statusCode}", name: TAG);
      if (response.statusCode == HttpStatus.ok) {
        if (response.data != null) {
          log("Response Data = ${response.data}", name: TAG);
          //TODO: STEP 3 : HERE CHANGES RESPONSE MODEL NAME
          return ResponseNotification.fromJson(response.data);
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

  static Future<ResponseProfile?> callProfile (RequestProfile model)
  async {
    //TODO: STEP 1 : HERE CHANGES REQUEST AND RESPONSE MODEL NAME
    String TAG =
        (_showLocationLogs == true ? Trace.current().frames[0].location : "") +
            Trace.current().frames[0].member!;
    FormData formData = FormData.fromMap(
        ApiUtils.getRequestMapForDio(requestString: jsonEncode(model)));
    try {
      log("Request URL = ${ApiList.urlProfile}", name: TAG);
      log("Request Data= ${formData.fields}", name: TAG);
      //TODO: STEP 2 : HERE CHANGES REQUEST URL
      Response response =
      await _getDio().post(ApiList.urlProfile, data: formData);
      log("Response status or statusCode  = ${response.statusCode}", name: TAG);
      if (response.statusCode == HttpStatus.ok) {
        if (response.data != null) {
          log("Response Data = ${response.data}", name: TAG);
          //TODO: STEP 3 : HERE CHANGES RESPONSE MODEL NAME
          return ResponseProfile.fromJson(response.data);
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

  static Future<ResponseMyOrder?> callMyOrder (RequestMyOrder model)
  async {
    //TODO: STEP 1 : HERE CHANGES REQUEST AND RESPONSE MODEL NAME
    String TAG =
        (_showLocationLogs == true ? Trace.current().frames[0].location : "") +
            Trace.current().frames[0].member!;
    FormData formData = FormData.fromMap(
        ApiUtils.getRequestMapForDio(requestString: jsonEncode(model)));
    try {
      log("Request URL = ${ApiList.urlMyOrder}", name: TAG);
      log("Request Data= ${formData.fields}", name: TAG);
      //TODO: STEP 2 : HERE CHANGES REQUEST URL
      Response response =
      await _getDio().post(ApiList.urlMyOrder, data: formData);
      log("Response status or statusCode  = ${response.statusCode}", name: TAG);
      if (response.statusCode == HttpStatus.ok) {
        if (response.data != null) {
          log("Response Data = ${response.data}", name: TAG);
          //TODO: STEP 3 : HERE CHANGES RESPONSE MODEL NAME
          return ResponseMyOrder.fromJson(response.data);
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

  static Future<ResponseMyOrderDetail?> callMyOrderDetail (RequestMyOrderDetail model)
  async {
    //TODO: STEP 1 : HERE CHANGES REQUEST AND RESPONSE MODEL NAME
    String TAG =
        (_showLocationLogs == true ? Trace.current().frames[0].location : "") +
            Trace.current().frames[0].member!;
    FormData formData = FormData.fromMap(
        ApiUtils.getRequestMapForDio(requestString: jsonEncode(model)));
    try {
      log("Request URL = ${ApiList.urlMyOrderDetail}", name: TAG);
      log("Request Data= ${formData.fields}", name: TAG);
      //TODO: STEP 2 : HERE CHANGES REQUEST URL
      Response response =
      await _getDio().post(ApiList.urlMyOrderDetail, data: formData);
      log("Response status or statusCode  = ${response.statusCode}", name: TAG);
      if (response.statusCode == HttpStatus.ok) {
        if (response.data != null) {
          log("Response Data = ${response.data}", name: TAG);
          //TODO: STEP 3 : HERE CHANGES RESPONSE MODEL NAME
          return ResponseMyOrderDetail.fromJson(response.data);
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

  static Future<ResponseUserDeal?> callUserDeal (RequestUserDeal model)
  async {
    //TODO: STEP 1 : HERE CHANGES REQUEST AND RESPONSE MODEL NAME
    String TAG =
        (_showLocationLogs == true ? Trace.current().frames[0].location : "") +
            Trace.current().frames[0].member!;
    FormData formData = FormData.fromMap(
        ApiUtils.getRequestMapForDio(requestString: jsonEncode(model)));
    try {
      log("Request URL = ${ApiList.urlUserDeal}", name: TAG);
      log("Request Data= ${formData.fields}", name: TAG);
      //TODO: STEP 2 : HERE CHANGES REQUEST URL
      Response response =
      await _getDio().post(ApiList.urlUserDeal, data: formData);
      log("Response status or statusCode  = ${response.statusCode}", name: TAG);
      if (response.statusCode == HttpStatus.ok) {
        if (response.data != null) {
          log("Response Data = ${response.data}", name: TAG);
          //TODO: STEP 3 : HERE CHANGES RESPONSE MODEL NAME
          return ResponseUserDeal.fromJson(response.data);
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

  static Future<ResponseCrackedDeal?> callCrackedDeal (RequestCrackedDeal model)
  async {
    //TODO: STEP 1 : HERE CHANGES REQUEST AND RESPONSE MODEL NAME
    String TAG =
        (_showLocationLogs == true ? Trace.current().frames[0].location : "") +
            Trace.current().frames[0].member!;
    FormData formData = FormData.fromMap(
        ApiUtils.getRequestMapForDio(requestString: jsonEncode(model)));
    try {
      log("Request URL = ${ApiList.urlCrackedDeal}", name: TAG);
      log("Request Data= ${formData.fields}", name: TAG);
      //TODO: STEP 2 : HERE CHANGES REQUEST URL
      Response response =
      await _getDio().post(ApiList.urlCrackedDeal, data: formData);
      log("Response status or statusCode  = ${response.statusCode}", name: TAG);
      if (response.statusCode == HttpStatus.ok) {
        if (response.data != null) {
          log("Response Data = ${response.data}", name: TAG);
          //TODO: STEP 3 : HERE CHANGES RESPONSE MODEL NAME
          return ResponseCrackedDeal.fromJson(response.data);
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

  static Future<ResponseBilling?> callBilling (RequestBilling model)
  async {
    //TODO: STEP 1 : HERE CHANGES REQUEST AND RESPONSE MODEL NAME
    String TAG =
        (_showLocationLogs == true ? Trace.current().frames[0].location : "") +
            Trace.current().frames[0].member!;
    FormData formData = FormData.fromMap(
        ApiUtils.getRequestMapForDio(requestString: jsonEncode(model)));
    try {
      log("Request URL = ${ApiList.urlBilling}", name: TAG);
      log("Request Data= ${formData.fields}", name: TAG);
      //TODO: STEP 2 : HERE CHANGES REQUEST URL
      Response response =
      await _getDio().post(ApiList.urlBilling, data: formData);
      log("Response status or statusCode  = ${response.statusCode}", name: TAG);
      if (response.statusCode == HttpStatus.ok) {
        if (response.data != null) {
          log("Response Data = ${response.data}", name: TAG);
          //TODO: STEP 3 : HERE CHANGES RESPONSE MODEL NAME
          return ResponseBilling.fromJson(response.data);
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

  static Future<ResponseBillHistory?> callBillHistory (RequestBillHistory model)
  async {
    //TODO: STEP 1 : HERE CHANGES REQUEST AND RESPONSE MODEL NAME
    String TAG =
        (_showLocationLogs == true ? Trace.current().frames[0].location : "") +
            Trace.current().frames[0].member!;
    FormData formData = FormData.fromMap(
        ApiUtils.getRequestMapForDio(requestString: jsonEncode(model)));
    try {
      log("Request URL = ${ApiList.urlBillHistory}", name: TAG);
      log("Request Data= ${formData.fields}", name: TAG);
      //TODO: STEP 2 : HERE CHANGES REQUEST URL
      Response response =
      await _getDio().post(ApiList.urlBillHistory, data: formData);
      log("Response status or statusCode  = ${response.statusCode}", name: TAG);
      if (response.statusCode == HttpStatus.ok) {
        if (response.data != null) {
          log("Response Data = ${response.data}", name: TAG);
          //TODO: STEP 3 : HERE CHANGES RESPONSE MODEL NAME
          return ResponseBillHistory.fromJson(response.data);
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

  static Future<ResponseBookingHistory?> callBookingHistory (RequestBookingHistory model)
  async {
    //TODO: STEP 1 : HERE CHANGES REQUEST AND RESPONSE MODEL NAME
    String TAG =
        (_showLocationLogs == true ? Trace.current().frames[0].location : "") +
            Trace.current().frames[0].member!;
    FormData formData = FormData.fromMap(
        ApiUtils.getRequestMapForDio(requestString: jsonEncode(model)));
    try {
      log("Request URL = ${ApiList.urlBookingHistory}", name: TAG);
      log("Request Data= ${formData.fields}", name: TAG);
      //TODO: STEP 2 : HERE CHANGES REQUEST URL
      Response response =
      await _getDio().post(ApiList.urlBookingHistory, data: formData);
      log("Response status or statusCode  = ${response.statusCode}", name: TAG);
      if (response.statusCode == HttpStatus.ok) {
        if (response.data != null) {
          log("Response Data = ${response.data}", name: TAG);
          //TODO: STEP 3 : HERE CHANGES RESPONSE MODEL NAME
          return ResponseBookingHistory.fromJson(response.data);
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

  static Future<ResponseBookingHistoryDetail?> callBookingHistoryDetail (RequestBookingHistoryDetail model)
  async {
    //TODO: STEP 1 : HERE CHANGES REQUEST AND RESPONSE MODEL NAME
    String TAG =
        (_showLocationLogs == true ? Trace.current().frames[0].location : "") +
            Trace.current().frames[0].member!;
    FormData formData = FormData.fromMap(
        ApiUtils.getRequestMapForDio(requestString: jsonEncode(model)));
    try {
      log("Request URL = ${ApiList.urlBookingHistoryDetail}", name: TAG);
      log("Request Data= ${formData.fields}", name: TAG);
      //TODO: STEP 2 : HERE CHANGES REQUEST URL
      Response response =
      await _getDio().post(ApiList.urlBookingHistoryDetail, data: formData);
      log("Response status or statusCode  = ${response.statusCode}", name: TAG);
      if (response.statusCode == HttpStatus.ok) {
        if (response.data != null) {
          log("Response Data = ${response.data}", name: TAG);
          //TODO: STEP 3 : HERE CHANGES RESPONSE MODEL NAME
          return ResponseBookingHistoryDetail.fromJson(response.data);
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

  static Future<ResponseUserPoint?> callUserPoint (RequestUserPoint model)
  async {
    //TODO: STEP 1 : HERE CHANGES REQUEST AND RESPONSE MODEL NAME
    String TAG =
        (_showLocationLogs == true ? Trace.current().frames[0].location : "") +
            Trace.current().frames[0].member!;
    FormData formData = FormData.fromMap(
        ApiUtils.getRequestMapForDio(requestString: jsonEncode(model)));
    try {
      log("Request URL = ${ApiList.urlUserPoint}", name: TAG);
      log("Request Data= ${formData.fields}", name: TAG);
      //TODO: STEP 2 : HERE CHANGES REQUEST URL
      Response response =
      await _getDio().post(ApiList.urlUserPoint, data: formData);
      log("Response status or statusCode  = ${response.statusCode}", name: TAG);
      if (response.statusCode == HttpStatus.ok) {
        if (response.data != null) {
          log("Response Data = ${response.data}", name: TAG);
          //TODO: STEP 3 : HERE CHANGES RESPONSE MODEL NAME
          return ResponseUserPoint.fromJson(response.data);
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

  static Future<ResponsePointDetail?> callPointDetail (RequestPointDetail model)
  async {
    //TODO: STEP 1 : HERE CHANGES REQUEST AND RESPONSE MODEL NAME
    String TAG =
        (_showLocationLogs == true ? Trace.current().frames[0].location : "") +
            Trace.current().frames[0].member!;
    FormData formData = FormData.fromMap(
        ApiUtils.getRequestMapForDio(requestString: jsonEncode(model)));
    try {
      log("Request URL = ${ApiList.urlUserPointDetail}", name: TAG);
      log("Request Data= ${formData.fields}", name: TAG);
      //TODO: STEP 2 : HERE CHANGES REQUEST URL
      Response response =
      await _getDio().post(ApiList.urlUserPointDetail, data: formData);
      log("Response status or statusCode  = ${response.statusCode}", name: TAG);
      if (response.statusCode == HttpStatus.ok) {
        if (response.data != null) {
          log("Response Data = ${response.data}", name: TAG);
          //TODO: STEP 3 : HERE CHANGES RESPONSE MODEL NAME
          return ResponsePointDetail.fromJson(response.data);
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

  static Future<ResponseFavData?> callFavData (RequestFavData model)
  async {
    //TODO: STEP 1 : HERE CHANGES REQUEST AND RESPONSE MODEL NAME
    String TAG =
        (_showLocationLogs == true ? Trace.current().frames[0].location : "") +
            Trace.current().frames[0].member!;
    FormData formData = FormData.fromMap(
        ApiUtils.getRequestMapForDio(requestString: jsonEncode(model)));
    try {
      log("Request URL = ${ApiList.urlFavData}", name: TAG);
      log("Request Data= ${formData.fields}", name: TAG);
      //TODO: STEP 2 : HERE CHANGES REQUEST URL
      Response response =
      await _getDio().post(ApiList.urlFavData, data: formData);
      log("Response status or statusCode  = ${response.statusCode}", name: TAG);
      if (response.statusCode == HttpStatus.ok) {
        if (response.data != null) {
          log("Response Data = ${response.data}", name: TAG);
          //TODO: STEP 3 : HERE CHANGES RESPONSE MODEL NAME
          return ResponseFavData.fromJson(response.data);
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

  static Future<ResponseFavDelete?> callFavDelete (RequestFavDelete model)
  async {
    //TODO: STEP 1 : HERE CHANGES REQUEST AND RESPONSE MODEL NAME
    String TAG =
        (_showLocationLogs == true ? Trace.current().frames[0].location : "") +
            Trace.current().frames[0].member!;
    FormData formData = FormData.fromMap(
        ApiUtils.getRequestMapForDio(requestString: jsonEncode(model)));
    try {
      log("Request URL = ${ApiList.urlFavDelete}", name: TAG);
      log("Request Data= ${formData.fields}", name: TAG);
      //TODO: STEP 2 : HERE CHANGES REQUEST URL
      Response response =
      await _getDio().post(ApiList.urlFavDelete, data: formData);
      log("Response status or statusCode  = ${response.statusCode}", name: TAG);
      if (response.statusCode == HttpStatus.ok) {
        if (response.data != null) {
          log("Response Data = ${response.data}", name: TAG);
          //TODO: STEP 3 : HERE CHANGES RESPONSE MODEL NAME
          return ResponseFavDelete.fromJson(response.data);
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

//TODO HOTEL
  static Future<ResponseHotelBooking?> callHotelBooking (RequestHotelBooking model)
  async {
    //TODO: STEP 1 : HERE CHANGES REQUEST AND RESPONSE MODEL NAME
    String TAG =
        (_showLocationLogs == true ? Trace.current().frames[0].location : "") +
            Trace.current().frames[0].member!;
    FormData formData = FormData.fromMap(
        ApiUtils.getRequestMapForDio(requestString: jsonEncode(model)));
    try {
      log("Request URL = ${ApiList.urlHotelBooking}", name: TAG);
      log("Request Data= ${formData.fields}", name: TAG);
      //TODO: STEP 2 : HERE CHANGES REQUEST URL
      Response response =
      await _getDio().post(ApiList.urlHotelBooking, data: formData);
      log("Response status or statusCode  = ${response.statusCode}", name: TAG);
      if (response.statusCode == HttpStatus.ok) {
        if (response.data != null) {
          log("Response Data = ${response.data}", name: TAG);
          //TODO: STEP 3 : HERE CHANGES RESPONSE MODEL NAME
          return ResponseHotelBooking.fromJson(response.data);
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

  static Future<ResponseHotelBookingDetail?> callHotelBookingDetail (RequestHotelBookingDetail model)
  async {
    //TODO: STEP 1 : HERE CHANGES REQUEST AND RESPONSE MODEL NAME
    String TAG =
        (_showLocationLogs == true ? Trace.current().frames[0].location : "") +
            Trace.current().frames[0].member!;
    FormData formData = FormData.fromMap(
        ApiUtils.getRequestMapForDio(requestString: jsonEncode(model)));
    try {
      log("Request URL = ${ApiList.urlHotelBookingDetail}", name: TAG);
      log("Request Data= ${formData.fields}", name: TAG);
      //TODO: STEP 2 : HERE CHANGES REQUEST URL
      Response response =
      await _getDio().post(ApiList.urlHotelBookingDetail, data: formData);
      log("Response status or statusCode  = ${response.statusCode}", name: TAG);
      if (response.statusCode == HttpStatus.ok) {
        if (response.data != null) {
          log("Response Data = ${response.data}", name: TAG);
          //TODO: STEP 3 : HERE CHANGES RESPONSE MODEL NAME
          return ResponseHotelBookingDetail.fromJson(response.data);
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

  static Future<ResponseHotelBookingCancellation?> callHotelBookingCancellation (RequestHotelBookingCancellation model)
  async {
    //TODO: STEP 1 : HERE CHANGES REQUEST AND RESPONSE MODEL NAME
    String TAG =
        (_showLocationLogs == true ? Trace.current().frames[0].location : "") +
            Trace.current().frames[0].member!;
    FormData formData = FormData.fromMap(
        ApiUtils.getRequestMapForDio(requestString: jsonEncode(model)));
    try {
      log("Request URL = ${ApiList.urlHotelBookingCancellation}", name: TAG);
      log("Request Data= ${formData.fields}", name: TAG);
      //TODO: STEP 2 : HERE CHANGES REQUEST URL
      Response response =
      await _getDio().post(ApiList.urlHotelBookingCancellation, data: formData);
      log("Response status or statusCode  = ${response.statusCode}", name: TAG);
      if (response.statusCode == HttpStatus.ok) {
        if (response.data != null) {
          log("Response Data = ${response.data}", name: TAG);
          //TODO: STEP 3 : HERE CHANGES RESPONSE MODEL NAME
          return ResponseHotelBookingCancellation.fromJson(response.data);
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

  static Future<ResponseHotelBookingRoomHistory?> callHotelBookingRoomHistory (RequestHotelBookingRoomHistory model)
  async {
    //TODO: STEP 1 : HERE CHANGES REQUEST AND RESPONSE MODEL NAME
    String TAG =
        (_showLocationLogs == true ? Trace.current().frames[0].location : "") +
            Trace.current().frames[0].member!;
    FormData formData = FormData.fromMap(
        ApiUtils.getRequestMapForDio(requestString: jsonEncode(model)));
    try {
      log("Request URL = ${ApiList.urlHotelBookingRoomHistory}", name: TAG);
      log("Request Data= ${formData.fields}", name: TAG);
      //TODO: STEP 2 : HERE CHANGES REQUEST URL
      Response response =
      await _getDio().post(ApiList.urlHotelBookingRoomHistory, data: formData);
      log("Response status or statusCode  = ${response.statusCode}", name: TAG);
      if (response.statusCode == HttpStatus.ok) {
        if (response.data != null) {
          log("Response Data = ${response.data}", name: TAG);
          //TODO: STEP 3 : HERE CHANGES RESPONSE MODEL NAME
          return ResponseHotelBookingRoomHistory.fromJson(response.data);
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

  static Future<ResponseHotelBookingServiceHistory?> callHotelBookingServiceHistory (RequestHotelBookingServiceHistory model)
  async {
    //TODO: STEP 1 : HERE CHANGES REQUEST AND RESPONSE MODEL NAME
    String TAG =
        (_showLocationLogs == true ? Trace.current().frames[0].location : "") +
            Trace.current().frames[0].member!;
    FormData formData = FormData.fromMap(
        ApiUtils.getRequestMapForDio(requestString: jsonEncode(model)));
    try {
      log("Request URL = ${ApiList.urlHotelBookingServiceHistory}", name: TAG);
      log("Request Data= ${formData.fields}", name: TAG);
      //TODO: STEP 2 : HERE CHANGES REQUEST URL
      Response response =
      await _getDio().post(ApiList.urlHotelBookingServiceHistory, data: formData);
      log("Response status or statusCode  = ${response.statusCode}", name: TAG);
      if (response.statusCode == HttpStatus.ok) {
        if (response.data != null) {
          log("Response Data = ${response.data}", name: TAG);
          //TODO: STEP 3 : HERE CHANGES RESPONSE MODEL NAME
          return ResponseHotelBookingServiceHistory.fromJson(response.data);
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

  static Future<ResponseHotelBookingRoomPricePlan?> callHotelBookingRoomPricePlan (RequestHotelBookingRoomPricePlan model)
  async {
    //TODO: STEP 1 : HERE CHANGES REQUEST AND RESPONSE MODEL NAME
    String TAG =
        (_showLocationLogs == true ? Trace.current().frames[0].location : "") +
            Trace.current().frames[0].member!;
    FormData formData = FormData.fromMap(
        ApiUtils.getRequestMapForDio(requestString: jsonEncode(model)));
    try {
      log("Request URL = ${ApiList.urlHotelBookingRoomPricePlan}", name: TAG);
      log("Request Data= ${formData.fields}", name: TAG);
      //TODO: STEP 2 : HERE CHANGES REQUEST URL
      Response response =
      await _getDio().post(ApiList.urlHotelBookingRoomPricePlan, data: formData);
      log("Response status or statusCode  = ${response.statusCode}", name: TAG);
      if (response.statusCode == HttpStatus.ok) {
        if (response.data != null) {
          log("Response Data = ${response.data}", name: TAG);
          //TODO: STEP 3 : HERE CHANGES RESPONSE MODEL NAME
          return ResponseHotelBookingRoomPricePlan.fromJson(response.data);
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

  static Future<ResponseHotelBookingCancellationHistory?> callHotelBookingCancellationHistory (RequestHotelBookingCancellationHistory model)
  async {
    //TODO: STEP 1 : HERE CHANGES REQUEST AND RESPONSE MODEL NAME
    String TAG =
        (_showLocationLogs == true ? Trace.current().frames[0].location : "") +
            Trace.current().frames[0].member!;
    FormData formData = FormData.fromMap(
        ApiUtils.getRequestMapForDio(requestString: jsonEncode(model)));
    try {
      log("Request URL = ${ApiList.urlHotelBookingCancellationHistory}", name: TAG);
      log("Request Data= ${formData.fields}", name: TAG);
      //TODO: STEP 2 : HERE CHANGES REQUEST URL
      Response response =
      await _getDio().post(ApiList.urlHotelBookingCancellationHistory, data: formData);
      log("Response status or statusCode  = ${response.statusCode}", name: TAG);
      if (response.statusCode == HttpStatus.ok) {
        if (response.data != null) {
          log("Response Data = ${response.data}", name: TAG);
          //TODO: STEP 3 : HERE CHANGES RESPONSE MODEL NAME
          return ResponseHotelBookingCancellationHistory.fromJson(response.data);
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

  static Future<ResponseProfileAddress?> callProfileAddress (RequestProfileAddress model)
  async {
    //TODO: STEP 1 : HERE CHANGES REQUEST AND RESPONSE MODEL NAME
    String TAG =
        (_showLocationLogs == true ? Trace.current().frames[0].location : "") +
            Trace.current().frames[0].member!;
    FormData formData = FormData.fromMap(
        ApiUtils.getRequestMapForDio(requestString: jsonEncode(model)));
    try {
      log("Request URL = ${ApiList.urlProfileAddress}", name: TAG);
      log("Request Data= ${formData.fields}", name: TAG);
      //TODO: STEP 2 : HERE CHANGES REQUEST URL
      Response response =
      await _getDio().post(ApiList.urlProfileAddress, data: formData);
      log("Response status or statusCode  = ${response.statusCode}", name: TAG);
      if (response.statusCode == HttpStatus.ok) {
        if (response.data != null) {
          log("Response Data = ${response.data}", name: TAG);
          //TODO: STEP 3 : HERE CHANGES RESPONSE MODEL NAME
          return ResponseProfileAddress.fromJson(response.data);
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

  static Future<ResponseEditAddress?> callEditAddress (RequestEditAddress model)
  async {
    //TODO: STEP 1 : HERE CHANGES REQUEST AND RESPONSE MODEL NAME
    String TAG =
        (_showLocationLogs == true ? Trace.current().frames[0].location : "") +
            Trace.current().frames[0].member!;
    FormData formData = FormData.fromMap(
        ApiUtils.getRequestMapForDio(requestString: jsonEncode(model)));
    try {
      log("Request URL = ${ApiList.urlEditAddress}", name: TAG);
      log("Request Data= ${formData.fields}", name: TAG);
      //TODO: STEP 2 : HERE CHANGES REQUEST URL
      Response response =
      await _getDio().post(ApiList.urlEditAddress, data: formData);
      log("Response status or statusCode  = ${response.statusCode}", name: TAG);
      if (response.statusCode == HttpStatus.ok) {
        if (response.data != null) {
          log("Response Data = ${response.data}", name: TAG);
          //TODO: STEP 3 : HERE CHANGES RESPONSE MODEL NAME
          return ResponseEditAddress.fromJson(response.data);
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

  static Future<ResponseDeleteAddress?> callDeleteAddress (RequestDeleteAddress model)
  async {
    //TODO: STEP 1 : HERE CHANGES REQUEST AND RESPONSE MODEL NAME
    String TAG =
        (_showLocationLogs == true ? Trace.current().frames[0].location : "") +
            Trace.current().frames[0].member!;
    FormData formData = FormData.fromMap(
        ApiUtils.getRequestMapForDio(requestString: jsonEncode(model)));
    try {
      log("Request URL = ${ApiList.urlDeleteAddress}", name: TAG);
      log("Request Data= ${formData.fields}", name: TAG);
      //TODO: STEP 2 : HERE CHANGES REQUEST URL
      Response response =
      await _getDio().post(ApiList.urlDeleteAddress, data: formData);
      log("Response status or statusCode  = ${response.statusCode}", name: TAG);
      if (response.statusCode == HttpStatus.ok) {
        if (response.data != null) {
          log("Response Data = ${response.data}", name: TAG);
          return ResponseDeleteAddress.fromJson(response.data);
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

  static Future<ResponseChangePassword?> callChangePassword (RequestChangePassword model)
  async {
    //TODO: STEP 1 : HERE CHANGES REQUEST AND RESPONSE MODEL NAME
    String TAG =
        (_showLocationLogs == true ? Trace.current().frames[0].location : "") +
            Trace.current().frames[0].member!;
    FormData formData = FormData.fromMap(
        ApiUtils.getRequestMapForDio(requestString: jsonEncode(model)));
    try {
      log("Request URL = ${ApiList.urlChangePassword}", name: TAG);
      log("Request Data= ${formData.fields}", name: TAG);
      //TODO: STEP 2 : HERE CHANGES REQUEST URL
      Response response =
      await _getDio().post(ApiList.urlChangePassword, data: formData);
      log("Response status or statusCode  = ${response.statusCode}", name: TAG);
      if (response.statusCode == HttpStatus.ok) {
        if (response.data != null) {
          log("Response Data = ${response.data}", name: TAG);
          //TODO: STEP 3 : HERE CHANGES RESPONSE MODEL NAME
          return ResponseChangePassword.fromJson(response.data);
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

  static Future<ResponseUpdateProfile?> callUpdateProfile(RequestUpdateProfile model, String? imagePath) async {
    String TAG = (_showLocationLogs == true ? Trace.current().frames[0].location : "") +
        Trace.current().frames[0].member!;


    Map<String, dynamic> map = ApiUtils.getRequestMapForDio(requestString: jsonEncode(model));

    if (imagePath != null && imagePath.isNotEmpty) {
      map['image'] = await MultipartFile.fromFile(
        imagePath,
        filename: imagePath.split('/').last,
      );
    }

    // 3. ફાઈનલ FormData બનાવીએ
    FormData formData = FormData.fromMap(map);

    try {
      log("Request URL = ${ApiList.urlUpdatePassword}", name: TAG);
      // FormData ના ફિલ્ડ્સ લોગ કરવા માટે
      log("Request Fields = ${formData.fields}", name: TAG);
      log("Request Files = ${formData.files}", name: TAG);

      Response response = await _getDio().post(ApiList.urlUpdatePassword, data: formData);

      log("Response status or statusCode  = ${response.statusCode}", name: TAG);
      if (response.statusCode == HttpStatus.ok) {
        if (response.data != null) {
          log("Response Data = ${response.data}", name: TAG);
          return ResponseUpdateProfile.fromJson(response.data);
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


