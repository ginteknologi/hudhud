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

class ContentHaditsPage extends ConsumerStatefulWidget {
  const ContentHaditsPage({super.key});

  @override
  ConsumerState<ContentHaditsPage> createState() => _ContentHaditsPageState();
}

class _ContentHaditsPageState extends ConsumerState<ContentHaditsPage> {
  int _currentIndex = 0;
  bool _initializedIndex = false;

  void _syncInitialIndex(List<ListHadistData> list, int? targetNoHdt) {
    if (_initializedIndex || list.isEmpty) return;
    if (targetNoHdt != null && targetNoHdt > 0) {
      final idx = list.indexWhere((item) => item.noHdt == targetNoHdt);
      if (idx != -1) {
        _currentIndex = idx;
      }
    }
    _initializedIndex = true;
  }

  void _toggleBookmark(
    Map<String, dynamic> detail,
    ListKitabData? content,
    ListBabData? bab,
    String babIndonesia,
    ListHadistData hadits,
    int totalHadits,
  ) {
    final namaTabel = (detail['namaTabel'] ?? '').toString();
    final longNama = (detail['longNama'] ?? 'Kitab Hadits').toString();

    final targetData = HaditsBookmarkData(
      namaTabel: namaTabel,
      longNama: longNama,
      idKitab: content?.idKitab ?? hadits.idKitab ?? 1,
      kitabIndonesia: content?.kitabIndonesia ?? babIndonesia,
      idBab: bab?.idBab ?? hadits.idBab,
      babIndonesia: babIndonesia.isNotEmpty ? babIndonesia : content?.kitabIndonesia,
      noHdt: hadits.noHdt,
      totalHadits: totalHadits,
      snippet: hadits.isiIndonesia.length > 80
          ? '${hadits.isiIndonesia.substring(0, 80)}...'
          : hadits.isiIndonesia,
    );

    final isSaved = ref.read(haditsBookmarkProvider.notifier).toggleBookmark(targetData);

    Fluttertoast.showToast(
      msg: isSaved
          ? 'Tersimpan ke Terakhir Dibaca (Hadits No. ${hadits.noHdt})'
          : 'Tanda Terakhir Dibaca dihapus',
      backgroundColor: isSaved ? const Color(0xFF048C7C) : const Color(0xFF4A5568),
      textColor: Colors.white,
    );
  }

  void _copyToClipboard(
    String bookTitle,
    String subTitle,
    ListHadistData hadits,
  ) {
    final text = '$bookTitle\n'
        'Hadits No. ${hadits.noHdt}${subTitle.isNotEmpty ? ' • $subTitle' : ''}\n\n'
        '${hadits.isiArab}\n\n'
        'Artinya:\n'
        '"${hadits.isiIndonesia}"\n\n'
        '(Dibagikan melalui Aplikasi Masjid An-Ni\'mah - Marbot)';

    Clipboard.setData(ClipboardData(text: text));
    Fluttertoast.showToast(
      msg: 'Teks Hadits berhasil disalin ke clipboard',
      backgroundColor: const Color(0xFF048C7C),
      textColor: Colors.white,
    );
  }

  void _shareHadits(
    String bookTitle,
    String subTitle,
    ListHadistData hadits,
  ) {
    final text = '$bookTitle\n'
        'Hadits No. ${hadits.noHdt}${subTitle.isNotEmpty ? ' • $subTitle' : ''}\n\n'
        '${hadits.isiArab}\n\n'
        'Artinya:\n'
        '"${hadits.isiIndonesia}"\n\n'
        'Dibagikan melalui Aplikasi Masjid An-Ni\'mah - Marbot';

    SharePlus.instance.share(
      ShareParams(
        text: text,
        subject: '$bookTitle - Hadits No. ${hadits.noHdt}',
      ),
    );
  }

  void _showJumpDialog(BuildContext context, List<ListHadistData> list) {
    final textController = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          'Lompat ke Nomor Hadits',
          style: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: const Color(0xFF137065),
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Masukkan nomor hadits yang ingin dibaca:',
              style: GoogleFonts.poppins(fontSize: 12, color: Colors.black54),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: textController,
              keyboardType: TextInputType.number,
              autofocus: true,
              style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.bold),
              decoration: InputDecoration(
                hintText: 'Contoh: ${list.first.noHdt}',
                hintStyle: GoogleFonts.poppins(fontSize: 13, color: Colors.black38),
                filled: true,
                fillColor: const Color(0xFFF8FAF9),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Color(0xFFE2EBE8)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Color(0xFF048C7C), width: 1.5),
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(
              'Batal',
              style: GoogleFonts.poppins(color: Colors.black54),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              final target = int.tryParse(textController.text.trim());
              if (target != null) {
                final idx = list.indexWhere((h) => h.noHdt == target);
                if (idx != -1) {
                  setState(() => _currentIndex = idx);
                  Navigator.pop(ctx);
                } else {
                  Fluttertoast.showToast(
                    msg: 'Nomor hadits $target tidak ditemukan di bab ini',
                  );
                }
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF048C7C),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            child: const Text('Buka'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final routeState = GoRouterState.of(context);
    final extra = routeState.extra;
    final args = extra is Map ? Map<String, dynamic>.from(extra) : <String, dynamic>{};
    final detail = args['detail'] is Map
        ? Map<String, dynamic>.from(args['detail'] as Map)
        : <String, dynamic>{};
    final content =
        args['content'] is ListKitabData ? args['content'] as ListKitabData : null;
    final bab = args['bab'] is ListBabData ? args['bab'] as ListBabData : null;
    final babIndonesia = (args['babIndonesia'] ?? '').toString();
    final namaTabel = (detail['namaTabel'] ?? '').toString();
    final idKitab =
        content?.idKitab ?? int.tryParse(routeState.pathParameters['id'] ?? '') ?? 0;
    final idBab =
        bab?.idBab ?? int.tryParse(routeState.pathParameters['content'] ?? '');
    final initialNoHdt = args['initialNoHdt'] as int?;

    final bookTitle = (detail['longNama'] ?? 'Kitab Hadits').toString();
    final subTitle = babIndonesia.isNotEmpty
        ? babIndonesia
        : (content?.kitabIndonesia ?? '');
    final totalHadits = detail['hadits'] ?? 0;

    final contentAsync = ref.watch(
      haditsContentProvider(
        HaditsContentParams(
          namaTabel: namaTabel,
          idKitab: idKitab,
          idBab: idBab,
        ),
      ),
    );

    final uiSettings = ref.watch(haditsUiSettingsProvider);
    final currentBookmark = ref.watch(haditsBookmarkProvider);

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
      ),
      child: Scaffold(
        backgroundColor: const Color(0xFFF8FAF9),
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          scrolledUnderElevation: 1,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_rounded, color: Color(0xFF137065)),
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                bookTitle,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.poppins(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF137065),
                ),
              ),
              if (subTitle.isNotEmpty)
                Text(
                  subTitle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.poppins(
                    fontSize: 11,
                    color: Colors.black54,
                  ),
                ),
            ],
          ),
          centerTitle: false,
          actions: [
            // Tombol Pengaturan Ukuran Teks
            IconButton(
              icon: const Icon(
                Icons.format_size_rounded,
                color: Color(0xFF048C7C),
              ),
              tooltip: 'Ukuran Font',
              onPressed: () => HaditsFontSizeModal.show(context),
            ),
            // Tombol Bookmark / Terakhir Dibaca (Toggle / Unchecklist)
            contentAsync.when(
              data: (list) {
                if (list.isEmpty) return const SizedBox();
                final currentHadits = list[_currentIndex];
                final isBookmarked = currentBookmark != null &&
                    currentBookmark.namaTabel == namaTabel &&
                    currentBookmark.noHdt == currentHadits.noHdt;

                return IconButton(
                  icon: Icon(
                    isBookmarked
                        ? Icons.bookmark_added_rounded
                        : Icons.bookmark_add_outlined,
                    color: isBookmarked
                        ? const Color(0xFFF9A825)
                        : const Color(0xFF048C7C),
                  ),
                  tooltip: isBookmarked ? 'Hapus Terakhir Dibaca' : 'Tandai Terakhir Dibaca',
                  onPressed: () => _toggleBookmark(
                    detail,
                    content,
                    bab,
                    babIndonesia,
                    currentHadits,
                    totalHadits,
                  ),
                );
              },
              loading: () => const SizedBox(),
              error: (_, __) => const SizedBox(),
            ),
            // Tombol Bagikan
            contentAsync.when(
              data: (list) {
                if (list.isEmpty) return const SizedBox();
                final currentHadits = list[_currentIndex];
                return IconButton(
                  icon: const Icon(Icons.share_rounded, color: Color(0xFF048C7C)),
                  tooltip: 'Bagikan Hadits',
                  onPressed: () => _shareHadits(bookTitle, subTitle, currentHadits),
                );
              },
              loading: () => const SizedBox(),
              error: (_, __) => const SizedBox(),
            ),
          ],
        ),
        body: contentAsync.when(
          data: (list) {
            if (list.isEmpty) {
              return _buildEmptyState(context);
            }
            _syncInitialIndex(list, initialNoHdt);
            final currentHadits = list[_currentIndex];

            return Column(
              children: [
                // Scrollable Content
                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.fromLTRB(18, 16, 18, 20),
                    child: _buildHaditsCard(
                      context,
                      bookTitle,
                      subTitle,
                      currentHadits,
                      uiSettings,
                    ),
                  ),
                ),

                // Bottom Navigation Control
                _buildBottomNav(context, list),
              ],
            );
          },
          loading: () => _buildLoadingSkeleton(),
          error: (err, stack) => _buildError(context, namaTabel, idKitab, idBab),
        ),
      ),
    );
  }

  Widget _buildHaditsCard(
    BuildContext context,
    String bookTitle,
    String subTitle,
    ListHadistData hadits,
    HaditsUiSettings uiSettings,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: const Color(0xFFE2EBE8)),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF048C7C).withValues(alpha: 0.05),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header Bar di dalam Card
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Badge Nomor Hadits
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: const Color(0xFFEAF5F2),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFFD4EAE5)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.star_rounded,
                      size: 14,
                      color: Color(0xFF048C7C),
                    ),
                    const SizedBox(width: 5),
                    Text(
                      'Hadits No. ${hadits.noHdt}',
                      style: GoogleFonts.poppins(
                        fontSize: 12.5,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF048C7C),
                      ),
                    ),
                  ],
                ),
              ),

              // Tombol Salin Teks
              InkWell(
                onTap: () => _copyToClipboard(bookTitle, subTitle, hadits),
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  padding: const EdgeInsets.all(7),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF8FAF9),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: const Color(0xFFE2EBE8)),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.copy_rounded, size: 14, color: Color(0xFF048C7C)),
                      SizedBox(width: 4),
                      Text(
                        'Salin',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF048C7C),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 22),

          // Teks Hadits Arab (Dynamic Height, Tanpa Batasan 300px!)
          if (uiSettings.showArabic) ...[
            Text(
              hadits.isiArab,
              textAlign: TextAlign.right,
              textDirection: TextDirection.rtl,
              style: GoogleFonts.amiri(
                fontSize: uiSettings.arabicFontSize,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF137065),
                height: 2.1,
              ),
            ),
            const SizedBox(height: 20),
          ],

          // Divider Hiasan Islami
          Row(
            children: [
              Expanded(
                child: Container(height: 1, color: const Color(0xFFE2EBE8)),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: const BoxDecoration(
                    color: Color(0xFFEAF5F2),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.auto_awesome,
                    size: 14,
                    color: Color(0xFF048C7C),
                  ),
                ),
              ),
              Expanded(
                child: Container(height: 1, color: const Color(0xFFE2EBE8)),
              ),
            ],
          ),

          const SizedBox(height: 18),

          // Terjemahan Bahasa Indonesia
          if (uiSettings.showTranslation) ...[
            Row(
              children: [
                Text(
                  'Terjemahan:',
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF137065),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              hadits.isiIndonesia,
              textAlign: TextAlign.justify,
              style: GoogleFonts.poppins(
                fontSize: uiSettings.translationFontSize,
                color: const Color(0xFF2D3748),
                height: 1.65,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildBottomNav(BuildContext context, List<ListHadistData> list) {
    final canPrev = _currentIndex > 0;
    final canNext = _currentIndex < list.length - 1;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: const Border(
          top: BorderSide(color: Color(0xFFE2EBE8), width: 1),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, -3),
          ),
        ],
      ),
      padding: EdgeInsets.fromLTRB(
        16,
        10,
        16,
        MediaQuery.of(context).padding.bottom + 10,
      ),
      child: Row(
        children: [
          // Tombol Sebelumnya
          Expanded(
            child: SizedBox(
              height: 44,
              child: ElevatedButton.icon(
                onPressed: canPrev ? () => setState(() => _currentIndex--) : null,
                icon: const Icon(Icons.chevron_left_rounded, size: 20),
                label: const FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text('Sebelumnya'),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF048C7C),
                  foregroundColor: Colors.white,
                  disabledBackgroundColor: const Color(0xFFE2EBE8),
                  disabledForegroundColor: Colors.black26,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),

          // Posisi & Lompat ke Hadits
          InkWell(
            onTap: () => _showJumpDialog(context, list),
            borderRadius: BorderRadius.circular(12),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: const Color(0xFFF8FAF9),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFE2EBE8)),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '${_currentIndex + 1} / ${list.length}',
                    style: GoogleFonts.poppins(
                      fontSize: 12.5,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF137065),
                    ),
                  ),
                  Text(
                    'Lompat ▾',
                    style: GoogleFonts.poppins(
                      fontSize: 9.5,
                      color: Colors.black45,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 8),

          // Tombol Selanjutnya
          Expanded(
            child: SizedBox(
              height: 44,
              child: ElevatedButton(
                onPressed: canNext ? () => setState(() => _currentIndex++) : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF048C7C),
                  foregroundColor: Colors.white,
                  disabledBackgroundColor: const Color(0xFFE2EBE8),
                  disabledForegroundColor: Colors.black26,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Flexible(
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text('Selanjutnya'),
                      ),
                    ),
                    SizedBox(width: 3),
                    Icon(Icons.chevron_right_rounded, size: 20),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingSkeleton() {
    return Skeletonizer(
      enabled: true,
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: 120,
                    height: 28,
                    color: Colors.grey.shade300,
                  ),
                  Container(
                    width: 60,
                    height: 28,
                    color: Colors.grey.shade300,
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Container(
                height: 120,
                color: Colors.grey.shade300,
              ),
              const SizedBox(height: 24),
              Container(
                height: 160,
                color: Colors.grey.shade300,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.menu_book_outlined,
              size: 48,
              color: Colors.black26,
            ),
            const SizedBox(height: 12),
            Text(
              'Belum ada konten hadits untuk bab ini',
              style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.black54,
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF048C7C),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text('Kembali'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildError(
    BuildContext context,
    String namaTabel,
    int idKitab,
    int? idBab,
  ) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline_rounded,
              color: Colors.redAccent,
              size: 44,
            ),
            const SizedBox(height: 12),
            Text(
              'Gagal memuat isi hadits',
              style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => ref.invalidate(
                haditsContentProvider(
                  HaditsContentParams(
                    namaTabel: namaTabel,
                    idKitab: idKitab,
                    idBab: idBab,
                  ),
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF048C7C),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text('Coba Lagi'),
            ),
          ],
        ),
      ),
    );
  }
}
