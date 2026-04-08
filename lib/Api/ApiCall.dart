
import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dio/io.dart';

import 'ApiList.dart';

class ApiCall{
  static final ApiCall _instance = ApiCall._internal();
  factory ApiCall() => _instance;
  late Dio _dio;

  ApiCall._internal() {
    _dio = Dio(BaseOptions(
      baseUrl: ApiList.baseUrl,
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 15),
    ));

    (_dio.httpClientAdapter as IOHttpClientAdapter).createHttpClient = () {
      final client = HttpClient();
      client.badCertificateCallback = (X509Certificate cert, String host, int port) => true;
      return client;
    };

    // લોગ્સ માટે
    _dio.interceptors.add(LogInterceptor(requestBody: true, responseBody: true));
  }


  Future<Map<String, dynamic>?> getRequest(String endpoint, {Map<String, dynamic>? query}) async {
    try {

      print("--- API REQUEST ---");
      print("URL: ${ApiList.baseUrl}$endpoint");
      print("Query: $query");

      final response = await _dio.get(endpoint, queryParameters: query);

      print("--- API RESPONSE ---");
      print("Status: ${response.statusCode}");
      print("Data: ${response.data}");

      if (response.statusCode == 200 || response.statusCode == 201) {
        if (response.data is String) {
          return jsonDecode(response.data);
        }
        return response.data;
      }
      return null;
    } on DioException catch (e) {
      // ❌ Error Log
      print("--- API ERROR ---");
      print("Message: ${e.message}");
      print("Response: ${e.response?.data}");
      _handleError(e);
      return null;
    }
  }


  Future<Map<String, dynamic>?> getBanner(String endpoint, {Map<String, dynamic>? query}) async {
    try {

      print("--- API REQUEST ---");
      print("URL: ${ApiList.baseUrl}$endpoint");
      print("Query: $query");

      final response = await _dio.get(endpoint, queryParameters: query);

      print("--- API RESPONSE ---");
      print("Status: ${response.statusCode}");
      print("Data: ${response.data}");

      if (response.statusCode == 200 || response.statusCode == 201) {
        if (response.data is String) {
          return jsonDecode(response.data);
        }
        return response.data;
      }
      return null;
    } on DioException catch (e) {
      // ❌ Error Log
      print("--- API ERROR ---");
      print("Message: ${e.message}");
      print("Response: ${e.response?.data}");
      _handleError(e);
      return null;
    }
  }





  Map<String, dynamic>? _handleResponse(Response response) {
    if (response.statusCode == 200 || response.statusCode == 201) {
      if (response.data is String) {
        return jsonDecode(response.data);
      }
      return response.data;
    }
    return null;
  }

  void _handleError(DioException e) {
    if (e.type == DioExceptionType.connectionTimeout) {
      print("નેટવર્ક સ્લો છે બોસ!");
    } else if (e.response != null) {
      print("સર્વર એરર: ${e.response?.data}");
    } else {
      print("કંઈક ભૂલ થઈ: ${e.message}");
    }
  }


}