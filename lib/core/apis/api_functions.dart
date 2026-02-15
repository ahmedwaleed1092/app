import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

class DioHelper {
  static Dio? dio;

  static void init() {
    dio ??= Dio(BaseOptions(baseUrl: "", receiveDataWhenStatusError: true));
    dio!.interceptors.add(PrettyDioLogger());
  }

  Future<Response<dynamic>?> getData({
    required String endPionts,
    Map<String, dynamic>? query,
    Map<String, dynamic>? headers,
  }) async {
    try {
      final response = await dio!.get(
        endPionts,
        queryParameters: query,
        options: Options(headers: headers),
      );
      return response;
    } catch (e) {
      log(e.toString());
      return null;
    }
  }

  static Future<Response?> postRequest({
    required String endPionts,
    Map<String, dynamic>? headers,
    required Map<String, dynamic> data,
  }) async {
    try {
      final response = await dio!.post(
        endPionts,
        data: data,
        options: Options(headers: headers),
      );
      return response;
    } catch (e) {
      log(e.toString());
    }
    return null;
  }

  Future<Response<dynamic>?> updateRequest({
    required String token,
    required String endPionts,
    required Map<String, dynamic> data,
  }) async {
    try {
      final response = await dio!.put(endPionts, queryParameters: data);
      return response;
    } catch (e) {
      log(e.toString());
      return null;
    }
  }

  Future<Response<dynamic>?> deleteRequest({
    required String token,
    required String endPionts,
    required Map<String, dynamic> data,
  }) async {
    try {
      final response = await dio!.delete(endPionts, queryParameters: data);
      return response;
    } catch (e) {
      log(e.toString());
      return null;
    }
  }
}
