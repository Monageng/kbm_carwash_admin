import 'package:http/http.dart' as http1;
import 'package:kbm_carwash_admin/common/functions/logger_utils.dart';
import 'package:kbm_carwash_admin/features/reviews/models/review_model.dart';
import 'dart:async';
import 'dart:convert';

import '../../../common/enviroment/env_variable.dart';
import '../../../common/functions/http_utils.dart';

class ReviewApiService {
  Future<List<ReviewModel>> getReviews(String franchiseId) async {
    try {
      var url = Uri.https(supabaseUrlv2, "rest/v1/review",
          {"select": "*, client(*)", "franchise_id": "eq.$franchiseId"});
      logger.d("review url $url");
      var response = await http1.get(url, headers: getHttpHeaders());
      logger.d("review response $response");
      if (response.statusCode == 200) {
        List<ReviewModel> list = (jsonDecode(response.body) as List)
            .map((json) => ReviewModel.fromJson(json))
            .toList();
        return Future.value(list);
      }
    } catch (e) {
      logger.e(e.toString());
    }
    return Future.value([]);
  }
}
