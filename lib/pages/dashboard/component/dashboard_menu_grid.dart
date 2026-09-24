import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'package:masjid_app/core/router/app_router.dart';
import 'package:masjid_app/providers/home_nav_provider.dart';
import 'package:url_launcher/url_launcher.dart';

class DashboardMenuGrid extends ConsumerWidget {
  const DashboardMenuGrid({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final menus = [
      {
        'label': 'Al Quran',
        'icon': 'assets/icons/newQuran.svg',
        'isPng': false,
        'onTap': () {
          ref.read(homeBottomNavIndexProvider.notifier).state = 1;
        },
      },
      {
        'label': 'Kiblat',
        'icon': 'assets/icons/kiblat.svg',
        'isPng': false,
        'onTap': () => context.push(AppRoutes.kiblat),
      },
      {
        'label': "Do'a",
        'icon': 'assets/icons/doa.svg',
        'isPng': false,
        'onTap': () => context.push(AppRoutes.doa),
      },
      {
        'label': 'Hadits',
        'icon': 'assets/icons/hadits.svg',
        'isPng': false,
        'onTap': () => context.push(AppRoutes.hadits),
      },
      {
        'label': 'Dzikir',
        'icon': 'assets/icons/dzikir_pagi_petang.svg',
        'isPng': false,
        'onTap': () => context.push(AppRoutes.dzikir),
      },
      {
        'label': 'Sedekah',
        'icon': 'assets/icons/sedekah.svg',
        'isPng': false,
        'onTap': () => context.push(AppRoutes.sedekah),
      },
      {
        'label': 'Ruangan',
        'icon': 'assets/icons/ruangan.svg',
        'isPng': false,
        'onTap': () => context.push(AppRoutes.ruangan),
      },
      {
        'label': 'Muazin',
        'icon': 'assets/icons/sahabat_muadzin.png',
        'isPng': true,
        'onTap': () {
          ref.read(homeBottomNavIndexProvider.notifier).state = 2;
        },
      },
      {
        'label': 'Marbot',
        'icon': 'assets/icons/dkm.png',
        'isPng': true,
        'onTap': () {
          ref.read(homeBottomNavIndexProvider.notifier).state = 3;
        },
      },
      {
        'label': 'Instagram',
        'icon': 'assets/icons/insta2.svg',
        'isPng': false,
        'onTap': () async {
          final url = Uri.parse('https://www.instagram.com/marbot.aplikasi/');
          if (!await launchUrl(url)) {
            Fluttertoast.showToast(msg: 'Tidak dapat membuka Instagram');
          }
        },
      },
    ];

    return Container(
      margin: const EdgeInsets.only(top: 14),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: const Color(0xFFE2EBE8),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF048C7C).withValues(alpha: 0.05),
            blurRadius: 14,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: menus.length,
        padding: EdgeInsets.zero,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 5,
          childAspectRatio: 0.76,
          crossAxisSpacing: 8,
          mainAxisSpacing: 10,
        ),
        itemBuilder: (context, index) {
          final item = menus[index];
          final isPng = item['isPng'] == true;

          return Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: item['onTap'] as void Function()?,
              borderRadius: BorderRadius.circular(16),
              splashColor: const Color(0xFF048C7C).withValues(alpha: 0.12),
              highlightColor: const Color(0xFF048C7C).withValues(alpha: 0.06),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Icon Squircle Container
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: const Color(0xFFEAF5F2),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: const Color(0xFFD4EAE5),
                        width: 0.8,
                      ),
                    ),
                    padding: const EdgeInsets.all(10),
                    child: isPng
                        ? Image.asset(
                            item['icon'] as String,
                            fit: BoxFit.contain,
                          )
                        : SvgPicture.asset(
                            item['icon'] as String,
                            fit: BoxFit.contain,
                          ),
                  ),

                  const SizedBox(height: 6),

                  // Menu Label
                  Text(
                    '${item["label"]}',
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF2C3E50),
                      letterSpacing: 0.1,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
