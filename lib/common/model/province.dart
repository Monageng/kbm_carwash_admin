class Province {
  int id;
  DateTime? createdAt;
  bool? isActive;
  String? name;

  Province({
    required this.id,
    this.createdAt,
    this.isActive,
    this.name,
  });

  factory Province.fromJson(Map<String, dynamic> json) {
    return Province(
      id: json['id'],
      createdAt: DateTime.parse(json['created_at']),
      isActive: json['isActive'],
      name: json['name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'created_at': createdAt!.toIso8601String(),
      'isActive': isActive,
      'name': name,
    };
  }
}
