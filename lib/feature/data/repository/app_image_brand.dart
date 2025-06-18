// import 'package:ams/feature/data/datasource/remote/api_client.dart';
// import 'package:ams/feature/data/datasource/remote/api_response.dart';
// import 'package:ams/feature/data/datasource/remote/api_urls.dart';

// class AppImageBrandRepo {
//   final ApiClient apiClient;

//   AppImageBrandRepo({required this.apiClient});

//   // Get list of all image brands
//   Future<ApiResponse> getImageBrands() async {
//     final token = apiClient.token;

//     final response = await ApiClient.getApi(
//       ApiUrls.imageBrand,
//       token: token,
//       apiKey: apiClient.organization,
//       fromJson: (json) => json,
//     );
//     return response;
//   }
// }
