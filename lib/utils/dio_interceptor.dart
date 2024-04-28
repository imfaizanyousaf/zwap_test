import "package:dio/dio.dart";
import "package:zwap_test/utils/token_manager.dart";

class DioInterceptor extends Interceptor {
  @override
  void onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    print("Options");
    print(options.headers);
    print("Options");
    final token = await TokenManager.getToken();
    options.headers['Content-Type'] = 'application/json';
    options.headers['X-XSRF-TOKEN'] = token;
    options.headers['Referer'] = "http://localhost:8000";
    super.onRequest(options, handler);
  }
}
