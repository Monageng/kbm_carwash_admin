import 'package:kbm_carwash_admin/features/franchise/models/franchise_model.dart';

class UserModel {
  int? id;
  String? userId;
  String? firstName;
  String? lastName;
  String? title;
  String? mobileNumber;
  String? email;
  String? dateOfBirth;
  DateTime? createdAt;
  bool? active;
  String? role;
  int? franchiseId;
  Franchise? franchise;

  UserModel({
    this.userId,
    this.id,
    this.firstName,
    this.lastName,
    this.title,
    this.mobileNumber,
    this.email,
    this.dateOfBirth,
    this.active,
    this.role,
    this.createdAt,
    this.franchiseId,
    this.franchise,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    print("json ### $json");
    String date = json["created_at"];
    print("date ### $date");
    DateTime formatedDate = DateTime.now();
    if (date != null) {
      date = date.substring(0, 10);
      print("date ### $date");
      formatedDate = DateTime.parse(date);
      print("formatedDate ### $formatedDate");
    }

    return UserModel(
      id: json['id'],
      userId: json['user_id'],
      firstName: json['first_name'],
      lastName: json['last_name'],
      title: json['title'],
      mobileNumber: json['mobile_number'],
      email: json['email'],
      dateOfBirth: json['date_of_birth'],
      createdAt: formatedDate,
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
      'created_at': createdAt,
      "active": active,
      "role": role,
      "franchise_id": franchiseId,
      // "franchise": franchise,
    };
    return data;
  }
}
