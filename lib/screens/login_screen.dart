import 'package:flutter/material.dart';
import 'package:smart_menu_waiter_app/api/smert_menu_api.dart';
import 'package:smart_menu_waiter_app/models/official.dart';
import 'package:smart_menu_waiter_app/utils/logger.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final double margin = 20;
  final String expandedLogoImage = 'images/logo_expanded.png';
  final Color mainColor = const Color(0xFFE42626);

  String email = "";
  String password = "";

  Future<void> login() async {
    ResponseJson loginReq = await SmartMenuApi.login(email, password);

    if (!loginReq.success) {
      showErro(loginReq.message);
      return;
    }

    Official official = Official.fromJson(loginReq.data!);

    Logger.log(official.restaurant!.tables.length);
  }

  void showErro(String error) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(error, style: const TextStyle(color: Colors.black)),
      backgroundColor: Colors.red[300],
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            margin: EdgeInsets.all(margin),
            child: Column(
              children: [
                Image(
                  image: AssetImage(expandedLogoImage),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      margin: const EdgeInsets.all(8),
                      child: Text(
                        "E-mail",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Sofia',
                            fontSize: 20,
                            color: mainColor),
                      ),
                    ),
                  ],
                ),
                Container(
                  margin: const EdgeInsets.all(8),
                  child: TextFormField(
                    onChanged: (value) {
                      email = value;
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Email Inválido';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0)),
                      labelText: 'Digite seu email',
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      margin: const EdgeInsets.all(8),
                      child: Text(
                        "Senha",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Sofia',
                            fontSize: 20,
                            color: mainColor),
                      ),
                    ),
                  ],
                ),
                Container(
                  margin: const EdgeInsets.all(8),
                  child: TextFormField(
                    onChanged: (value) {
                      password = value;
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Senha inválida';
                      }
                      return null;
                    },
                    obscureText: true,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0)),
                      labelText: 'Digite sua senha',
                    ),
                  ),
                ),
                Container(
                  width: double.infinity,
                  height: 50,
                  margin: EdgeInsets.all(margin),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: mainColor),
                    onPressed: () {
                      login();
                    },
                    child: const Text(
                      'ENTRAR',
                      style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'Sofia',
                          fontWeight: FontWeight.w800,
                          fontSize: 20),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
