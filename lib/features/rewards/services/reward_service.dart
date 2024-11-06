import 'package:http/http.dart' as http1;
import 'package:kbm_carwash_admin/features/rewards/models/referal_model.dart';
import 'dart:async';
import 'dart:convert';

import '../../../common/enviroment/env_variable.dart';
import '../../../common/functions/http_utils.dart';
import '../../../common/functions/logger_utils.dart';
import '../models/reward_config.dart';
import '../models/reward_model.dart';
import '../models/reward_running_total.dart';

class RewardsApiService {
  Future<List<Reward>> getAllRewardAllocation(String clientId) async {
    try {
      var url = Uri.https(supabaseUrlv2, "rest/v1/reward_allocation",
          {"select": "*,reward_config(*)", "client_id": "eq.$clientId"});
      logger.d("Url ::: $url");
      var response = await http1.get(url, headers: getHttpHeaders());

      if (response.statusCode == 200) {
        List<Reward> list = (jsonDecode(response.body) as List)
            .map((json) => Reward.fromJson(json))
            .toList();
        return Future.value(list);
      }
    } catch (e) {
      logger.e("object ${e.toString()}");
    }
    return Future.value([]);
  }

  Future<List<RewardConfig>> getAllRewardConfig() async {
    try {
      var url = Uri.https(supabaseUrlv2, "rest/v1/reward_config",
          {"active": "eq.true", "order": "title.asc"});
      logger.d("Url ::: $url");
      var response = await http1.get(url, headers: getHttpHeaders());

      if (response.statusCode == 200) {
        List<RewardConfig> list = (jsonDecode(response.body) as List)
            .map((json) => RewardConfig.fromJson(json))
            .toList();
        return Future.value(list);
      }
    } catch (e) {
      logger.e("object ${e.toString()}");
    }
    return Future.value([]);
  }

  Future<List<Referral>> getAllReferals() async {
    try {
      var url = Uri.https(supabaseUrlv2, "rest/v1/referal", {
        "select": "*,recipient_client(*),sender_client(*)",
        "order": "valid_from.asc"
      });
      logger.d("Url ::: $url");
      var response = await http1.get(url, headers: getHttpHeaders());
      logger.d("response ::: ${response.body}");
      if (response.statusCode == 200) {
        List<Referral> list = (jsonDecode(response.body) as List)
            .map((json) => Referral.fromJson(json))
            .toList();
        return Future.value(list);
      }
    } catch (e) {
      logger.e("object ${e.toString()}");
    }
    return Future.value([]);
  }

  Future<List<RewardConfig>> getAllRewardConfigByFranchiseId(
      int franchiseId) async {
    try {
      var url = Uri.https(supabaseUrlv2, "rest/v1/reward_config", {
        "active": "eq.true",
        "franchise_id": "eq.$franchiseId",
        "order": "title.asc"
      });
      logger.d("Url ::: $url");
      var response = await http1.get(url, headers: getHttpHeaders());

      if (response.statusCode == 200) {
        List<RewardConfig> list = (jsonDecode(response.body) as List)
            .map((json) => RewardConfig.fromJson(json))
            .toList();
        return Future.value(list);
      }
    } catch (e) {
      logger.e("object ${e.toString()}");
    }
    return Future.value([]);
  }

  Future<List<RewardRunningTotal>> getAllRewardRunningTotal(
      String clientId) async {
    try {
      var url = Uri.https(supabaseUrlv2, "rest/v1/reward_running_total",
          {"select": "*,reward_config(*)", "client_id": "eq.$clientId"});
      logger.d("Url ::: $url");
      var response = await http1.get(url, headers: getHttpHeaders());

      if (response.statusCode == 200) {
        List<RewardRunningTotal> list = (jsonDecode(response.body) as List)
            .map((json) => RewardRunningTotal.fromJson(json))
            .toList();
        return Future.value(list);
      }
    } catch (e) {
      logger.e("object ${e.toString()}");
    }
    return Future.value([]);
  }

  Future<List<Reward>> getAllRewardAllocationByClientUserId(
      String userId) async {
    try {
      var url = Uri.https(supabaseUrlv2, "rest/v1/reward_allocation",
          {"select": "*,client(*)", "client.user_id": "eq.$userId"});
      logger.d("Url ::: $url");
      var response = await http1.get(url, headers: getHttpHeaders());
      if (response.statusCode == 200) {
        List<Reward> list = (jsonDecode(response.body) as List)
            .map((json) => Reward.fromJson(json))
            .toList();
        return Future.value(list);
      }
    } catch (e) {
      logger.e("object ${e.toString()}");
    }
    return Future.value([]);
  }
}
