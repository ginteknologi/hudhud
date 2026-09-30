import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:masjid_app/components/hudhud_ui.dart';
import 'package:masjid_app/core/companion/hudhud_day_period.dart';
import 'package:masjid_app/core/router/app_router.dart';
import 'package:masjid_app/core/theme/hudhud_theme.dart';
import 'package:masjid_app/models/jadwal_shalat_model.dart';
import 'package:masjid_app/pages/artikel/component/artikel_card.dart';
import 'package:masjid_app/providers/artikel_provider.dart';
import 'package:masjid_app/providers/auth_provider.dart';
import 'package:masjid_app/providers/home_nav_provider.dart';
import 'package:masjid_app/providers/jadwal_shalat_provider.dart';
import 'package:masjid_app/providers/location_provider.dart';
import 'package:skeletonizer/skeletonizer.dart';

class DashboardPage extends ConsumerStatefulWidget {
  const DashboardPage({super.key});

  @override
  ConsumerState<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends ConsumerState<DashboardPage>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted && !ref.read(locationProvider).hasCoordinates) {
        _initializeLocation();
      }
    });
  }

  Future<void> _initializeLocation() async {
    final message = await ref.read(locationProvider.notifier).detect();
    if (!mounted || message == null) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
          content:
              Text('$message. Pilih lokasi untuk waktu salat yang akurat.')),
    );
    await _showLocationOptions();
  }

  Future<void> _showLocationOptions() async {
    final choice = await showModalBottomSheet<_LocationChoice>(
      context: context,
      isScrollControlled: true,
      builder: (context) => SafeArea(
        child: ListView(
          shrinkWrap: true,
          children: [
            ListTile(
              leading: const Icon(Icons.my_location),
              title: const Text('Gunakan lokasi perangkat'),
              onTap: () => Navigator.pop(context, _LocationChoice.device),
            ),
            for (final city in _indonesianCities)
              ListTile(
                leading: const Icon(Icons.location_city),
                title: Text(city.name),
                subtitle: Text(city.zoneLabel),
                onTap: () => Navigator.pop(context, city),
              ),
          ],
        ),
      ),
    );
    if (!mounted || choice == null) return;
    if (choice == _LocationChoice.device) {
      final message = await ref.read(locationProvider.notifier).detect();
      if (mounted && message != null) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(message)));
      }
      return;
    }
    await ref.read(locationProvider.notifier).setManualLocation(
          name: choice.name,
          latitude: choice.latitude,
          longitude: choice.longitude,
          timeZoneId: choice.timeZoneId,
        );
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state != AppLifecycleState.resumed) return;
    final location = ref.read(locationProvider);
    if (!location.isDeviceLocation || location.loading) return;
    ref.read(locationProvider.notifier).detect();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final schedule = ref.watch(jadwalShalatProvider);
    final countdown = ref.watch(prayerCountdownProvider);
    final location = ref.watch(locationProvider);
    final articles = ref.watch(artikelTerbaruProvider);
    final user = ref.watch(authNotifierProvider).valueOrNull;
    final t = context.hudhud;

    return Scaffold(
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            ref.invalidate(jadwalShalatProvider);
            ref.invalidate(artikelTerbaruProvider);
            await Future.wait([
              ref.read(jadwalShalatProvider.future),
              ref.read(artikelTerbaruProvider.future),
            ]);
          },
          child: CustomScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            slivers: [
              SliverPadding(
                padding:
                    EdgeInsets.fromLTRB(t.spaceLg, t.spaceMd, t.spaceLg, 0),
                sliver: SliverToBoxAdapter(
                  child: _Header(
                    name: user?.name ?? 'Tamu',
                    location: location.name,
                    locationLoading: location.loading,
                    onLocation: location.loading ? null : _showLocationOptions,
                    onNotification: () => context.push(AppRoutes.notifikasi),
                  ),
                ),
              ),
              SliverPadding(
                padding: EdgeInsets.all(t.spaceLg),
                sliver: SliverList.list(
                  children: [
                    schedule.when(
                      loading: () => const _FocusSkeleton(),
                      error: (_, __) => HudhudStateView(
                        icon: LucideIcons.wifiOff,
                        title: 'Jadwal belum dapat dimuat',
                        message: 'Periksa koneksi lalu coba kembali.',
                        actionLabel: 'Coba lagi',
                        onAction: () => ref.invalidate(jadwalShalatProvider),
                      ),
                      data: (jadwal) => countdown.when(
                        loading: () => const _FocusSkeleton(),
                        error: (_, __) => _CompanionFocus(schedule: jadwal),
                        data: (info) =>
                            _CompanionFocus(schedule: jadwal, info: info),
                      ),
                    ),
                    SizedBox(height: t.spaceXl),
                    const HudhudSectionHeader(title: 'Waktu salat hari ini'),
                    SizedBox(height: t.spaceSm),
                    schedule.when(
                      loading: () => const _PrayerStripSkeleton(),
                      error: (_, __) => const SizedBox.shrink(),
                      data: (jadwal) => _PrayerStrip(
                        items: jadwal.toItems(),
                        nextPrayerId: countdown.valueOrNull?.nextShalat.id,
                      ),
                    ),
                    SizedBox(height: t.spaceXl),
                    _ContinueTilawah(
                      onTap: () => ref
                          .read(homeBottomNavIndexProvider.notifier)
                          .state = 1,
                    ),
                    SizedBox(height: t.spaceXl),
                    const HudhudSectionHeader(title: 'Temani ibadahmu'),
                    SizedBox(height: t.spaceSm),
                    const _Services(),
                    SizedBox(height: t.spaceXl),
                    HudhudSectionHeader(
                      title: 'Artikel terbaru',
                      actionLabel: 'Lihat semua',
                      onAction: () => context.push(AppRoutes.artikel),
                    ),
                    SizedBox(height: t.spaceSm),
                    articles.when(
                      loading: () => const _ArticleSkeleton(),
                      error: (_, __) => HudhudStateView(
                        icon: LucideIcons.wifiOff,
                        title: 'Artikel belum dapat dimuat',
                        message: 'Buka halaman artikel untuk mencoba kembali.',
                        actionLabel: 'Lihat semua',
                        onAction: () => context.push(AppRoutes.artikel),
                      ),
                      data: (items) => items.isEmpty
                          ? HudhudStateView(
                              icon: LucideIcons.newspaper,
                              title: 'Belum ada artikel',
                              message: 'Artikel terbaru akan tampil di sini.',
                              actionLabel: 'Lihat semua',
                              onAction: () => context.push(AppRoutes.artikel),
                            )
                          : Column(
                              children: items.take(5).map((item) {
                                final title = item.judul;
                                final image = item.thumbnail;
                                final date = formatArtikelDate(item.createdAt);
                                return ArtikelCard(
                                  judul: title,
                                  image: image,
                                  dateLabel: date,
                                  onTap: () => context.push(
                                    AppRoutes.artikelDetail
                                        .replaceFirst(':id', '${item.id}'),
                                  ),
                                );
                              }).toList(),
                            ),
                    ),
                    SizedBox(height: t.spaceXl),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _LocationChoice {
  const _LocationChoice({
    required this.name,
    required this.latitude,
    required this.longitude,
    required this.timeZoneId,
    required this.zoneLabel,
  });

  static const device = _LocationChoice(
    name: '',
    latitude: 0,
    longitude: 0,
    timeZoneId: '',
    zoneLabel: '',
  );

  final String name;
  final double latitude;
  final double longitude;
  final String timeZoneId;
  final String zoneLabel;
}

const _indonesianCities = <_LocationChoice>[
  _LocationChoice(
      name: 'Jakarta',
      latitude: -6.2088,
      longitude: 106.8456,
      timeZoneId: 'Asia/Jakarta',
      zoneLabel: 'WIB'),
  _LocationChoice(
      name: 'Makassar',
      latitude: -5.1477,
      longitude: 119.4327,
      timeZoneId: 'Asia/Makassar',
      zoneLabel: 'WITA'),
  _LocationChoice(
      name: 'Kupang',
      latitude: -10.1772,
      longitude: 123.6070,
      timeZoneId: 'Asia/Makassar',
      zoneLabel: 'WITA'),
  _LocationChoice(
      name: 'Jayapura',
      latitude: -2.5916,
      longitude: 140.6690,
      timeZoneId: 'Asia/Jayapura',
      zoneLabel: 'WIT'),
];

class _Header extends StatelessWidget {
  const _Header({
    required this.name,
    required this.location,
    required this.locationLoading,
    required this.onLocation,
    required this.onNotification,
  });

  final String name;
  final String location;
  final bool locationLoading;
  final VoidCallback? onLocation;
  final VoidCallback onNotification;

  @override
  Widget build(BuildContext context) {
    final t = context.hudhud;
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Assalamu'alaikum, $name",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 3),
              InkWell(
                onTap: onLocation,
                borderRadius: BorderRadius.circular(t.radiusSm),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (locationLoading)
                        const SizedBox(
                            width: 15,
                            height: 15,
                            child: CircularProgressIndicator(strokeWidth: 2))
                      else
                        Icon(LucideIcons.mapPin, size: 16, color: t.terracotta),
                      const SizedBox(width: 6),
                      Flexible(
                          child: Text(location,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context).textTheme.bodySmall)),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        HudhudIconButton(
            icon: LucideIcons.bell,
            tooltip: 'Notifikasi',
            onPressed: onNotification),
      ],
    );
  }
}

class _CompanionFocus extends StatelessWidget {
  const _CompanionFocus({required this.schedule, this.info});

  final JadwalShalatModel schedule;
  final NextShalatInfo? info;

  @override
  Widget build(BuildContext context) {
    final t = context.hudhud;
    final companion = resolveHudhudCompanion(DateTime.now(), schedule);
    final next = info?.nextShalat;
    return Semantics(
      container: true,
      label:
          '${companion.greeting}. ${companion.message}. Salat berikutnya ${next?.label ?? 'belum tersedia'} ${next?.waktu ?? ''}',
      child: Container(
        padding: EdgeInsets.all(t.spaceLg),
        decoration: BoxDecoration(
            color: t.surface, borderRadius: BorderRadius.circular(t.radiusMd)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      HudhudStatusChip(
                          label: companion.greeting,
                          icon: LucideIcons.sunMedium),
                      SizedBox(height: t.spaceMd),
                      Text(
                          next == null
                              ? 'Jaga langkah kecilmu hari ini'
                              : '${next.label} • ${next.waktu}',
                          style: Theme.of(context).textTheme.headlineSmall),
                      SizedBox(height: t.spaceXs),
                      Text(
                        info == null
                            ? companion.message
                            : '${info!.formattedRemaining} lagi. ${companion.message}',
                        style: Theme.of(context)
                            .textTheme
                            .bodyMedium
                            ?.copyWith(color: t.muted),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: t.spaceSm),
                Image.asset(companion.assetPath,
                    width: 112,
                    height: 126,
                    fit: BoxFit.contain,
                    semanticLabel: 'Ilustrasi pendamping Hudhud'),
              ],
            ),
            SizedBox(height: t.spaceMd),
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: () => context.push(AppRoutes.jadwalImsakiah),
                icon: const Icon(LucideIcons.calendarClock, size: 19),
                label: const Text('Lihat jadwal lengkap'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PrayerStrip extends StatelessWidget {
  const _PrayerStrip({required this.items, this.nextPrayerId});
  final List<ShalatTimeItem> items;
  final int? nextPrayerId;

  @override
  Widget build(BuildContext context) {
    final t = context.hudhud;
    return SizedBox(
      height: 76,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: items.length,
        separatorBuilder: (_, __) => SizedBox(width: t.spaceSm),
        itemBuilder: (_, i) {
          final item = items[i];
          final isNext = item.id == nextPrayerId;
          return Semantics(
            container: true,
            label:
                '${item.label}, ${item.waktu}${isNext ? ', salat berikutnya' : ''}',
            child: Container(
              width: 82,
              padding: EdgeInsets.all(t.spaceSm),
              decoration: BoxDecoration(
                color: isNext ? t.terracottaDark : t.surface,
                borderRadius: BorderRadius.circular(t.radiusMd),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(item.label,
                      style: Theme.of(context).textTheme.labelMedium?.copyWith(
                          color: isNext ? t.surface : t.charcoal,
                          fontWeight: isNext ? FontWeight.w700 : null)),
                  const SizedBox(height: 4),
                  Text(item.waktu,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          color: isNext ? t.surface : t.terracottaDark)),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _ContinueTilawah extends StatelessWidget {
  const _ContinueTilawah({required this.onTap});
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => Container(
        decoration: BoxDecoration(
            color: context.hudhud.terracotta.withValues(alpha: .09),
            borderRadius: BorderRadius.circular(context.hudhud.radiusMd)),
        child: HudhudActionRow(
          icon: LucideIcons.bookOpen,
          title: 'Lanjutkan tilawah',
          subtitle: "Kembali ke bacaan Al-Qur'an terakhir",
          onTap: onTap,
        ),
      );
}

class _Services extends StatelessWidget {
  const _Services();

  @override
  Widget build(BuildContext context) {
    final t = context.hudhud;
    final services = [
      (LucideIcons.compass, 'Kiblat', AppRoutes.kiblat),
      (LucideIcons.handHeart, 'Doa', AppRoutes.doa),
      (LucideIcons.sparkles, 'Dzikir', AppRoutes.dzikir),
      (LucideIcons.scrollText, 'Hadits', AppRoutes.hadits),
      (LucideIcons.calendarDays, 'Imsakiah', AppRoutes.jadwalImsakiah),
      (LucideIcons.mapPinned, 'Masjid', AppRoutes.cariMasjid),
    ];
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisExtent: MediaQuery.textScalerOf(context).scale(104),
        crossAxisSpacing: t.spaceSm,
        mainAxisSpacing: t.spaceSm,
      ),
      itemCount: services.length,
      itemBuilder: (_, index) {
        final item = services[index];
        return HudhudServiceItem(
            icon: item.$1, label: item.$2, onTap: () => context.push(item.$3));
      },
    );
  }
}

class _ArticleSkeleton extends StatelessWidget {
  const _ArticleSkeleton();

  @override
  Widget build(BuildContext context) => Skeletonizer(
        enabled: true,
        child: Column(
          children: List.generate(
            3,
            (_) => const ArtikelCard(
              judul: 'Artikel terbaru sedang dimuat',
              image: '',
              dateLabel: 'Memuat tanggal',
            ),
          ),
        ),
      );
}

class _FocusSkeleton extends StatelessWidget {
  const _FocusSkeleton();
  @override
  Widget build(BuildContext context) => Skeletonizer(
        enabled: true,
        child: Container(
          height: 236,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
              color: context.hudhud.surface,
              borderRadius: BorderRadius.circular(context.hudhud.radiusMd)),
          child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Selamat pagi'),
                SizedBox(height: 20),
                Text('Dzuhur • 12:00'),
                SizedBox(height: 8),
                Text('Satu jam lagi menuju waktu salat berikutnya.'),
                Spacer(),
                SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ColoredBox(color: Colors.white)),
              ]),
        ),
      );
}

class _PrayerStripSkeleton extends StatelessWidget {
  const _PrayerStripSkeleton();
  @override
  Widget build(BuildContext context) => Skeletonizer(
        child: Row(
            children: List.generate(
                4,
                (_) => Expanded(
                    child: Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: Container(height: 76, color: Colors.white))))),
      );
}
