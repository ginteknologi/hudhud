import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:mesjid_app/pages/home/home_controller.dart';

class HomePage extends StatelessWidget{
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    // final ctrl = Get.put(HomeController());
    
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        title: const Text('GetX Home Page'),
      ),      
    );
  }
}