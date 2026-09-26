import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:masjid_app/core/router/app_router.dart';
import 'package:masjid_app/models/hadist_data.dart';
import 'package:masjid_app/pages/hadits/component/hadits_last_read_card.dart';
import 'package:masjid_app/providers/hadits_providers.dart';
import 'package:masjid_app/storage/hadits_bookmark_storage.dart';
import 'package:skeletonizer/skeletonizer.dart';

/// Landing hadits — section, bukan tab.
///
/// Isinya cuma 10 kitab + beberapa tema + beberapa bookmark; tab hanya
/// menambah plumbing tanpa menambah hasil.
class HaditsPage extends ConsumerWidget {
  const HaditsPage({super.key});

  /// Cover per `namaTabel`. Dipetakan dari tabel, bukan dari `longNama`,
  /// supaya tidak bergantung pada ejaan judul.
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

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final booksAsync = ref.watch(haditsBooksProvider);

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
      ),
      child: Scaffold(
        backgroundColor: const Color(0xFFF8FAF9),
        body: SafeArea(
          child: booksAsync.when(
            data: (books) => _buildBody(context, ref, books, isLoading: false),
            loading: () => _buildBody(context, ref, _dummyBooks, isLoading: true),
            error: (err, stack) => _buildError(context, ref),
          ),
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
    final temas =
        ref.watch(haditsTemaProvider).valueOrNull ?? const <HaditsTema>[];
    final saved = ref.watch(haditsBookmarkProvider);
    final bookmarks = saved.where((e) => e.isBookmark).take(5).toList();
    final history = saved.take(5).toList();

    return Skeletonizer(
      enabled: isLoading,
      child: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverToBoxAdapter(child: _buildHeader(context)),
          SliverToBoxAdapter(child: _buildSearchBox(context)),
          if (temas.isNotEmpty) ...[
            SliverToBoxAdapter(child: _sectionTitle('Tema Pilihan')),
            SliverToBoxAdapter(child: _buildTemaStrip(context, temas)),
          ],
          SliverToBoxAdapter(
            child: _sectionTitle(
              'Kutubut Tis\'ah & Arba\'in',
              trailing: '${books.length} Kitab',
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 8),
            sliver: SliverGrid(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.76,
                crossAxisSpacing: 14,
                mainAxisSpacing: 14,
              ),
              delegate: SliverChildBuilderDelegate(
                (ctx, i) => _buildBookCard(context, books[i]),
                childCount: books.length,
              ),
            ),
          ),
          if (bookmarks.isNotEmpty) ...[
            SliverToBoxAdapter(child: _sectionTitle('Tanda Baca')),
            SliverToBoxAdapter(
              child: _buildSavedList(context, ref, bookmarks, isBookmark: true),
            ),
          ],
          if (history.isNotEmpty) ...[
            SliverToBoxAdapter(child: _sectionTitle('Riwayat')),
            SliverToBoxAdapter(
              child: _buildSavedList(context, ref, history, isBookmark: false),
            ),
          ],
          const SliverToBoxAdapter(child: SizedBox(height: 24)),
        ],
      ),
    );
  }

  // ─── Header & search ───────────────────────────────────────

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 14, 20, 16),
      child: Row(
        children: [
          InkWell(
            onTap: () => Navigator.of(context).pop(),
            borderRadius: BorderRadius.circular(12),
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFE2EBE8)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.04),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: const Icon(Icons.arrow_back_rounded,
                  size: 20, color: Color(0xFF137065)),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Ensiklopedia Hadits',
                  style: GoogleFonts.poppins(
                    fontSize: 19,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF137065),
                  ),
                ),
                const SizedBox(height: 1),
                Text(
                  'Kumpulan sabda & sunnah Rasulullah SAW',
                  style: GoogleFonts.poppins(
                    fontSize: 11,
                    color: Colors.black54,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Kotak cari read-only — mengetik di sini tidak menyaring apa pun,
  /// ia hanya membuka halaman pencarian (satu pintu pencarian).
  Widget _buildSearchBox(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
      child: Column(
        children: [
          GestureDetector(
            onTap: () => context.push(AppRoutes.haditsSearch),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: const Color(0xFFE2EBE8)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.03),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 14),
              child: Row(
                children: [
                  const Icon(Icons.search_rounded,
                      color: Color(0xFF048C7C), size: 22),
                  const SizedBox(width: 10),
                  Text(
                    'Cari teks hadits…',
                    style: GoogleFonts.poppins(
                      color: Colors.black38,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          HaditsLastReadCard(),
        ],
      ),
    );
  }

  // ─── Section helpers ───────────────────────────────────────

  Widget _sectionTitle(String title, {String? trailing}) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: GoogleFonts.poppins(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF137065),
            ),
          ),
          if (trailing != null)
            Text(
              trailing,
              style: GoogleFonts.poppins(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF048C7C),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildTemaStrip(BuildContext context, List<HaditsTema> temas) {
    final shown = temas.take(8).toList();
    return SizedBox(
      height: 44,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        children: [
          for (final t in shown)
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: GestureDetector(
                onTap: () => context.push('/hadits/tema/${t.id}'),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: const Color(0xFFE2EBE8)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        t.nama,
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF137065),
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        '${t.jumlah}',
                        style: GoogleFonts.poppins(
                          fontSize: 10,
                          color: Colors.black38,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          if (temas.length > shown.length)
            GestureDetector(
              onTap: () => context.push(AppRoutes.haditsTema),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                decoration: BoxDecoration(
                  color: const Color(0xFFEAF5F2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  'Semua tema',
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF048C7C),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  // ─── Kartu kitab ───────────────────────────────────────────

  Widget _buildBookCard(BuildContext context, ImamData book) {
    final assetPath =
        'assets/icons/${coverByTable[book.namaTabel] ?? 'hadits.svg'}';

    // Inilah seluruh mekanisme degradasi 3 level → 2 level.
    final route = book.babCount > 0
        ? AppRoutes.haditsBab.replaceFirst(':id', book.namaTabel)
        : AppRoutes.haditsListRoute.replaceFirst(':id', book.namaTabel);

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFE2EBE8)),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF048C7C).withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(18),
          onTap: () => context.push(route),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Center(
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.08),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.asset(
                          assetPath,
                          fit: BoxFit.contain,
                          errorBuilder: (_, __, ___) => Container(
                            width: double.infinity,
                            color: const Color(0xFFEAF5F2),
                            child: Center(
                              child: SvgPicture.asset(
                                'assets/icons/hadits.svg',
                                width: 44,
                                height: 44,
                                colorFilter: const ColorFilter.mode(
                                  Color(0xFF048C7C),
                                  BlendMode.srcIn,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  book.longNama,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.poppins(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                    height: 1.25,
                  ),
                ),
                const SizedBox(height: 6),
                // Di lebar tile terkecil chip "N Hadits" + "N bab" kelebihan
                // ~11px. Skala-turun, bukan ellipsis — dua-duanya tetap terbaca.
                FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.centerLeft,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: const Color(0xFFEAF5F2),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.menu_book_rounded,
                                size: 11, color: Color(0xFF048C7C)),
                            const SizedBox(width: 4),
                            Text(
                              '${book.hadits} Hadits',
                              style: GoogleFonts.poppins(
                                fontSize: 10.5,
                                fontWeight: FontWeight.bold,
                                color: const Color(0xFF048C7C),
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (book.babCount > 0) ...[
                        const SizedBox(width: 6),
                        Text(
                          '${book.babCount} bab',
                          style: GoogleFonts.poppins(
                            fontSize: 9.5,
                            color: Colors.black38,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ─── Bookmark & riwayat ────────────────────────────────────

  Widget _buildSavedList(
    BuildContext context,
    WidgetRef ref,
    List<HaditsBookmarkData> entries, {
    required bool isBookmark,
  }) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 8),
      child: Column(
        children: [
          for (final e in entries)
            Container(
              margin: const EdgeInsets.only(bottom: 8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFE2EBE8)),
              ),
              child: ListTile(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                dense: true,
                leading: Icon(
                  isBookmark
                      ? Icons.bookmark_rounded
                      : Icons.history_rounded,
                  size: 20,
                  color: const Color(0xFF048C7C),
                ),
                title: Text(
                  e.longNama,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.poppins(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                subtitle: Text(
                  'Hadits No. ${e.noHdt}'
                  '${(e.babIndonesia ?? '').isNotEmpty ? ' • ${e.babIndonesia}' : ''}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.poppins(fontSize: 10, color: Colors.black45),
                ),
                trailing: const Icon(Icons.chevron_right_rounded,
                    size: 18, color: Colors.black26),
                onTap: () => context.push(
                  '${AppRoutes.haditsListRoute.replaceFirst(':id', e.namaTabel)}?mulai=${e.noHdt}',
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildError(BuildContext context, WidgetRef ref) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline_rounded,
                color: Colors.redAccent, size: 48),
            const SizedBox(height: 12),
            Text(
              'Gagal memuat daftar kitab hadits',
              style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'Periksa koneksi internet Anda dan coba lagi',
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(fontSize: 12, color: Colors.black54),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: () => ref.invalidate(haditsBooksProvider),
              icon: const Icon(Icons.refresh_rounded, size: 18),
              label: const Text('Coba Lagi'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF048C7C),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Skeleton: harus punya `babCount` seperti data asli, kalau tidak chip
  /// "N bab" muncul/hilang saat loading selesai.
  static final List<ImamData> _dummyBooks = List.generate(
    6,
    (index) => const ImamData(
      imamId: 0,
      imamSorting: 0,
      hadits: 7008,
      longNama: 'Kitab Hadits Shahih Bukhari',
      namaTabel: 'bukhari',
      babCount: 97,
    ),
  );
}
