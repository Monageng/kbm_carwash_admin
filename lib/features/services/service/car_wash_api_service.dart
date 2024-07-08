import '../../../common/enviroment/env_variable.dart';
import '../../../common/functions/http_utils.dart';
import '../../../common/functions/logger_utils.dart';
import '../models/car_wash_service_model.dart';
import 'package:http/http.dart' as http1;
import 'dart:async';
import 'dart:convert';

class CarWashApiService {
  Future<List<CarWashService>> getAllCarWashService() async {
    try {
      var url = Uri.https(supabaseUrlv2, "rest/v1/services",
          {"active": "eq.true", "order": "service_name.asc"});
      logger.d("Url ::: $url");
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

  Future<List<CarWashService>> getAllCarWashServiceByFranchise(
      int franchiseId) async {
    try {
      var url = Uri.https(supabaseUrlv2, "rest/v1/services", {
        "active": "eq.true",
        "select": "*,franchise:franchise_id(*)",
        "franchise.id": "eq.$franchiseId",
        "order": "service_name.asc"
      });

      logger.d("Url ::: $url");
      var response = await http1.get(url, headers: getHttpHeaders());
      if (response.statusCode == 200) {
        List<CarWashService> data = (jsonDecode(response.body) as List)
            .map((json) => CarWashService.fromJson(json))
            .toList();
        //return Future.value(list);

        List<CarWashService> filteredList =
            data.where((element) => element.franchise != null).toList();

        for (var element in filteredList) {
          if (element.franchise != null) {
            print(
                "Franchise is not null ${element.franchise} for ${element.name} ");
          } else {
            print("Nulll  ${element.name} ");
          }
        }

        print("filteredList ${filteredList} ");
        return filteredList;
      }
    } catch (e) {
      logger.e("object ${e.toString()}");
    }
    return Future.value([]);
  }
}
