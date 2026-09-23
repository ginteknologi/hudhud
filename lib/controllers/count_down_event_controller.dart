import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:masjid_app/models/event_count_down.dart';
import 'package:masjid_app/service/eventCountDown_service.dart';

class CountDownEventController extends GetxController {
  var isLoadingEvent = true.obs;
  late Timer _timer;
  final Rx<DateTime> _targetDate = DateTime.parse("2025-02-28").obs;
  RxList<Map<String, dynamic>> countdownData = <Map<String, dynamic>>[].obs;
  Rx<EventCountDownData> eventData = Rx(EventCountDownData(
    title: 'Default Title',
    limitDate: '2024-12-31',
    description: 'Default Description',
    imageUrl: 'https://nos.wjv-1.neo.id/marbot/assets/ramadhan-01.png',
  ));

  Future<void> getData() async {
    try {
      final data = await EventCountDownService.getData();
      if (data != null && data['selesai'] != null) {
        _targetDate.value = DateTime.parse(data['selesai']);
        eventData.value = EventCountDownData(
            status: true,
            description: data['keterangan'] ?? '',
            limitDate: data['selesai'] ?? '',
            title: data['judul'] ?? '',
            imageUrl: data['image'] ?? 'https://nos.wjv-1.neo.id/marbot/assets/ramadhan-01.png');
      }
      isLoadingEvent.value = false;
      if (kDebugMode) {
        debugPrint("ini >>>>>>>>>>>>>>>>>> eventData");
        debugPrint(eventData.toString());
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint("error controller EventCountDownService");
        debugPrint(e.toString());
      }
    }
  }

  void _updateTimer(Timer timer) {
    DateTime currentDate = DateTime.now();
    Duration remainingTime = _targetDate.value.difference(currentDate);
    countdownData.assignAll([
      {'value': remainingTime.inDays, 'label': 'Hari'},
      {'value': remainingTime.inHours % 24, 'label': 'Jam'},
      {'value': remainingTime.inMinutes % 60, 'label': 'Menit'},
      {'value': remainingTime.inSeconds % 60, 'label': 'Detik'},
    ]);
  }

  @override
  void onInit() async {
    super.onInit();
    await getData();
    _timer = Timer.periodic(Duration(seconds: 1), _updateTimer);
  }

  @override
  void onClose() {
    super.onClose();
    _timer.cancel();
  }
}
