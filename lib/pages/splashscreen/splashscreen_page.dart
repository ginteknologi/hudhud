import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:masjid_app/core/router/app_router.dart';

class SplashscreenPage extends StatefulWidget {
  const SplashscreenPage({super.key});

  @override
  State<SplashscreenPage> createState() => _SplashscreenPageState();
}

class _SplashscreenPageState extends State<SplashscreenPage> {
  @override
  void initState() {
    super.initState();
    _checkRedirect();
  }

  Future<void> _checkRedirect() async {
    await Future.delayed(const Duration(milliseconds: 1500));
    if (mounted) {
      context.go(AppRoutes.home);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0DA49D),
      body: SizedBox.expand(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              'assets/img/logo-splash.png',
              width: 160,
            ),
          ],
        ),
      ),
    );
  }
}
