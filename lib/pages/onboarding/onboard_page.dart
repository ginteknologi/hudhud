import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:masjid_app/core/router/app_router.dart';
import 'package:masjid_app/core/storage/preferences_service.dart';
import 'package:masjid_app/core/theme/hudhud_theme.dart';

class OnboardPage extends StatefulWidget {
  const OnboardPage({super.key});

  @override
  State<OnboardPage> createState() => _OnboardPageState();
}

class _Slide {
  const _Slide(this.title, this.body, this.asset);
  final String title;
  final String body;
  final String asset;
}

class _OnboardPageState extends State<OnboardPage> {
  final _controller = PageController();
  int _index = 0;

  static const _slides = [
    _Slide(
        'Tepat waktu, tanpa terasa ramai',
        'Lihat waktu salat berikutnya dan pengingat yang relevan dengan harimu.',
        'assets/img/hudhud/morning.png'),
    _Slide(
        "Dekat dengan Al-Qur'an",
        'Cari surah, simpan bacaan, lalu lanjutkan tilawah dari tempat terakhir.',
        'assets/img/hudhud/midday.png'),
    _Slide(
        'Rutinitas kecil yang bermakna',
        'Doa, dzikir, hadits, dan arah kiblat hadir saat kamu membutuhkannya.',
        'assets/img/hudhud/night.png'),
  ];

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _finish() {
    HapticFeedback.mediumImpact();
    PreferencesService.onboardingCompleted = true;
    context.go(AppRoutes.auth);
  }

  void _next() {
    if (_index == _slides.length - 1) return _finish();
    final reduced = MediaQuery.disableAnimationsOf(context);
    _controller.nextPage(
      duration: reduced ? Duration.zero : context.hudhud.motionNormal,
      curve: Curves.easeOutQuart,
    );
  }

  @override
  Widget build(BuildContext context) {
    final t = context.hudhud;
    final last = _index == _slides.length - 1;
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(t.spaceLg, t.spaceSm, t.spaceSm, 0),
              child: Row(
                children: [
                  Image.asset('assets/img/new-logo.png', width: 36, height: 36),
                  const SizedBox(width: 10),
                  Expanded(
                      child: Text('Hudhud',
                          style: Theme.of(context).textTheme.titleMedium)),
                  TextButton(onPressed: _finish, child: const Text('Lewati')),
                ],
              ),
            ),
            Expanded(
              child: PageView.builder(
                controller: _controller,
                itemCount: _slides.length,
                onPageChanged: (value) => setState(() => _index = value),
                itemBuilder: (_, i) {
                  final slide = _slides[i];
                  return Padding(
                    padding: EdgeInsets.symmetric(horizontal: t.spaceXl),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Flexible(
                            child: Image.asset(slide.asset,
                                height: 300,
                                fit: BoxFit.contain,
                                semanticLabel: 'Ilustrasi Hudhud')),
                        SizedBox(height: t.spaceXl),
                        Text(slide.title,
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.headlineMedium),
                        SizedBox(height: t.spaceMd),
                        Text(slide.body,
                            textAlign: TextAlign.center,
                            style: Theme.of(context)
                                .textTheme
                                .bodyLarge
                                ?.copyWith(color: t.muted)),
                      ],
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: EdgeInsets.all(t.spaceXl),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                        _slides.length,
                        (i) => AnimatedContainer(
                              duration: MediaQuery.disableAnimationsOf(context)
                                  ? Duration.zero
                                  : t.motionFast,
                              width: i == _index ? 24 : 8,
                              height: 8,
                              margin: const EdgeInsets.symmetric(horizontal: 3),
                              decoration: BoxDecoration(
                                  color: i == _index ? t.terracotta : t.outline,
                                  borderRadius: BorderRadius.circular(4)),
                            )),
                  ),
                  SizedBox(height: t.spaceXl),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton.icon(
                      onPressed: _next,
                      iconAlignment: IconAlignment.end,
                      icon: const Icon(LucideIcons.arrowRight, size: 19),
                      label: Text(last ? 'Mulai bersama Hudhud' : 'Lanjut'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
