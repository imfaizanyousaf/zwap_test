import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:zwap_test/model/categories.dart';
import 'package:zwap_test/model/conditions.dart';
import 'package:zwap_test/model/locations.dart';
import 'package:zwap_test/model/post.dart';
import 'package:zwap_test/utils/dio_interceptor.dart';
import 'package:http/http.dart' as http;

class api {
  late final Dio _dio;
  late final String baseUrl = "https://zwap.codeshar.com";
  late final String apiUrl;
  api() {
    apiUrl = baseUrl + "/api";

    _dio = Dio();
    _dio.interceptors.add(DioInterceptor());
    _dio.interceptors.add(LogInterceptor(
      requestHeader: true,
    )); // Add LogInterceptor with logging enabled
  }

  //function to get crsf token and store it using token_manager.setToken
  Future<void> getCsrfToken() async {
    final response = await http.get(
      Uri.parse("${baseUrl}/sanctum/csrf-cookie"),
    );
    final setCookie = response.headers;
    print('---------------------- Set Cookie ----------------------');
    print(setCookie['Set-Cookie']);
    // var newToken = setCookie.toString().split('=')[1].split(';')[0];
    // newToken = Uri.decodeFull(newToken);
    // await TokenManager.setToken(newToken);

    // final response = await _dio.get("${baseUrl}/sanctum/csrf-cookie");
    // if (response.statusCode == 204) {
    //   final cookieHeader = response.headers['set-cookie'];
    //   print(cookieHeader);
    //   if (cookieHeader != null) {
    //     var token = cookieHeader[0].split('=')[1].split(';')[0];
    //     token = Uri.decodeFull(token);
    //     await TokenManager.setToken(token);
    //   }
    // } else {
    //   throw Exception('Failed to fetch CSRF token: ${response.statusCode}');
    // }
  }

  Future<String> login(String email, String password) async {
    await getCsrfToken();
    // final token = await TokenManager.getToken();
    // print("Token: $token");

    // final response = await http.post(
    //   Uri.parse("${baseUrl}/login"),
    //   body: {
    //     'email': email,
    //     'password': password,
    //   },
    //   headers: {
    //     'Accept': 'application/json',
    //     'X-XSRF-TOKEN':
    //         token, // Add XSRF token to headers to prevent 419 error code
    //   },
    // );
    // // print("---------------------- Login Response ----------------------");
    // print(response.body);
    // print(response.headers);
    // print("---------------------- Login Response End ------------------");
    // return response.toString();

    // await getCsrfToken();
    // try {
    //   final response = await _dio.post(
    //     "${baseUrl}/login",
    //     data: {
    //       'email': '$email',
    //       'password': '$password',
    //     },
    //   );
    //   print("Login Response: ${response.data}");
    //   return response.statusMessage.toString();
    // } catch (e) {
    //   print("Login failed: Error Code $e.toString()");
    //   return e.toString();
    // }

    // if (response.statusCode == 204) {
    //   await TokenManager.setToken(response.headers['set-cookie'] as String);
    //   return response.statusCode.toString();
    // } else {
    //   return response.statusCode.toString();
    // }

    return "";
  }

  Future<String> getUser() async {
    try {
      final response = await _dio.get("${apiUrl}/user");
      if (response.statusCode == 200) {
        return response.data.toString();
      } else {
        return Future.error(response.statusCode.toString());
      }
    } on DioException catch (e) {
      return e.response?.data ?? 'Error occured';
    }
  }

  Future<List<Post>> getPostsForYou() async {
    try {
      final response = await http.get(Uri.parse(apiUrl + "/posts?per-page=10"));
      if (response.statusCode == 200) {
        Map<String, dynamic> responseData = json.decode(response.body);
        List<dynamic> data = responseData['data'] as List;
        List<Post> posts = data.map((json) => Post.fromJson(json)).toList();
        return posts;
      } else {
        throw Exception("Failed to load posts ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Failed to load postss: $e");
    }
  }

  Future<List<Post>> searchPosts(String query, List<String> categories) async {
    try {
      final response = await http.post(
        Uri.parse(apiUrl + "/posts/search"),
        headers: {"Content-Type": "application/json"}, // Add this line
        body: jsonEncode({"query": query, "categories": categories}),
      );
      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        List<Post> posts = data.map((json) => Post.fromJson(json)).toList();
        return posts;
      } else {
        throw Exception("Failed to search posts ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Failed to search posts: $e");
    }
  }

  Future<List<Categories>> getCategories() async {
    try {
      final response = await http.get(Uri.parse(apiUrl + "/categories"));
      if (response.statusCode == 200) {
        List<dynamic> responseData = json.decode(response.body);
        List<Categories> categories =
            responseData.map((json) => Categories.fromJson(json)).toList();
        return categories;
      } else {
        throw Exception("Failed to load categories ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Failed to load categories: $e");
    }
  }

  Future<List<Locations>> getLocations() async {
    try {
      final response = await http.get(Uri.parse(apiUrl + "/locations"));
      if (response.statusCode == 200) {
        List<dynamic> responseData = json.decode(response.body);
        List<Locations> locationss =
            responseData.map((json) => Locations.fromJson(json)).toList();
        return locationss;
      } else {
        throw Exception("Failed to load locations ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Failed to load locations: $e");
    }
  }

  //create an add Post function that takes in a post object and sends a post request to the api
  Future<String> addPost(Post post) async {
    try {
      final response = await _dio.post(
        "${apiUrl}/posts",
        data: post.toJson(),
      );
      if (response.statusCode == 201) {
        return response.data.toString();
      } else {
        return Future.error(response.statusCode.toString());
      }
    } on DioException catch (e) {
      return e.response?.data ?? 'Error occured';
    }
  }

  //create a get condition similar to getCategories fucntion above
  Future<List<Conditions>> getConditions() async {
    try {
      final response = await http.get(Uri.parse(apiUrl + "/conditions"));
      if (response.statusCode == 200) {
        List<dynamic> responseData = json.decode(response.body);
        List<Conditions> conditions =
            responseData.map((json) => Conditions.fromJson(json)).toList();
        return conditions;
      } else {
        throw Exception("Failed to load conditions ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Failed to load conditions: $e");
    }
  }
}
