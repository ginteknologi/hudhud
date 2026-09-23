import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'package:masjid_app/components/button/iconbutton.dart';
import 'package:masjid_app/components/layout/custom_card_item.dart';
import 'package:masjid_app/core/router/app_router.dart';
import 'package:masjid_app/models/artikel_model.dart';
import 'package:masjid_app/models/doa_models.dart';
import 'package:masjid_app/models/kajian_model.dart';
import 'package:masjid_app/pages/dashboard/component/count_down.dart';
import 'package:masjid_app/pages/dashboard/component/prayer_times_card.dart';
import 'package:masjid_app/pages/dashboard/component/ramadhan_menu.dart';
import 'package:masjid_app/pages/dashboard/component/sedang_live.dart';
import 'package:masjid_app/providers/artikel_provider.dart';
import 'package:masjid_app/providers/auth_provider.dart';
import 'package:masjid_app/providers/dashboard_data_providers.dart';
import 'package:masjid_app/providers/doa_providers.dart';
import 'package:masjid_app/providers/home_nav_provider.dart';
import 'package:masjid_app/providers/jadwal_shalat_provider.dart';
import 'package:masjid_app/providers/kajian_provider.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:url_launcher/url_launcher.dart';

class DashboardPage extends ConsumerWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarIconBrightness: Brightness.dark,
      statusBarColor: Colors.transparent,
    ));

    final user = ref.watch(authNotifierProvider).valueOrNull;
    final sedangLiveAsync = ref.watch(sedangLiveListProvider);
    final kajianLiveAsync = ref.watch(kajianLiveListProvider);
    final kajianSliderAsync = ref.watch(kajianSliderProvider('tafsir'));
    final artikelAsync = ref.watch(artikelTerbaruProvider);
    final doaAsync = ref.watch(doaListProvider(const DoaListParams(categoryId: '1')));

    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      extendBodyBehindAppBar: true,
      resizeToAvoidBottomInset: false,
      body: Container(
        padding: EdgeInsets.only(top: screenHeight / 20),
        height: screenHeight,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF189A8C), Colors.white, Colors.white],
          ),
        ),
        child: RefreshIndicator(
          onRefresh: () async {
            ref.invalidate(jadwalShalatProvider);
            ref.invalidate(sedangLiveListProvider);
            ref.invalidate(kajianLiveListProvider);
            ref.invalidate(kajianSliderProvider('tafsir'));
            ref.invalidate(artikelTerbaruProvider);
          },
          child: SingleChildScrollView(
            physics: const ClampingScrollPhysics(),
            child: Column(
              children: [
                // Header Profil & Lokasi
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: screenWidth / 30),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            user?.name ?? 'Pengguna Tamu',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 4),
                          const Row(
                            children: [
                              Icon(Icons.location_pin, size: 12, color: Color(0xFFFFECB7)),
                              SizedBox(width: 4),
                              Text(
                                'Masjid An-Ni’mah Cibubur',
                                style: TextStyle(color: Color(0xFFFFECB7), fontSize: 12),
                              ),
                            ],
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          ButtonIcon(
                            onTap: () {},
                            bgcolor: Colors.transparent,
                            icon: const Icon(
                              Icons.notifications_none_rounded,
                              size: 30,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(width: 8),
                          InkWell(
                            onTap: () => context.push(AppRoutes.profile),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: (user?.photo.isNotEmpty ?? false)
                                  ? Image.network(
                                      user!.photo,
                                      height: 35,
                                      width: 35,
                                      fit: BoxFit.cover,
                                      errorBuilder: (_, __, ___) => Image.asset(
                                        'assets/icons/app_icon.png',
                                        height: 35,
                                        width: 35,
                                      ),
                                    )
                                  : Image.asset(
                                      'assets/icons/app_icon.png',
                                      height: 35,
                                      width: 35,
                                    ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // Kartu Waktu Shalat Realtime Riverpod
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: screenWidth / 30),
                  child: const PrayerTimesCard(),
                ),

                // Grid Menu Dashboard
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: screenWidth / 30),
                  child: _buildGridMenu(context, ref),
                ),

                SizedBox(height: screenWidth / 40),

                // Sedang Live
                SedangLiveWidget(listSedangLive: sedangLiveAsync.valueOrNull ?? []),

                SizedBox(height: screenWidth / 30),

                // CountDown Ramadhan
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: screenWidth / 30),
                  child: const CountDownWidget(),
                ),

                SizedBox(height: screenWidth / 30),

                // Ramadhan Menu
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: screenWidth / 30),
                  child: const RamadhanMenuWidget(),
                ),

                SizedBox(height: screenWidth / 30),

                // Doa Sahabat Masjid
                Container(
                  margin: const EdgeInsets.only(top: 10),
                  padding: EdgeInsets.symmetric(horizontal: screenWidth / 30),
                  child: _buildSeparator('Doa Pilihan', 'Lihat Semua', context, () {
                    context.push(AppRoutes.doa);
                  }),
                ),
                Padding(
                  padding: EdgeInsets.only(left: screenWidth / 30),
                  child: Skeletonizer(
                    enabled: doaAsync.isLoading,
                    child: _buildDoaSlider(doaAsync.valueOrNull ?? [], context),
                  ),
                ),

                // Riwayat Kajian Live
                Container(
                  margin: const EdgeInsets.only(top: 10),
                  padding: EdgeInsets.symmetric(horizontal: screenWidth / 30),
                  child: _buildSeparator('Riwayat Kajian Live', 'Lihat Semua', context, () {}),
                ),
                Padding(
                  padding: EdgeInsets.only(left: screenWidth / 30),
                  child: Skeletonizer(
                    enabled: kajianLiveAsync.isLoading,
                    child: _buildKajianSlider(kajianLiveAsync.valueOrNull ?? []),
                  ),
                ),

                // Kajian Tafsir Quran
                Container(
                  padding: EdgeInsets.symmetric(horizontal: screenWidth / 30),
                  margin: const EdgeInsets.only(top: 10),
                  child: _buildSeparator('Kajian Tafsir Quran', 'Lihat Semua', context, () {}),
                ),
                Padding(
                  padding: EdgeInsets.only(left: screenWidth / 30),
                  child: Skeletonizer(
                    enabled: kajianSliderAsync.isLoading,
                    child: _buildKajianSlider(kajianSliderAsync.valueOrNull ?? []),
                  ),
                ),

                // Artikel Terbaru
                Container(
                  padding: EdgeInsets.symmetric(horizontal: screenWidth / 30),
                  child: _buildSeparator('Artikel Terbaru', '', context, () {}),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: screenWidth / 30),
                  child: Skeletonizer(
                    enabled: artikelAsync.isLoading,
                    child: _buildArtikelList(artikelAsync.valueOrNull ?? [], context),
                  ),
                ),

                SizedBox(height: screenHeight / 30),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildGridMenu(BuildContext context, WidgetRef ref) {
    final screenWidth = MediaQuery.of(context).size.width;
    final menus = [
      {
        'label': 'Al Quran',
        'icon': 'assets/icons/newQuran.svg',
        'onTap': () {
          ref.read(homeBottomNavIndexProvider.notifier).state = 1;
        },
      },
      {
        'label': 'Kiblat',
        'icon': 'assets/icons/kiblat.svg',
        'onTap': () => context.push(AppRoutes.kiblat),
      },
      {
        'label': "Do'a",
        'icon': 'assets/icons/doa.svg',
        'onTap': () => context.push(AppRoutes.doa),
      },
      {
        'label': 'Hadits',
        'icon': 'assets/icons/hadits.svg',
        'onTap': () => context.push(AppRoutes.hadits),
      },
      {
        'label': 'Dzikir',
        'icon': 'assets/icons/dzikir_pagi_petang.svg',
        'onTap': () => context.push(AppRoutes.dzikir),
      },
      {
        'label': 'Sedekah',
        'icon': 'assets/icons/sedekah.svg',
        'onTap': () => context.push(AppRoutes.sedekah),
      },
      {
        'label': 'Ruangan',
        'icon': 'assets/icons/ruangan.svg',
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
        'onTap': () async {
          final url = Uri.parse('https://www.instagram.com/marbot.aplikasi/');
          if (!await launchUrl(url)) {
            Fluttertoast.showToast(msg: 'Tidak dapat membuka Instagram');
          }
        },
      },
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: menus.length,
      padding: const EdgeInsets.only(top: 15),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 5,
        childAspectRatio: 0.82,
      ),
      itemBuilder: (context, index) {
        final item = menus[index];
        final isPng = item['isPng'] == true;

        return Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: item['onTap'] as void Function()?,
            borderRadius: BorderRadius.circular(20),
            splashColor: Colors.green.withValues(alpha: 0.5),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                isPng
                    ? Image.asset(item['icon'] as String, height: screenWidth / 7.2, width: screenWidth / 7.2)
                    : SvgPicture.asset(item['icon'] as String, height: screenWidth / 7.2, width: screenWidth / 7.2),
                const SizedBox(height: 5),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: screenWidth / 50),
                    child: AutoSizeText(
                      '${item["label"]}',
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      presetFontSizes: [screenWidth / 38],
                      style: TextStyle(
                        fontSize: Theme.of(context).textTheme.labelMedium?.fontSize,
                        height: 1.1,
                        color: Colors.black87,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildSeparator(String title, String? sub, BuildContext context, VoidCallback onTap) {
    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.black87,
              fontSize: Theme.of(context).textTheme.titleMedium?.fontSize,
            ),
          ),
        ),
        if (sub != null && sub.isNotEmpty)
          InkWell(
            onTap: onTap,
            child: Padding(
              padding: const EdgeInsets.only(left: 8),
              child: Text(
                sub,
                style: TextStyle(
                  color: Colors.black54,
                  fontSize: Theme.of(context).textTheme.bodySmall?.fontSize,
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildDoaSlider(List<DoaItemModel> list, BuildContext context) {
    return SizedBox(
      height: 151,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: list.isEmpty ? 3 : list.length,
        itemBuilder: (context, index) {
          final item = list.isNotEmpty ? list[index] : null;
          return Container(
            margin: const EdgeInsets.only(right: 12),
            child: CustomCardItem(
              title: item?.judul ?? 'Doa',
              subtitle: item?.arti ?? '',
              height: 140,
              width: 200,
              chipText: 'Doa',
            ),
          );
        },
      ),
    );
  }

  Widget _buildKajianSlider(List<KajianModel> list) {
    return SizedBox(
      height: 151,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: list.isEmpty ? 3 : list.length,
        itemBuilder: (context, index) {
          final item = list.isNotEmpty ? list[index] : null;
          return Container(
            margin: const EdgeInsets.only(right: 12),
            child: CustomCardItem(
              title: item?.judul ?? 'Kajian',
              subtitle: item?.subjudul ?? '',
              imgPath: item?.image ?? '',
              network: (item?.image.isNotEmpty ?? false),
              link: item?.link,
              islink: (item?.link.isNotEmpty ?? false),
              height: 140,
              width: 200,
              chipText: 'Kajian',
            ),
          );
        },
      ),
    );
  }

  Widget _buildArtikelList(List<ArtikelModel> list, BuildContext context) {
    return Column(
      children: list.map((item) {
        return Card(
          elevation: 1,
          margin: const EdgeInsets.only(bottom: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          child: ListTile(
            contentPadding: const EdgeInsets.all(12),
            leading: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: item.thumbnail.isNotEmpty
                  ? Image.network(
                      item.thumbnail,
                      width: 60,
                      height: 60,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Image.asset(
                        'assets/icons/app_icon.png',
                        width: 60,
                        height: 60,
                      ),
                    )
                  : Image.asset('assets/icons/app_icon.png', width: 60, height: 60),
            ),
            title: Text(
              item.judul,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text(
              item.createdAt,
              style: const TextStyle(color: Color(0xFF048C7C)),
            ),
          ),
        );
      }).toList(),
    );
  }
}
