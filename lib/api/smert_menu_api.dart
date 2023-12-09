import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ResponseJson {
  bool success;
  String message;
  Map<String, dynamic>? data;

  ResponseJson(this.success, this.message, this.data);
}

class SmartMenuApi {
  static String mainIp = "https://smartmenuapi.nntech.online";
  // static String mainIp = "http://172.20.10.13";
  // static String mainIp = "http://localhost";

  static String mainApiUrl = "$mainIp/api";

  static Future<http.Response> get(String url) {
    if (url[0] != '/') {
      url = '/$url';
    }

    debugPrint("get: $mainApiUrl$url");

    return http.get(Uri.parse(mainApiUrl + url));
  }

  static Future<http.Response> post(String url, String json) {
    if (url[0] != '/') {
      url = '/$url';
    }

    debugPrint("post: $mainApiUrl$url");
    debugPrint("post body: $json");

    return http.post(Uri.parse(mainApiUrl + url),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: json);
  }

  static Future<ResponseJson> login(String email, String password) async {
    String body = jsonEncode({"email": email, "password": password});

    http.Response response = await post('officials/login', body);

    Map<String, dynamic> json;

    json = jsonDecode(response.body);

    if (json['success'] == null) {
      throw Exception("Invalid response from api");
    }

    return ResponseJson(json['success'], json['message'], json['data']);
  }
}
