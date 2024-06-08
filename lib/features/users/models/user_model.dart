class UserModel {
  int id;
  String? userId;
  String? firstName;
  String? lastName;
  String? title;
  String? mobileNumber;
  String? email;
  String? dateOfBirth;

  UserModel(
      {this.userId,
      required this.id,
      this.firstName,
      this.lastName,
      this.title,
      this.mobileNumber,
      this.email,
      this.dateOfBirth});

// Deserialize JSON to User object
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
    );
  }

  // Serialize User object to JSON
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
    };
    return data;
  }
}
