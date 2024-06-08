class PrimaryKeyResponse {
  int uuid;
  PrimaryKeyResponse({required this.uuid});

  factory PrimaryKeyResponse.fromJson(Map json) {
    return PrimaryKeyResponse(
      uuid: json['id'],
    );
  }
}
