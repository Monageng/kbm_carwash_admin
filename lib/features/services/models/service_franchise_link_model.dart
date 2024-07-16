import '../../franchise/models/franchise_model.dart';
import 'car_models_model.dart';
import 'car_wash_service_model.dart';

class ServiceFranchiseLink {
  int id;
  int? serviceId;
  int? franchiseId;
  int? carModelId;
  double? price;
  DateTime? createdAt;
  bool? active;
  Franchise? franchise;
  CarWashService? service;
  CarModel? carModel;

  ServiceFranchiseLink({
    required this.id,
    this.serviceId,
    this.price,
    this.active,
    this.createdAt,
    this.franchiseId,
    this.carModelId,
    this.franchise,
    this.service,
    this.carModel,
  });

  factory ServiceFranchiseLink.fromJson(Map<String, dynamic> json) {
    return ServiceFranchiseLink(
      id: json['id'] as int,
      franchiseId: json["franchise_id"],
      carModelId: json["car_model_id"],
      serviceId: json['service_id'],
      price: json['price'] != null ? (json['price'] as num).toDouble() : null,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : null,
      active: json['active'] as bool?,
      service: json['services'] != null
          ? CarWashService.fromJson(json['services'])
          : null,
      franchise: json['franchise'] != null
          ? Franchise.fromJson(json['franchise'])
          : null,
      carModel: json['car_model'] != null
          ? CarModel.fromJson(json['car_model'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data["franchise_id"] = franchiseId;
    data['service_id'] = serviceId;
    data["car_model_id"] = carModelId;
    data['price'] = price;
    data['created_at'] = createdAt?.toIso8601String();
    data['active'] = active;
    return data;
  }
}
