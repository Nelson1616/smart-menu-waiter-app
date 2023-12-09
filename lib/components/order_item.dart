import 'package:flutter/material.dart';
import 'package:smart_menu_waiter_app/api/smart_menu_socker_api.dart';
import 'package:smart_menu_waiter_app/components/session_user_bar.dart';
import 'package:smart_menu_waiter_app/models/session_order.dart';
import 'package:smart_menu_waiter_app/models/session_order_user.dart';

class OrderItem extends StatefulWidget {
  final SessionOrder sessionOrder;
  final double maxWidth;

  const OrderItem(
      {super.key, required this.sessionOrder, required this.maxWidth});

  @override
  State<OrderItem> createState() => _OrderItemState();
}

class _OrderItemState extends State<OrderItem> {
  bool currentUserInOrder = false;

  List<UserBar> sessionUserBars = [];

  bool verifyOrderNotFinished() {
    return widget.sessionOrder.statusId != 4 &&
        widget.sessionOrder.statusId != 0;
  }

  void cancelOrder() {
    SmartMenuSocketApi().cancelOrder(widget.sessionOrder.id);
  }

  void receiveOrder() {
    SmartMenuSocketApi().updateOrder(widget.sessionOrder.id);
  }

  void deliverOrder() {
    SmartMenuSocketApi().updateOrder(widget.sessionOrder.id);
  }

  void downgradeOrder() {
    SmartMenuSocketApi().downgradeOrder(widget.sessionOrder.id);
  }

  Widget createTableNumberText() {
    return Text(
      'Mesa ${widget.sessionOrder.session!.table!.number}',
      style: TextStyle(
          color: Colors.red[900],
          fontFamily: 'Sofia',
          fontSize: 20,
          fontWeight: FontWeight.w600),
    );
  }

  Widget createCancelOrderButton() {
    if (verifyOrderNotFinished()) {
      return Container(
        padding: const EdgeInsets.only(top: 10, bottom: 10),
        height: 60,
        width: widget.maxWidth * 0.8,
        child: ElevatedButton(
          onPressed: () async {
            cancelOrder();
          },
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [Text("Cancelar Pedido"), Icon(Icons.cancel)],
          ),
        ),
      );
    } else {
      return const SizedBox.shrink();
    }
  }

  Widget createReceiveOrderButton() {
    if (verifyOrderNotFinished() && widget.sessionOrder.statusId == 1) {
      return Container(
        padding: const EdgeInsets.only(top: 10, bottom: 10),
        height: 60,
        width: widget.maxWidth * 0.8,
        child: ElevatedButton(
          onPressed: () async {
            receiveOrder();
          },
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text("Receber Pedido"),
              Icon(
                Icons.drive_file_rename_outline,
              ),
            ],
          ),
        ),
      );
    } else {
      return const SizedBox.shrink();
    }
  }

  Widget createDeliverOrderButton() {
    if (verifyOrderNotFinished() && widget.sessionOrder.statusId == 2) {
      return Container(
        padding: const EdgeInsets.only(top: 10, bottom: 10),
        height: 60,
        width: widget.maxWidth * 0.8,
        child: ElevatedButton(
          onPressed: () async {
            deliverOrder();
          },
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text("Entregar Pedido"),
              Icon(
                Icons.check,
              ),
            ],
          ),
        ),
      );
    } else {
      return const SizedBox.shrink();
    }
  }

  Widget createDowngradeOrderButton() {
    if (widget.sessionOrder.statusId > 1) {
      return Container(
        padding: const EdgeInsets.only(top: 10, bottom: 10),
        height: 60,
        width: widget.maxWidth * 0.8,
        child: ElevatedButton(
          onPressed: () async {
            downgradeOrder();
          },
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text("Voltar Status"),
              Icon(
                Icons.arrow_back,
              ),
            ],
          ),
        ),
      );
    } else {
      return const SizedBox.shrink();
    }
  }

  @override
  Widget build(BuildContext context) {
    currentUserInOrder = false;
    sessionUserBars = [];

    List<SessionOrderUser> sessionOrderUsers =
        widget.sessionOrder.sessionOrderUsers;

    for (int i = 0; i < sessionOrderUsers.length; i++) {
      sessionUserBars.add(
        UserBar(sessionUser: sessionOrderUsers.elementAt(i).sessionUser!),
      );
    }

    String statusText = "Pedido Feito";
    Color colorStatusText = Colors.yellow[800]!;

    Color color = const Color(0xFFFFFFFF);

    if (widget.sessionOrder.statusId == 0) {
      color = Colors.green[100]!;
      statusText = "Pedido Pago";
      colorStatusText = Colors.green[800]!;
    } else if (widget.sessionOrder.statusId == 1) {
      color = Colors.yellow[100]!;
      statusText = "Pedido Feito";
      colorStatusText = Colors.yellow[800]!;
    } else if (widget.sessionOrder.statusId == 2) {
      color = Colors.blue[100]!;
      statusText = "Pedido Recebido";
      colorStatusText = Colors.blue[800]!;
    } else if (widget.sessionOrder.statusId == 3) {
      color = Colors.white;
      statusText = "Pedido Entregue";
      colorStatusText = Colors.black;
    } else {
      color = Colors.red[100]!;
      statusText = "Pedido Cancelado";
      colorStatusText = Colors.red[800]!;
    }

    return Container(
      width: widget.maxWidth,
      decoration: BoxDecoration(
          color: color,
          borderRadius: const BorderRadius.all(Radius.circular(10)),
          border: Border.all(color: const Color(0xFFD3D3D3))),
      child: Column(
        children: [
          createTableNumberText(),
          SizedBox(
            height: widget.maxWidth * 0.05,
          ),
          Row(
            children: [
              SizedBox(
                width: widget.maxWidth * 0.05,
              ),
              SizedBox(
                width: widget.maxWidth * 0.45,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.sessionOrder.product!.name,
                      style: const TextStyle(
                          fontFamily: 'Sofia',
                          fontSize: 20,
                          fontWeight: FontWeight.w600),
                    ),
                    Row(
                      children: [
                        Text(
                          '${widget.sessionOrder.quantity}x ',
                          style: const TextStyle(
                              fontFamily: 'Sofia',
                              fontWeight: FontWeight.w500,
                              fontSize: 14),
                        ),
                        Text(
                          'R\$${(widget.sessionOrder.product!.price) / 100}',
                          style: const TextStyle(
                              fontFamily: 'Sofia',
                              fontWeight: FontWeight.w500,
                              fontSize: 18),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        const Text(
                          '= ',
                          style: TextStyle(
                              fontFamily: 'Sofia',
                              fontWeight: FontWeight.w600,
                              fontSize: 16),
                        ),
                        Text(
                          'R\$${(widget.sessionOrder.amount) / 100}',
                          style: const TextStyle(
                              fontFamily: 'Sofia',
                              fontWeight: FontWeight.w900,
                              fontSize: 22),
                        ),
                      ],
                    ),
                    Text(
                      statusText,
                      style: TextStyle(
                          color: colorStatusText,
                          fontFamily: 'Sofia',
                          fontWeight: FontWeight.w400,
                          fontSize: 14),
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: widget.maxWidth * 0.05,
              ),
              Container(
                width: widget.maxWidth * 0.30,
                height: widget.maxWidth * 0.40,
                decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(10)),
                clipBehavior: Clip.antiAliasWithSaveLayer,
                child: Image.network(
                  widget.sessionOrder.product!.image,
                  fit: BoxFit.cover,
                ),
              ),
            ],
          ),
          Column(
            children: [
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Container(
                  padding: const EdgeInsets.only(left: 20),
                  child: Row(
                    children: sessionUserBars,
                  ),
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  createDeliverOrderButton(),
                  createReceiveOrderButton(),
                  createDowngradeOrderButton(),
                  createCancelOrderButton(),
                ],
              )
            ],
          )
        ],
      ),
    );
  }
}
