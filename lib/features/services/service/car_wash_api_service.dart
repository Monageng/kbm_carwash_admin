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
      var url = Uri.https(supabaseUrlv2, "rest/v1/car_wash_services");
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
}
