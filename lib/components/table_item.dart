import 'package:flutter/material.dart';
import 'package:smart_menu_waiter_app/api/smart_menu_socker_api.dart';
import 'package:smart_menu_waiter_app/components/order_item.dart';
import 'package:smart_menu_waiter_app/components/session_user_bar.dart';
import 'package:smart_menu_waiter_app/models/session_order.dart';

class TableItem extends StatefulWidget {
  final TableReference tableReference;
  final double maxWidth;

  const TableItem(
      {super.key, required this.tableReference, required this.maxWidth});

  @override
  State<TableItem> createState() => _TableItemState();
}

class _TableItemState extends State<TableItem> {
  List<UserBar> sessionUserBars = [];

  List<Container> orders = [];

  @override
  Widget build(BuildContext context) {
    sessionUserBars = [];

    for (int i = 0; i < widget.tableReference.sessionUsers.length; i++) {
      sessionUserBars.add(
        UserBar(sessionUser: widget.tableReference.sessionUsers.elementAt(i)),
      );
    }

    orders = [];

    for (int i = 0; i < widget.tableReference.sessionOrders.length; i++) {
      SessionOrder sessionOrder = widget.tableReference.sessionOrders[i];

      orders.add(Container(
        margin: EdgeInsets.all(widget.maxWidth * 0.05),
        child: OrderItem(
          maxWidth: widget.maxWidth * 0.9,
          sessionOrder: sessionOrder,
        ),
      ));
    }

    return Container(
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(
          Radius.circular(20),
        ),
        color: Colors.brown,
      ),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          title: Column(
            children: [
              Text(
                "Mesa ${widget.tableReference.number}",
                style: const TextStyle(
                    color: Colors.white,
                    fontFamily: 'Sofia',
                    fontSize: 25,
                    fontWeight: FontWeight.w600),
              ),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Container(
                  height: 70,
                  padding: const EdgeInsets.only(left: 20),
                  child: Row(
                    children: sessionUserBars,
                  ),
                ),
              ),
            ],
          ),
          controlAffinity: ListTileControlAffinity.leading,
          children: orders,
        ),
      ),
    );
  }
}
