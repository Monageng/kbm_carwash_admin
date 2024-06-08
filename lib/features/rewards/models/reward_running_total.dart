import 'reward_config.dart';

class RewardRunningTotal {
  final int id;
  final DateTime? createdAt;
  final int? clientId;
  final DateTime? fromDate;
  final DateTime? toDate;
  final int? runningTotal;
  final String? rewardType;
  final int? rewardConfigId;
  final RewardConfig? rewardConfig;
  final String? description;

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
    this.description,
  });

  factory RewardRunningTotal.fromJson(Map<String, dynamic> json) {
    var rewardRunningTotal = RewardRunningTotal(
      id: json['id'] as int,
      createdAt: DateTime.parse(json['created_at'] as String),
      clientId: json['client_id'] as int,
      fromDate: DateTime.parse(json['from_date'] as String),
      toDate: DateTime.parse(json['to_date'] as String),
      runningTotal: json['running_total'] as int,
      rewardType: json['reward_type'] as String,
      rewardConfigId: json['reward_config_id'] as int,
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
      'reward_config_id': rewardConfigId,
      'reward_config':
          rewardConfig?.toJson(), // Assuming RewardConfig has toJson method
    };
    return d;
  }
}
