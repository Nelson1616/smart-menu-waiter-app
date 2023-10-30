import 'package:flutter/material.dart';
import 'package:smart_menu_waiter_app/components/session_user_bar.dart';
import 'package:smart_menu_waiter_app/models/session_waiter_call.dart';

class WaiterCallItem extends StatefulWidget {
  final SessionWaiterCall waiterCall;
  final double maxWidth;

  const WaiterCallItem(
      {super.key, required this.waiterCall, required this.maxWidth});

  @override
  State<WaiterCallItem> createState() => _WaiterCallItemState();
}

class _WaiterCallItemState extends State<WaiterCallItem> {
  void updateWaiterCall() {}

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.maxWidth,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: const Color(0xFFFFFFFF),
        border: Border.all(color: const Color(0xFFD3D3D3)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              ConstrainedBox(
                constraints: BoxConstraints(maxWidth: widget.maxWidth * 0.3),
                child: UserBar(sessionUser: widget.waiterCall.sessionUser!),
              ),
              SizedBox(
                width: widget.maxWidth * 0.45,
                child: Text(
                    'solicitou atendimento na Mesa ${widget.waiterCall.sessionUser!.session!.table!.number}'),
              ),
            ],
          ),
          SizedBox(
              width: widget.maxWidth * 0.20,
              child: ElevatedButton(
                  onPressed: () async {
                    updateWaiterCall();
                  },
                  style: ElevatedButton.styleFrom(
                    shape: const CircleBorder(),
                  ),
                  child: const Icon(Icons.check))),
        ],
      ),
    );
  }
}
