import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:masjid_app/components/button/elevatedbutton.dart';
import 'package:masjid_app/components/layout/app_bar_ws.dart';
import 'package:masjid_app/components/partial/list_ui.dart';
import 'package:masjid_app/core/router/app_router.dart';
import 'package:masjid_app/providers/auth_provider.dart';
import 'package:masjid_app/providers/home_nav_provider.dart';

class AkunPage extends ConsumerWidget {
  const AkunPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authNotifierProvider).valueOrNull;
    final userName = user?.name ?? 'Pengguna Tamu';
    final userEmail = user?.email ?? 'guest@annimah.id';
    final userPhoto = user?.photo ?? '';
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBarWSWidget.getAppbarWidget(
        title: 'Profile',
        context: context,
        elevation: 0,
      ),
      body: SafeArea(
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 21),
            child: SingleChildScrollView(
              physics: const ClampingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    margin: const EdgeInsets.only(top: 20),
                    child: Column(
                      children: [
                        Align(
                          alignment: Alignment.topCenter,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(90),
                            child: userPhoto.isNotEmpty
                                ? Image.network(
                                    userPhoto,
                                    height: 110,
                                    width: 110,
                                    fit: BoxFit.cover,
                                    errorBuilder: (_, __, ___) => Image.asset(
                                      'assets/icons/app_icon.png',
                                      height: 110,
                                      width: 110,
                                      fit: BoxFit.cover,
                                    ),
                                  )
                                : Image.asset(
                                    'assets/icons/app_icon.png',
                                    height: 110,
                                    width: 110,
                                    fit: BoxFit.cover,
                                  ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        Text(
                          userName,
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                        Text(
                          userEmail,
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                fontWeight: FontWeight.normal,
                              ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 30),
                  ListItemUiWidget(
                    id: 1,
                    title: 'Tentang Kami',
                    titleStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                    showIcon: IconPosition.left,
                    iconLeft: Icon(
                      Icons.info_rounded,
                      color: Theme.of(context).primaryColor,
                      size: 30,
                    ),
                    onTap: () {
                      ref.read(homeBottomNavIndexProvider.notifier).state = 3;
                      context.go(AppRoutes.home);
                    },
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height / 6,
                  ),
                  ButtonElevated(
                    title: 'Keluar',
                    iconLeft: const Icon(Icons.logout_rounded),
                    showIcon: 'left',
                    nearLeft: true,
                    width: screenWidth,
                    bgcolor: Theme.of(context).primaryColor,
                    height: 45,
                    color: Colors.white,
                    radius: 7,
                    onPressed: () async {
                      await ref.read(authNotifierProvider.notifier).logout();
                      if (context.mounted) {
                        context.go(AppRoutes.auth);
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
