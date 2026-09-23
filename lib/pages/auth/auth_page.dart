import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:masjid_app/components/button/outlinebutton.dart';
import 'package:masjid_app/core/router/app_router.dart';
import 'package:masjid_app/providers/auth_provider.dart';

class AuthPage extends ConsumerWidget {
  const AuthPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authNotifierProvider);
    final isLoading = authState.isLoading;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      extendBodyBehindAppBar: false,
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                'Assalamu’alaikum \n Warahmatullahi Wabarakatuh',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'DMSerifDisplay',
                  color: Color(0xFF048C7C),
                  fontSize: 28,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Selamat datang di aplikasi Masjid An-Ni’mah',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.black54, fontSize: 14),
              ),
              const SizedBox(height: 30),
              Image.asset(
                'assets/img/new-logo.png',
                width: 256,
              ),
              const SizedBox(height: 30),
              if (isLoading)
                const CircularProgressIndicator()
              else ...[
                ButtonOutline(
                  onPressed: () async {
                    await ref.read(authNotifierProvider.notifier).loginGuest();
                    if (context.mounted) {
                      context.go(AppRoutes.home);
                    }
                  },
                  radius: 40,
                  title: 'Lewati (Masuk Tamu)',
                  width: 250,
                  shadow: false,
                ),
                Container(
                  margin: const EdgeInsets.fromLTRB(0, 12, 0, 0),
                  child: ButtonOutline(
                    onPressed: () async {
                      await ref.read(authNotifierProvider.notifier).loginGoogle();
                      if (context.mounted) {
                        context.go(AppRoutes.home);
                      }
                    },
                    radius: 40,
                    showIcon: 'left',
                    iconLeft: Image.asset(
                      'assets/img/google.png',
                      height: 30,
                    ),
                    title: 'Login dengan Google',
                    width: 250,
                    shadow: false,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
