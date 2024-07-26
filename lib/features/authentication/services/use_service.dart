import 'package:http/http.dart' as http1;
import 'dart:async';
import 'dart:convert';

import '../../../common/enviroment/env_variable.dart';
import '../../../common/functions/http_utils.dart';
import '../../../common/functions/logger_utils.dart';
import '../../users/models/user_model.dart';

class UserApiService {
  Future<List<UserModel>> getUserById(String userId) async {
    try {
      var url = Uri.https(supabaseUrlv2, "rest/v1/client", {
        "select": "*,franchise(*)",
        "active": "eq.true",
        "user_id": "eq.$userId"
      });
      logger.d("Url2 ::: $url");
      var response = await http1.get(url, headers: getHttpHeaders());
      logger.d("getUserById response ::: ${response.body}");
      if (response.statusCode == 200) {
        List<UserModel> list = (jsonDecode(response.body) as List)
            .map((json) => UserModel.fromJson(json))
            .toList();
        return Future.value(list);
      }
    } catch (e) {
      logger.e("object ${e.toString()}");
    }
    return Future.value([]);
  }
}
