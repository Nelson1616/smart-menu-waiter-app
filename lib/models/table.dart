import 'package:flutter/material.dart';

class RestaurantTable {
  int id;
  int restauranId;
  String enterCode;
  int number;
  int statusId;
  String createdAt;
  String updatedAt;
  Map<String, dynamic> json;

  RestaurantTable(
      {required this.id,
      required this.restauranId,
      required this.enterCode,
      required this.number,
      required this.statusId,
      required this.createdAt,
      required this.updatedAt,
      required this.json});

  factory RestaurantTable.fromJson(Map<String, dynamic> json) {
    RestaurantTable? table;

    try {
      table = RestaurantTable(
          id: json['id'] ?? (throw Exception("id is required")),
          restauranId: json['restaurant_id'] ??
              (throw Exception("restaurant_id is required")),
          enterCode:
              json['enter_code'] ?? (throw Exception("enter_code is required")),
          number: json['number'] ?? (throw Exception("number is required")),
          statusId:
              json['status_id'] ?? (throw Exception("status_id is required")),
          createdAt:
              json['created_at'] ?? (throw Exception("created_at is required")),
          updatedAt:
              json['updated_at'] ?? (throw Exception("updated_at is required")),
          json: json);
    } on Exception catch (e) {
      debugPrint('$e');
      throw Exception("Erro ao ler mesa");
    }

    return table;
  }
}
