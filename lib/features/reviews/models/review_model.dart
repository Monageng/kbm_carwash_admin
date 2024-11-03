import 'package:kbm_carwash_admin/features/users/models/user_model.dart';

class ReviewModel {
  final int id;
  final DateTime? createdAt;
  final int? clientId;
  final String? review;
  final int? rating;
  final DateTime? reviewDate;
  final int? franchiseId;
  final UserModel? client;

  ReviewModel({
    required this.id,
    this.createdAt,
    this.clientId,
    this.review,
    this.rating,
    this.reviewDate,
    this.franchiseId,
    this.client,
  });

  factory ReviewModel.fromJson(Map<String, dynamic> json) {
    return ReviewModel(
      id: json['id'],
      createdAt: DateTime.parse(json['created_at']),
      clientId: json['client_id'],
      review: json['review'],
      rating: json['rating'],
      reviewDate: DateTime.parse(json['review_date']),
      franchiseId: json['franchise_id'],
      client: UserModel.fromJson(json['client']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'created_at': createdAt!.toIso8601String(),
      'client_id': clientId,
      'review': review,
      'rating': rating,
      'review_date': reviewDate!.toIso8601String(),
      'franchise_id': franchiseId,
      'client': client!.toJson(),
    };
  }
}
