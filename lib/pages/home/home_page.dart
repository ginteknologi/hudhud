import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:masjid_app/pages/akun/akun_page.dart';
import 'package:masjid_app/pages/dashboard/dashboard_page.dart';
import 'package:masjid_app/pages/quran/new_quran/alquran_page.dart';
import 'package:masjid_app/providers/home_nav_provider.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  static const _pages = [DashboardPage(), AlquranPage(), AkunPage()];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selected = ref.watch(homeBottomNavIndexProvider).clamp(0, 2);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: IndexedStack(index: selected, children: _pages),
      bottomNavigationBar: NavigationBar(
        selectedIndex: selected,
        onDestinationSelected: (index) {
          if (index == selected) return;
          HapticFeedback.selectionClick();
          ref.read(homeBottomNavIndexProvider.notifier).state = index;
        },
        destinations: const [
          NavigationDestination(
              icon: Icon(LucideIcons.house),
              selectedIcon: Icon(LucideIcons.house),
              label: 'Beranda'),
          NavigationDestination(
              icon: Icon(LucideIcons.bookOpen),
              selectedIcon: Icon(LucideIcons.bookOpen),
              label: "Al-Qur'an"),
          NavigationDestination(
              icon: Icon(LucideIcons.userRound),
              selectedIcon: Icon(LucideIcons.userRound),
              label: 'Akun'),
        ],
      ),
    );
  }
}
