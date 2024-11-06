import '../../users/models/user_model.dart';

class Referral {
  int id;
  String? status;
  DateTime? fromDate;
  DateTime? toDate;
  String? desciption;
  String? referelCode;
  UserModel? senderClient;
  UserModel? recipientClient;
  String? referralCode;

  Referral({
    required this.id,
    this.status,
    this.fromDate,
    this.toDate,
    this.desciption,
    this.recipientClient,
    this.senderClient,
    required this.referralCode,
  });

  // Factory constructor to create Referral instance from JSON
  factory Referral.fromJson(Map<String, dynamic> json) {
    return Referral(
      id: json['id'],
      status: json['status'],
      fromDate: json['valid_from'] != null
          ? DateTime.parse(json['valid_from'])
          : null,
      toDate:
          json['valid_to'] != null ? DateTime.parse(json['valid_to']) : null,
      desciption: json['description'],
      senderClient: json['sender_client'] != null
          ? UserModel.fromJson(json['sender_client'])
          : null,
      recipientClient: json['recipient_client'] != null
          ? UserModel.fromJson(json['recipient_client'])
          : null,
      referralCode: json['referral_code'],
    );
  }

  // Method to convert Referral instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'status': status,
      'valid_from': fromDate?.toIso8601String(),
      'valid_to': toDate?.toIso8601String(),
      'description': desciption,
      'sender_client': senderClient?.toJson(),
      'recipient_client': recipientClient?.toJson(),
      'referral_code': referralCode,
    };
  }
}
