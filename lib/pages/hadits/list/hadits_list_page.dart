import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:masjid_app/models/hadist_data.dart';
import 'package:masjid_app/pages/hadits/component/hadits_font_size_modal.dart';
import 'package:masjid_app/providers/hadits_providers.dart';
import 'package:masjid_app/providers/hadits_ui_settings_provider.dart';
import 'package:masjid_app/storage/hadits_bookmark_storage.dart';
import 'package:share_plus/share_plus.dart';
import 'package:skeletonizer/skeletonizer.dart';

/// HaditsListPage — Screen v2
/// Navigasi: HaditsPage → HaditsListPage (langsung tampil daftar hadits + pagination)
class HaditsListPage extends ConsumerStatefulWidget {
  const HaditsListPage({super.key});

  @override
  ConsumerState<HaditsListPage> createState() => _HaditsListPageState();
}

class _HaditsListPageState extends ConsumerState<HaditsListPage> {
  late Map<String, dynamic> _book;
  late String _namaTabel;
  late String _longNama;

  int _currentPage = 1;
  static const int _limit = 20;

  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    // Data dikirim via GoRouter extra dari HaditsPage
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final extra = ModalRoute.of(context)?.settings.arguments;
      if (extra == null) {
        // Diambil dari GoRouterState di didChangeDependencies
      }
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final extra = GoRouterState.of(context).extra;
    if (extra is Map<String, dynamic>) {
      _book = extra;
      _namaTabel = (_book['namaTabel'] ?? '').toString();
      _longNama = (_book['longNama'] ?? 'Hadits').toString();
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  HaditsListParams get _params => HaditsListParams(
        namaTabel: _namaTabel,
        page: _currentPage,
        limit: _limit,
      );

  void _goToPage(int page) {
    setState(() => _currentPage = page);
    _scrollController.animateTo(
      0,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  void _saveBookmark(HaditsData hadits, int total) {
    final data = HaditsBookmarkData(
      namaTabel: _namaTabel,
      longNama: _longNama,
      idKitab: 1,
      kitabIndonesia: _longNama,
      idBab: null,
      babIndonesia: null,
      noHdt: hadits.noHdt,
      totalHadits: total,
      snippet: hadits.isiIndonesia.length > 80
          ? '${hadits.isiIndonesia.substring(0, 80)}...'
          : hadits.isiIndonesia,
    );
    final saved = ref.read(haditsBookmarkProvider.notifier).toggleBookmark(data);
    Fluttertoast.showToast(
      msg: saved
          ? 'Tersimpan ke Terakhir Dibaca (No. ${hadits.noHdt})'
          : 'Tanda Terakhir Dibaca dihapus',
      backgroundColor:
          saved ? const Color(0xFF048C7C) : const Color(0xFF4A5568),
      textColor: Colors.white,
    );
  }

  void _shareHadits(HaditsData hadits) {
    final text = '$_longNama\n'
        'Hadits No. ${hadits.noHdt}\n\n'
        '${hadits.isiArab}\n\n'
        'Artinya:\n'
        '"${hadits.isiIndonesia}"\n\n'
        '(Dibagikan melalui Aplikasi Masjid An-Ni\'mah - Marbot)';
    SharePlus.instance.share(ShareParams(text: text));
  }

  void _copyHadits(HaditsData hadits) {
    final text = '$_longNama\n'
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
    final asyncResult = ref.watch(haditsListProvider(_params));
    final uiSettings = ref.watch(haditsUiSettingsProvider);

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
      ),
      child: Scaffold(
        backgroundColor: const Color(0xFFF8FAF9),
        body: SafeArea(
          child: asyncResult.when(
            data: (result) => _buildBody(result, uiSettings, isLoading: false),
            loading: () => _buildBody(
              HaditsPageResult(
                items: List.generate(
                  5,
                  (_) => HaditsData(
                    noHdt: 1,
                    isiArab: 'بِسْمِ اللَّهِ الرَّحْمَنِ الرَّحِيمِ',
                    isiIndonesia: 'Teks hadits sedang dimuat...',
                  ),
                ),
                pagination: HaditsPagination(
                  page: 1, limit: _limit, total: 0, totalPages: 1),
              ),
              uiSettings,
              isLoading: true,
            ),
            error: (err, _) => _buildError(),
          ),
        ),
      ),
    );
  }

  Widget _buildBody(
    HaditsPageResult result,
    HaditsUiSettings uiSettings, {
    required bool isLoading,
  }) {
    final arabFontSize = uiSettings.arabicFontSize;
    final indoFontSize = uiSettings.translationFontSize;

    return Skeletonizer(
      enabled: isLoading,
      child: CustomScrollView(
        controller: _scrollController,
        physics: const BouncingScrollPhysics(),
        slivers: [
          // Header
          SliverToBoxAdapter(child: _buildHeader(result.pagination)),

          // List Hadits
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (ctx, i) => _buildHaditsCard(
                  result.items[i],
                  result.pagination.total,
                  arabFontSize,
                  indoFontSize,
                ),
                childCount: result.items.length,
              ),
            ),
          ),

          // Pagination
          if (!isLoading)
            SliverToBoxAdapter(
              child: _buildPagination(result.pagination),
            ),

          const SliverToBoxAdapter(child: SizedBox(height: 24)),
        ],
      ),
    );
  }

  Widget _buildHeader(HaditsPagination pagination) {
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
                      _longNama,
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
              // Tombol ukuran font
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
        ],
      ),
    );
  }

  Widget _buildHaditsCard(
    HaditsData hadits,
    int total,
    double arabFontSize,
    double indoFontSize,
  ) {
    final bookmark = ref.watch(haditsBookmarkProvider);
    final isBookmarked =
        bookmark != null &&
        bookmark.namaTabel == _namaTabel &&
        bookmark.noHdt == hadits.noHdt;

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
            // Nomor hadits + action icons
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
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
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFEAF5F2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.bookmark_rounded,
                          size: 11,
                          color: Color(0xFF048C7C),
                        ),
                        const SizedBox(width: 3),
                        Text(
                          'Terakhir Dibaca',
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
                // Actions
                _ActionIcon(
                  icon: isBookmarked
                      ? Icons.bookmark_rounded
                      : Icons.bookmark_border_rounded,
                  color: isBookmarked
                      ? const Color(0xFF048C7C)
                      : Colors.black45,
                  onTap: () => _saveBookmark(hadits, total),
                ),
                const SizedBox(width: 4),
                _ActionIcon(
                  icon: Icons.copy_rounded,
                  color: Colors.black45,
                  onTap: () => _copyHadits(hadits),
                ),
                const SizedBox(width: 4),
                _ActionIcon(
                  icon: Icons.share_rounded,
                  color: Colors.black45,
                  onTap: () => _shareHadits(hadits),
                ),
              ],
            ),

            const SizedBox(height: 14),

            // Teks Arab
            Align(
              alignment: Alignment.centerRight,
              child: Text(
                hadits.isiArab,
                textAlign: TextAlign.right,
                textDirection: TextDirection.rtl,
                style: GoogleFonts.amiri(
                  fontSize: arabFontSize,
                  height: 2.0,
                  color: const Color(0xFF1A1A1A),
                ),
              ),
            ),

            const SizedBox(height: 12),
            const Divider(color: Color(0xFFEEEEEE)),
            const SizedBox(height: 10),

            // Terjemahan
            Text(
              hadits.isiIndonesia,
              style: GoogleFonts.poppins(
                fontSize: indoFontSize,
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
          // Tombol prev
          _PaginationButton(
            icon: Icons.chevron_left_rounded,
            enabled: _currentPage > 1,
            onTap: () => _goToPage(_currentPage - 1),
          ),

          const SizedBox(width: 8),

          // Info halaman
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

          // Tombol next
          _PaginationButton(
            icon: Icons.chevron_right_rounded,
            enabled: _currentPage < pagination.totalPages,
            onTap: () => _goToPage(_currentPage + 1),
          ),
        ],
      ),
    );
  }

  Widget _buildError() {
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
              onPressed: () =>
                  ref.invalidate(haditsListProvider(_params)),
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


