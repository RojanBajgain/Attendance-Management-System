// ignore_for_file: constant_identifier_names

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

  @override
  String toString() {
    return "Status : $status \nData : $response \nMessage : $message";
  }
}

enum ApiStatus { INITIAL, LOADING, SUCCESS, ERROR }
