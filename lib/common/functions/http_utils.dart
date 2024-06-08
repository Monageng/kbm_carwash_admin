import "../enviroment/env_variable.dart";

Map<String, String> getHttpHeaders() {
  Map<String, String> headers = {
    'Content-Type': 'application/json',
    "apikey": supabaseKeyv2
  };

  return headers;
}
