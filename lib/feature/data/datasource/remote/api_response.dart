class ApiResponse<T> {
  ApiStatus status;
  T? response;
  String? message;

  ApiResponse.initial([this.message])
      : status = ApiStatus.INITIAL,
        response = null;

  ApiResponse.loading([this.message])
      : status = ApiStatus.LOADING,
        response = null;

  ApiResponse.completed(this.response, [this.message])
      : status = ApiStatus.SUCCESS;

  ApiResponse.error([this.message])
      : status = ApiStatus.ERROR,
        response = null;

  // Add a factory constructor for parsing JSON
  factory ApiResponse.fromJson(
      Map<String, dynamic> json, T Function(dynamic) fromJsonT) {
    return ApiResponse.completed(
      fromJsonT(json), // Parse the response using the provided function
      json['message'] as String?, // Parse the message (if available)
    );
  }

  @override
  String toString() {
    return "Status : $status \nData : $response \nMessage : $message";
  }
}

enum ApiStatus { INITIAL, LOADING, SUCCESS, ERROR }
