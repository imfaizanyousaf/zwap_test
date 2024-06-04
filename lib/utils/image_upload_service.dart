import 'dart:convert';
import 'dart:math';

import 'package:dio/dio.dart';
import 'package:zwap_test/model/categories.dart';
import 'package:zwap_test/model/conditions.dart';
import 'package:zwap_test/model/locations.dart';
import 'package:zwap_test/model/post.dart';
import 'package:zwap_test/model/user.dart';
import 'package:zwap_test/utils/dio_interceptor.dart';
import 'package:http/http.dart' as http;
import 'package:zwap_test/utils/token_manager.dart';

class ImageUploadService {
  late final Dio _dio;
  late final String apiUrl = "https://zwap.codeshar.com/api";
  ImageUploadService() {
    _dio = Dio();
    _dio.interceptors.add(DioInterceptor());
    _dio.interceptors.add(LogInterceptor(
      requestHeader: true,
    )); // Add LogInterceptor with logging enabled
  }

  // function upload image to the server using multipart request in dio
  Future<String> uploadImage(String imagePath) async {
    try {
      String fileName = imagePath.split('/').last;
      FormData formData = FormData.fromMap({
        "file": await MultipartFile.fromFile(imagePath, filename: fileName),
      });
      Response response = await _dio.post(
        "$apiUrl/upload",
        data: formData,
      );
      return response.data['data']['url'];
    } catch (e) {
      print(e);
      return "";
    }
  }
}
