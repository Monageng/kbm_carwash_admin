import 'package:kbm_carwash_admin/features/franchise/models/franchise_model.dart';

class UserModel {
  int id;
  String? userId;
  String? firstName;
  String? lastName;
  String? title;
  String? mobileNumber;
  String? email;
  String? dateOfBirth;
  bool? active;
  String? role;
  int? franchiseId;
  Franchise? franchise;

  UserModel({
    this.userId,
    required this.id,
    this.firstName,
    this.lastName,
    this.title,
    this.mobileNumber,
    this.email,
    this.dateOfBirth,
    this.active,
    this.role,
    this.franchiseId,
    this.franchise,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      userId: json['user_id'],
      firstName: json['first_name'],
      lastName: json['last_name'],
      title: json['title'],
      mobileNumber: json['mobile_number'],
      email: json['email'],
      dateOfBirth: json['date_of_birth'],
      active: json["active"],
      role: json["role"],
      franchiseId: json["franchise_id"],
      franchise: json["franchise"] != null
          ? Franchise.fromJson(json["franchise"])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      "id": id,
      'user_id': userId,
      'first_name': firstName,
      'last_name': lastName,
      'title': title,
      'mobile_number': mobileNumber,
      'email': email,
      'date_of_birth': dateOfBirth,
      "active": active,
      "role": role,
      "franchise_id": franchiseId,
      // "franchise": franchise,
    };
    return data;
  }
}
