import 'reward_config.dart';

class RewardRunningTotal {
  int id;
  DateTime? createdAt;
  int? clientId;
  DateTime? fromDate;
  DateTime? toDate;
  int? runningTotal;
  String? rewardType;
  int? rewardConfigId;
  RewardConfig? rewardConfig;
  String? status;
  bool? qualify;
  DateTime? modifiedDate;
  int? franchiseId;
  RewardRunningTotal({
    required this.id,
    this.createdAt,
    this.clientId,
    this.fromDate,
    this.toDate,
    this.runningTotal,
    this.rewardType,
    this.rewardConfigId,
    this.rewardConfig,
    this.status,
    this.qualify,
    this.modifiedDate,
    this.franchiseId,
  });

  factory RewardRunningTotal.fromJson(Map<String, dynamic> json) {
    var rewardRunningTotal = RewardRunningTotal(
      id: json['id'] as int,
      createdAt: DateTime.parse(json['created_at'] as String),
      clientId: json['client_id'] as int,
      fromDate: DateTime.parse(json['from_date'] as String),
      toDate: DateTime.parse(json['to_date'] as String),
      runningTotal: json['running_total'] as int,
      status: json["status"],
      modifiedDate: DateTime.parse(json['modified_date'] as String),
      qualify: json["qualify"],
      rewardType: json['reward_type'] as String,
      rewardConfigId: json['reward_config_id'] as int,
      franchiseId: json['franchise_id'] as int,
      rewardConfig: json['reward_config'] != null
          ? RewardConfig.fromJson(json['reward_config'])
          : null,
    );

    return rewardRunningTotal;
  }

  Map<String, dynamic> toJson() {
    var d = {
      'id': id,
      'created_at': createdAt?.toIso8601String(),
      'client_id': clientId,
      'from_date': fromDate?.toIso8601String(),
      'to_date': toDate?.toIso8601String(),
      'running_total': runningTotal,
      'reward_type': rewardType,
      "status": status,
      "qualify": qualify,
      "modified_date": modifiedDate?.toIso8601String(),
      'reward_config_id': rewardConfigId,
      'franchise_id': franchiseId
    };
    return d;
  }
}
