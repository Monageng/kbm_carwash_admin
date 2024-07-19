import '../../../common/enviroment/env_variable.dart';
import '../../../common/functions/http_utils.dart';
import '../../../common/functions/logger_utils.dart';
import '../models/car_models_model.dart';
import '../models/car_wash_service_model.dart';
import 'package:http/http.dart' as http1;
import 'dart:async';
import 'dart:convert';

import '../models/service_franchise_link_model.dart';

class CarWashApiService {
  Future<List<CarWashService>> getAllCarWashService() async {
    try {
      var url = Uri.https(supabaseUrlv2, "rest/v1/services",
          {"active": "eq.true", "order": "service_name.asc"});
      logger.d("Url  ::: $url");
      var response = await http1.get(url, headers: getHttpHeaders());

      if (response.statusCode == 200) {
        List<CarWashService> list = (jsonDecode(response.body) as List)
            .map((json) => CarWashService.fromJson(json))
            .toList();
        return Future.value(list);
      }
    } catch (e) {
      logger.e("object ${e.toString()}");
    }
    return Future.value([]);
  }

  Future<List<CarModel>> getAllCarModels() async {
    try {
      var url = Uri.https(supabaseUrlv2, "rest/v1/car_model");
      logger.d("Url ::: $url");
      var response = await http1.get(url, headers: getHttpHeaders());
      if (response.statusCode == 200) {
        List<CarModel> list = (jsonDecode(response.body) as List)
            .map((json) => CarModel.fromJson(json))
            .toList();
        return Future.value(list);
      }
    } catch (e) {
      logger.e("object ${e.toString()}");
    }
    return Future.value([]);
  }

  Future<List<ServiceFranchiseLink>> getServiceByFranchiseId(
      int franchiseId) async {
    try {
      var url = Uri.https(supabaseUrlv2, "rest/v1/service_franchise_links", {
        "select": "*,franchise(*),services(*), car_model(*)",
        "franchise_id": "eq.$franchiseId",
        "order": "car_model_id.asc"
      });
      logger.d("Url ::: $url");
      var response = await http1.get(url, headers: getHttpHeaders());
      if (response.statusCode == 200) {
        List<ServiceFranchiseLink> list = (jsonDecode(response.body) as List)
            .map((json) => ServiceFranchiseLink.fromJson(json))
            .toList();
        return Future.value(list);
      }
    } catch (e) {
      logger.e("object ${e.toString()}");
    }
    return Future.value([]);
  }
}
