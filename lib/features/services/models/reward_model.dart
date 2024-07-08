import '../../rewards/models/reward_config.dart';
import '../../users/models/user_model.dart';

class Reward {
  int? clientId;
  String? title;
  String? description;
  DateTime? date;
  double? transactionAmount;
  double? rewardAmount;
  double? discountedAmount;
  RewardConfig? rewardConfig;
  UserModel? userModel;

  Reward(
      {this.title,
      this.clientId,
      this.description,
      this.transactionAmount,
      this.date,
      this.rewardAmount,
      this.discountedAmount,
      this.rewardConfig,
      this.userModel});

  factory Reward.fromJson(Map<String, dynamic> json) {
    return Reward(
        title: json['title'],
        clientId: json['client_id'],
        description: json['description'],
        rewardConfig: json['reward_config'] != null
            ? RewardConfig.fromJson(json['reward_config'])
            : null,
        date: json['transaction_date'] != null
            ? DateTime.parse(json['transaction_date'])
            : null,
        transactionAmount: json['transaction_amount'] as double,
        rewardAmount: json['reward_amount'] as double,
        discountedAmount: json['discounted_amount'] as double);
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'client_id': clientId,
      'description': description,
      'date': date?.toIso8601String(),
      'transaction_amount': transactionAmount,
      'reward_amount': rewardAmount,
      'discounted_amount': discountedAmount,
    };
  }
}
