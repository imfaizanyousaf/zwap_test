import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pusher_channels_flutter/pusher_channels_flutter.dart';
import 'package:zwap_test/global/commons/toast.dart';
import 'package:zwap_test/utils/conversation_mannager.dart';
import 'package:zwap_test/utils/dio_interceptor.dart';
import 'package:zwap_test/utils/token_manager.dart';
import 'package:zwap_test/view/onboarding.dart';
import 'package:zwap_test/view/splash_screen.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  void onEvent(PusherEvent event) {
    print("------------------ON EVENT-------------");
    print("onEvent: $event");
    showToast(message: "onEvent: $event");
  }

  void onSubscriptionSucceeded(String channelName, dynamic data) {
    print("------------------ON SUBSCRIPTION SUCCEEDED-------------");
    print("onSubscriptionSucceeded: $channelName data: $data");
  }

  void onError(String message, int? code, dynamic e) {
    print("------------------ON ERROR-------------");
    print("onError: $message code: $code exception: $e");
  }

  dynamic _channelAuthorizer(
      String channelName, String socketId, dynamic options) async {
    late final Dio _dio;
    _dio = Dio();
    _dio.interceptors.add(DioInterceptor());
    _dio.interceptors.add(LogInterceptor(
      requestHeader: true,
    ));
    final token = await TokenManager.getToken();

    showToast(message: token);

    final response = await _dio.post(
      "https://zwap.codeshar.com/broadcasting/auth",
      options: Options(
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      ),
    );
    if (response.statusCode == 200) {
      final authData = json.decode(response.data);
      return {
        'auth': 'socket_id=' + socketId + '&channel_name=' + channelName,
        'channel_data': authData,
        "shared_secret": "foobar"
      };
    } else {
      throw Exception('Failed to authorize channel');
    }
  }

  void onSubscriptionError(String message, dynamic e) {
    print("------------------ON SUBSCRIPTION ERROR-------------");
    print("onSubscriptionError: $message Exception: $e");
    showToast(message: "onSubscriptionError: $message Exception: $e");
  }

  void initializePusher() async {
    PusherChannelsFlutter pusher = PusherChannelsFlutter.getInstance();

    try {
      await pusher.init(
        apiKey: "425d80dbcfd83f2f16bb",
        cluster: "ap2",
        onEvent: onEvent,
        onError: onError,
        onSubscriptionError: onSubscriptionError,
        onSubscriptionSucceeded: onSubscriptionSucceeded,
        onAuthorizer: _channelAuthorizer,
      );

      await pusher.subscribe(channelName: "private-chat-channel-2");
      await pusher.connect();
    } catch (e) {
      print("ERROR: $e");
    }
  }

  @override
  void initState() {
    super.initState();
    // initializePusher();
  }

  @override
  void dispose() {
    // PusherChannelsFlutter.getInstance().disconnect();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        fontFamily: GoogleFonts.manrope().fontFamily,
      ),
      debugShowCheckedModeBanner: false,
      title: 'Zwap',
      // home: HomeScreen(),
      home: SplashScreen(
        child: OnboardingScreen(),
      ), // Set SplashScreen as the initial screen
    );
  }
}
