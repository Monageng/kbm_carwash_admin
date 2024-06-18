import '../../../common/enviroment/env_variable.dart';
import '../../../common/functions/http_utils.dart';
import '../../../common/functions/logger_utils.dart';
import 'package:http/http.dart' as http1;
import 'dart:async';
import 'dart:convert';

import '../models/user_model.dart';

class UserApiService {
  Future<List<UserModel>> getAllUsers() async {
    try {
      var url = Uri.https(supabaseUrlv2, "rest/v1/client",
          {"active": "eq.true", "order": "first_name.asc"});
      logger.d("Url ::: $url");
      var response = await http1.get(url, headers: getHttpHeaders());
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
