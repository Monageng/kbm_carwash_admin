import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http1;

import '../enviroment/env_variable.dart';
import '../functions/http_utils.dart';
import '../functions/logger_utils.dart';
import '../model/city_model.dart';
import '../model/province.dart';
import 'api_error_response.dart';
import 'primary_ket_response.dart';

class CommonApiService {
  Future<String> save(Map jsonRequest, String entity) async {
    var responseMessage = "";
    try {
      var url = Uri.https(supabaseUrlv2, "/rest/v1/$entity");
      String encodedRequest = jsonEncode(jsonRequest);
      var response = await http1.post(url,
          body: encodedRequest, headers: getHttpHeaders());
      logger.d("url : $url");
      logger.d("encodedRequest $entity : $encodedRequest");
      if (response.statusCode == 201) {
        responseMessage = "Record saved successfully";
      } else {
        ErrorResponse errorResponse =
            ErrorResponse.fromJson(jsonDecode(response.body));
        responseMessage =
            "Error occured ${errorResponse.details},  ${errorResponse.message} ";
      }
    } catch (e) {
      logger.e(e);
      responseMessage = e.toString();
    }
    return Future.value(responseMessage);
  }

  Future<String> update(
      int id, String entity, Map<String, dynamic> updatedData) async {
    var responseMessage = "";

    logger.d("Start update");
    try {
      var url = Uri.https(supabaseUrlv2, "/rest/v1/$entity", {"id": "eq.$id"});

      logger.d("Update url : $url");
      logger.d("Update encodedRequest $entity: $updatedData");
      final response = await http1.patch(
        url,
        headers: getHttpHeaders(),
        body: jsonEncode(updatedData),
      );
      logger.d("response statusCode : ${response.statusCode}");
      logger.d("response stbodyatusCode : ${response.body}");
      if (response.statusCode == 204) {
        responseMessage = "Record saved successfully";
      } else {
        ErrorResponse errorResponse =
            ErrorResponse.fromJson(jsonDecode(response.body));
        responseMessage =
            "Error occured ${errorResponse.details},  ${errorResponse.message} ";
      }
    } catch (error) {
      responseMessage = error.toString();
    }
    return Future.value(responseMessage);
  }

  Future<int> getLatestID(String entity) async {
    int key = 1;
    try {
      Uri url = Uri.https(supabaseUrlv2, "/rest/v1/$entity",
          {"select": "id", "order": "id.desc", "limit": "1"});
      logger.d("url $url");
      var response = await http1.get(url, headers: {"apikey": supabaseKeyv2});
      if (response.statusCode == 200) {
        List<PrimaryKeyResponse> primaryKeyList =
            (jsonDecode(response.body) as List)
                .map((json) => PrimaryKeyResponse.fromJson(json))
                .toList();

        if (primaryKeyList.isNotEmpty) {
          key = primaryKeyList[0].uuid + 1;
        }
      }
    } catch (e) {
      rethrow;
    }
    return Future.value(key);
  }

  Future<List<Province>> fetchProvince() async {
    var url =
        Uri.https(supabaseUrlv2, "/rest/v1/provinces", {"order": "name.asc"});

    print("URL $url");
    var response = await http1.get(url, headers: getHttpHeaders());
    if (response.statusCode == 200) {
      List<Province> data = (jsonDecode(response.body) as List)
          .map((json) => Province.fromJson(json))
          .toList();

      return data;
    } else {
      throw Exception('Failed to load provinces');
    }
  }

  Future<List<City>> fetchCity() async {
    var url =
        Uri.https(supabaseUrlv2, "/rest/v1/cities", {"order": "name.asc"});
    var response = await http1.get(url, headers: getHttpHeaders());
    print("URL $url");
    if (response.statusCode == 200) {
      List<City> data = (jsonDecode(response.body) as List)
          .map((json) => City.fromJson(json))
          .toList();

      return data;
    } else {
      throw Exception('Failed to load cities');
    }
  }

  Future<List<City>> fetchCityByProvince(String province) async {
    var url = Uri.https(supabaseUrlv2, "/rest/v1/cities", {
      "select": "*,province:province_id(*)",
      "province.name": "eq.$province"
    });

    var response = await http1.get(url, headers: getHttpHeaders());

    //https://jazesnfbevoyuzaizgko.supabase.co/rest/v1/cities?province.name=eq.Gauteng&select=*,province:province_uuid(*)&isActive=eq.true
    print(" url  ${url} ");
    if (response.statusCode == 200) {
      List<City> data = (jsonDecode(response.body) as List)
          .map((json) => City.fromJson(json))
          .toList();

      List<City> filteredList =
          data.where((element) => element.province != null).toList();

      for (var element in filteredList) {
        if (element.province != null) {
          print("PROVICE is not null for ${element.name} ");
        } else {
          print("Nulll  ${element.name} ");
        }
      }

      return filteredList;
    } else {
      throw Exception('Failed to load cities');
    }
  }
}
