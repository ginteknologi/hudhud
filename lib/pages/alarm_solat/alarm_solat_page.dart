import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:masjid_app/controllers/alarm_solat_controller.dart';
import 'package:masjid_app/models/waktu_solat_data.dart';

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
              trailing: (item.alarm ?? false)
                ? const Icon(Icons.alarm)
                : const Icon(Icons.alarm_off),
            );
          }),
    );
  }
}
