import 'package:flutter/material.dart';
import 'package:smart_menu_waiter_app/models/session_user.dart';

class SessionWaiterCall {
  int id;
  int statusId;
  int sessionUserId;
  String createdAt;
  String updatedAt;
  SessionUser? sessionUser;
  Map<String, dynamic> json;

  SessionWaiterCall(
      {required this.id,
      required this.statusId,
      required this.sessionUserId,
      required this.createdAt,
      required this.updatedAt,
      required this.json}) {
    if (json['sessionUser'] != null) {
      sessionUser = SessionUser.fromJson(json['sessionUser']);
    }
  }

  factory SessionWaiterCall.fromJson(Map<String, dynamic> json) {
    SessionWaiterCall? sessionWaiterCall;

    try {
      sessionWaiterCall = SessionWaiterCall(
          id: json['id'] ?? (throw Exception("id is required")),
          sessionUserId: json['session_user_id'] ??
              (throw Exception("session_user_id is required")),
          statusId:
              json['status_id'] ?? (throw Exception("status_id is required")),
          createdAt:
              json['created_at'] ?? (throw Exception("created_at is required")),
          updatedAt:
              json['updated_at'] ?? (throw Exception("updated_at is required")),
          json: json);
    } on Exception catch (e) {
      debugPrint('$e');
      throw Exception("Erro ao ler chamada de garçom");
    }

    return sessionWaiterCall;
  }
}
