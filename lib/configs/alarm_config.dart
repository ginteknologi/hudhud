import 'dart:isolate';

import 'package:flutter/foundation.dart';

class AlarmConfig {
  @pragma('vm:entry-point')
  static void printHello() {
    final DateTime now = DateTime.now();
    final int isolateId = Isolate.current.hashCode;
    if (kDebugMode) {
      debugPrint(
          "[$now] Hello, world! isolate=$isolateId function='$printHello'");
    }
  }
}
