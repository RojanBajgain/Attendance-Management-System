import 'package:http/http.dart' as http;

class ApiMessage {
  static String getMessage(int statusCode, http.Response response) {
    // Map<String, dynamic> jsonResponse = jsonDecode(response.body);
    String message = response.body;
    switch (statusCode) {
      case 200:
        return 'Success Request. $message';
      case 201:
        return 'Success Request. $message';
      case 400:
        return 'Bad Request. $message';
      case 401:
        {
          return 'Unauthorised. $message';
        }
      case 403:
        return 'Forbidden. $message';
      case 404:
        return 'Not Found. $message';
      case 416:
        return 'Not Found. $message';
      case 417:
        return 'Expectation Failed. $message';
      case 500:
        return 'Bad Request. $message';
      case 502:
        return 'Server Error. $message';
      default:
        return 'Something went wrong. $message';
    }
  }
}
