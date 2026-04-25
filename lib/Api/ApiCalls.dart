
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
import 'package:gotilo_new/Api/Request/AllNewlyAdded/RequestAllNewlyAdded.dart';
import 'package:gotilo_new/Api/Request/AllService/RequestAllService.dart';
import 'package:gotilo_new/Api/Request/Login/RequestLogin.dart';
import 'package:gotilo_new/Api/Request/Register/RequestRegister.dart';
import 'package:gotilo_new/Api/Request/Search/RequestSearch.dart';
import 'package:gotilo_new/Api/Request/SubCategoryList/RequestSubCategoryList.dart';
import 'package:gotilo_new/Api/Request/SubCategoryList/RequestSubCategoryListDetails.dart';
import 'package:gotilo_new/Api/Request/SubCategoryList/RequestSubCategoryProductList.dart';
import 'package:gotilo_new/Api/Response/AllCollection/ResponseAllCollection.dart';
import 'package:gotilo_new/Api/Response/AllCollection/ResponseCollectionDetails.dart';
import 'package:gotilo_new/Api/Response/AllCollection/ResponseCollectionProductList.dart';
import 'package:gotilo_new/Api/Response/AllDeals/ResponseAllDeals.dart';
import 'package:gotilo_new/Api/Response/AllLatestRelease/ResponseAllLatestRelease.dart';
import 'package:gotilo_new/Api/Response/AllListings/ResponseAllListings.dart';
import 'package:gotilo_new/Api/Response/AllNewlyAdded/ResponseAllNewlyAdded.dart';
import 'package:gotilo_new/Api/Response/AllService/ResponseAllService.dart';
import 'package:gotilo_new/Api/Response/Banner/ResponseBanner.dart';
import 'package:gotilo_new/Api/Response/Blog/ResponseBlogData.dart';
import 'package:gotilo_new/Api/Response/Home/ResponseHomeCollection.dart';
import 'package:gotilo_new/Api/Response/Home/ResponseHomeLatestRelease.dart';
import 'package:gotilo_new/Api/Response/Home/ResponseHomeService.dart';
import 'package:gotilo_new/Api/Response/LatestListing/ResponseHomeLatestListing.dart';
import 'package:gotilo_new/Api/Response/Login/ResponseLogin.dart';
import 'package:gotilo_new/Api/Response/PrisePlan/ResponsePrisePlan.dart';
import 'package:gotilo_new/Api/Response/Register/ResponseRegister.dart';
import 'package:gotilo_new/Api/Response/Search/ResponseSearch.dart';
import 'package:gotilo_new/Api/Response/SubCategoryList/ResponseSubCategoryList.dart';
import 'package:gotilo_new/Api/Response/SubCategoryList/ResponseSubCategoryProductList.dart';
import 'package:gotilo_new/Api/Response/SubCategoryList/ResponseSubcategoryListDetails.dart';

import 'ApiList.dart';
import 'ApiUtils.dart';
import 'package:stack_trace/stack_trace.dart';

import 'Request/Blog/RequestBlogsData.dart';
import 'Response/City/ResponseCity.dart';
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
      await _getDio().post(ApiList.urlLogin, data: formData,options: Options(
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/json",
        },
      ),);
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





}


