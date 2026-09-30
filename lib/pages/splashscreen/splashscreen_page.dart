import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:masjid_app/core/audio/app_audio_service.dart';
import 'package:masjid_app/core/router/app_router.dart';
import 'package:masjid_app/core/storage/preferences_service.dart';
import 'package:masjid_app/theme.dart';

class SplashscreenPage extends StatefulWidget {
  const SplashscreenPage({super.key});

  @override
  State<SplashscreenPage> createState() => _SplashscreenPageState();
}

class _SplashscreenPageState extends State<SplashscreenPage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _entranceController;
  late final Animation<double> _opacity;
  late final Animation<double> _scale;
  bool _animationStarted = false;

  @override
  void initState() {
    super.initState();
    _entranceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );
    final entranceCurve = CurvedAnimation(
      parent: _entranceController,
      curve: Curves.easeOutCubic,
    );
    _opacity = Tween<double>(begin: 0, end: 1).animate(entranceCurve);
    _scale = Tween<double>(begin: 0.96, end: 1).animate(entranceCurve);
    AppAudioService.playBismillah();
    _checkRedirect();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_animationStarted) return;
    _animationStarted = true;

    final reduceMotion =
        MediaQuery.maybeOf(context)?.disableAnimations ?? false;
    if (reduceMotion) {
      _entranceController.value = 1;
    } else {
      _entranceController.forward();
    }
  }

  @override
  void dispose() {
    _entranceController.dispose();
    super.dispose();
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
        systemNavigationBarColor: AppColors.surface,
        systemNavigationBarIconBrightness: Brightness.dark,
        systemNavigationBarDividerColor: Colors.transparent,
      ),
      child: Scaffold(
        backgroundColor: AppColors.surface,
        body: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              final logoSize = (constraints.biggest.shortestSide * 0.48)
                  .clamp(164.0, 224.0)
                  .toDouble();

              return Center(
                child: FadeTransition(
                  opacity: _opacity,
                  child: ScaleTransition(
                    scale: _scale,
                    child: Semantics(
                      container: true,
                      label: 'Hudhud. Teman ibadah, setiap hari.',
                      child: ExcludeSemantics(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(32),
                              child: Image.asset(
                                'assets/img/new-logo.png',
                                width: logoSize,
                                height: logoSize,
                                fit: BoxFit.contain,
                                filterQuality: FilterQuality.high,
                                gaplessPlayback: true,
                              ),
                            ),
                            const SizedBox(height: 22),
                            const Text(
                              'Hudhud',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontFamily: 'DMSerifDisplay',
                                fontSize: 42,
                                height: 1,
                                letterSpacing: 0,
                                color: AppColors.textDark,
                              ),
                            ),
                            const SizedBox(height: 10),
                            const Text(
                              'Teman ibadah, setiap hari',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 14,
                                height: 1.4,
                                letterSpacing: 0,
                                fontWeight: FontWeight.w500,
                                color: Color(0xFF6C5148),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
