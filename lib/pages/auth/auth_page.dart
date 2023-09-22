import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:mesjid_app/pages/auth/auth_controller.dart';

class AuthPage extends StatelessWidget{
  const AuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    final ctrl = Get.put(AuthController());
    
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
    );
  }
}