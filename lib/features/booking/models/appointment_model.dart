import '../../users/models/user_model.dart';

class Appointment {
  int id;
  int? franchiseId;
  bool? active;
  String? serviceName;
  DateTime? createAt;
  DateTime? date;
  String? status;
  int? clientId;
  String? time;
  UserModel? client;

  Appointment({
    this.serviceName,
    this.time,
    this.date,
    this.status,
    this.active,
    this.clientId,
    this.createAt,
    required this.id,
    this.client,
    this.franchiseId,
  });

// Method to deserialize JSON into a CarWashAppointment object
  factory Appointment.fromJson(Map<String, dynamic> json) {
    return Appointment(
      id: json['id'],
      franchiseId: json["franchise_id"],
      time: json['time'],
      active: json['active'],
      serviceName: json['service_name'],
      createAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : null,
      date: json['date'] != null ? DateTime.parse(json['date']) : null,
      status: json['status'],
      clientId: json['client_id'],
      client:
          json['client'] != null ? UserModel.fromJson(json['client']) : null,
    );
  }

  // Method to serialize a CarWashAppointment object into JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'active': active,
      "time": time,
      'service_name': serviceName,
      'created_at':
          createAt?.toIso8601String(), // Serialize DateTime to ISO 8601 format
      'date': date?.toIso8601String(), // Serialize DateTime to ISO 8601 format
      'status': status,
      'client_id': clientId,
      "franchise_id": franchiseId,
      //d'client': client!.toJson(),
    };
  }
}
