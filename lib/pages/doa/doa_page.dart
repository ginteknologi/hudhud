import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:mesjid_app/pages/doa/doa_controller.dart';

class DoaPage extends StatelessWidget{
  const DoaPage({super.key});

  @override
  Widget build(BuildContext context) {
    final ctrl = Get.put(DoaController());
    
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
    );
  }
}