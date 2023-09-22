import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:mesjid_app/pages/akun/akun_controller.dart';

class AkunPage extends StatelessWidget{
  const AkunPage({super.key});

  @override
  Widget build(BuildContext context) {
    final ctrl = Get.put(AkunController());
    
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
    );
  }
}