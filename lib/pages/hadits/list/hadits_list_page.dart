import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:masjid_app/core/router/app_router.dart';
import 'package:masjid_app/models/hadist_data.dart';
import 'package:masjid_app/pages/hadits/component/hadits_font_size_modal.dart';
import 'package:masjid_app/pages/hadits/component/hadits_jump_sheet.dart';
import 'package:masjid_app/providers/hadits_providers.dart';
import 'package:masjid_app/providers/hadits_ui_settings_provider.dart';
import 'package:masjid_app/storage/hadits_bookmark_storage.dart';
import 'package:share_plus/share_plus.dart';
import 'package:skeletonizer/skeletonizer.dart';

/// HaditsListPage — reader satu kitab.
///
/// Navigasi: HaditsPage → (HaditsBabPage) → HaditsListPage.
/// Scope lewat query param, bukan `extra`: `/hadits/list/arbain?bab=12`,
/// `/hadits/list/bukhari?mulai=500`. `extra` hilang saat refresh/deep link.
class HaditsListPage extends ConsumerStatefulWidget {
  const HaditsListPage({super.key});

  @override
  ConsumerState<HaditsListPage> createState() => _HaditsListPageState();
}

class _HaditsListPageState extends ConsumerState<HaditsListPage> {
  late String _namaTabel;

  /// Dari query param — diisi sekali di didChangeDependencies.
  int? _queryMulai;
  int? _queryAkhir;
  int? _babId;

  int _currentPage = 1;
  static const int _limit = 20;

  /// Guard agar markRead tidak berulang tiap rebuild.
  String? _markedKey;

  final ScrollController _scrollController = ScrollController();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final state = GoRouterState.of(context);
    _namaTabel = state.pathParameters['id'] ?? '';
    final q = state.uri.queryParameters;
    _queryMulai = int.tryParse(q['mulai'] ?? '');
    _queryAkhir = int.tryParse(q['akhir'] ?? '');
    _babId = int.tryParse(q['bab'] ?? '');
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  // ─── Resolusi scope ────────────────────────────────────────

  ImamData? _findBook(List<ImamData> books) {
    for (final b in books) {
      if (b.namaTabel == _namaTabel) return b;
    }
    return null;
  }

  /// Bab yang sedang di-scope. `bab` tak dikenal → diam-diam diabaikan.
  HaditsBab? _findBab(List<HaditsBab> babs) {
    if (_babId == null) return null;
    for (final b in babs) {
      if (b.id == _babId) return b;
    }
    return null;
  }

  void _goToPage(int page) {
    setState(() => _currentPage = page);
    _scrollController.animateTo(
      0,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  /// Catat riwayat baca sekali per rentang yang dibuka.
  void _markRead(HaditsPageResult result, ImamData? book, HaditsBab? bab) {
    if (result.items.isEmpty) return;
    final key = '$_namaTabel#${bab?.id}#${_queryMulai ?? 0}#${result.pagination.total}';
    if (_markedKey == key) return;
    _markedKey = key;

    final first = result.items.first;
    final position = bab != null ? bab.nama : 'Hadits ${first.noHdt}';
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      ref.read(haditsBookmarkProvider.notifier).markRead(
            HaditsBookmarkData(
              namaTabel: _namaTabel,
              longNama: book?.longNama ?? 'Hadits ${_namaTabel.toUpperCase()}',
              babIndonesia: bab?.nama,
              noHdt: first.noHdt,
              totalHadits: result.pagination.total,
              snippet: _snippet(first.isiIndonesia),
            ),
          );
      debugPrint('hadits: dibaca $position');
    });
  }

  static String _snippet(String text) =>
      text.length > 80 ? '${text.substring(0, 80)}...' : text;

  void _jumpTo(String namaTabel, int noHdt) {
    if (namaTabel == _namaTabel) {
      // Masih kitab yang sama — cukup pindah jendela, tanpa menumpuk halaman.
      context.pushReplacement('${AppRoutes.haditsListRoute.replaceFirst(':id', namaTabel)}?mulai=$noHdt');
    } else {
      context.push('${AppRoutes.haditsListRoute.replaceFirst(':id', namaTabel)}?mulai=$noHdt');
    }
  }

  void _saveBookmark(HaditsData hadits, int total, ImamData? book, HaditsBab? bab) {
    final data = HaditsBookmarkData(
      namaTabel: _namaTabel,
      longNama: book?.longNama ?? 'Hadits ${_namaTabel.toUpperCase()}',
      babIndonesia: bab?.nama,
      noHdt: hadits.noHdt,
      totalHadits: total,
      snippet: _snippet(hadits.isiIndonesia),
    );
    final saved = ref.read(haditsBookmarkProvider.notifier).toggle(data);
    Fluttertoast.showToast(
      msg: saved
          ? 'Disimpan ke Tanda Baca (No. ${hadits.noHdt})'
          : 'Tanda Baca dilepas (tetap ada di Riwayat)',
      backgroundColor:
          saved ? const Color(0xFF048C7C) : const Color(0xFF4A5568),
      textColor: Colors.white,
    );
  }

  void _shareHadits(HaditsData hadits, String longNama) {
    final text = '$longNama\n'
        'Hadits No. ${hadits.noHdt}\n\n'
        '${hadits.isiArab}\n\n'
        'Artinya:\n'
        '"${hadits.isiIndonesia}"\n\n'
        '(Dibagikan melalui Aplikasi Masjid An-Ni\'mah - Marbot)';
    SharePlus.instance.share(ShareParams(text: text));
  }

  void _copyHadits(HaditsData hadits, String longNama) {
    final text = '$longNama\n'
        'Hadits No. ${hadits.noHdt}\n\n'
        '${hadits.isiArab}\n\n'
        'Artinya:\n'
        '"${hadits.isiIndonesia}"';
    Clipboard.setData(ClipboardData(text: text));
    Fluttertoast.showToast(
      msg: 'Teks hadits disalin ke clipboard',
      backgroundColor: const Color(0xFF048C7C),
      textColor: Colors.white,
    );
  }

  @override
  Widget build(BuildContext context) {
    final books = ref.watch(haditsBooksProvider).valueOrNull ?? const <ImamData>[];
    final babs = ref.watch(haditsBabProvider(_namaTabel)).valueOrNull ??
        const <HaditsBab>[];
    final book = _findBook(books);
    final bab = _findBab(babs);
    final longNama = book?.longNama ?? 'Hadits ${_namaTabel.toUpperCase()}';

    // Bab menang atas mulai/akhir: keduanya menyatakan hal yang sama.
    final params = HaditsListParams(
      namaTabel: _namaTabel,
      page: _currentPage,
      limit: _limit,
      mulai: bab?.noAwal ?? _queryMulai,
      akhir: bab?.noAkhir ?? _queryAkhir,
    );

    final asyncResult = ref.watch(haditsListProvider(params));
    final uiSettings = ref.watch(haditsUiSettingsProvider);

    _markRead(
      asyncResult.valueOrNull ?? const HaditsPageResult(
        items: [],
        pagination: HaditsPagination(page: 1, limit: _limit, total: 0, totalPages: 1),
      ),
      book,
      bab,
    );

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
      ),
      child: Scaffold(
        backgroundColor: const Color(0xFFF8FAF9),
        body: SafeArea(
          child: asyncResult.when(
            data: (result) => _buildBody(
              result,
              uiSettings,
              books,
              book,
              bab,
              longNama,
              isLoading: false,
            ),
            loading: () => _buildBody(
              HaditsPageResult(
                items: List.generate(
                  5,
                  (_) => const HaditsData(
                    noHdt: 1,
                    isiArab: 'بِسْمِ اللَّهِ الرَّحْمَنِ الرَّحِيمِ',
                    isiIndonesia: 'Teks hadits sedang dimuat...',
                  ),
                ),
                pagination: const HaditsPagination(
                    page: 1, limit: _limit, total: 0, totalPages: 1),
              ),
              uiSettings,
              books,
              book,
              bab,
              longNama,
              isLoading: true,
            ),
            error: (err, _) => _buildError(params),
          ),
        ),
      ),
    );
  }

  Widget _buildBody(
    HaditsPageResult result,
    HaditsUiSettings uiSettings,
    List<ImamData> books,
    ImamData? book,
    HaditsBab? bab,
    String longNama, {
    required bool isLoading,
  }) {
    return Skeletonizer(
      enabled: isLoading,
      child: CustomScrollView(
        controller: _scrollController,
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverToBoxAdapter(
            child: _buildHeader(result.pagination, bab, longNama, books, isLoading),
          ),
          if (!isLoading && result.items.isEmpty)
            SliverFillRemaining(
              hasScrollBody: false,
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(32),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: const BoxDecoration(
                          color: Color(0xFFEAF5F2),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.menu_book_outlined,
                          size: 36,
                          color: Color(0xFF048C7C),
                        ),
                      ),
                      const SizedBox(height: 14),
                      Text(
                        'Hadits tidak ditemukan',
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Belum ada data untuk kategori atau nomor ini',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          color: Colors.black45,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            )
          else ...[
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (ctx, i) => _buildHaditsCard(
                    result.items[i],
                    result.pagination.total,
                    uiSettings,
                    book,
                    bab,
                    longNama,
                  ),
                  childCount: result.items.length,
                ),
              ),
            ),
            if (!isLoading)
              SliverToBoxAdapter(child: _buildPagination(result.pagination)),
          ],
          const SliverToBoxAdapter(child: SizedBox(height: 24)),
        ],
      ),
    );
  }

  Widget _buildHeader(
    HaditsPagination pagination,
    HaditsBab? bab,
    String longNama,
    List<ImamData> books,
    bool isLoading,
  ) {
    final start = (pagination.page - 1) * pagination.limit + 1;
    final end = (pagination.page * pagination.limit).clamp(0, pagination.total);

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 14, 20, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
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
                  child: const Icon(
                    Icons.arrow_back_rounded,
                    size: 20,
                    color: Color(0xFF137065),
                  ),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      longNama,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.poppins(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF137065),
                      ),
                    ),
                    if (pagination.total > 0)
                      Text(
                        'Hadits $start–$end dari ${pagination.total}',
                        style: GoogleFonts.poppins(
                          fontSize: 11,
                          color: Colors.black54,
                        ),
                      ),
                  ],
                ),
              ),
              if (!isLoading)
                IconButton(
                  onPressed: () => showHaditsJumpSheet(
                    context: context,
                    namaTabel: _namaTabel,
                    longNama: longNama,
                    totalHadits: pagination.total,
                    listBooks: books,
                    onJump: (no) => _jumpTo(_namaTabel, no),
                    onSelectKitab: (t) => _jumpTo(t, 1),
                  ),
                  icon: const Icon(
                    Icons.tune_rounded,
                    color: Color(0xFF048C7C),
                    size: 22,
                  ),
                  tooltip: 'Lompat / Ganti Kitab',
                ),
              IconButton(
                onPressed: () => HaditsFontSizeModal.show(context),
                icon: const Icon(
                  Icons.text_fields_rounded,
                  color: Color(0xFF048C7C),
                  size: 22,
                ),
                tooltip: 'Ukuran Teks',
              ),
            ],
          ),
          if (bab != null) ...[
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: const Color(0xFFEAF5F2),
                borderRadius: BorderRadius.circular(9),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.menu_book_rounded,
                      size: 13, color: Color(0xFF048C7C)),
                  const SizedBox(width: 6),
                  Flexible(
                    child: Text(
                      bab.nama,
                      maxLines: 2,
                      style: GoogleFonts.poppins(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF048C7C),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildHaditsCard(
    HaditsData hadits,
    int total,
    HaditsUiSettings uiSettings,
    ImamData? book,
    HaditsBab? bab,
    String longNama,
  ) {
    final isBookmarked = ref.watch(haditsBookmarkProvider).any(
          (e) => e.namaTabel == _namaTabel && e.noHdt == hadits.noHdt && e.isBookmark,
        );

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isBookmarked
              ? const Color(0xFF048C7C).withValues(alpha: 0.4)
              : const Color(0xFFE2EBE8),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFF048C7C),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    'No. ${hadits.noHdt}',
                    style: GoogleFonts.poppins(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                if (isBookmarked) ...[
                  const SizedBox(width: 6),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFFEAF5F2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.bookmark_rounded,
                            size: 11, color: Color(0xFF048C7C)),
                        const SizedBox(width: 3),
                        Text(
                          'Disimpan',
                          style: GoogleFonts.poppins(
                            fontSize: 10,
                            color: const Color(0xFF048C7C),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
                const Spacer(),
                _ActionIcon(
                  icon: isBookmarked
                      ? Icons.bookmark_rounded
                      : Icons.bookmark_border_rounded,
                  color: isBookmarked ? const Color(0xFF048C7C) : Colors.black45,
                  onTap: () => _saveBookmark(hadits, total, book, bab),
                ),
                const SizedBox(width: 4),
                _ActionIcon(
                  icon: Icons.copy_rounded,
                  color: Colors.black45,
                  onTap: () => _copyHadits(hadits, longNama),
                ),
                const SizedBox(width: 4),
                _ActionIcon(
                  icon: Icons.share_rounded,
                  color: Colors.black45,
                  onTap: () => _shareHadits(hadits, longNama),
                ),
              ],
            ),
            if (uiSettings.showArabic) ...[
              const SizedBox(height: 14),
              Align(
                alignment: Alignment.centerRight,
                child: Text(
                  hadits.isiArab,
                  textAlign: TextAlign.right,
                  textDirection: TextDirection.rtl,
                  style: GoogleFonts.amiri(
                    fontSize: uiSettings.arabicFontSize,
                    height: 2.0,
                    color: const Color(0xFF1A1A1A),
                  ),
                ),
              ),
            ],
            if (uiSettings.showArabic && uiSettings.showTranslation) ...[
              const SizedBox(height: 12),
              const Divider(color: Color(0xFFEEEEEE)),
              const SizedBox(height: 10),
            ] else if (uiSettings.showTranslation) ...[
              const SizedBox(height: 14),
            ],
            if (uiSettings.showTranslation)
              Text(
                hadits.isiIndonesia,
                style: GoogleFonts.poppins(
                  fontSize: uiSettings.translationFontSize,
                  height: 1.65,
                  color: const Color(0xFF333333),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildPagination(HaditsPagination pagination) {
    if (pagination.totalPages <= 1) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _PaginationButton(
            icon: Icons.chevron_left_rounded,
            enabled: _currentPage > 1,
            onTap: () => _goToPage(_currentPage - 1),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: const Color(0xFF048C7C),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              '$_currentPage / ${pagination.totalPages}',
              style: GoogleFonts.poppins(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(width: 8),
          _PaginationButton(
            icon: Icons.chevron_right_rounded,
            enabled: _currentPage < pagination.totalPages,
            onTap: () => _goToPage(_currentPage + 1),
          ),
        ],
      ),
    );
  }

  Widget _buildError(HaditsListParams params) {
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
              'Gagal memuat hadits',
              style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: () => ref.invalidate(haditsListProvider(params)),
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
}

// ─── Helper widgets ───────────────────────────────────────────

class _ActionIcon extends StatelessWidget {
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _ActionIcon({
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.all(4),
        child: Icon(icon, size: 18, color: color),
      ),
    );
  }
}

class _PaginationButton extends StatelessWidget {
  final IconData icon;
  final bool enabled;
  final VoidCallback onTap;

  const _PaginationButton({
    required this.icon,
    required this.enabled,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: enabled ? onTap : null,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: enabled ? const Color(0xFFEAF5F2) : const Color(0xFFF0F0F0),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: enabled
                ? const Color(0xFF048C7C).withValues(alpha: 0.3)
                : Colors.transparent,
          ),
        ),
        child: Icon(
          icon,
          size: 22,
          color: enabled ? const Color(0xFF048C7C) : Colors.black26,
        ),
      ),
    );
  }
}
