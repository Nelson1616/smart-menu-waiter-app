import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_menu_waiter_app/api/smart_menu_socker_api.dart';
import 'package:smart_menu_waiter_app/components/order_item.dart';
import 'package:smart_menu_waiter_app/components/table_item.dart';
import 'package:smart_menu_waiter_app/components/waiter_call_item.dart';
import 'package:smart_menu_waiter_app/models/official.dart';
import 'package:smart_menu_waiter_app/models/session_order.dart';
import 'package:smart_menu_waiter_app/models/table.dart';
import 'package:smart_menu_waiter_app/screens/login_screen.dart';

class RestaurantScreen extends StatefulWidget {
  final Official official;

  const RestaurantScreen({super.key, required this.official});

  @override
  State<RestaurantScreen> createState() => _RestaurantScreenState();
}

class _RestaurantScreenState extends State<RestaurantScreen> {
  final double margin = 20;
  final String expandedLogoImage = 'images/logo_expanded.png';
  final Color mainColor = const Color(0xFFE42626);

  Future<void> logout() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    prefs.remove('officialId').then((value) {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (context) => const LoginScreen(),
        ),
        (route) => true,
      );
    });
  }

  void showErro(String error) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(error, style: const TextStyle(color: Colors.black)),
      backgroundColor: Colors.red[300],
    ));
  }

  int bottonNavegationIndex = 0;

  void onOptionSelected(int index) {
    setState(() {
      bottonNavegationIndex = index;
    });
  }

  double screenWidth = 300;

  List<Container> orders = [];

  List<Container> tableItems = [];

  List<Container> waiterCalls = [];

  void onSocketOrdersListener({bool state = true}) {
    try {
      for (int i = 0; i < widget.official.restaurant!.tables.length; i++) {
        RestaurantTable table = widget.official.restaurant!.tables[i];

        if (SmartMenuSocketApi().tables[table.id] == null) {
          SmartMenuSocketApi().tables[table.id] =
              TableReference(id: table.id, number: table.number);
        }
      }

      orders = [];
      tableItems = [];

      SmartMenuSocketApi().tables.forEach((tableId, tableReference) {
        tableItems.add(Container(
          margin: EdgeInsets.all(screenWidth * 0.05),
          child: TableItem(
            tableReference: tableReference,
            maxWidth: screenWidth,
          ),
        ));

        for (int i = 0; i < tableReference.sessionOrders.length; i++) {
          SessionOrder sessionOrder = tableReference.sessionOrders[i];

          orders.add(Container(
            margin: EdgeInsets.all(screenWidth * 0.05),
            child: OrderItem(
              maxWidth: screenWidth,
              sessionOrder: sessionOrder,
            ),
          ));
        }
      });

      if (state) {
        setState(() {});
      }
    } on Error catch (e) {
      debugPrint('$e');
    }
  }

  void onSocketWaiterCallsListener({bool state = true}) {
    try {
      waiterCalls = [];

      for (int i = 0; i < SmartMenuSocketApi().sessionWaiterCalls.length; i++) {
        waiterCalls.add(Container(
          margin: EdgeInsets.all(screenWidth * 0.05),
          child: WaiterCallItem(
              waiterCall: SmartMenuSocketApi().sessionWaiterCalls[i],
              maxWidth: screenWidth * 0.9),
        ));
      }
      if (state) {
        setState(() {});
      }
    } on Error catch (e) {
      debugPrint('$e');
    }
  }

  @override
  Widget build(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;

    SmartMenuSocketApi().officialId = widget.official.id;
    SmartMenuSocketApi().setOnSocketOrdersListener(onSocketOrdersListener);
    SmartMenuSocketApi()
        .setOnSocketWaiterCallsListener(onSocketWaiterCallsListener);
    SmartMenuSocketApi().connect();

    onSocketOrdersListener(state: false);
    onSocketWaiterCallsListener(state: false);

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Center(
          child: Text(
            widget.official.restaurant!.name,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontFamily: 'Sofia',
              fontSize: 20,
            ),
          ),
        ),
        backgroundColor: mainColor,
        leading: const SizedBox.shrink(),
        actions: [
          SizedBox(
            width: 58,
            child: PopupMenuButton(
              icon: CircleAvatar(
                backgroundImage:
                    AssetImage("images/avatar_${widget.official.imageId}.png"),
                backgroundColor: Colors.red,
              ),
              itemBuilder: (BuildContext context) {
                return [
                  PopupMenuItem<String>(
                    value: '1',
                    child: Row(
                      children: [
                        TextButton(
                            onPressed: () {
                              logout();
                            },
                            child: const Text("Sair")),
                        const Icon(Icons.exit_to_app),
                      ],
                    ),
                  ),
                ];
              },
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Container(
          child: (<Widget>[
            Column(children: tableItems),
            Column(children: orders),
            Column(children: waiterCalls),
          ]).elementAt(bottonNavegationIndex),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        iconSize: 30,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.table_bar),
            label: 'Mesas',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.restaurant_menu),
            label: 'Pedidos',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.waving_hand),
            label: 'Chamados',
          ),
        ],
        currentIndex: bottonNavegationIndex,
        selectedItemColor: Colors.white,
        onTap: onOptionSelected,
        backgroundColor: mainColor,
      ),
    );
  }
}
