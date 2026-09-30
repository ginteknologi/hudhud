import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:masjid_app/components/worship/worship_reader_scaffold.dart';
import 'package:masjid_app/components/worship/worship_scripture_block.dart';
import 'package:masjid_app/components/worship/worship_share_helper.dart';
import 'package:masjid_app/components/worship/worship_state_views.dart';
import 'package:masjid_app/core/router/app_router.dart';
import 'package:masjid_app/core/theme/hudhud_theme.dart';
import 'package:masjid_app/models/hadist_data.dart';
import 'package:masjid_app/pages/hadits/component/hadits_font_size_modal.dart';
import 'package:masjid_app/pages/hadits/component/hadits_jump_sheet.dart';
import 'package:masjid_app/providers/hadits_providers.dart';
import 'package:masjid_app/providers/hadits_ui_settings_provider.dart';
import 'package:masjid_app/storage/hadits_bookmark_storage.dart';
import 'package:skeletonizer/skeletonizer.dart';

class HaditsListPage extends ConsumerStatefulWidget {
  const HaditsListPage({super.key});

  @override
  ConsumerState<HaditsListPage> createState() => _HaditsListPageState();
}

class _HaditsListPageState extends ConsumerState<HaditsListPage> {
  late String _namaTabel;

  int? _queryMulai;
  int? _queryAkhir;
  int? _babId;

  int _currentPage = 1;
  static const int _limit = 20;

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

  ImamData? _findBook(List<ImamData> books) {
    for (final b in books) {
      if (b.namaTabel == _namaTabel) return b;
    }
    return null;
  }

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
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeOut,
    );
  }

  void _markRead(HaditsPageResult result, ImamData? book, HaditsBab? bab) {
    if (result.items.isEmpty) return;
    final key = '$_namaTabel#${bab?.id}#${_queryMulai ?? 0}#${result.pagination.total}';
    if (_markedKey == key) return;
    _markedKey = key;

    final first = result.items.first;
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
    });
  }

  static String _snippet(String text) =>
      text.length > 80 ? '${text.substring(0, 80)}...' : text;

  void _jumpTo(String namaTabel, int noHdt) {
    if (namaTabel == _namaTabel) {
      context.pushReplacement(
        '${AppRoutes.haditsListRoute.replaceFirst(':id', namaTabel)}?mulai=$noHdt',
      );
    } else {
      context.push(
        '${AppRoutes.haditsListRoute.replaceFirst(':id', namaTabel)}?mulai=$noHdt',
      );
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
      backgroundColor: saved ? const Color(0xFFD06A4C) : const Color(0xFF4A5568),
      textColor: Colors.white,
    );
  }

  @override
  Widget build(BuildContext context) {
    final books = ref.watch(haditsBooksProvider).valueOrNull ?? const <ImamData>[];
    final babs = ref.watch(haditsBabProvider(_namaTabel)).valueOrNull ?? const <HaditsBab>[];
    final book = _findBook(books);
    final bab = _findBab(babs);
    final longNama = book?.longNama ?? 'Hadits ${_namaTabel.toUpperCase()}';

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
      asyncResult.valueOrNull ??
          const HaditsPageResult(
            items: [],
            pagination: HaditsPagination(page: 1, limit: _limit, total: 0, totalPages: 1),
          ),
      book,
      bab,
    );

    final subtitle = bab != null
        ? bab.nama
        : (asyncResult.valueOrNull != null
            ? '${asyncResult.valueOrNull!.pagination.total} Hadits'
            : 'Memuat hadits...');

    return WorshipReaderScaffold(
      title: longNama,
      subtitle: subtitle,
      actions: [
        IconButton(
          constraints: const BoxConstraints(minWidth: 48, minHeight: 48),
          icon: const Icon(LucideIcons.slidersHorizontal, size: 20),
          tooltip: 'Lompat / Ganti Kitab',
          onPressed: () {
            final pagination = asyncResult.valueOrNull?.pagination;
            showHaditsJumpSheet(
              context: context,
              namaTabel: _namaTabel,
              longNama: longNama,
              totalHadits: pagination?.total ?? book?.hadits ?? 0,
              listBooks: books,
              onJump: (no) => _jumpTo(_namaTabel, no),
              onSelectKitab: (t) => _jumpTo(t, 1),
            );
          },
        ),
        IconButton(
          constraints: const BoxConstraints(minWidth: 48, minHeight: 48),
          icon: const Icon(LucideIcons.type, size: 20),
          tooltip: 'Pengaturan Teks',
          onPressed: () => HaditsFontSizeModal.show(context),
        ),
      ],
      body: asyncResult.when(
        data: (result) => _buildBody(result, uiSettings, book, bab, longNama, isLoading: false),
        loading: () => _buildBody(
          HaditsPageResult(
            items: List.generate(
              4,
              (i) => HaditsData(
                noHdt: i + 1,
                isiArab: 'بِسْمِ اللَّهِ الرَّحْمَنِ الرَّحِيمِ',
                isiIndonesia: 'Teks terjemahan hadits sedang dimuat di sini.',
              ),
            ),
            pagination: const HaditsPagination(
              page: 1,
              limit: _limit,
              total: 0,
              totalPages: 1,
            ),
          ),
          uiSettings,
          book,
          bab,
          longNama,
          isLoading: true,
        ),
        error: (_, __) => WorshipErrorView(
          title: 'Gagal Memuat Hadits',
          message: 'Silakan periksa koneksi dan coba lagi.',
          onRetry: () => ref.invalidate(haditsListProvider(params)),
        ),
      ),
    );
  }

  Widget _buildBody(
    HaditsPageResult result,
    HaditsUiSettings uiSettings,
    ImamData? book,
    HaditsBab? bab,
    String longNama, {
    required bool isLoading,
  }) {
    final t = context.hudhud;

    if (!isLoading && result.items.isEmpty) {
      return const WorshipEmptyView(
        title: 'Hadits Tidak Ditemukan',
        message: 'Belum ada data untuk kategori atau nomor ini.',
        icon: LucideIcons.bookOpen,
      );
    }

    return Skeletonizer(
      enabled: isLoading,
      child: ListView.separated(
        controller: _scrollController,
        padding: EdgeInsets.fromLTRB(t.spaceLg, t.spaceSm, t.spaceLg, t.spaceXl),
        itemCount: result.items.length + (result.pagination.totalPages > 1 ? 1 : 0),
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (ctx, i) {
          if (i == result.items.length) {
            return _buildPagination(result.pagination);
          }
          return _buildHaditsCard(
            result.items[i],
            result.pagination.total,
            uiSettings,
            book,
            bab,
            longNama,
          );
        },
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
    final t = context.hudhud;
    final isBookmarked = ref.watch(haditsBookmarkProvider).any(
          (e) => e.namaTabel == _namaTabel && e.noHdt == hadits.noHdt && e.isBookmark,
        );

    return Container(
      padding: EdgeInsets.all(t.spaceLg),
      decoration: BoxDecoration(
        color: t.surface,
        borderRadius: BorderRadius.circular(t.radiusMd),
        border: Border.all(color: isBookmarked ? t.terracotta : t.outline),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: t.terracotta,
                  borderRadius: BorderRadius.circular(t.radiusSm),
                ),
                child: Text(
                  'No. ${hadits.noHdt}',
                  style: const TextStyle(
                    fontFamily: 'Roboto',
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ),
              if (isBookmarked) ...[
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: t.sand,
                    borderRadius: BorderRadius.circular(t.radiusSm),
                    border: Border.all(color: t.outline),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(LucideIcons.bookmarkCheck, size: 12, color: t.terracotta),
                      const SizedBox(width: 4),
                      Text(
                        'Disimpan',
                        style: TextStyle(
                          fontFamily: 'Roboto',
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          color: t.terracotta,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
              const Spacer(),
              IconButton(
                constraints: const BoxConstraints(minWidth: 48, minHeight: 48),
                icon: Icon(
                  isBookmarked ? LucideIcons.bookmarkCheck : LucideIcons.bookmark,
                  size: 18,
                  color: isBookmarked ? t.terracotta : t.muted,
                ),
                tooltip: 'Bookmark',
                onPressed: () => _saveBookmark(hadits, total, book, bab),
              ),
              IconButton(
                constraints: const BoxConstraints(minWidth: 48, minHeight: 48),
                icon: Icon(LucideIcons.copy, size: 18, color: t.muted),
                tooltip: 'Salin Hadits',
                onPressed: () => WorshipShareHelper.copyItem(
                  title: '$longNama • No. ${hadits.noHdt}',
                  arabic: hadits.isiArab,
                  translation: hadits.isiIndonesia,
                ),
              ),
              IconButton(
                constraints: const BoxConstraints(minWidth: 48, minHeight: 48),
                icon: Icon(LucideIcons.share2, size: 18, color: t.muted),
                tooltip: 'Bagikan Hadits',
                onPressed: () => WorshipShareHelper.shareItem(
                  title: '$longNama • No. ${hadits.noHdt}',
                  arabic: hadits.isiArab,
                  translation: hadits.isiIndonesia,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          WorshipScriptureBlock(
            arabic: hadits.isiArab,
            translation: hadits.isiIndonesia,
            arabicFontSize: uiSettings.arabicFontSize,
            showArabic: uiSettings.showArabic,
            showTranslation: uiSettings.showTranslation,
          ),
        ],
      ),
    );
  }

  Widget _buildPagination(HaditsPagination pagination) {
    final t = context.hudhud;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(
            constraints: const BoxConstraints(minWidth: 48, minHeight: 48),
            icon: Icon(
              LucideIcons.chevronLeft,
              size: 20,
              color: _currentPage > 1 ? t.charcoal : t.muted.withValues(alpha: 0.4),
            ),
            onPressed: _currentPage > 1 ? () => _goToPage(_currentPage - 1) : null,
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: t.terracotta,
              borderRadius: BorderRadius.circular(t.radiusMd),
            ),
            child: Text(
              '$_currentPage / ${pagination.totalPages}',
              style: const TextStyle(
                fontFamily: 'Roboto',
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(width: 8),
          IconButton(
            constraints: const BoxConstraints(minWidth: 48, minHeight: 48),
            icon: Icon(
              LucideIcons.chevronRight,
              size: 20,
              color: _currentPage < pagination.totalPages
                  ? t.charcoal
                  : t.muted.withValues(alpha: 0.4),
            ),
            onPressed: _currentPage < pagination.totalPages
                ? () => _goToPage(_currentPage + 1)
                : null,
          ),
        ],
      ),
    );
  }
}
