import 'package:dio/dio.dart';
import 'package:zwap_test/utils/token_manager.dart';

class DioInterceptor extends Interceptor {
  @override
  void onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    final token = await TokenManager.getToken();

    options.headers['Content-Type'] = 'application/json';
    if (!token.contains('html')) {
      options.headers['Authorization'] = "Bearer $token";
    }

    super.onRequest(options, handler);

    //   void updateSession(String updatedToken) {
    //   options.headers['Authorization'] = "Bearer $updatedToken";
    // }
  }
}
