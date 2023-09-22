import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:mesjid_app/pages/quran/quran_controller.dart';

class QuranPage extends StatelessWidget{
  const QuranPage({super.key});

  @override
  Widget build(BuildContext context) {
    final ctrl = Get.put(QuranController());
    
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
    );
  }
}