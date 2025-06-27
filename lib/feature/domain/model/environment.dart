import 'package:flutter_dotenv/flutter_dotenv.dart';

class Environment {
  static String get fileName {
    return '.env.development';
    // return '.env.production';
  }

  // static String get apiKey {
  //   return dotenv.env['API_KEY'] ?? "API_KEY not specified";
  // }

  static String get apiBaseUrl {
    return dotenv.env['API_BASE_URL'] ?? "API_BASE_URL not specified";
  }
}
