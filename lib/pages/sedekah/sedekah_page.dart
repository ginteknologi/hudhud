import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:mesjid_app/pages/sedekah/sedekah_controller.dart';

class SedekahPage extends StatelessWidget{
  const SedekahPage({super.key});

  @override
  Widget build(BuildContext context) {
    final ctrl = Get.put(SedekahController());
    
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
    );
  }
}