import 'dart:io';
import 'dart:convert';
import 'dart:developer';
import 'package:ams/feature/data/datasource/remote/api_client.dart';
import 'package:ams/feature/data/datasource/remote/api_response.dart';
import 'package:ams/feature/data/datasource/remote/api_urls.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';

class ChatRepo {
  final ApiClient apiClient;

  ChatRepo({required this.apiClient});

  // Get list of all chats/conversations
  Future<ApiResponse> getChats() async {
    final token = await apiClient.token;
    final organization = await apiClient.organization;

    final response = await apiClient.getApi(
      ApiUrls.chat,
      token: token,
      apiKey: organization,
      fromJson: (json) => json,
    );
    return response;
  }

  // Get messages for a specific user or department
  Future<ApiResponse> getChatMessages({
    int? receiverId,
    int? senderId,
    int? userId,
    int? departmentId,
  }) async {
    final token = await apiClient.token;
    final organization = await apiClient.organization;

    // Build query parameters based on the type of chat
    String queryString = '';

    if (departmentId != null && departmentId > 0) {
      // Department chat: user= (empty) and department=ID
      queryString = '?user=&department=$departmentId';
    } else if (userId != null && userId > 1) {
      // Admin/User chat: user=ID and department= (empty)
      queryString = '?user=$userId&department=';
    } else {
      // Default case - this shouldn't happen but handle it
      queryString = '?user=&department=';
    }

    String url = '${ApiUrls.chat}$queryString';

    final response = await apiClient.getApi(
      url,
      token: token,
      apiKey: organization,
      fromJson: (json) => json,
    );
    return response;
  }

  // Get department messages specifically
  Future<ApiResponse> getDepartmentMessages(int departmentId) async {
    final token = await apiClient.token;
    final organization = await apiClient.organization;

    String url = '${ApiUrls.chat}?user=&department=$departmentId';

    final response = await apiClient.getApi(
      url,
      token: token,
      apiKey: organization,
      fromJson: (json) => json,
    );
    return response;
  }

  // Get admin/user messages specifically
  Future<ApiResponse> getUserMessages(int userId) async {
    final token = await apiClient.token;
    final organization = await apiClient.organization;

    String url = '${ApiUrls.chat}?user=$userId&department=';

    final response = await apiClient.getApi(
      url,
      token: token,
      apiKey: organization,
      fromJson: (json) => json,
    );
    return response;
  }

  // Send a text message
  Future<ApiResponse> sendMessage({
    required String message,
    int? senderID,
    int? departmentID,
    String? mediaUrl,
  }) async {
    final token = await apiClient.token;
    final organization = await apiClient.organization;

    final response = await apiClient.postApi(
      ApiUrls.chat,
      requestBody: {
        'message': message,
        if (senderID != null) 'receiver': senderID,
        if (departmentID != null) 'department': departmentID,
        if (mediaUrl != null) 'media_url': mediaUrl,
      },
      token: token,
      apiKey: organization,
      fromJson: (json) => json,
    );
    return response;
  }

  // Send a message with file attachment
  Future<ApiResponse> sendMessageWithFile({
    required File file,
    String message = '',
    // int? senderID,
    int? receiverID,
    int? departmentID,
  }) async {
    try {
      final token = await apiClient.token;
      final organization = await apiClient.organization;

      final url = '${ApiUrls.baseUrl}${ApiUrls.chat}';

      // Create multipart request
      var request = http.MultipartRequest('POST', Uri.parse(url));

      // Add headers
      request.headers['Authorization'] = 'Bearer $token';
      request.headers['Accept'] = 'application/json';
      request.headers['x-organization'] = organization;

      // Add form fields
      request.fields['message'] = message;

      if (receiverID != null) {
        request.fields['receiver'] = receiverID.toString();
      }
      if (departmentID != null) {
        request.fields['department'] = departmentID.toString();
      }

      // Add file
      String fileName = basename(file.path);
      var multipartFile = await http.MultipartFile.fromPath(
        'document',
        file.path,
        filename: fileName,
      );
      request.files.add(multipartFile);
      log("Added document file: ${file.path}");

      // Log the request
      log("Request URL: $url");
      log("Request Headers: ${request.headers}");
      log("Request Fields: ${request.fields}");
      if (request.files.isNotEmpty) {
        log("Request Files: ${request.files.map((file) => '${file.field}: ${file.filename}').join(", ")}");
      }

      // Send request
      var response = await request.send();

      // Read the response
      var responseData = await response.stream.bytesToString();
      var jsonResponse = jsonDecode(responseData);

      // Log the response
      log("Response Status Code: ${response.statusCode}");
      log("Response Body: $responseData");

      // Check if the response is successful
      if (response.statusCode >= 200 && response.statusCode < 300) {
        return ApiResponse.fromJson(jsonResponse, (json) {
          // Log the parsed JSON
          log("Parsed JSON: $json");

          // Ensure the JSON is not null
          if (json == null) {
            throw Exception("Response data is null");
          }

          // Return the parsed JSON
          return json;
        });
      } else {
        // Handle server errors
        throw Exception(
          "Failed to send file: ${jsonResponse['message'] ?? 'Unknown error'}",
        );
      }
    } catch (e) {
      // Log the error
      log("Error in postProfileUpdate: $e");
      throw Exception("An error occurred: $e");
    }
  }
}
