import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:masjid_app/models/menu_bottom_data.dart';
import 'package:masjid_app/pages/dashboard/dashboard_page.dart';
import 'package:masjid_app/pages/dkm/dkm_page.dart';
import 'package:masjid_app/pages/muazin/muazin_page.dart';
import 'package:masjid_app/pages/quran/new_quran/alquran_page.dart';
import 'package:masjid_app/providers/home_nav_provider.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  static const List<Widget> _pages = [
    DashboardPage(),
    AlquranPage(),
    MuazinPage(),
    DkmPage(),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedIdx = ref.watch(homeBottomNavIndexProvider);
    final menuList = ref.watch(homeBottomMenuListProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAF9),
      extendBodyBehindAppBar: true,
      resizeToAvoidBottomInset: false,
      // Menggunakan IndexedStack agar status scroll & state tiap tab tetap terjaga
      body: IndexedStack(
        index: selectedIdx.clamp(0, _pages.length - 1),
        children: _pages,
      ),
      bottomNavigationBar: _buildModernBottomBar(
        context,
        ref,
        menuList: menuList,
        currentIndex: selectedIdx,
      ),
    );
  }

  Widget _buildModernBottomBar(
    BuildContext context,
    WidgetRef ref, {
    required List<BottomMenuModel> menuList,
    required int currentIndex,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(22)),
        border: Border(
          top: BorderSide(
            color: const Color(0xFFE5EDE9),
            width: 0.8,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF048C7C).withValues(alpha: 0.08),
            blurRadius: 20,
            offset: const Offset(0, -4),
          ),
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 6,
            offset: const Offset(0, -1),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 62,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(menuList.length, (index) {
              final item = menuList[index];
              final isSelected = index == currentIndex;

              return Expanded(
                child: Semantics(
                  selected: isSelected,
                  label: item.title,
                  button: true,
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () {
                        if (index != currentIndex) {
                          HapticFeedback.lightImpact();
                          ref.read(homeBottomNavIndexProvider.notifier).state = index;
                        }
                      },
                      splashColor: const Color(0xFF048C7C).withValues(alpha: 0.1),
                      highlightColor: Colors.transparent,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Icon tetap stabil tanpa efek geser/flip
                          SizedBox(
                            height: 24,
                            width: 24,
                            child: Image.asset(
                              isSelected ? item.activeIcon : item.icon,
                              fit: BoxFit.contain,
                            ),
                          ),
                          const SizedBox(height: 4),

                          // Text Label
                          Text(
                            item.title ?? '',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                              color: isSelected
                                  ? const Color(0xFF048C7C)
                                  : const Color(0xFF7A8E88),
                              letterSpacing: 0.1,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}
