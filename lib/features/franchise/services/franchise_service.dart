import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http1;
import 'package:kbm_carwash_admin/common/functions/logger_utils.dart';

import '../../../common/enviroment/env_variable.dart';
import '../models/franchise_model.dart';

class FranchiseApiService {
  Future<List<Franchise>> getAllFranchise() async {
    try {
      var url = Uri.https(supabaseUrlv2, "/rest/v1/franchise",
          {"active": "eq.true", "order": "name.asc"});
      var response = await http1.get(url, headers: {"apikey": supabaseKeyv2});

      if (response.statusCode == 200) {
        List<Franchise> categoryList = (jsonDecode(response.body) as List)
            .map((json) => Franchise.fromJson(json))
            .toList();

        return Future.value(categoryList);
      }
    } catch (e) {
      logger.e(e);
    }
    return Future.value([]);
  }
}
