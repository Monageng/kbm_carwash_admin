import 'province.dart';

class City {
  int id;
  DateTime? createdAt;
  String? name;
  int? provinceId;
  Province? province;

  City({
    required this.id,
    this.createdAt,
    this.name,
    this.provinceId,
    this.province,
  });

  factory City.fromJson(Map<String, dynamic> json) {
    return City(
      id: json['id'],
      createdAt: DateTime.parse(json['created_at']),
      name: json['name'],
      provinceId: json['province_id'],
      province:
          json['province'] != null ? Province.fromJson(json['province']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uuidid': id,
      'created_at': createdAt!.toIso8601String(),
      'name': name,
      'province_id': provinceId,
    };
  }
}
