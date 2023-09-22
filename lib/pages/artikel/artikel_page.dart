import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:mesjid_app/pages/artikel/artikel_controller.dart';

class ArtikelPage extends StatelessWidget{
  const ArtikelPage({super.key});

  @override
  Widget build(BuildContext context) {
    final ctrl = Get.put(ArtikelController());
    
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
    );
  }
}