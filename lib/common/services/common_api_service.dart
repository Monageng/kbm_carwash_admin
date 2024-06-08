import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http1;
import 'package:kbm_carwash_admin/common/functions/logger_utils.dart';

import '../enviroment/env_variable.dart';
import '../functions/http_utils.dart';
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
      logger.d("url : ${url}");
      logger.d("encodedRequest : ${encodedRequest}");
      logger.d("response.statusCode : ${response.statusCode}");
      if (response.statusCode == 201) {
        responseMessage = "Record saved successfully";
      } else {
        ErrorResponse errorResponse =
            ErrorResponse.fromJson(jsonDecode(response.body));
        responseMessage =
            "Error occured ${errorResponse.details},  ${errorResponse.message} ";
      }
    } catch (e) {
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

      logger.d("Update url : ${url}");
      logger.d("Update data : ${updatedData}");
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
      print('Error: $error');
      responseMessage = error.toString();
    }
    return Future.value(responseMessage);
  }

  Future<int> getLatestID(String entity) async {
    int key = 1;
    try {
      Uri url = Uri.https(supabaseUrlv2, "/rest/v1/$entity",
          {"select": "id", "order": "id.desc", "limit": "1"});
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
      print("Next Available key is $key");
    } catch (e) {
      throw e;
    }
    return Future.value(key);
  }
}
