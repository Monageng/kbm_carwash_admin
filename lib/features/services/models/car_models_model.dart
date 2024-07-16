class CarModel {
  int id;
  String? carType;
  String? imageUrl;
  DateTime? createdAt;

  CarModel({
    required this.id,
    this.carType,
    this.imageUrl,
    this.createdAt,
  });

  factory CarModel.fromJson(Map<String, dynamic> json) {
    return CarModel(
      id: json['id'] as int,
      carType: json["car_type"],
      imageUrl: json['image_url'] as String?,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data["car_type"] = carType;
    data['image_url'] = imageUrl;
    data['created_at'] = createdAt?.toIso8601String();
    return data;
  }
}
