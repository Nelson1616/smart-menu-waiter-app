import 'package:flutter/material.dart';
import 'package:smart_menu_waiter_app/api/smert_menu_api.dart';
import 'package:smart_menu_waiter_app/models/session.dart';
import 'package:smart_menu_waiter_app/models/session_order.dart';
import 'package:smart_menu_waiter_app/models/session_user.dart';
import 'package:smart_menu_waiter_app/utils/logger.dart';
import 'package:socket_io_client/socket_io_client.dart';

class TableReference {
  int id;
  int sessionId;
  int number;
  List<SessionUser> sessionUsers = [];
  List<SessionOrder> sessionOrders = [];

  TableReference(
      {required this.id, required this.sessionId, required this.number});
}

class SmartMenuSocketApi {
  static final SmartMenuSocketApi _instance = SmartMenuSocketApi._internal();

  Socket? socket;
  int? officialId;

  Function? onSocketErrorListener;
  Function? onSocketUsersListener;
  Function? onSocketOrdersListener;

  void setOnSocketErrorListener(Function onSocketErrorListener) {
    if (this.onSocketErrorListener != onSocketErrorListener) {
      debugPrint("setOnSocketErrorListener");
      this.onSocketErrorListener = onSocketErrorListener;
    }
  }

  void setOnSocketUsersListener(Function onSocketUsersListener) {
    if (this.onSocketUsersListener != onSocketUsersListener) {
      debugPrint("setOnSocketUsersListener = $onSocketUsersListener");
      this.onSocketUsersListener = onSocketUsersListener;
    }
  }

  void setOnSocketOrdersListener(Function onSocketOrdersListener) {
    if (this.onSocketOrdersListener != onSocketOrdersListener) {
      debugPrint("setOnSocketOrdersListener");
      this.onSocketOrdersListener = onSocketOrdersListener;
    }
  }

  Map<int, TableReference> tables = {};

  SmartMenuSocketApi._internal();

  factory SmartMenuSocketApi() {
    return _instance;
  }

  void connect() {
    if (officialId != null) {
      if (socket != null) {
        if (socket!.connected) {
          return;
        }
      }

      socket = io('${SmartMenuApi.mainIp}:3016/', <String, dynamic>{
        'transports': ['websocket'],
        'autoConnect': false,
        'query': {
          'official_id': officialId,
        }
      });

      setupSocket();
      socket!.connect();
    }
  }

  void disconnect() {
    onSocketErrorListener = null;
    onSocketOrdersListener = null;
    onSocketUsersListener = null;

    officialId = null;

    if (socket != null) {
      socket!.disconnect();
      socket = null;
    }
  }

  void cleanListeners() {
    onSocketErrorListener = null;
    onSocketOrdersListener = null;
    onSocketUsersListener = null;
  }

  void setupSocket() {
    if (socket != null) {
      socket!.on('error', (data) {
        // debugPrint('$data');
        if (onSocketErrorListener != null) {
          onSocketErrorListener!(data);
        }
      });

      socket!.on('message', (data) => debugPrint('$data'));

      socket!.on('connect_error', (data) => debugPrint('$data'));

      socket!.on('users', (data) {
        try {
          debugPrint('users atualizado');

          Map<String, dynamic> response = data;

          List<SessionUser> sessionUsers = [];

          for (int i = 0;
              i < (response['sessionUsers'] as List<dynamic>).length;
              i++) {
            SessionUser sessionUser =
                SessionUser.fromJson(response['sessionUsers'][i]);

            if (sessionUser.user != null) {
              sessionUsers.add(sessionUser);
            }
          }

          Session session = Session.fromJson(response['session']);

          if (tables[session.tableId] == null) {
            tables[session.tableId] = TableReference(
                id: session.tableId,
                sessionId: session.id,
                number: session.table!.number);
          }

          tables[session.tableId]!.sessionUsers = sessionUsers;

          if (onSocketUsersListener != null) {
            onSocketUsersListener!();
          }
        } on Error catch (e) {
          Logger.log(e);
        } on Exception catch (e) {
          Logger.log(e);
        }
      });

      socket!.on('orders', (data) {
        try {
          debugPrint('orders atualizado');

          List<SessionOrder> sessionOrders = [];

          Map<String, dynamic> response = data;

          for (int i = 0;
              i < (response['sessionOrders'] as List<dynamic>).length;
              i++) {
            SessionOrder sessionOrder =
                SessionOrder.fromJson(response['sessionOrders'][i]);

            // if (sessionOrder.product != null) {
            sessionOrders.add(sessionOrder);
            // }
          }

          Session session = Session.fromJson(response['session']);

          if (tables[session.tableId] == null) {
            tables[session.tableId] = TableReference(
                id: session.tableId,
                sessionId: session.id,
                number: session.table!.number);
          }

          tables[session.tableId]!.sessionOrders = sessionOrders;

          if (onSocketOrdersListener != null) {
            onSocketOrdersListener!();
          }
        } on Error catch (e) {
          debugPrint('$e');
        }
      });
    }
  }
}
