import 'package:http/http.dart' as http1;
import 'package:kbm_carwash_admin/features/reviews/models/review_model.dart';
import 'dart:async';
import 'dart:convert';

import '../../../common/enviroment/env_variable.dart';
import '../../../common/functions/http_utils.dart';

class ReviewApiService {
  Future<List<ReviewModel>> getReviews(String franchiseId) async {
    try {
      var url = Uri.https(supabaseUrlv2, "rest/v1/review",
          {"select": "*", "franchise_id": "eq.$franchiseId"});
      print("Request : $url");
      var response = await http1.get(url, headers: getHttpHeaders());
      print("response : ${response.body}");
      if (response.statusCode == 200) {
        List<ReviewModel> list = (jsonDecode(response.body) as List)
            .map((json) => ReviewModel.fromJson(json))
            .toList();
        return Future.value(list);
      }
    } catch (e) {}
    return Future.value([]);
  }
}
