// import 'package:ams/feature/data/datasource/remote/api_client.dart';
// import 'package:ams/feature/data/datasource/remote/api_response.dart';
// import 'package:ams/feature/data/datasource/remote/api_urls.dart';

// class PrivacyRepo {
//   final ApiClient apiClient;

//   PrivacyRepo({required this.apiClient});

//   Future<ApiResponse> getprivacydata(String typeID) async {
//     final token = apiClient.token;

//     var url = '${ApiUrls.privacydata}?typeID=$typeID';
//     final response = await ApiClient.getApi(
//       url,
//       token: token,
//       apiKey: apiClient.organization,
//       fromJson: (json) => PrivacyModel.fromJson(json),
//     );
//     return response;
//   }
// }
