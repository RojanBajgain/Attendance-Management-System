import 'dart:async';
import 'dart:io';

class ApiExceptionMsg {
  static String getMessageForException(dynamic e) {
    if (e is SocketException) {
      return "No Internet Connection";
    } else if (e is FormatException) {
      return "Could not parse data";
    } else if (e is TimeoutException) {
      return "Time out";
    } else {
      return "An error occurred: ${e.toString()}";
    }
  }
}
