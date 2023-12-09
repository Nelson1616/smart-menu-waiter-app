import 'package:smart_menu_waiter_app/api/smert_menu_api.dart';
import 'package:smart_menu_waiter_app/models/session.dart';
import 'package:smart_menu_waiter_app/models/session_order.dart';
import 'package:smart_menu_waiter_app/models/session_user.dart';
import 'package:smart_menu_waiter_app/models/session_waiter_call.dart';
import 'package:smart_menu_waiter_app/utils/logger.dart';
import 'package:socket_io_client/socket_io_client.dart';

class TableReference {
  int id;
  int? sessionId;
  int number;
  List<SessionUser> sessionUsers = [];
  List<SessionOrder> sessionOrders = [];

  TableReference({required this.id, this.sessionId, required this.number});
}

class SmartMenuSocketApi {
  static final SmartMenuSocketApi _instance = SmartMenuSocketApi._internal();

  Socket? socket;
  int? officialId;

  Function? onSocketErrorListener;
  Function? onSocketUsersListener;
  Function? onSocketOrdersListener;
  Function? onSocketWaiterCallsListener;

  void setOnSocketErrorListener(Function onSocketErrorListener) {
    if (this.onSocketErrorListener != onSocketErrorListener) {
      Logger.log("setOnSocketErrorListener");
      this.onSocketErrorListener = onSocketErrorListener;
    }
  }

  void setOnSocketUsersListener(Function onSocketUsersListener) {
    if (this.onSocketUsersListener != onSocketUsersListener) {
      Logger.log("setOnSocketUsersListener = $onSocketUsersListener");
      this.onSocketUsersListener = onSocketUsersListener;
    }
  }

  void setOnSocketOrdersListener(Function onSocketOrdersListener) {
    if (this.onSocketOrdersListener != onSocketOrdersListener) {
      Logger.log("setOnSocketOrdersListener");
      this.onSocketOrdersListener = onSocketOrdersListener;
    }
  }

  void setOnSocketWaiterCallsListener(Function onSocketWaiterCallsListener) {
    if (this.onSocketWaiterCallsListener != onSocketWaiterCallsListener) {
      Logger.log("setOnSocketWaiterCallsListener");
      this.onSocketWaiterCallsListener = onSocketWaiterCallsListener;
    }
  }

  Map<int, TableReference> tables = {};

  List<SessionWaiterCall> sessionWaiterCalls = [];

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

      socket = io('${SmartMenuApi.mainIp}/', <String, dynamic>{
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
    onSocketWaiterCallsListener = null;

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
    onSocketWaiterCallsListener = null;
  }

  void setupSocket() {
    if (socket != null) {
      socket!.on('error', (data) {
        // Logger.log('$data');
        if (onSocketErrorListener != null) {
          onSocketErrorListener!(data);
        }
      });

      socket!.on('message', (data) => Logger.log('$data'));

      socket!.on('connect_error', (data) => Logger.log('$data'));

      socket!.on('connect', (data) {
        Logger.log('$data');

        socket!.emit("join_official", {"official_id": officialId});
      });

      socket!.on('users', (data) {
        try {
          Logger.log('users atualizado');

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
          Logger.log('orders atualizado');

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
          Logger.log('$e');
        }
      });

      socket!.on('on_waiter_call', (data) {
        try {
          Logger.log('waitercalls atualizado');

          Map<String, dynamic> response = data;

          sessionWaiterCalls = [];

          for (int i = 0;
              i < (response['sessionWaiterCalls'] as List<dynamic>).length;
              i++) {
            sessionWaiterCalls.add(
                SessionWaiterCall.fromJson(response['sessionWaiterCalls'][i]));
          }

          if (onSocketWaiterCallsListener != null) {
            onSocketWaiterCallsListener!();
          }
        } on Error catch (e) {
          Logger.log('$e');
        }
      });
    }
  }

  void updateWaiterCall(int waiterCallId) {
    socket!.emit("update_waiter_call",
        {"official_id": officialId, "waiter_call_id": waiterCallId});
  }

  void updateOrder(int sessionOrderId) {
    socket!.emit("update_order",
        {"official_id": officialId, "session_order_id": sessionOrderId});
  }

  void downgradeOrder(int sessionOrderId) {
    socket!.emit("downgrade_order",
        {"official_id": officialId, "session_order_id": sessionOrderId});
  }

  void cancelOrder(int sessionOrderId) {
    socket!.emit("cancel_order",
        {"official_id": officialId, "session_order_id": sessionOrderId});
  }
}
