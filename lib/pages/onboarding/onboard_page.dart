// lib/pages/onboarding/onboard_page.dart
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:masjid_app/core/router/app_router.dart';
import 'package:masjid_app/core/storage/preferences_service.dart';

class OnboardPage extends StatelessWidget {
  OnboardPage({super.key});

  void _finish(BuildContext context) {
    PreferencesService.onboardingCompleted = true;
    context.go(AppRoutes.auth);
  }

  final onboardingPagesList = [
    PageViewModel(
      titleWidget: const Text(
        "Jadwal Sholat",
        style: TextStyle(
          fontFamily: "DMSerifDisplay",
          color: Color(0xFF048C7C),
          fontSize: 30,
        ),
      ),
      bodyWidget: const Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Flexible(
            child: Text(
              'Selamat datang di aplikasi \n Masjid An-Ni’mah',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.black54),
            ),
          )
        ],
      ),
      image: Center(
        child: Image.asset(
          "assets/img/pray-night.png",
          height: 200,
        ),
      ),
    ),
    PageViewModel(
      titleWidget: const Text(
        "Al-Qur'an Digital",
        style: TextStyle(
          fontFamily: "DMSerifDisplay",
          color: Color(0xFF048C7C),
          fontSize: 30,
        ),
      ),
      bodyWidget: const Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Flexible(
            child: Text(
              'Selamat datang di aplikasi \n Masjid An-Ni’mah',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.black54),
            ),
          )
        ],
      ),
      image: Center(
        child: Image.asset(
          "assets/img/alquran.png",
          height: 200,
        ),
      ),
    ),
    PageViewModel(
      titleWidget: const Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Fitur dan Konten \n Islami",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: "DMSerifDisplay",
              color: Color(0xFF048C7C),
              fontSize: 30,
            ),
          ),
        ],
      ),
      bodyWidget: const Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Flexible(
            child: Text(
              'Selamat datang di aplikasi \n Masjid An-Ni’mah',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.black54),
            ),
          )
        ],
      ),
      image: Center(
        child: Image.asset(
          "assets/img/pray-night.png",
          height: 200,
        ),
      ),
    ),
  ];

  Widget _circleBtn(BuildContext context, IconData icon,
      {bool outline = false}) {
    final primary = Theme.of(context).primaryColor;
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: outline ? Colors.white : primary,
        border: outline ? Border.all(color: primary, width: 2) : null,
      ),
      padding: const EdgeInsets.all(12),
      child: Icon(
        icon,
        size: 24,
        color: outline ? primary : Colors.white,
      ),
    );
  }

  Widget layout(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          Align(
            alignment: Alignment.centerRight,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 15, 0),
              child: TextButton(
                onPressed: () => _finish(context),
                child: const Text("Lewati"),
              ),
            ),
          ),
          Expanded(
            child: IntroductionScreen(
              // ✓ VERSI BARU: pakai done/next/back
              pages: onboardingPagesList,
              showSkipButton: false,
              showNextButton: true,
              showBackButton: true,

              // Tombol default diganti dengan widget kustom (tanpa overrideX)
              next: _circleBtn(context, Icons.arrow_forward),
              back: _circleBtn(context, Icons.arrow_back, outline: true),
              done: const Text("Selesai"),

              // Spasi/posisi kontrol
              controlsMargin: const EdgeInsets.only(bottom: 70),
              controlsPadding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 8),

              // Callback selesai
              onDone: () => _finish(context),

              // Dekorasi dots optional
              dotsDecorator: const DotsDecorator(
                activeColor: Color(0xFF048C7C),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(statusBarIconBrightness: Brightness.dark),
    );

    return Scaffold(
      extendBodyBehindAppBar: false,
      resizeToAvoidBottomInset: false,
      body: layout(context),
    );
  }
}
