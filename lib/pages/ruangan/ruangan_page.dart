import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:mesjid_app/pages/ruangan/ruangan_controller.dart';

class RuanganPage extends StatelessWidget{
  const RuanganPage({super.key});

  @override
  Widget build(BuildContext context) {
    final ctrl = Get.put(RuanganController());
    
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
    );
  }
}