import 'dart:convert';
import 'dart:io';
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

class api {
  late final Dio _dio;
  late final String apiUrl = "https://zwap.codeshar.com/api";
  api() {
    _dio = Dio();
    _dio.interceptors.add(DioInterceptor());
    _dio.interceptors.add(LogInterceptor(
      requestHeader: true,
    )); // Add LogInterceptor with logging enabled
  }

  //function to get crsf token and store it using token_manager.setToken
  Future<String> getCsrfToken() async {
    final response = await http.get(
      Uri.parse("${apiUrl}/sanctum/csrf-cookie"),
    );
    final setCookie = response.headers['set-cookie'];

    var newToken = setCookie.toString().split('=')[1].split(';')[0];
    newToken = Uri.decodeFull(newToken);
    return newToken;

    // final response = await http.post(
    //   Uri.parse("${apiUrl}/login"),
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

    // final response = await _dio.get("${apiUrl}/sanctum/csrf-cookie");
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
    try {
      var response = await _dio.post(
        "${apiUrl}/login",
        data: {
          'email': '$email',
          'password': '$password',
          'device_name': 'mobile',
        },
        options: Options(
          headers: {
            'Accept': 'application/json',
          },
        ),
      );
      var body = jsonDecode(response.toString());
      var token = body['token'];
      if (!token.contains('html')) {
        await TokenManager.setToken(token);
      }

      return response.statusMessage.toString();
    } catch (e) {
      return 'Error Logging in, Try again later';
    }
  }

  Future<int> checkSession() async {
    try {
      final response = await _dio.get("${apiUrl}/user");
      return response.statusCode!;
    } catch (e) {
      return 0;
    }
  }

  Future<int> logout() async {
    try {
      final response = await _dio.post("${apiUrl}/logout");
      return response.statusCode!;
    } catch (e) {
      return 0;
    }
  }

  Future<User> getUser(int? id) async {
    String url;
    if (id != null) {
      url = "${apiUrl}/users/$id";
    } else {
      url = "${apiUrl}/user";
    }
    try {
      final response = await _dio.get(url);
      if (response.statusCode == 200) {
        User currentUser = User.fromJson(response.data);
        return currentUser;
      } else {
        throw Future.error(response);
      }
    } on DioException catch (e) {
      throw Future.error(e);
    }
  }

  Future<String> updateUser(User user, {String? filePath}) async {
    print('File Path: $filePath');

    try {
      // Validate the file path
      if (filePath != null) {
        final file = File(filePath);
        if (!await file.exists()) {
          throw Exception("File does not exist");
        }
      }

      // Create FormData
      FormData formData = FormData.fromMap({
        'first_name': user.firstName,
        'last_name': user.lastName,
        'email': user.email,
        if (filePath != null)
          "file":
              await MultipartFile.fromFile(filePath, filename: "avatar.jpg"),
      });

      _dio.options.connectTimeout = Duration(milliseconds: 5000);
      _dio.options.receiveTimeout = Duration(milliseconds: 5000);
      // Send PUT request
      final response = await _dio
          .post("${apiUrl}/users/${user.id}", data: formData, queryParameters: {
        '_method': 'PUT',
      });

      // Handle response
      if (response.statusCode == 200) {
        return response.statusCode.toString();
      } else {
        return response.statusCode.toString();
      }
    } on DioException catch (e) {
      print('Dio Error: ${e.response?.data}');
      return e.response?.statusCode?.toString() ?? 'Unknown Error';
    } catch (e) {
      print('Error: $e');
      return 'Error';
    }
  }

  Future<int> assignCategories(int id, List<int> categories) async {
    try {
      final response = await _dio.post(
        "${apiUrl}/categories/assign",
        data: {
          'user_id': id,
          'category_id': categories,
        },
      );
      return response.statusCode!;
    } catch (e) {
      return 0;
    }
  }

  Future<List<Categories>> getUserIntersts(int id) async {
    try {
      final response = await _dio.get("${apiUrl}/categories/user/$id");
      if (response.statusCode == 200) {
        List<dynamic> responseData = response.data;
        List<Categories> categories =
            responseData.map((json) => Categories.fromJson(json)).toList();
        return categories;
      } else {
        throw Exception("Failed to load user interests ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Failed to load user interests: $e");
    }
  }

  Future<String> register(
      String firstName, String lastName, String email, String password) async {
    try {
      var response = await _dio.post(
        "${apiUrl}/register",
        data: {
          'first_name': firstName,
          'last_name': lastName,
          'email': email,
          'password': password,
          'password_confirmation': password,
          'device_name': 'mobile',
        },
        options: Options(
          headers: {
            'Accept': 'application/json',
          },
          followRedirects: false,
          validateStatus: (status) {
            return status! < 500; // Accept all status codes below 500
          },
        ),
      );

      var token = response.toString();
      if (!token.contains('html')) {
        await TokenManager.setToken(token);
      }

      return response.statusCode.toString();
    } catch (e) {
      print(e);
      return 'Error Occured';
    }
  }

  Future<List<Post>> getPostsForYou(int userId) async {
    try {
      final response = await _dio.get(apiUrl + "/posts/foryou/$userId");
      if (response.statusCode == 200) {
        Map<String, dynamic> responseData = response.data;
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

  Future<List<Post>> searchPosts(String query, List<String> categories,
      List<String> locations, List<String> conditions) async {
    try {
      final response = await _dio.post(apiUrl + "/posts/search", data: {
        'query': query,
        'categories': categories,
        'locations': locations,
        'conditions': conditions,
      });
      if (response.statusCode == 200) {
        List<dynamic> data = response.data;
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
      final response = await _dio.get(apiUrl + "/categories");

      if (response.statusCode == 200) {
        // the following line is causing the exception
        List<dynamic> responseData = response.data;
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
      final response = await _dio.get(apiUrl + "/locations");
      if (response.statusCode == 200) {
        List<dynamic> responseData = response.data;
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
        // options: Options(
        //   validateStatus: (status) {
        //     return status! < 500; // Accept all status codes below 500
        //   },
        // ),
        data: post.toJson(),
      );
      if (response.statusCode! >= 200 && response.statusCode! < 300) {
        return response.statusCode.toString();
      } else {
        return Future.error(response.statusCode.toString());
      }
    } on DioException catch (e) {
      return e.response!.statusCode.toString();
    }
  }

  Future<String> addFavPost(int userId, List<int> postId) async {
    try {
      final response = await _dio.post(
        "${apiUrl}/users/favourite-posts",
        options: Options(
          validateStatus: (status) {
            return status! < 500; // Accept all status codes below 500
          },
        ),
        data: {
          'user_id': userId,
          'post_id': postId,
        },
      );
      if (response.statusCode! >= 200 && response.statusCode! < 300) {
        return response.statusCode.toString();
      } else {
        return response.statusCode.toString();
      }
    } on DioException catch (e) {
      return e.response!.statusCode.toString();
    }
  }

  Future<List<User>> getFollowedBy(int userId) async {
    try {
      final response = await _dio.get("${apiUrl}/users/followed/$userId");
      if (response.statusCode == 200) {
        return (response.data as List)
            .map((json) => User.fromJson(json))
            .toList();
      } else {
        throw Exception("Failed to load user posts ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Failed to load user posts: $e");
    }
  }

  Future<List<User>> getFollowing(int userId) async {
    try {
      final response = await _dio.get("${apiUrl}/users/following/$userId");
      if (response.statusCode == 200) {
        return (response.data as List)
            .map((json) => User.fromJson(json))
            .toList();
      } else {
        throw Exception("Failed to load user posts ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Failed to load user posts: $e");
    }
  }

  Future<String> addFollowing(int userId, List<int> following_id) async {
    try {
      final response = await _dio.post("${apiUrl}/users/following", data: {
        'user_id': userId,
        'following_user_id': following_id,
      });
      if (response.statusCode == 200) {
        return response.statusCode.toString();
      } else {
        throw Exception("Failed to load user posts ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Failed to load user posts: $e");
    }
  }

  Future<String> addFollowedBy(int userId, List<int> followed_id) async {
    try {
      final response = await _dio.post("${apiUrl}/users/followed", data: {
        'user_id': userId,
        'followed_user_id': followed_id,
      });
      if (response.statusCode == 200) {
        return response.statusCode.toString();
      } else {
        throw Exception("Failed to load user posts ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Failed to load user posts: $e");
    }
  }

  // function to get fav posts
  Future<List<Post>> getFavPosts(int userId) async {
    try {
      final response =
          await _dio.get("${apiUrl}/users/favourite-posts/$userId");
      if (response.statusCode == 200) {
        List<dynamic> responseData = response.data;
        List<Post> posts =
            responseData.map((json) => Post.fromJson(json)).toList();
        return posts;
      } else {
        throw Exception("Failed to load user posts ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Failed to load user posts: $e");
    }
  }

  // create a getPostsByUser function that takes in a user id and returns a list of posts
  Future<List<Post>> getPostsByUser(int id) async {
    try {
      final response = await _dio.get("${apiUrl}/posts/user/$id");
      if (response.statusCode == 200) {
        List<dynamic> responseData = response.data;
        List<Post> posts =
            responseData.map((json) => Post.fromJson(json)).toList();
        return posts;
      } else {
        throw Exception("Failed to load user posts ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Failed to load user posts: $e");
    }
  }

  //create a get condition similar to getCategories fucntion above
  Future<List<Conditions>> getConditions() async {
    try {
      final response = await _dio.get(apiUrl + "/conditions");
      if (response.statusCode == 200) {
        List<dynamic> responseData = response.data;
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
