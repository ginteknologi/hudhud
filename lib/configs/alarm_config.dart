import 'dart:isolate';

class alarmConfig {
  @pragma('vm:entry-point')
  static void printHello() {
    final DateTime now = DateTime.now();
    final int isolateId = Isolate.current.hashCode;
    print("[$now] Hello, world! isolate=$isolateId function='$printHello'");
  }
}
