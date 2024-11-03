class RewardConfig {
  int id;
  DateTime? createdAt;
  String? title;
  String? description;
  String? rewardType;
  DateTime? fromDate;
  DateTime? toDate;
  double? rewardValue;
  bool? active;
  String? discountType;
  String? rewardCode;
  String? frequencyType;
  int? frequencyCount;
  int? franchiseId;

  RewardConfig({
    required this.id,
    this.createdAt,
    this.title,
    this.description,
    this.rewardType,
    this.fromDate,
    this.toDate,
    this.rewardValue,
    this.active,
    this.discountType,
    this.rewardCode,
    this.frequencyCount,
    this.frequencyType,
    this.franchiseId,
  });

  factory RewardConfig.fromJson(Map<String, dynamic> json) {
    var rewardConfig = RewardConfig(
      id: json['id'] as int,
      franchiseId: json["franchise_id"] as int,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : null,
      title: json['title'] as String?,
      description: json['description'] as String?,
      rewardType: json['reward_type'] as String?,
      fromDate:
          json['from_date'] != null ? DateTime.parse(json['from_date']) : null,
      toDate: json['to_date'] != null ? DateTime.parse(json['to_date']) : null,
      rewardValue: json['reward_value']?.toDouble(),
      active: json['active'] as bool?,
      discountType: json['discount_type'] as String?,
      rewardCode: json['reward_code'] as String?,
      frequencyCount: json["frequency_count"],
      frequencyType: json["frequency_type"],
    );
    return rewardConfig;
  }

  Map<String, dynamic> toJson() {
    var d = {
      'id': id,
      "franchise_id": franchiseId!,
      'created_at': createdAt!.toIso8601String(),
      'title': title!,
      'description': description!,
      'reward_type': rewardType!,
      'from_date': fromDate!.toIso8601String(),
      'to_date': toDate!.toIso8601String(),
      'reward_value': rewardValue!,
      'active': active,
      'discount_type': discountType!,
      'reward_code': rewardCode!,
      "frequency_count": frequencyCount!,
      "frequency_type": frequencyType!
    };

    return d;
  }
}
