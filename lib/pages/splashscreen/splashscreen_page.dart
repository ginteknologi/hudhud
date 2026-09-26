import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:masjid_app/core/audio/app_audio_service.dart';
import 'package:masjid_app/core/router/app_router.dart';
import 'package:masjid_app/core/storage/preferences_service.dart';

class SplashscreenPage extends StatefulWidget {
  const SplashscreenPage({super.key});

  @override
  State<SplashscreenPage> createState() => _SplashscreenPageState();
}

class _SplashscreenPageState extends State<SplashscreenPage> {
  @override
  void initState() {
    super.initState();
    AppAudioService.playBismillah();
    _checkRedirect();
  }

  Future<void> _checkRedirect() async {
    await Future.delayed(const Duration(milliseconds: 2200));
    if (mounted) {
      if (!PreferencesService.onboardingCompleted) {
        context.go(AppRoutes.onboarding);
      } else {
        context.go(AppRoutes.home);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
      ),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: Image.asset(
            'assets/img/new-logo.png',
            width: 190,
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }
}
