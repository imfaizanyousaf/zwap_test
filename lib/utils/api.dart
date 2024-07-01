import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:dio/dio.dart';
import 'package:zwap_test/model/categories.dart';
import 'package:zwap_test/model/conditions.dart';
import 'package:zwap_test/model/locations.dart';
import 'package:zwap_test/model/post.dart';
import 'package:zwap_test/model/request.dart';
import 'package:zwap_test/model/reviews.dart';
import 'package:zwap_test/model/user.dart';
import 'package:zwap_test/utils/connection.dart';
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

  Future<List<User>> getAllUsers() async {
    String url;

    url = "${apiUrl}/users";

    try {
      final response = await _dio.get(url);
      if (response.statusCode == 200) {
        List<User> users =
            (response.data as List).map((json) => User.fromJson(json)).toList();
        return users;
      } else {
        throw Future.error(response);
      }
    } on DioException catch (e) {
      throw Future.error(e);
    }
  }

  Future<String> updateUser(User user, {String? filePath}) async {
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

  Future<int> assignLocations(int id, List<int> locations) async {
    try {
      final response = await _dio.post(
        "${apiUrl}/locations/assign",
        data: {
          'user_id': id,
          'location_id': locations,
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

  Future<List<Locations>> getUserLocations(int id) async {
    try {
      final response = await _dio.get("${apiUrl}/locations/user/$id");
      if (response.statusCode == 200) {
        List<dynamic> responseData = response.data;
        List<Locations> locations =
            responseData.map((json) => Locations.fromJson(json)).toList();
        return locations;
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

  Future<Post> getPostById(int postId) async {
    try {
      final response = await _dio.get(apiUrl + "/posts/$postId");
      if (response.statusCode == 200) {
        Post post = Post.fromJson(response.data);
        return post;
      } else {
        throw Exception("Failed to load posts ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Failed to load postss: $e");
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

  Future<List<Post>> getFollowingFeed(int userId) async {
    try {
      final response = await _dio.get(apiUrl + "/posts/following/$userId");
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
      if (await isConnected()) {
        throw Exception("Failed to load categories: $e");
      } else {
        throw 'No Internet Connection';
      }
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

  Future<String> exchanged(int postId) async {
    try {
      final response = await _dio.post(
        "${apiUrl}/posts/exchanged/$postId",
      );
      if (response.statusCode == 200) {
        return response.statusCode.toString();
      } else {
        throw Exception("Failed to exchange ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Failed to exchange: $e");
    }
  }

  Future<String> addPost(Post post) async {
    try {
      List<MultipartFile> imageFiles = [];
      if (post.images != null) {
        for (String imagePath in post.images!) {
          final file = File(imagePath);
          if (!await file.exists()) {
            throw Exception("File does not exist");
          }
          imageFiles.add(await MultipartFile.fromFile(file.path,
              filename: imagePath.split('/').last));
        }
      }
      // Create FormData
      FormData formData = FormData.fromMap({
        "title": post.title,
        "description": post.description,
        "user_id": post.userId,
        "condition_id": post.conditionId,
        "categories": post.categories != null
            ? post.categories!.map((e) => e.id).toList()
            : [],
        "locations": post.locations != null
            ? post.locations!.map((e) => e.id).toList()
            : [],
        "published": post.published == true ? 1 : 0,
        "images": imageFiles,
      }, ListFormat.multiCompatible);

      // Send POST request
      final response = await _dio.post(
        "${apiUrl}/posts",
        data: formData,
      );
      print(formData.fields);
      // Handle response
      if (response.statusCode! >= 200 && response.statusCode! < 300) {
        return response.statusCode.toString();
      } else {
        return Future.error(response.statusCode.toString());
      }
    } on DioException catch (e) {
      FormData data = e.requestOptions.data;

      print("ERROR POSTING: ${jsonEncode(e.response.toString())}");

      return e.response?.statusCode?.toString() ?? 'Unknown error';
    }
  }

  Future<String> deletePost(int postId) async {
    try {
      final response = await _dio.delete(
        "${apiUrl}/posts/${postId}",
        options: Options(
          validateStatus: (status) {
            return status! < 500; // Accept all status codes below 500
          },
        ),
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

  Future<String> addFeedback(String rating, int feedbackOn, int feedbackBy,
      int feedbackTo, String comment) async {
    try {
      final response = await _dio.post(
        "${apiUrl}/feedbacks",
        data: {
          "rating": rating,
          "comment": comment,
          "feedback_by": feedbackBy,
          "feedback_to": feedbackTo,
          "feedback_on": feedbackOn
        },
      );
      if (response.statusCode! >= 200 && response.statusCode! < 300) {
        return response.statusCode.toString();
      } else {
        return response.statusCode.toString();
      }
    } on DioException catch (e) {
      print('FEEDBACK RESPONSE: ${jsonDecode(e.response.toString())}');
      return e.response!.statusCode.toString();
    }
  }

  Future<List<Reviews>> getFeedbackByUser(int userId) async {
    try {
      final response = await _dio.get(
        "${apiUrl}/feedbacks/user/${userId}",
      );
      List<dynamic> responseData = response.data;
      List<Reviews> reviews =
          responseData.map((json) => Reviews.fromJson(json)).toList();
      return reviews;
    } on DioException catch (e) {
      throw e.response!.statusCode.toString();
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
      if (await isConnected()) {
        throw Exception("Failed to load user posts: $e");
      } else {
        throw 'No Internet Connection';
      }
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

  Future<List<Request>> getReceivedRequests() async {
    try {
      final response = await _dio.get(apiUrl + "/requests/received");
      if (response.statusCode == 200) {
        List<dynamic> responseData = response.data;
        List<Request> requests =
            responseData.map((json) => Request.fromJson(json)).toList();
        return requests;
      } else {
        throw Exception("Failed to load requests ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Failed to load requests: $e");
    }
  }

  Future<List<Request>> getSentRequests() async {
    try {
      final response = await _dio.get(apiUrl + "/requests/sent");
      if (response.statusCode == 200) {
        List<dynamic> responseData = response.data;
        List<Request> requests =
            responseData.map((json) => Request.fromJson(json)).toList();
        // remove the requests that have been canceled. you can check its status from request.status
        requests.removeWhere((element) => element.status == 'canceled');
        return requests;
      } else {
        throw Exception("Failed to load requests ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Failed to load requests: $e");
    }
  }

  // function to add request
  Future<String> addRequest(
      int requestPostId, int exchangePostId, String requestMessage) async {
    try {
      final response = await _dio.post("${apiUrl}/requests", data: {
        'requested_post_id': requestPostId,
        'exchange_post_id': exchangePostId,
        'request_message': requestMessage,
      });
      if (response.statusCode == 200) {
        return response.statusCode.toString();
      } else {
        throw Exception("Failed to update request ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Failed to update request: $e");
    }
  }

  // function to cancel request
  Future<String> cancelRequest(int requestId) async {
    try {
      final response = await _dio.get(
        "${apiUrl}/requests/$requestId/cancel",
      );
      if (response.statusCode == 200) {
        return response.statusCode.toString();
      } else {
        throw Exception("Failed to update request ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Failed to update request: $e");
    }
  }

  Future<String> reviewPost(int requestId) async {
    try {
      final response = await _dio.get(
        "${apiUrl}/requests/$requestId/review",
      );
      if (response.statusCode == 200) {
        return response.statusCode.toString();
      } else {
        throw Exception("Failed to update request ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Failed to update request: $e");
    }
  }

  Future<String> acceptRequest(int requestId) async {
    try {
      final response = await _dio.get(
        "${apiUrl}/requests/$requestId/accept",
      );
      if (response.statusCode == 200) {
        return response.statusCode.toString();
      } else {
        throw Exception("Failed to update request ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Failed to update request: $e");
    }
  }

  Future<String> rejectRequest(int requestId) async {
    try {
      final response = await _dio.get(
        "${apiUrl}/requests/$requestId/reject",
      );
      if (response.statusCode == 200) {
        return response.statusCode.toString();
      } else {
        throw Exception("Failed to update request ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Failed to update request: $e");
    }
  }
}
