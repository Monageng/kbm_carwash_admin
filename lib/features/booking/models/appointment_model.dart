import '../../services/models/car_wash_service_model.dart';
import '../../services/models/service_franchise_link_model.dart';
import '../../users/models/user_model.dart';

class Appointment {
  int id;
  int? franchiseId;
  bool? active;
  String? serviceName;
  DateTime? createAt;
  DateTime? modifiedDate;
  DateTime? date;
  String? status;
  int? clientId;
  int? carModelId;
  int? referalId;
  int? serviceFranchiseLinkId;
  String? time;
  UserModel? client;
  CarWashService? service;
  ServiceFranchiseLink? serviceFranchiseLink;

  Appointment({
    this.serviceName,
    this.time,
    this.date,
    this.status,
    this.active,
    this.clientId,
    this.createAt,
    this.modifiedDate,
    required this.id,
    this.client,
    this.franchiseId,
    this.carModelId,
    this.referalId,
    this.service,
    this.serviceFranchiseLinkId,
    this.serviceFranchiseLink,
  });

  factory Appointment.fromJson(Map<String, dynamic> json) {
    var appointment = Appointment(
      id: json['id'],
      franchiseId: json["franchise_id"],
      time: json['time'],
      active: json['active'],
      serviceName: json['service_name'],
      createAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : null,
      modifiedDate: json['modified_date'] != null
          ? DateTime.parse(json['modified_date'])
          : null,
      date: json['date'] != null ? DateTime.parse(json['date']) : null,
      status: json['status'],
      clientId: json['client_id'],
      referalId: json["referal_id"],
      carModelId: json['car_model_id'],
      serviceFranchiseLinkId: json['service_franchise_link_id'],
      client:
          json['client'] != null ? UserModel.fromJson(json['client']) : null,
      service: json['service'] != null
          ? CarWashService.fromJson(json['service'])
          : null,
      serviceFranchiseLink: json['service_franchise_links'] != null
          ? ServiceFranchiseLink.fromJson(json['service_franchise_links'])
          : null,
    );

    return appointment;
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'active': active,
      "time": time,
      'service_name': serviceName,
      'modified_date': modifiedDate?.toIso8601String(),
      'created_at':
          createAt?.toIso8601String(), // Serialize DateTime to ISO 8601 format
      'date': date?.toIso8601String(), // Serialize DateTime to ISO 8601 format
      'status': status,
      'client_id': clientId,
      "franchise_id": franchiseId,
      "car_model_id": carModelId,
      "referal_id": referalId,
      "service_franchise_link_id": serviceFranchiseLinkId
    };
  }
}
