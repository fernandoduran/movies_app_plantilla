import 'dart:async';
import 'dart:io';

import "package:dio/dio.dart";
import 'package:movies_app/constants/globals.dart';

class ApiClient {
  // Build a Singleton
  static final ApiClient _apiClient = ApiClient._internal();

  factory ApiClient() {
    return _apiClient;
  }

  ApiClient._internal();

  // Default headers
  final Map<String, String> _headers = {
    "Access-Control-Allow-Origin": "*",
    HttpHeaders.contentTypeHeader: "application/json",
    HttpHeaders.acceptHeader: "*", //"application/json", This breaks the response
  };

  Dio init() {
    // Connection Options
    BaseOptions _options = BaseOptions(
      connectTimeout: Globals.timeout, //5000
      receiveTimeout: Globals.timeout,
      baseUrl: Globals.apiUrl,
      headers: _headers,
    );

    // Create client
    Dio _dio = Dio(_options);

    // Add interceptors
    _dio.interceptors.add(ApiInterceptors());

    return _dio;
  }
}

class ApiInterceptors extends Interceptor {
  
  @override
  onError(DioError err, ErrorInterceptorHandler handler) {
    String? error = err.response?.data['error'];

    if(error != null) return handler.resolve(err.response!);

    return handler.next(err);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) async {
    // do something before response

   return handler.next(response);
  }
}