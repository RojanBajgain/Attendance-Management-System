import 'package:flutter_dotenv/flutter_dotenv.dart';

class Environment {
  static String get fileName {
    // return '.env.development';
    // return '.env.production';

    return '.env.development'; // Replace with your desired default or logic
  }
 
  static String get apiBaseUrl {
    return dotenv.env['API_BASE_URL'] ?? "API_BASE_URL not specified";
  }
}
