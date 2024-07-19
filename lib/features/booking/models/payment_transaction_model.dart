import '../../franchise/models/franchise_model.dart';
import '../../services/models/car_wash_service_model.dart';
import '../../users/models/user_model.dart';

class PaymentTransaction {
  int id;
  DateTime? createAt;
  DateTime? date;
  double? amount;
  int? clientId;
  int? franchiseId;
  int? servcieId;
  UserModel? client;
  Franchise? franchise;
  CarWashService? service;

  PaymentTransaction({
    this.amount,
    this.date,
    this.clientId,
    this.createAt,
    required this.id,
    this.client,
    this.servcieId,
    this.franchiseId,
    this.franchise,
    this.service,
  });

  factory PaymentTransaction.fromJson(Map<String, dynamic> json) {
    return PaymentTransaction(
      id: json['id'],
      franchiseId: json["franchise_id"],
      amount: json['amount'],
      createAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : null,
      date: json['date'] != null ? DateTime.parse(json['date']) : null,
      servcieId: json['servcie_id'],
      clientId: json['client_id'],
      client:
          json['client'] != null ? UserModel.fromJson(json['client']) : null,
      franchise: json['franchise'] != null
          ? Franchise.fromJson(json['franchise'])
          : null,
      service: json['service'] != null
          ? CarWashService.fromJson(json['service'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      "amount": amount,
      'created_at':
          createAt?.toIso8601String(), // Serialize DateTime to ISO 8601 format
      'date': date?.toIso8601String(), // Serialize DateTime to ISO 8601 format
      'client_id': clientId,
      "franchise_id": franchiseId,
      "sercive_id": servcieId,
    };
  }
}
