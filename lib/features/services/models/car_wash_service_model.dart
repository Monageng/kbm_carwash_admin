import '../../franchise/models/franchise_model.dart';

class CarWashService {
  int id;
  String? name;
  String? description;
  double? price;
  DateTime? createdAt;
  String? code;
  DateTime? fromDate;
  DateTime? toDate;
  bool? active;
  int? franchiseId;
  Franchise? franchise;

  CarWashService({
    required this.id,
    this.name,
    this.description,
    this.price,
    this.active,
    this.code,
    this.createdAt,
    this.fromDate,
    this.toDate,
    this.franchiseId,
    this.franchise,
  });

  factory CarWashService.fromJson(Map<String, dynamic> json) {
    return CarWashService(
      id: json['id'] as int,
      franchiseId: json['franchise_id'] as int,
      name: json['service_name'] as String?,
      description: json['description'] as String?,
      price: json['price'] != null ? (json['price'] as num).toDouble() : null,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : null,
      code: json['code'] as String?,
      fromDate:
          json['from_date'] != null ? DateTime.parse(json['from_date']) : null,
      toDate: json['to_date'] != null ? DateTime.parse(json['to_date']) : null,
      active: json['active'] as bool?,
      franchise: json['franchise'] != null
          ? Franchise.fromJson(json['franchise'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data["franchise_id"] = franchiseId;
    data['service_name'] = name;
    data['description'] = description;
    data['price'] = price;
    data['created_at'] = createdAt?.toIso8601String();
    data['code'] = code;
    data['from_date'] = fromDate?.toIso8601String();
    data['to_date'] = toDate?.toIso8601String();
    data['active'] = active;
    return data;
  }
}
