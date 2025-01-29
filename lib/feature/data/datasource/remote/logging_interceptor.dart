import 'dart:async';
import 'dart:developer';

import 'package:http/http.dart';
import 'package:http_interceptor/models/interceptor_contract.dart';

///This class is used to log all the http methods
class LoggingInterceptor implements InterceptorContract {
  @override
  Future<BaseRequest> interceptRequest({
    required BaseRequest request,
  }) async {
    log('----- Request -----');
    log(request.toString());
    log(request.headers.toString());
    return request;
  }

  @override
  Future<BaseResponse> interceptResponse({
    required BaseResponse response,
  }) async {
    log('----- Response -----');
    log('Code: ${response.statusCode}');
    if (response is Response) {
      log((response).body);
    }
    return response;
  }

  @override
  FutureOr<bool> shouldInterceptRequest() {
    // Return true to intercept requests
    return true; // or false if you don't want to intercept requests
  }

  @override
  FutureOr<bool> shouldInterceptResponse() {
    // Return true to intercept responses
    return true; // or false if you don't want to intercept responses
  }
}
