class RankModel {
  int? id;
  int? rank;
  int? count;
  DateTime? fromDate;
  DateTime? toDate;
  String? firstName;
  String? lastName;

  RankModel({
    this.id,
    this.firstName,
    this.lastName,
    this.fromDate,
    this.toDate,
    this.count,
    this.rank,
  });

// Deserialize JSON to User object
  factory RankModel.fromJson(Map<String, dynamic> json) {
    return RankModel(
      id: json['id'],
      firstName: json['first_name'],
      fromDate: json['from_date'],
      toDate: json['to_date'],
      lastName: json['last_name'],
      count: json['count'],
      rank: json['rank'],
    );
  }

// Serialize User object to JSON
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      "id": id,
      'from_date': fromDate,
      'first_name': firstName,
      'last_name': lastName,
      'to_date': toDate,
      'count': count,
      'rank': rank,
    };
    return data;
  }
}
