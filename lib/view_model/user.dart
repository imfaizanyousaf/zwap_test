import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:zwap_test/utils/token_manager.dart';

//create user view_model class that uses http package to make a request to the server login api and pass login parameters wrapped in try catch

class UserViewModel {
  String baseUrl = "https://zwap.codeshar.com/login";
  String baseUrl2 = "https://zwap.codeshar.com/api/user";

  //print response from userViewModel.login api and wait while the response is being fetched
  Future<String> login(String email, String password) async {
    String? xsrfToken;

    try {
      // Fetch CSRF token
      final response = await http
          .get(Uri.parse("https://zwap.codeshar.com/sanctum/csrf-cookie"));
      if (response.statusCode == 204) {
        xsrfToken = response.headers['set-cookie'];
        TokenManager.setToken(xsrfToken!);
      } else {
        throw Exception('Failed to fetch CSRF token: ${response.statusCode}');
      }

      // Send login request
      final headers = {
        'Accept': 'application/json',
        'X-XSRF-TOKEN': xsrfToken,
      };
      final loginResponse = await http.post(
        Uri.parse(baseUrl),
        body: {
          'email': email,
          'password': password,
        },
        headers: headers,
      );

      if (loginResponse.statusCode == 200 || loginResponse.statusCode == 204) {
        return "Success";
      } else {
        print("Login Failed: ${loginResponse.body}");
        print(" Headers: ${headers}");
        return ('Failed to login: ${loginResponse.statusCode}');
      }
    } catch (e) {
      return ('Login failed: Error Code $e');
    }
  }

  Future<String> getUser() async {
    final xsrfToken = await TokenManager.getToken();
    try {
      final headers = {'Accept': 'application/json', 'X-XSRF-TOKEN': xsrfToken};
      final response = await http.get(Uri.parse(baseUrl2),
          headers: headers.cast<String, String>());
      if (response.statusCode == 200) {
        return response.body;
      } else {
        return Future.error(response.body);
      }
    } catch (e) {
      return Future.error(e);
    }
  }

  //function to get list of posts from the api for the for you tab
}
