import 'package:http/http.dart' as http1;
import 'dart:async';
import 'dart:convert';

import '../../../common/enviroment/env_variable.dart';
import '../../../common/functions/http_utils.dart';
import '../models/appointment_model.dart';

class BookAppointmentApiService {
  Future<List<CarWashAppointment>> getAllAppointments(String clientId) async {
    try {
      var url = Uri.https(supabaseUrlv2, "rest/v1/appointment",
          {"select": "*", "active": "eq.true", "client_id": "eq.$clientId"});
      var response = await http1.get(url, headers: getHttpHeaders());
      if (response.statusCode == 200) {
        List<CarWashAppointment> list = (jsonDecode(response.body) as List)
            .map((json) => CarWashAppointment.fromJson(json))
            .toList();
        return Future.value(list);
      }
    } catch (e) {}
    return Future.value([]);
  }

  Future<List<CarWashAppointment>> getAllActiveAppointments() async {
    try {
      var url = Uri.https(supabaseUrlv2, "rest/v1/appointment",
          {"select": "*,client(*)", "active": "eq.true"});
      var response = await http1.get(url, headers: getHttpHeaders());
      if (response.statusCode == 200) {
        List<CarWashAppointment> list = (jsonDecode(response.body) as List)
            .map((json) => CarWashAppointment.fromJson(json))
            .toList();
        return Future.value(list);
      }
    } catch (e) {}
    return Future.value([]);
  }
}
