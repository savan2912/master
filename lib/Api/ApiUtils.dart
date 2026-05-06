import 'dart:developer';
import 'package:dio/dio.dart';

class ApiUtils {
  static const String API_KEY = "apikey";
  static const String DATA_KEY = "data";
  // static const String API_KEY_VALUE = ApiList.apiKey;

  static const String IMAGE_KEY = "image";

  static dynamic getRequestMapForDio({String? requestString}) {
    var map = <String, dynamic>{};

    // map[API_KEY] = API_KEY_VALUE;
    if (requestString != "") {
      map[DATA_KEY] = requestString;
    }
    // log("requestString = ${map.toString()}", name: "getRequestMapForDio");

    return map;
  }

  static Map<String, dynamic> getRequestMapForDioWithFile({
    String? requestString,
    String? filePath,
  }) {
    var map = <String, dynamic>{};

    // map[API_KEY] = API_KEY_VALUE;
    if (requestString != "") {
      map[DATA_KEY] = requestString;
    }

    if (filePath != null && filePath != "") {
      map[IMAGE_KEY] = MultipartFile.fromFile(
        filePath,
        filename: filePath.split("/").last,
      );
    }

    log("reqMap = ${map.toString()}", name: "getRequestMapForDio");
    log("filePath = ${filePath.toString()}", name: "getRequestMapForDio");
    log("filename = ${filePath?.split("/").last}", name: "getRequestMapForDio");

    return map;
  }
}
