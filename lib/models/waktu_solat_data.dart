class WaktuSolatData {
  String label, time;
  String? time24;
  bool status;
  bool? alarm;
  WaktuSolatData(
      {required this.label,
      required this.time,
      this.time24,
      required this.status,
      this.alarm = false});

  factory WaktuSolatData.fromJson(Map<String, dynamic> json) {
    return WaktuSolatData(
      label: json['label'],
      time: json['time'],
      status: json['status'],
    );
  }
}
