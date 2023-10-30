import 'package:flutter/material.dart';
import 'package:smart_menu_waiter_app/models/table.dart';

class Session {
  int id;
  int statusId;
  int tableId;
  String createdAt;
  String updatedAt;
  Map<String, dynamic> json;
  RestaurantTable? table;

  Session(
      {required this.id,
      required this.statusId,
      required this.tableId,
      required this.createdAt,
      required this.updatedAt,
      required this.json}) {
    if (json['table'] != null) {
      table = RestaurantTable.fromJson(json['table']);
    }
  }

  factory Session.fromJson(Map<String, dynamic> json) {
    Session? session;

    try {
      session = Session(
          id: json['id'] ?? (throw Exception("id is required")),
          tableId:
              json['table_id'] ?? (throw Exception("table_id is required")),
          statusId:
              json['status_id'] ?? (throw Exception("status_id is required")),
          createdAt:
              json['created_at'] ?? (throw Exception("created_at is required")),
          updatedAt:
              json['updated_at'] ?? (throw Exception("updated_at is required")),
          json: json);
    } on Exception catch (e) {
      debugPrint('$e');
      throw Exception("Erro ao ler Session");
    }

    return session;
  }
}
