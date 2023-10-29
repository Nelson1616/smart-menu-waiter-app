import 'package:flutter/material.dart';
import 'package:smart_menu_waiter_app/models/restaurant.dart';

class Official {
  int id;
  String name;
  String email;
  String password;
  int statusId;
  int restaurantId;
  int imageId;
  String createdAt;
  String updatedAt;
  Restaurant? restaurant;
  Map<String, dynamic> json;

  Official(
      {required this.id,
      required this.name,
      required this.email,
      required this.password,
      required this.statusId,
      required this.restaurantId,
      required this.imageId,
      required this.createdAt,
      required this.updatedAt,
      required this.json}) {
    if (json['restaurant'] != null) {
      restaurant = Restaurant.fromJson(json['restaurant']);
    }
  }

  factory Official.fromJson(Map<String, dynamic> json) {
    Official? official;

    try {
      official = Official(
          id: json['id'] ?? (throw Exception("id is required")),
          name: json['name'] ?? (throw Exception("name is required")),
          email: json['email'] ?? (throw Exception("email is required")),
          password:
              json['password'] ?? (throw Exception("password is required")),
          statusId:
              json['status_id'] ?? (throw Exception("status_id is required")),
          restaurantId: json['restaurant_id'] ??
              (throw Exception("restaurant_id is required")),
          imageId:
              json['image_id'] ?? (throw Exception("image_id is required")),
          createdAt:
              json['created_at'] ?? (throw Exception("created_at is required")),
          updatedAt:
              json['updated_at'] ?? (throw Exception("updated_at is required")),
          json: json);
    } on Exception catch (e) {
      debugPrint('$e');
      throw Exception("Erro ao ler Official");
    }

    return official;
  }
}
