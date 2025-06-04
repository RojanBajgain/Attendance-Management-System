// import 'package:ams/feature/data/datasource/remote/api_client.dart';
// import 'package:ams/feature/data/datasource/remote/api_response.dart';
// import 'package:ams/feature/data/datasource/remote/api_urls.dart';

// class WebsocketRepo {
//   ApiClient apiClient;
//   WebsocketRepo({required this.apiClient});

//   Future<ApiResponse> getWebSocketUrl() async {
//     final token = apiClient.token;
//     final response = await ApiClient.getApi(
//       ApiUrls.wsUrl,
//       token: token,
//       apiKey: apiClient.organization,
//       fromJson: (json) => json,
//     );
//     return response;
//   }
// }
