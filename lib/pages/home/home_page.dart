import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:masjid_app/models/menu_bottom_data.dart';
import 'package:masjid_app/pages/dashboard/dashboard_page.dart';
import 'package:masjid_app/pages/dkm/dkm_page.dart';
import 'package:masjid_app/pages/muazin/muazin_page.dart';
import 'package:masjid_app/pages/quran/new_quran/alquran_page.dart';
import 'package:masjid_app/providers/home_nav_provider.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  Widget _getCurrentWidget(BottomBarEnum type) {
    switch (type) {
      case BottomBarEnum.beranda:
        return DashboardPage();
      case BottomBarEnum.alquran:
        return AlquranPage();
      case BottomBarEnum.muazin:
        return MuazinPage();
      case BottomBarEnum.dkm:
        return DkmPage();
      default:
        return DashboardPage();
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final navType = ref.watch(homeBottomNavTypeProvider);
    final selectedIdx = ref.watch(homeBottomNavIndexProvider);
    final menuList = ref.watch(homeBottomMenuListProvider);
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      extendBodyBehindAppBar: true,
      resizeToAvoidBottomInset: false,
      body: _getCurrentWidget(navType),
      bottomNavigationBar: Container(
        color: Colors.white,
        child: BottomNavigationBar(
          backgroundColor: Colors.white,
          showSelectedLabels: false,
          showUnselectedLabels: false,
          elevation: 10,
          currentIndex: selectedIdx,
          type: BottomNavigationBarType.fixed,
          items: List.generate(menuList.length, (index) {
            final item = menuList[index];
            return BottomNavigationBarItem(
              icon: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Image.asset(
                    item.icon,
                    height: screenWidth * 0.069,
                    width: screenWidth * 0.069,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 0),
                    child: Text(
                      item.title ?? '',
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.start,
                      style: const TextStyle(
                        color: Colors.black54,
                        fontSize: 10,
                      ),
                    ),
                  ),
                ],
              ),
              activeIcon: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Image.asset(
                    item.activeIcon,
                    height: screenWidth * 0.069,
                    width: screenWidth * 0.069,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 0),
                    child: Text(
                      item.title ?? '',
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 10,
                      ),
                    ),
                  ),
                ],
              ),
              label: '',
            );
          }),
          onTap: (index) {
            ref.read(homeBottomNavIndexProvider.notifier).state = index;
          },
        ),
      ),
    );
  }
}
