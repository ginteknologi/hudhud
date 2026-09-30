import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:html/parser.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:masjid_app/components/worship/worship_reader_scaffold.dart';
import 'package:masjid_app/components/worship/worship_reader_toolbar.dart';
import 'package:masjid_app/components/worship/worship_scripture_block.dart';
import 'package:masjid_app/components/worship/worship_share_helper.dart';
import 'package:masjid_app/components/worship/worship_state_views.dart';
import 'package:masjid_app/core/theme/hudhud_theme.dart';
import 'package:masjid_app/models/doa_data.dart';
import 'package:masjid_app/models/doa_models.dart';
import 'package:masjid_app/providers/doa_providers.dart';
import 'package:skeletonizer/skeletonizer.dart';

class ContentDoaPage extends ConsumerStatefulWidget {
  const ContentDoaPage({super.key});

  @override
  ConsumerState<ContentDoaPage> createState() => _ContentDoaPageState();
}

class _ContentDoaPageState extends ConsumerState<ContentDoaPage> {
  double _arabicFontSize = 24.0;

  String _cleanHtml(String htmlString) {
    if (htmlString.isEmpty) return '';
    try {
      final doc = parse(htmlString);
      return doc.body?.text.trim() ?? htmlString;
    } catch (_) {
      return htmlString;
    }
  }

  void _copyToClipboard(DoaData data, String categoryName) {
    final text = WorshipShareHelper.formatWorshipText(
      title: data.judul.isNotEmpty ? data.judul : "Do'a",
      subtitle: categoryName.isNotEmpty ? 'Kategori: $categoryName' : null,
      arabic: data.arabic,
      latin: data.transliteration != null ? _cleanHtml(data.transliteration!) : null,
      translation: data.translations != null
          ? _cleanHtml(data.translations!)
          : (data.isi != null ? _cleanHtml(data.isi!) : null),
      source: data.opening != null ? _cleanHtml(data.opening!) : null,
    );
    WorshipShareHelper.copy(text: text, successMessage: "Do'a berhasil disalin");
  }

  void _shareDoa(DoaData data, String categoryName) {
    final text = WorshipShareHelper.formatWorshipText(
      title: data.judul.isNotEmpty ? data.judul : "Do'a",
      subtitle: categoryName.isNotEmpty ? 'Kategori: $categoryName' : null,
      arabic: data.arabic,
      latin: data.transliteration != null ? _cleanHtml(data.transliteration!) : null,
      translation: data.translations != null
          ? _cleanHtml(data.translations!)
          : (data.isi != null ? _cleanHtml(data.isi!) : null),
      source: data.opening != null ? _cleanHtml(data.opening!) : null,
    );
    WorshipShareHelper.share(text: text, subject: data.judul);
  }

  void _showFontSizeSheet() {
    final t = context.hudhud;
    showModalBottomSheet(
      context: context,
      backgroundColor: t.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(t.radiusMd)),
      ),
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: EdgeInsets.fromLTRB(t.spaceLg, t.spaceMd, t.spaceLg, t.spaceXl),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: t.outline,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  SizedBox(height: t.spaceLg),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Ukuran Teks Arab',
                        style: TextStyle(
                          fontFamily: 'Roboto',
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: t.charcoal,
                        ),
                      ),
                      Text(
                        '${_arabicFontSize.toInt()} pt',
                        style: TextStyle(
                          fontFamily: 'Roboto',
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: t.terracotta,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  SliderTheme(
                    data: SliderTheme.of(context).copyWith(
                      activeTrackColor: t.terracotta,
                      inactiveTrackColor: t.sand,
                      thumbColor: t.terracotta,
                    ),
                    child: Slider(
                      value: _arabicFontSize,
                      min: 18.0,
                      max: 36.0,
                      divisions: 9,
                      onChanged: (val) {
                        setModalState(() => _arabicFontSize = val);
                        setState(() => _arabicFontSize = val);
                      },
                    ),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(t.spaceMd),
                    decoration: BoxDecoration(
                      color: t.sand,
                      borderRadius: BorderRadius.circular(t.radiusMd),
                      border: Border.all(color: t.outline),
                    ),
                    child: Text(
                      'بِسْمِ اللّٰهِ الرَّحْمٰنِ الرَّحِيْمِ',
                      textAlign: TextAlign.center,
                      textDirection: TextDirection.rtl,
                      style: GoogleFonts.amiri(
                        fontSize: _arabicFontSize,
                        color: t.charcoal,
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final routeState = GoRouterState.of(context);
    final contentId = routeState.pathParameters['content'] ?? '';
    final extra = routeState.extra;

    String categoryName = "Do'a Pilihan";
    DoaItemModel? passedDoaItem;

    if (extra is Map) {
      if (extra.containsKey('categoryName')) {
        categoryName = extra['categoryName'].toString();
      }
      if (extra.containsKey('doaItem') && extra['doaItem'] is DoaItemModel) {
        passedDoaItem = extra['doaItem'] as DoaItemModel;
      }
    }

    final doaAsync = ref.watch(doaDetailProvider(contentId));

    return WorshipReaderScaffold(
      title: categoryName,
      subtitle: 'Bacaan Doa',
      actions: [
        IconButton(
          constraints: const BoxConstraints(minWidth: 48, minHeight: 48),
          icon: const Icon(LucideIcons.type, size: 20),
          tooltip: 'Ukuran Font',
          onPressed: _showFontSizeSheet,
        ),
      ],
      body: doaAsync.when(
        data: (data) {
          final finalData = data ??
              DoaData(
                id: passedDoaItem?.id ?? int.tryParse(contentId) ?? 1,
                judul: passedDoaItem?.judul ?? "Do'a",
                updatedAt: '',
                arabic: passedDoaItem?.arab,
                transliteration: passedDoaItem?.latin,
                translations: passedDoaItem?.arti,
                isi: passedDoaItem?.arti,
              );
          return _buildContent(context, finalData, categoryName, isLoading: false);
        },
        loading: () {
          if (passedDoaItem != null) {
            final initialData = DoaData(
              id: passedDoaItem.id,
              judul: passedDoaItem.judul,
              updatedAt: '',
              arabic: passedDoaItem.arab.isNotEmpty ? passedDoaItem.arab : null,
              transliteration:
                  passedDoaItem.latin.isNotEmpty ? passedDoaItem.latin : null,
              translations:
                  passedDoaItem.arti.isNotEmpty ? passedDoaItem.arti : null,
              isi: passedDoaItem.arti.isNotEmpty ? passedDoaItem.arti : null,
            );
            return _buildContent(context, initialData, categoryName, isLoading: false);
          }
          return _buildContent(
            context,
            DoaData(
              id: 1,
              judul: 'Memuat Judul Doa...',
              updatedAt: '',
              arabic: 'بِسْمِ اللّٰهِ الرَّحْمٰنِ الرَّحِيْمِ',
              translations: 'Sedang memuat arti dan terjemahan doa...',
            ),
            categoryName,
            isLoading: true,
          );
        },
        error: (err, stack) => WorshipErrorView(
          title: 'Gagal Memuat Detail Doa',
          message: 'Silakan periksa koneksi dan coba lagi.',
          onRetry: () => ref.invalidate(doaDetailProvider(contentId)),
        ),
      ),
    );
  }

  Widget _buildContent(
    BuildContext context,
    DoaData data,
    String categoryName, {
    required bool isLoading,
  }) {
    final t = context.hudhud;
    final arabicText = data.arabic ?? '';
    final latinText = data.transliteration != null ? _cleanHtml(data.transliteration!) : null;
    final translationText = data.translations != null
        ? _cleanHtml(data.translations!)
        : (data.isi != null ? _cleanHtml(data.isi!) : null);
    final openingText = data.opening != null ? _cleanHtml(data.opening!) : null;

    return Skeletonizer(
      enabled: isLoading,
      child: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(t.spaceLg, t.spaceSm, t.spaceLg, t.spaceXl),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header card
            Container(
              padding: EdgeInsets.all(t.spaceLg),
              decoration: BoxDecoration(
                color: t.surface,
                borderRadius: BorderRadius.circular(t.radiusMd),
                border: Border.all(color: t.outline),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          data.judul,
                          style: TextStyle(
                            fontFamily: 'Roboto',
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: t.charcoal,
                            height: 1.3,
                          ),
                        ),
                      ),
                      if (!isLoading) ...[
                        const SizedBox(width: 8),
                        WorshipReaderToolbar(
                          onCopy: () => _copyToClipboard(data, categoryName),
                          onShare: () => _shareDoa(data, categoryName),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Divider(),
                  const SizedBox(height: 16),
                  WorshipScriptureBlock(
                    arabic: arabicText,
                    latin: latinText,
                    translation: translationText,
                    note: openingText,
                    arabicFontSize: _arabicFontSize,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
