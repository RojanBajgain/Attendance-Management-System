import 'package:http_interceptor/http/intercepted_client.dart';

import 'logging_interceptor.dart';

class MyHttpClient {
  static final client = InterceptedClient.build(
    interceptors: [LoggingInterceptor()],
    requestTimeout: const Duration(seconds: 60),
  );
}
