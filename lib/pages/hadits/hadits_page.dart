import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:masjid_app/components/worship/worship_reader_scaffold.dart';
import 'package:masjid_app/components/worship/worship_state_views.dart';
import 'package:masjid_app/core/router/app_router.dart';
import 'package:masjid_app/core/theme/hudhud_theme.dart';
import 'package:masjid_app/models/hadist_data.dart';
import 'package:masjid_app/pages/hadits/component/hadits_last_read_card.dart';
import 'package:masjid_app/providers/hadits_providers.dart';
import 'package:masjid_app/storage/hadits_bookmark_storage.dart';
import 'package:skeletonizer/skeletonizer.dart';

class HaditsPage extends ConsumerWidget {
  const HaditsPage({super.key});

  static const Map<String, String> coverByTable = {
    'arbain': 'Hadits Arbain.png',
    'bukhari': 'Shahih Bukhari.png',
    'muslim': 'Shahih Muslim.png',
    'abudaud': 'Sunan Abu Daud.png',
    'tirmidzi': 'Sunan Tirmidzi.png',
    'nasai': "Sunan Nasa'i.png",
    'ibnumajah': 'Sunan Ibnu Majah.png',
    'ahmad': 'Musnad Ahmad.png',
    'malik': 'Muwatho Malik.png',
    'darimi': 'Sunan Darimi.png',
  };

  static final List<ImamData> _dummyBooks = List.generate(
    10,
    (i) => ImamData(
      imamId: i + 1,
      imamSorting: i + 1,
      longNama: 'Shahih Hadits $i',
      namaTabel: 'kitab_$i',
      hadits: 1000,
      babCount: 10,
    ),
  );

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final booksAsync = ref.watch(haditsBooksProvider);

    return WorshipReaderScaffold(
      title: 'Ensiklopedia Hadits',
      subtitle: 'Sabda & sunnah Rasulullah SAW',
      body: booksAsync.when(
        data: (books) => _buildBody(context, ref, books, isLoading: false),
        loading: () => _buildBody(context, ref, _dummyBooks, isLoading: true),
        error: (err, stack) => WorshipErrorView(
          title: 'Gagal Memuat Kitab Hadits',
          message: 'Silakan periksa koneksi dan coba lagi.',
          onRetry: () => ref.invalidate(haditsBooksProvider),
        ),
      ),
    );
  }

  Widget _buildBody(
    BuildContext context,
    WidgetRef ref,
    List<ImamData> books, {
    required bool isLoading,
  }) {
    final t = context.hudhud;
    final temas =
        ref.watch(haditsTemaProvider).valueOrNull ?? const <HaditsTema>[];
    final saved = ref.watch(haditsBookmarkProvider);
    final bookmarks = saved.where((e) => e.isBookmark).take(5).toList();
    final history = saved.take(5).toList();

    return Skeletonizer(
      enabled: isLoading,
      child: CustomScrollView(
        slivers: [
          // 1. Lanjut Baca
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.fromLTRB(
                  t.spaceLg, t.spaceSm, t.spaceLg, t.spaceMd),
              child: const HaditsLastReadCard(),
            ),
          ),
          // 2. Pencarian
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.fromLTRB(t.spaceLg, 0, t.spaceLg, t.spaceMd),
              child: _buildSearchBox(context),
            ),
          ),
          // 3. Tema
          if (temas.isNotEmpty) ...[
            SliverToBoxAdapter(
              child: _sectionTitle(
                context,
                'Tema Pilihan',
                trailing: 'Lihat Semua',
                onTrailingTap: () => context.push(AppRoutes.haditsTema),
              ),
            ),
            SliverToBoxAdapter(child: _buildTemaStrip(context, temas)),
            const SliverToBoxAdapter(child: SizedBox(height: 12)),
          ],
          // 4. Koleksi Kitab
          SliverToBoxAdapter(
            child: _sectionTitle(
              context,
              'Kutubut Tis\'ah & Arba\'in',
              trailing: '${books.length} Kitab',
            ),
          ),
          SliverPadding(
            padding: EdgeInsets.fromLTRB(t.spaceLg, 0, t.spaceLg, t.spaceMd),
            sliver: SliverGrid(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.78,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
              ),
              delegate: SliverChildBuilderDelegate(
                (ctx, i) => _buildBookCard(context, books[i]),
                childCount: books.length,
              ),
            ),
          ),
          // 5. Bookmark
          if (bookmarks.isNotEmpty) ...[
            SliverToBoxAdapter(
                child: _sectionTitle(context, 'Tanda Baca (Bookmark)')),
            SliverToBoxAdapter(
              child: _buildSavedList(context, ref, bookmarks, isBookmark: true),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 12)),
          ],
          // 6. Riwayat
          if (history.isNotEmpty) ...[
            SliverToBoxAdapter(child: _sectionTitle(context, 'Riwayat Baca')),
            SliverToBoxAdapter(
              child: _buildSavedList(context, ref, history, isBookmark: false),
            ),
          ],
          SliverToBoxAdapter(child: SizedBox(height: t.spaceXl)),
        ],
      ),
    );
  }

  Widget _buildSearchBox(BuildContext context) {
    final t = context.hudhud;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(t.radiusMd),
        onTap: () => context.push(AppRoutes.haditsSearch),
        child: Container(
          height: t.controlHeight,
          decoration: BoxDecoration(
            color: t.surface,
            borderRadius: BorderRadius.circular(t.radiusMd),
            border: Border.all(color: t.outline),
          ),
          padding: EdgeInsets.symmetric(horizontal: t.spaceMd),
          child: Row(
            children: [
              Icon(LucideIcons.search, size: 18, color: t.muted),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  'Cari hadits dalam kitab atau tema...',
                  style: TextStyle(
                    fontFamily: 'Roboto',
                    fontSize: 13,
                    color: t.muted,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _sectionTitle(
    BuildContext context,
    String title, {
    String? trailing,
    VoidCallback? onTrailingTap,
  }) {
    final t = context.hudhud;
    return Padding(
      padding: EdgeInsets.fromLTRB(t.spaceLg, t.spaceSm, t.spaceLg, t.spaceSm),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
              fontFamily: 'Roboto',
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: t.charcoal,
            ),
          ),
          if (trailing != null)
            GestureDetector(
              onTap: onTrailingTap,
              child: Text(
                trailing,
                style: TextStyle(
                  fontFamily: 'Roboto',
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: t.terracotta,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildTemaStrip(BuildContext context, List<HaditsTema> temas) {
    final t = context.hudhud;
    return SizedBox(
      height: 48,
      child: ListView.separated(
        padding: EdgeInsets.symmetric(horizontal: t.spaceLg),
        scrollDirection: Axis.horizontal,
        itemCount: temas.take(8).length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (ctx, i) {
          final tema = temas[i];
          return ActionChip(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(t.radiusMd),
              side: BorderSide(color: t.outline),
            ),
            backgroundColor: t.surface,
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            label: Text(
              '${tema.nama} (${tema.jumlah})',
              style: TextStyle(
                fontFamily: 'Roboto',
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: t.charcoal,
              ),
            ),
            onPressed: () => context.push('/hadits/tema/${tema.id}'),
          );
        },
      ),
    );
  }

  Widget _buildBookCard(BuildContext context, ImamData book) {
    final t = context.hudhud;
    final assetPath =
        'assets/icons/${coverByTable[book.namaTabel] ?? 'hadits.svg'}';
    final route = book.babCount > 0
        ? AppRoutes.haditsBab.replaceFirst(':id', book.namaTabel)
        : AppRoutes.haditsListRoute.replaceFirst(':id', book.namaTabel);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(t.radiusMd),
        onTap: () => context.push(route),
        child: Container(
          decoration: BoxDecoration(
            color: t.surface,
            borderRadius: BorderRadius.circular(t.radiusMd),
            border: Border.all(color: t.outline),
          ),
          padding: EdgeInsets.all(t.spaceMd),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Center(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(t.radiusSm),
                    child: Image.asset(
                      assetPath,
                      fit: BoxFit.contain,
                      errorBuilder: (_, __, ___) => SvgPicture.asset(
                        'assets/icons/hadits.svg',
                        width: 48,
                        height: 48,
                        colorFilter:
                            ColorFilter.mode(t.terracotta, BlendMode.srcIn),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                book.longNama,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Roboto',
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: t.charcoal,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                '${book.hadits} Hadits',
                style: TextStyle(
                  fontFamily: 'Roboto',
                  fontSize: 11,
                  color: t.muted,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSavedList(
    BuildContext context,
    WidgetRef ref,
    List<HaditsBookmarkData> list, {
    required bool isBookmark,
  }) {
    final t = context.hudhud;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: t.spaceLg),
      child: Column(
        children: list.map((e) {
          return Container(
            margin: const EdgeInsets.only(bottom: 8),
            decoration: BoxDecoration(
              color: t.surface,
              borderRadius: BorderRadius.circular(t.radiusMd),
              border: Border.all(color: t.outline),
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(t.radiusMd),
                onTap: () => context.push(
                  '${AppRoutes.haditsListRoute.replaceFirst(':id', e.namaTabel)}?mulai=${e.noHdt}',
                ),
                child: Padding(
                  padding: EdgeInsets.all(t.spaceMd),
                  child: Row(
                    children: [
                      Icon(
                        isBookmark ? LucideIcons.bookmark : LucideIcons.history,
                        size: 18,
                        color: t.terracotta,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              e.longNama,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontFamily: 'Roboto',
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                                color: t.charcoal,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              'Hadits No. ${e.noHdt}'
                              '${(e.babIndonesia ?? '').isNotEmpty ? ' • ${e.babIndonesia}' : ''}',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontFamily: 'Roboto',
                                fontSize: 11,
                                color: t.muted,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Icon(LucideIcons.chevronRight, size: 18, color: t.muted),
                    ],
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
