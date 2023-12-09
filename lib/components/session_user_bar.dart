import 'package:flutter/material.dart';
import 'package:smart_menu_waiter_app/api/smart_menu_socker_api.dart';
import 'package:smart_menu_waiter_app/models/session_user.dart';

class UserBar extends StatefulWidget {
  final SessionUser sessionUser;
  const UserBar({super.key, required this.sessionUser});

  @override
  State<UserBar> createState() => _UserBarState();
}

class _UserBarState extends State<UserBar> {
  pay() {
    SmartMenuSocketApi().pay(widget.sessionUser.id);
  }

  @override
  Widget build(BuildContext context) {
    Color color = Colors.blue[200]!;

    if (widget.sessionUser.statusId == 0) {
      color = Colors.green[200]!;
    }

    return GestureDetector(
      onTap: () {
        showDialog<String>(
          context: context,
          builder: (BuildContext dialogContext) => StatefulBuilder(
            builder: (dialogContext, setState) => Dialog(
              child: SizedBox(
                height: 400,
                child: Column(children: [
                  Container(
                    margin: const EdgeInsets.all(10),
                    width: 180,
                    height: 180,
                    decoration: const BoxDecoration(shape: BoxShape.circle),
                    clipBehavior: Clip.hardEdge,
                    child: Image(
                      image: AssetImage(
                          'images/avatar_${widget.sessionUser.user!.imageId}.png'),
                      fit: BoxFit.fill,
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.all(10),
                    child: Text(
                      widget.sessionUser.user!.name,
                      style: const TextStyle(
                          fontFamily: 'Sofia',
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                          fontSize: 14),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.all(10),
                    child: ElevatedButton(
                      onPressed: () {
                        pay();
                        Navigator.pop(dialogContext);
                      },
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Pagar Conta"),
                          Icon(Icons.paid),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.all(10),
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(dialogContext);
                      },
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Cancelar"),
                          Icon(Icons.cancel),
                        ],
                      ),
                    ),
                  ),
                ]),
              ),
            ),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: color,
        ),
        padding: const EdgeInsets.only(right: 8, left: 3, top: 3, bottom: 3),
        margin: const EdgeInsets.all(4),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              Container(
                margin: const EdgeInsets.only(right: 8),
                child: CircleAvatar(
                  backgroundImage: AssetImage(
                      "images/avatar_${widget.sessionUser.user!.imageId}.png"),
                  backgroundColor: Colors.red,
                ),
              ),
              Text(
                widget.sessionUser.user!.name,
                style: const TextStyle(
                    fontFamily: 'Sofia',
                    fontSize: 14,
                    fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
