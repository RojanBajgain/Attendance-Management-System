import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

import 'package:ams/feature/data/datasource/remote/api_client.dart';
import 'package:ams/feature/data/datasource/remote/api_response.dart';
import 'package:ams/feature/data/datasource/remote/api_urls.dart';
import 'package:ams/feature/presentation/pages/profile/model/profile_detail_model.dart';
import 'package:ams/feature/presentation/pages/profile/model/profile_model.dart';
import 'package:intl/intl.dart';

class ProfileRepo {
  final ApiClient apiClient;

  ProfileRepo({required this.apiClient});

  // Get profile
  Future<ApiResponse> getProfile() async {
    final token = await apiClient.token;
    final organization = await apiClient.organization;

    // Get the current user's profile ID from storage
    final GetStorage box = GetStorage();
    final userId = box.read('user_id');

    if (userId == null) {
      throw Exception('User ID not found');
    }

    final url = "${ApiUrls.profile}$userId/";

    final response = await apiClient.getApi(
      url,
      token: token,
      apiKey: organization,
      fromJson: (json) => ProfileModel.fromJson(json),
    );
    return response;
  }

  // Get country list
  Future<ApiResponse> getCountryList() async {
    final token = await apiClient.token;
    final organization = await apiClient.organization;

    final response = await apiClient.getApi(
      ApiUrls.getcountry,
      token: token,
      apiKey: organization,
      fromJson: (json) => json,
    );
    return response;
  }

  // Getting profile details
  Future<ApiResponse> getProfileDetail(String id) async {
    final token = await apiClient.token;
    final organization = await apiClient.organization;

    final url = "${ApiUrls.profiledetail}$id/";

    final response = await apiClient.getApi(
      url,
      token: token,
      apiKey: organization,
      fromJson: (json) => ProfileDetailModel.fromJson(json),
    );
    return response;
  }

  // Updating user info
  Future<ApiResponse> postProfileUpdate(
    int id,
    int profileID,
    File? profileImage,
    String username,
    String dob,
    String phonenumber,
    String gender,
    String joinedDate,
    List<String> skills,
    File? resume,
    String empno,
  ) async {
    try {
      final token = await apiClient.token;
      final organization = await apiClient.organization;

      // Ensure the URL is complete (include the scheme and host)
      final url = '${ApiUrls.baseUrl}${ApiUrls.updateprofile}$id/';

      // Create a multipart request
      var request = http.MultipartRequest('PATCH', Uri.parse(url));

      // Add headers
      request.headers['Authorization'] = 'Bearer $token';
      request.headers['Accept'] = 'application/json';
      request.headers['x-organization'] = organization;

      // Add fields
      request.fields['id'] = id.toString();
      request.fields['user.full_name'] = username;
      request.fields['dob'] = dob;

      request.fields['phone_number'] = phonenumber;
      request.fields['gender'] = gender;
      request.fields['joined_date'] = joinedDate;
      request.fields['skills'] = skills.join(",");
      request.fields['employee_no'] = empno;
      // Add profile image file if it exists
      if (profileImage != null) {
        var profileImageFile = await http.MultipartFile.fromPath(
          'profile_image',
          profileImage.path,
        );
        request.files.add(profileImageFile);
        log("Added profile image: ${profileImage.path}");
      }

      // Add resume file if it exists
      if (resume != null) {
        var resumeFile = await http.MultipartFile.fromPath(
          'resume',
          resume.path,
        );
        request.files.add(resumeFile);
        log("Added resume file: ${resume.path}");
      } else {
        log("No resume file to add.");
      }

      // Log the request
      log("Request URL: $url");
      log("Request Headers: ${request.headers}");
      log("Request Fields: ${request.fields}");
      if (request.files.isNotEmpty) {
        log("Request Files: ${request.files.map((file) => '${file.field}: ${file.filename}').join(", ")}");
      }

      // Send the request
      var response = await request.send();

      // Read the response
      var responseData = await response.stream.bytesToString();
      var jsonResponse = jsonDecode(responseData);

      // Log the response
      log("Response Status Code: ${response.statusCode}");
      log("Response Body: $responseData");

      // Check if the response is successful
      if (response.statusCode == 200) {
        return ApiResponse.fromJson(jsonResponse, (json) {
          // Log the parsed JSON
          log("Parsed JSON: $json");

          // Ensure the JSON is not null
          if (json == null) {
            throw Exception("Response data is null");
          }

          // Return the parsed JSON (or a parsed object)
          return json; // Replace this with your actual parsing logic
        });
      } else {
        // Handle server errors
        throw Exception(
          "Failed to update profile: ${jsonResponse['message'] ?? 'Unknown error'}",
        );
      }
    } catch (e) {
      // Log the error
      log("Error in postProfileUpdate: $e");
      throw Exception("An error occurred: $e");
    }
  }

  // Updating user new Address
  Future<ApiResponse> postnewuserAddress(
    int userID,
    int issuedCountry,
    String province,
    String city,
    String addressLineOne,
    String addressLineTwo,
    String zipcode,
    String addressType,
  ) async {
    final token = await apiClient.token;
    final organization = await apiClient.organization;

    final url = ApiUrls.postuseraddress;

    final response = await apiClient.postApi(
      url,
      requestBody: {
        "profile": userID,
        "issued_country": issuedCountry,
        "province": province,
        "postal_code": zipcode,
        "city": city,
        "address_type": addressType,
        "address_line_one": addressLineOne,
        "address_line_two": addressLineTwo,
      },
      token: token,
      apiKey: organization,
      fromJson: null,
    );
    return response;
  }

  // Updating user Address
  Future<ApiResponse> postuserAddress(
    int id,
    int addressID,
    String country,
    String province,
    String city,
    String addressLineOne,
    String addressLineTwo,
    String zipcode,
    String addressType,
  ) async {
    final token = await apiClient.token;
    final organization = await apiClient.organization;

    final url = '${ApiUrls.updateaddress}$addressID/';

    int countryId = int.tryParse(country) ?? 1;

    final response = await apiClient.patchApi(
      url,
      requestBody: {
        "profile": id,
        "issued_country": countryId,
        "province": province,
        "postal_code": zipcode,
        "city": city,
        "address_type": addressType,
        "address_line_one": addressLineOne,
        "address_line_two": addressLineTwo,
      },
      token: token,
      apiKey: organization,
      fromJson: null,
    );
    return response;
  }

  // Updating user bank details
  Future<ApiResponse> postuserBankDetails(
    int bankdetailID,
    int profileID,
    String bankname,
    String bankaccount,
    String bankaccountname,
    String bankbranch,
    String ispayroll,
  ) async {
    final token = await apiClient.token;
    final organization = await apiClient.organization;

    // Debug print to verify values
    print('Updating bank detail with ID: $bankdetailID');
    print('Payload: {'
        'profile: $profileID, '
        'bank_name: $bankname, '
        'bank_account: $bankaccount, '
        'bank_account_name: $bankaccountname, '
        'bank_branch: $bankbranch, '
        'is_payroll: $ispayroll'
        '}');

    final url = '${ApiUrls.updatebankdetail}$bankdetailID/';

    try {
      final response = await apiClient.patchApi(
        url,
        requestBody: {
          "profile": profileID,
          "bank_name": bankname,
          "bank_account": bankaccount,
          "bank_account_name": bankaccountname,
          "bank_branch": bankbranch,
          "is_payroll": ispayroll.toLowerCase() == 'true',
        },
        token: token,
        apiKey: organization,
        fromJson: null,
      );

      print('PATCH response: ${response.status} - ${response.message}');
      return response;
    } catch (e) {
      print('PATCH error: $e');
      rethrow;
    }
  }

  // add new user bankk account
  Future<ApiResponse> postnewBankDetails(
    int profileID,
    String bankName,
    String bankAccount,
    String bankaccountName,
    String bankBranch,
    String isPayroll,
  ) async {
    final token = await apiClient.token;
    final organization = await apiClient.organization;

    const url = ApiUrls.postnewbankdetail;

    // Debug print to verify the profile ID
    print('Attempting to create bank detail for profile ID: $profileID');

    final response = await apiClient.postApi(
      url,
      requestBody: {
        'profile': profileID.toString(),
        "bank_name": bankName,
        "bank_account": bankAccount,
        "bank_account_name": bankaccountName,
        "bank_branch": bankBranch,
        "is_payroll": isPayroll,
      },
      token: token,
      apiKey: organization,
      fromJson: null,
    );
    return response;
  }

  // Updating user documents
  Future<ApiResponse> postuserDocuments(
    int documentID,
    int userID,
    String type,
    String title,
    String? identifier,
    DateTime? issuedDate,
    int profileId,
    List<int> filesToKeep,
    File? documentImage,
    File? file,
  ) async {
    final token = await apiClient.token;
    final organization = await apiClient.organization;

    final url = '${ApiUrls.baseUrl}${ApiUrls.updatedocuments}$documentID/';

    var request = http.MultipartRequest('PATCH', Uri.parse(url));

    request.headers['Authorization'] = 'Bearer $token';
    request.headers['x-organization'] = organization;

    request.fields['id'] = documentID.toString();
    request.fields['user'] = userID.toString();
    request.fields['type'] = type;
    request.fields['title'] = title;
    request.fields['identifier'] =
        identifier != null ? identifier.toString() : '';
    request.fields['issued_date'] =
        issuedDate != null ? DateFormat('yyyy-MM-dd').format(issuedDate) : '';
    request.fields['profile'] = profileId.toString();

    if (filesToKeep.isNotEmpty) {
      request.fields['files_to_keep'] = filesToKeep.join(',');
    }

    if (documentImage != null) {
      request.files.add(await http.MultipartFile.fromPath(
        'new_files',
        documentImage.path,
      ));
    }

    if (file != null &&
        (documentImage == null || file.path != documentImage.path)) {
      request.files.add(await http.MultipartFile.fromPath(
        'new_files',
        file.path,
      ));
    }

    log("Request Fields: ${request.fields}");
    log("Request Files: ${request.files}");

    var response = await request.send();

    // Read the response
    var responseData = await response.stream.bytesToString();
    var jsonResponse = jsonDecode(responseData);

    // Log the response
    log("Response Status Code: ${response.statusCode}");
    log("Response Body: $responseData");

    if (response.statusCode == 200) {
      return ApiResponse.fromJson(jsonResponse, (json) {
        log("Parsed JSON: $json");

        if (json == null) {
          throw Exception("Response data is null");
        }

        return json;
      });
    } else {
      final errorMessage = jsonResponse['message'] ?? 'Unknown error';
      log("Server Error: $errorMessage");
      throw Exception("Failed to update document: $errorMessage");
    }
  }

  // Post users new documents
  Future<ApiResponse> postNewUserDocument({
    required int userId,
    required String type,
    required String title,
    required String? issuedDate,
    required String? identifier,
    required int profileId,
    required File? documentFile,
  }) async {
    final token = await apiClient.token;
    final organization = await apiClient.organization;

    final url = '${ApiUrls.baseUrl}${ApiUrls.postnewedocuments}';

    var request = http.MultipartRequest('POST', Uri.parse(url));

    request.headers['Authorization'] = 'Bearer $token';
    request.headers['x-organization'] = organization;

    // Add fields according to the expected payload
    request.fields['documents[1][type]'] = type;
    request.fields['documents[1][title]'] = title;
    if (issuedDate != null && issuedDate.isNotEmpty) {
      request.fields['documents[1][issued_date]'] = issuedDate;
    }
    if (identifier != null && identifier.isNotEmpty) {
      request.fields['documents[1][identifier]'] = identifier;
    }
    request.fields['documents[1][profile]'] = profileId.toString();

    // Add the document file if provided
    if (documentFile != null) {
      request.files.add(await http.MultipartFile.fromPath(
        'documents[1][document_file][]',
        documentFile.path,
      ));
    }

    log("Request Fields: ${request.fields}");
    log("Request Files: ${request.files}");

    var response = await request.send();

    // Read the response
    var responseData = await response.stream.bytesToString();
    var jsonResponse = jsonDecode(responseData);

    // Log the response
    log("Response Status Code: ${response.statusCode}");
    log("Response Body: $responseData");

    if (response.statusCode == 201 || response.statusCode == 200) {
      return ApiResponse.fromJson(jsonResponse, (json) {
        log("Parsed JSON: $json");

        if (json == null) {
          throw Exception("Response data is null");
        }

        return json;
      });
    } else {
      final errorMessage = jsonResponse['message'] ?? 'Unknown error';
      log("Server Error: $errorMessage");
      throw Exception("Failed to add new document: $errorMessage");
    }
  }

  // Delete User Document
  Future<ApiResponse> deleteuserDocument(int id) async {
    final token = await apiClient.token;
    final organization = await apiClient.organization;

    final response = await apiClient.deleteApi(
      '${ApiUrls.deletedocument}$id/',
      token: token,
      apiKey: organization,
      fromJson: null,
    );
    return response;
  }

  // Delete User Bank Details
  Future<ApiResponse> deleteuserBankDetails(int id) async {
    final token = await apiClient.token;
    final organization = await apiClient.organization;

    final response = await apiClient.deleteApi(
      '${ApiUrls.deletebankdetails}$id/',
      token: token,
      apiKey: organization,
      fromJson: null,
    );
    return response;
  }
}
