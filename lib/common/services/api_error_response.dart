class ErrorResponse {
  String code;
  String details;
  String message;

  ErrorResponse(
      {required this.code, required this.details, required this.message});

  factory ErrorResponse.fromJson(Map<String, dynamic> json) {
    return ErrorResponse(
        code: json['code'], details: json['details'], message: json['message']);
  }
}
