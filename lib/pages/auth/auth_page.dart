import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:masjid_app/core/router/app_router.dart';
import 'package:masjid_app/core/theme/hudhud_theme.dart';
import 'package:masjid_app/providers/auth_provider.dart';

class AuthPage extends ConsumerStatefulWidget {
  const AuthPage({super.key});

  @override
  ConsumerState<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends ConsumerState<AuthPage> {
  String? _error;

  Future<void> _run(Future<void> Function() action) async {
    HapticFeedback.lightImpact();
    setState(() => _error = null);
    try {
      await action();
      final state = ref.read(authNotifierProvider);
      if (state.hasError) {
        if (mounted) {
          setState(() =>
              _error = 'Belum berhasil masuk. Periksa koneksi lalu coba lagi.');
        }
      } else if (mounted) {
        context.go(AppRoutes.home);
      }
    } catch (_) {
      if (mounted) {
        setState(
            () => _error = 'Terjadi kendala saat masuk. Silakan coba lagi.');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = context.hudhud;
    final loading = ref.watch(authNotifierProvider).isLoading;
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(t.spaceXl),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 440),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Image.asset('assets/img/hudhud/morning.png',
                      height: 230,
                      fit: BoxFit.contain,
                      semanticLabel: 'Hudhud menyambut pengguna'),
                  SizedBox(height: t.spaceLg),
                  Text('Ibadah harian, lebih dekat',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.headlineMedium),
                  SizedBox(height: t.spaceSm),
                  Text(
                    'Jadwal salat, Al-Qur\'an, doa, dan dzikir dalam satu ruang yang tenang.',
                    textAlign: TextAlign.center,
                    style: Theme.of(context)
                        .textTheme
                        .bodyLarge
                        ?.copyWith(color: t.muted),
                  ),
                  SizedBox(height: t.spaceXl),
                  if (_error != null) ...[
                    Semantics(
                      liveRegion: true,
                      child: Container(
                        padding: EdgeInsets.all(t.spaceMd),
                        decoration: BoxDecoration(
                            color: t.danger.withValues(alpha: .09),
                            borderRadius: BorderRadius.circular(t.radiusMd)),
                        child: Row(children: [
                          Icon(LucideIcons.circleAlert,
                              color: t.danger, size: 20),
                          SizedBox(width: t.spaceSm),
                          Expanded(
                              child: Text(_error!,
                                  style: TextStyle(color: t.danger))),
                        ]),
                      ),
                    ),
                    SizedBox(height: t.spaceMd),
                  ],
                  FilledButton.icon(
                    onPressed: loading
                        ? null
                        : () => _run(() => ref
                            .read(authNotifierProvider.notifier)
                            .loginGoogle()),
                    icon: loading
                        ? const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(
                                strokeWidth: 2, color: Colors.white))
                        : const Icon(LucideIcons.logIn, size: 19),
                    label:
                        Text(loading ? 'Sedang masuk…' : 'Masuk dengan Google'),
                  ),
                  SizedBox(height: t.spaceSm),
                  OutlinedButton(
                    onPressed: loading
                        ? null
                        : () => _run(() => ref
                            .read(authNotifierProvider.notifier)
                            .loginGuest()),
                    child: const Text('Lanjut sebagai tamu'),
                  ),
                  SizedBox(height: t.spaceXl),
                  Text(
                      'Dengan melanjutkan, Anda menyetujui penggunaan data minimum yang diperlukan agar fitur berjalan.',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodySmall),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
