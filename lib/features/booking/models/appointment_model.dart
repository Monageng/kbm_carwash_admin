class CarWashAppointment {
  int id;
  bool? active;
  String? serviceName;
  DateTime? createAt;
  DateTime? date;
  String? status;
  int? clientId;
  String? time;

  CarWashAppointment({
    this.serviceName,
    this.time,
    this.date,
    this.status,
    this.active,
    this.clientId,
    this.createAt,
    required this.id,
  });

// Method to deserialize JSON into a CarWashAppointment object
  factory CarWashAppointment.fromJson(Map<String, dynamic> json) {
    return CarWashAppointment(
      id: json['id'],
      time: json['time'],
      active: json['active'],
      serviceName: json['service_name'],
      createAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : null,
      date: json['date'] != null ? DateTime.parse(json['date']) : null,
      status: json['status'],
      clientId: json['client_id'],
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
    };
  }
}
