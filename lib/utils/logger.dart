import 'package:flutter/material.dart';

class Logger {
  static void log(dynamic message) {
    debugPrint("logger: $message");
  }
}
