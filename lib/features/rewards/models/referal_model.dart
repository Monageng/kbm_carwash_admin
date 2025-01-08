import 'package:kbm_carwash_admin/features/franchise/models/franchise_model.dart';

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
  Franchise? franchise;
  String? referralCode;
  DateTime? modifiedDate;

  Referral({
    required this.id,
    this.status,
    this.fromDate,
    this.toDate,
    this.modifiedDate,
    this.desciption,
    this.recipientClient,
    this.senderClient,
    this.franchise,
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
      modifiedDate: json['modified_date'] != null
          ? DateTime.parse(json['modified_date'])
          : null,
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
      'sender_client': senderClient!.id,
      'recipient_client': recipientClient?.id,
      'franchise_id': franchise?.id,
      'referral_code': referralCode,
      'modified_date': modifiedDate?.toIso8601String(),
    };
  }
}
