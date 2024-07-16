class CarWashService {
  int id;
  String? name;
  String? description;
  DateTime? createdAt;
  DateTime? fromDate;
  DateTime? toDate;
  bool? active;

  CarWashService({
    required this.id,
    this.name,
    this.description,
    this.active,
    this.createdAt,
    this.fromDate,
    this.toDate,
  });

  factory CarWashService.fromJson(Map<String, dynamic> json) {
    try {
      var data = CarWashService(
        id: json['id'] as int,
        name: json['service_name'] as String?,
        description: json['description'] as String?,
        createdAt: json['created_at'] != null
            ? DateTime.parse(json['created_at'])
            : null,
        fromDate: json['from_date'] != null
            ? DateTime.parse(json['from_date'])
            : null,
        toDate:
            json['to_date'] != null ? DateTime.parse(json['to_date']) : null,
        active: json['active'] as bool?,
      );
      print("CarWashService.fromJson Data $data");
      return data;
    } catch (e) {
      print("CarWashService.fromJson Error  $e");
      return CarWashService(id: -10);
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['service_name'] = name;
    data['description'] = description;
    data['created_at'] = createdAt?.toIso8601String();
    data['from_date'] = fromDate?.toIso8601String();
    data['to_date'] = toDate?.toIso8601String();
    data['active'] = active;
    return data;
  }
}
