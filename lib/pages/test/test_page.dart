import 'package:flutter/material.dart';
import 'package:get/get.dart';
// import 'package:flutter_background_service/flutter_background_service.dart';

class TestPage extends StatefulWidget {

  const TestPage({Key? key}) : super(key: key);
  @override
  State<TestPage> createState() => _TestPageState();
}
  class _TestPageState extends State<TestPage> {
    String text = "Stop service";
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Push Notification Example'),
      ),
      body: SizedBox(
        width: Get.width,
        height: Get.height,
        child: Column(
                  )
      )
    );
  }
    
  }