import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:masjid_app/controllers/alarm_solat_controller.dart';
import 'package:masjid_app/models/waktuSolatData.dart';

class AlarmSolatPage extends StatelessWidget {
  final AlarmSolatController alarmController = Get.put(AlarmSolatController());

  AlarmSolatPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Alarm App'),
      ),
      body: ListView.builder(
          itemCount: alarmController.list.length,
          itemBuilder: (context, index) {
            WaktuSolatData item = alarmController.list[index];
            return ListTile(
              title: Text(item.label),
              subtitle: Text(item.time),
              trailing:
                  item.alarm == 0 ? Icon(Icons.alarm) : Icon(Icons.alarm_off),
            );
          }),
    );
  }
}
