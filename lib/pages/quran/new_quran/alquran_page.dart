import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:masjid_app/components/hudhud_ui.dart';
import 'package:masjid_app/core/router/app_router.dart';
import 'package:masjid_app/core/storage/bookmark_storage.dart';
import 'package:masjid_app/core/storage/quran_reading_progress_storage.dart';
import 'package:masjid_app/core/theme/hudhud_theme.dart';
import 'package:masjid_app/models/bookmark_data.dart';
import 'package:masjid_app/models/quran_models.dart';
import 'package:masjid_app/pages/quran/new_quran/quran_verse_search_sheet.dart';
import 'package:masjid_app/providers/quran_provider.dart';
import 'package:skeletonizer/skeletonizer.dart';

class AlquranPage extends ConsumerStatefulWidget {
  const AlquranPage({super.key});

  @override
  ConsumerState<AlquranPage> createState() => _AlquranPageState();
}

class _AlquranPageState extends ConsumerState<AlquranPage>
    with SingleTickerProviderStateMixin {
  final _search = TextEditingController();
  late final TabController _tabs;
  final _ayatStore = BookmarkStorage('ayat');
  final _indonesiaStore = BookmarkStorage('indonesia_saved');
  final _madinahStore = BookmarkStorage('madinah_saved');
  final _tajwidStore = BookmarkStorage('tajwid_saved');
  late BookmarkData _ayat;
  late BookmarkData _indonesia;
  late BookmarkData _madinah;
  late BookmarkData _tajwid;
  QuranReadingProgress? _progress;
  String _query = '';

  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    _tabs = TabController(length: 4, vsync: this);
    _tabs.addListener(_onTabChanged);
    _loadBookmarks();
  }

  void _onTabChanged() {
    if (_tabs.index >= 2) FocusManager.instance.primaryFocus?.unfocus();
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    _tabs.removeListener(_onTabChanged);
    _tabs.dispose();
    _search.dispose();
    super.dispose();
  }

  void _loadBookmarks() {
    _ayat = _ayatStore.getBookmark();
    _indonesia = _indonesiaStore.getBookmark();
    _madinah = _madinahStore.getBookmark();
    _tajwid = _tajwidStore.getBookmark();
    _progress = QuranReadingProgressStorage.getLatest();
  }

  Future<void> _open(String route, {bool bookmark = false}) async {
    await context.push(bookmark ? '$route?bookmarks=true' : route);
    if (mounted) setState(_loadBookmarks);
  }

  Future<void> _searchVerses() async {
    final t = context.hudhud;
    final progress = _progress;
    final selected = await showModalBottomSheet<QuranVerseSelection>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: t.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      clipBehavior: Clip.antiAlias,
      builder: (_) => QuranVerseSearchSheet(
        initialSurahId: progress?.mode == QuranReadingMode.ayat
            ? progress!.surahNumber
            : null,
      ),
    );
    if (selected != null && mounted) {
      await _open(
        '${AppRoutes.quranPerAyat}?surah=${selected.surah}&ayat=${selected.ayat}',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = context.hudhud;
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) => [
          SliverAppBar(
            pinned: true,
            title: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Al-Qur'an"),
                  Text('Baca tenang, lanjutkan mudah',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style:
                          TextStyle(fontSize: 12, fontWeight: FontWeight.w400)),
                ]),
            actions: [
              HudhudIconButton(
                  icon: LucideIcons.settings2,
                  tooltip: 'Pengaturan Al-Qur\'an',
                  onPressed: () => _open(AppRoutes.quranPengaturan)),
            ],
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.fromLTRB(
                  t.spaceLg, t.spaceSm, t.spaceLg, t.spaceMd),
              child: Column(
                children: [
                  _ContinuePanel(
                    progress: _progress,
                    onTap: _continueReading,
                  ),
                  if (_tabs.index < 2) ...[
                    SizedBox(height: t.spaceMd),
                    TextField(
                      controller: _search,
                      onChanged: (value) =>
                          setState(() => _query = value.trim()),
                      decoration: InputDecoration(
                        hintText: _tabs.index == 0
                            ? 'Cari surah, arti, atau nomor'
                            : 'Cari juz atau nama surah',
                        prefixIcon: const Icon(LucideIcons.search),
                        suffixIcon: _query.isEmpty
                            ? null
                            : IconButton(
                                tooltip: 'Hapus pencarian',
                                icon: const Icon(LucideIcons.x),
                                onPressed: () {
                                  _search.clear();
                                  setState(() => _query = '');
                                }),
                      ),
                    ),
                  ],
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton.icon(
                      onPressed: _searchVerses,
                      icon: const Icon(LucideIcons.scanSearch, size: 18),
                      label: const Text('Cari ayat dalam surah'),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverPersistentHeader(
            pinned: true,
            delegate: _QuranTabsHeader(
              color: t.sand,
              child: TabBar(
                controller: _tabs,
                isScrollable: true,
                tabAlignment: TabAlignment.start,
                padding: EdgeInsets.symmetric(horizontal: t.spaceLg),
                labelPadding: EdgeInsets.symmetric(horizontal: t.spaceMd),
                indicatorSize: TabBarIndicatorSize.label,
                indicatorColor: t.terracottaDark,
                labelColor: t.terracottaDark,
                unselectedLabelColor: t.muted,
                dividerHeight: 0,
                tabs: const [
                  Tab(text: 'Surah'),
                  Tab(text: 'Juz'),
                  Tab(text: 'Mushaf'),
                  Tab(text: 'Tanda baca')
                ],
              ),
            ),
          ),
        ],
        body: TabBarView(
          controller: _tabs,
          children: [_surahTab(), _juzTab(), _mushafTab(), _bookmarkTab()],
        ),
      ),
    );
  }

  Future<void> _continueReading() {
    final progress = _progress;
    if (progress == null) return _open(AppRoutes.quranPerAyat);
    switch (progress.mode) {
      case QuranReadingMode.ayat:
        return _open(
            '${AppRoutes.quranPerAyat}?surah=${progress.surahNumber}&ayat=${progress.ayatNumber}');
      case QuranReadingMode.indonesia:
        return _open('${AppRoutes.quranPage}?page=${progress.pageNumber}');
      case QuranReadingMode.madinah:
        return _open(
            '${AppRoutes.quranPageMadinah}?page=${progress.pageNumber}');
      case QuranReadingMode.tajwid:
        return _open(
            '${AppRoutes.quranPageTajwid}?page=${progress.pageNumber}');
    }
  }

  Widget _surahTab() {
    final async = ref.watch(surahListProvider(''));
    return async.when(
      loading: () => Skeletonizer(
          child: ListView(
              children: List.generate(
                  7,
                  (_) => const ListTile(
                      leading: CircleAvatar(),
                      title: Text('Al-Fatihah'),
                      subtitle: Text('Pembukaan • 7 ayat'))))),
      error: (_, __) => HudhudStateView(
          icon: LucideIcons.wifiOff,
          title: 'Daftar surah belum dimuat',
          message: 'Periksa koneksi dan coba kembali.',
          actionLabel: 'Coba lagi',
          onAction: () => ref.invalidate(surahListProvider(''))),
      data: (items) {
        final q = _query.toLowerCase();
        final filtered = items
            .where((e) =>
                q.isEmpty ||
                e.nama.toLowerCase().contains(q) ||
                e.arti.toLowerCase().contains(q) ||
                '${e.id}' == q)
            .toList();
        if (filtered.isEmpty) {
          return const HudhudStateView(
              icon: LucideIcons.searchX,
              title: 'Surah tidak ditemukan',
              message: 'Coba nama, arti, atau nomor surah yang lain.');
        }
        return ListView.separated(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          itemCount: filtered.length,
          separatorBuilder: (_, __) => const Divider(indent: 56),
          itemBuilder: (_, index) {
            final s = filtered[index];
            return _QuranRow(
              number: '${s.id}',
              title: s.nama,
              subtitle: '${s.arti} • ${s.jumlahAyat} ayat',
              arabic: s.asma,
              onTap: () => _open('${AppRoutes.quranPerAyat}?surah=${s.id}'),
            );
          },
        );
      },
    );
  }

  Widget _juzTab() {
    final q = _query.toLowerCase();
    final items = kQuranJuzList
        .where((e) =>
            q.isEmpty ||
            e.name.toLowerCase().contains(q) ||
            e.startSurahName.toLowerCase().contains(q) ||
            '${e.juzNumber}' == q)
        .toList();
    if (items.isEmpty) {
      return const HudhudStateView(
          icon: LucideIcons.searchX,
          title: 'Juz tidak ditemukan',
          message: 'Coba nomor juz atau nama surah yang lain.');
    }
    return ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      itemCount: items.length,
      separatorBuilder: (_, __) => const Divider(indent: 56),
      itemBuilder: (_, index) {
        final j = items[index];
        return _QuranRow(
            number: '${j.juzNumber}',
            title: '${j.name} • ${j.startSurahName}',
            subtitle: 'Ayat ${j.startAyat} • Halaman ${j.startPage}',
            arabic: j.arabicName,
            onTap: () => _open('${AppRoutes.quranPage}?page=${j.startPage}'));
      },
    );
  }

  Widget _mushafTab() {
    final items = [
      (
        'Standar Indonesia',
        'Mushaf Kemenag, 15 baris',
        AppRoutes.quranPage,
      ),
      ('Mushaf Madinah', 'Rasm Utsmani', AppRoutes.quranPageMadinah),
      (
        'Mushaf Tajwid',
        'Panduan warna kaidah tajwid',
        AppRoutes.quranPageTajwid,
      ),
    ];
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: items.length,
      separatorBuilder: (_, __) => const Divider(),
      itemBuilder: (_, index) {
        final item = items[index];
        return HudhudActionRow(
          icon: LucideIcons.bookOpen,
          title: item.$1,
          subtitle: item.$2,
          onTap: () => _open(item.$3),
        );
      },
    );
  }

  Widget _bookmarkTab() {
    final items = [
      (
        'Tilawah per ayat',
        _ayat.surat > 0 ? '${_ayat.namaSurat} • Ayat ${_ayat.ayat}' : null,
        AppRoutes.quranPerAyat,
        _ayat.surat > 0
      ),
      (
        'Mushaf Indonesia',
        _indonesia.index > 0
            ? 'Halaman ${_indonesia.index} • ${_indonesia.namaSurat}'
            : null,
        AppRoutes.quranPage,
        _indonesia.index > 0
      ),
      (
        'Mushaf Madinah',
        _madinah.index > 0
            ? 'Halaman ${_madinah.index} • ${_madinah.namaSurat}'
            : null,
        AppRoutes.quranPageMadinah,
        _madinah.index > 0
      ),
      (
        'Mushaf Tajwid',
        _tajwid.index > 0
            ? '${_tajwid.ayat > 0 ? 'Ayat ${_tajwid.ayat} • ' : ''}Halaman ${_tajwid.index} • ${_tajwid.namaSurat}'
            : null,
        AppRoutes.quranPageTajwid,
        _tajwid.index > 0
      ),
    ];
    final available = items.where((e) => e.$4).toList();
    if (available.isEmpty) {
      return HudhudStateView(
          icon: LucideIcons.bookmark,
          title: 'Belum ada tanda baca',
          message:
              'Saat membaca, tandai ayat atau halaman untuk kembali ke sini.',
          actionLabel: 'Mulai membaca',
          onAction: () => _tabs.animateTo(0));
    }
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: available.length,
      separatorBuilder: (_, __) => const Divider(),
      itemBuilder: (_, i) => HudhudActionRow(
          icon: LucideIcons.bookmarkCheck,
          title: available[i].$1,
          subtitle: available[i].$2,
          onTap: () {
            final item = available[i];
            if (item.$3 == AppRoutes.quranPerAyat) {
              _open(item.$3, bookmark: true);
            } else {
              final page = switch (item.$3) {
                AppRoutes.quranPage => _indonesia.index,
                AppRoutes.quranPageMadinah => _madinah.index,
                _ => _tajwid.index,
              };
              _open('${item.$3}?page=$page');
            }
          }),
    );
  }
}

class _QuranTabsHeader extends SliverPersistentHeaderDelegate {
  const _QuranTabsHeader({required this.color, required this.child});

  final Color color;
  final PreferredSizeWidget child;

  @override
  double get minExtent => child.preferredSize.height;

  @override
  double get maxExtent => child.preferredSize.height;

  @override
  Widget build(
          BuildContext context, double shrinkOffset, bool overlapsContent) =>
      Material(color: color, child: child);

  @override
  bool shouldRebuild(covariant _QuranTabsHeader oldDelegate) =>
      color != oldDelegate.color || child != oldDelegate.child;
}

class _ContinuePanel extends StatelessWidget {
  const _ContinuePanel({required this.progress, required this.onTap});
  final QuranReadingProgress? progress;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final t = context.hudhud;
    final hasData = progress != null;
    final detail = progress?.detail ?? 'Mulai dari Al-Fatihah';
    final name = progress?.surahName.isNotEmpty == true
        ? progress!.surahName
        : "Buka Al-Qur'an";
    return Material(
      color: t.terracotta.withValues(alpha: .09),
      borderRadius: BorderRadius.circular(t.radiusMd),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(t.radiusMd),
        child: ConstrainedBox(
          constraints: const BoxConstraints(minHeight: 88),
          child: Padding(
            padding: EdgeInsets.all(t.spaceMd),
            child: Row(children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                    color: t.surface,
                    borderRadius: BorderRadius.circular(t.radiusMd)),
                child: Icon(LucideIcons.bookOpen,
                    color: t.terracottaDark, size: 22),
              ),
              SizedBox(width: t.spaceMd),
              Expanded(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                    Text(hasData ? 'Lanjutkan tilawah' : 'Tilawah hari ini',
                        style: Theme.of(context)
                            .textTheme
                            .labelMedium
                            ?.copyWith(color: t.terracottaDark)),
                    SizedBox(height: t.spaceXs),
                    Text(name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.titleMedium),
                    Text(detail, style: Theme.of(context).textTheme.bodySmall),
                  ])),
              SizedBox(width: t.spaceSm),
              Icon(LucideIcons.arrowRight, color: t.terracottaDark, size: 20),
            ]),
          ),
        ),
      ),
    );
  }
}

class _QuranRow extends StatelessWidget {
  const _QuranRow(
      {required this.number,
      required this.title,
      required this.subtitle,
      required this.arabic,
      required this.onTap});
  final String number;
  final String title;
  final String subtitle;
  final String arabic;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final t = context.hudhud;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(t.radiusMd),
      child: ConstrainedBox(
        constraints: const BoxConstraints(minHeight: 76),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: t.spaceSm),
          child: Row(children: [
            Container(
              width: 36,
              height: 36,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  color: t.amber.withValues(alpha: .18),
                  borderRadius: BorderRadius.circular(t.radiusMd)),
              child: Text(number,
                  style: Theme.of(context)
                      .textTheme
                      .labelLarge
                      ?.copyWith(color: t.terracottaDark)),
            ),
            SizedBox(width: t.spaceMd),
            Expanded(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                  Text(title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.titleSmall),
                  SizedBox(height: t.spaceXs),
                  Text(subtitle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodySmall)
                ])),
            if (arabic.isNotEmpty) ...[
              SizedBox(width: t.spaceSm),
              ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 96),
                child: Text(arabic,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textDirection: TextDirection.rtl,
                    style: GoogleFonts.amiriQuran(
                        fontSize: 20, color: t.charcoal)),
              ),
            ],
          ]),
        ),
      ),
    );
  }
}
