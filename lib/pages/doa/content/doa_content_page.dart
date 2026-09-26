import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:html/parser.dart';
import 'package:masjid_app/models/doa_data.dart';
import 'package:masjid_app/models/doa_models.dart';
import 'package:masjid_app/providers/doa_providers.dart';
import 'package:share_plus/share_plus.dart';
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
    final buffer = StringBuffer();
    if (data.judul.isNotEmpty) buffer.writeln(data.judul);
    if (categoryName.isNotEmpty) buffer.writeln('Kategori: $categoryName');
    buffer.writeln();

    if (data.arabic != null && data.arabic!.isNotEmpty) {
      buffer.writeln(data.arabic);
      buffer.writeln();
    }

    if (data.transliteration != null && data.transliteration!.isNotEmpty) {
      buffer.writeln('Transliterasi:');
      buffer.writeln(_cleanHtml(data.transliteration!));
      buffer.writeln();
    }

    if (data.translations != null && data.translations!.isNotEmpty) {
      buffer.writeln('Artinya:');
      buffer.writeln(_cleanHtml(data.translations!));
      buffer.writeln();
    } else if (data.isi != null && data.isi!.isNotEmpty) {
      buffer.writeln('Artinya:');
      buffer.writeln(_cleanHtml(data.isi!));
      buffer.writeln();
    }

    buffer.writeln("(Dibagikan melalui Aplikasi Masjid An-Ni'mah - Marbot)");

    Clipboard.setData(ClipboardData(text: buffer.toString().trim()));
    Fluttertoast.showToast(
      msg: "Do'a berhasil disalin ke papan klip",
      backgroundColor: const Color(0xFF048C7C),
      textColor: Colors.white,
    );
  }

  void _shareDoa(DoaData data, String categoryName) {
    final buffer = StringBuffer();
    if (data.judul.isNotEmpty) buffer.writeln(data.judul);
    buffer.writeln();

    if (data.arabic != null && data.arabic!.isNotEmpty) {
      buffer.writeln(data.arabic);
      buffer.writeln();
    }

    if (data.transliteration != null && data.transliteration!.isNotEmpty) {
      buffer.writeln(_cleanHtml(data.transliteration!));
      buffer.writeln();
    }

    if (data.translations != null && data.translations!.isNotEmpty) {
      buffer.writeln('Artinya:');
      buffer.writeln(_cleanHtml(data.translations!));
      buffer.writeln();
    } else if (data.isi != null && data.isi!.isNotEmpty) {
      buffer.writeln('Artinya:');
      buffer.writeln(_cleanHtml(data.isi!));
      buffer.writeln();
    }

    buffer.writeln("Dibagikan melalui Aplikasi Masjid An-Ni'mah - Marbot");

    SharePlus.instance.share(
      ShareParams(
        text: buffer.toString().trim(),
        subject: data.judul.isNotEmpty ? data.judul : "Do'a Harian",
      ),
    );
  }

  void _showFontSizeSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Colors.black12,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Ukuran Teks Arab',
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF137065),
                        ),
                      ),
                      Text(
                        '${_arabicFontSize.toInt()} pt',
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF048C7C),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  SliderTheme(
                    data: SliderTheme.of(context).copyWith(
                      activeTrackColor: const Color(0xFF048C7C),
                      inactiveTrackColor: const Color(0xFFE2EBE8),
                      thumbColor: const Color(0xFF137065),
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
                  const SizedBox(height: 8),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF8FAF9),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: const Color(0xFFE2EBE8)),
                    ),
                    child: Text(
                      'بِسْمِ اللّٰهِ الرَّحْمٰنِ الرَّحِيْمِ',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.amiri(
                        fontSize: _arabicFontSize,
                        color: const Color(0xFF2D3748),
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
            icon: const Icon(
              Icons.arrow_back_rounded,
              color: Color(0xFF137065),
            ),
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: Text(
            categoryName,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.poppins(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF137065),
            ),
          ),
          actions: [
            IconButton(
              icon: const Icon(
                Icons.format_size_rounded,
                color: Color(0xFF137065),
              ),
              tooltip: 'Ukuran Font',
              onPressed: _showFontSizeSheet,
            ),
          ],
        ),
        body: doaAsync.when(
          data: (data) {
            // Jika API detail mengembalikan null, gunakan passedDoaItem sebagai fallback
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
            // Gunakan fallback model dari router extra jika sudah ada saat loading
            if (passedDoaItem != null) {
              final initialData = DoaData(
                id: passedDoaItem.id,
                judul: passedDoaItem.judul,
                updatedAt: '',
                arabic: passedDoaItem.arab.isNotEmpty ? passedDoaItem.arab : null,
                transliteration: passedDoaItem.latin.isNotEmpty ? passedDoaItem.latin : null,
                translations: passedDoaItem.arti.isNotEmpty ? passedDoaItem.arti : null,
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
          error: (err, stack) => _buildError(context, contentId, passedDoaItem, categoryName),
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
    final hasArabic = data.arabic != null && data.arabic!.trim().isNotEmpty;
    final hasTransliteration =
        data.transliteration != null && data.transliteration!.trim().isNotEmpty;
    final hasTranslations =
        (data.translations != null && data.translations!.trim().isNotEmpty) ||
            (data.isi != null && data.isi!.trim().isNotEmpty);
    final translationContent = (data.translations != null && data.translations!.isNotEmpty)
        ? data.translations!
        : (data.isi ?? '');

    return Skeletonizer(
      enabled: isLoading,
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Badge & Card Container
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: const Color(0xFFE2EBE8)),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF048C7C).withValues(alpha: 0.06),
                    blurRadius: 16,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Header Strip
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                    decoration: const BoxDecoration(
                      color: Color(0xFFF4F9F7),
                      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                      border: Border(
                        bottom: BorderSide(color: Color(0xFFE2EBE8)),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: const Color(0xFF048C7C).withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                categoryName,
                                style: GoogleFonts.poppins(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                  color: const Color(0xFF048C7C),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          data.judul,
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF137065),
                            height: 1.4,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Reading Section
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Opening (if any)
                        if (data.opening != null && data.opening!.trim().isNotEmpty) ...[
                          HtmlWidget(
                            data.opening!,
                            textStyle: GoogleFonts.poppins(
                              fontSize: 12,
                              color: Colors.black54,
                            ),
                          ),
                          const SizedBox(height: 16),
                        ],

                        // Arabic Text Box
                        if (hasArabic) ...[
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF8FAF9),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(color: const Color(0xFFE5EDE9)),
                            ),
                            child: HtmlWidget(
                              data.arabic!,
                              textStyle: GoogleFonts.amiri(
                                fontSize: _arabicFontSize,
                                fontWeight: FontWeight.bold,
                                color: const Color(0xFF1E293B),
                                height: 2.0,
                              ),
                              customStylesBuilder: (element) {
                                return {
                                  'text-align': 'right',
                                  'direction': 'rtl',
                                };
                              },
                            ),
                          ),
                          const SizedBox(height: 20),
                        ],

                        // Transliterasi (Latin)
                        if (hasTransliteration) ...[
                          Row(
                            children: [
                              const Icon(
                                Icons.record_voice_over_rounded,
                                size: 16,
                                color: Color(0xFF048C7C),
                              ),
                              const SizedBox(width: 6),
                              Text(
                                'Transliterasi',
                                style: GoogleFonts.poppins(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: const Color(0xFF048C7C),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 6),
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: const Color(0xFFEAEAEA)),
                            ),
                            child: HtmlWidget(
                              data.transliteration!,
                              textStyle: GoogleFonts.poppins(
                                fontSize: 13,
                                fontStyle: FontStyle.italic,
                                color: const Color(0xFF4A5568),
                                height: 1.5,
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                        ],

                        // Arti / Terjemahan
                        if (hasTranslations) ...[
                          Row(
                            children: [
                              const Icon(
                                Icons.translate_rounded,
                                size: 16,
                                color: Color(0xFF137065),
                              ),
                              const SizedBox(width: 6),
                              Text(
                                'Artinya',
                                style: GoogleFonts.poppins(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: const Color(0xFF137065),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 6),
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: const Color(0xFFEAEAEA)),
                            ),
                            child: HtmlWidget(
                              translationContent,
                              textStyle: GoogleFonts.poppins(
                                fontSize: 13,
                                color: const Color(0xFF2D3748),
                                height: 1.6,
                              ),
                              customStylesBuilder: (element) {
                                if (element.classes.contains('arabic') ||
                                    element.classes.contains('arabic-quran')) {
                                  return {
                                    'font-family': 'Amiri',
                                    'font-size': '${_arabicFontSize}px',
                                    'font-weight': 'bold',
                                    'text-align': 'right',
                                    'direction': 'rtl',
                                    'line-height': '2.0',
                                    'color': '#1E293B',
                                  };
                                }
                                if (element.classes.contains('latin-text')) {
                                  return {
                                    'font-style': 'italic',
                                    'color': '#048C7C',
                                    'font-size': '12px',
                                    'margin-bottom': '6px',
                                  };
                                }
                                if (element.classes.contains('text')) {
                                  return {
                                    'font-size': '13px',
                                    'color': '#2D3748',
                                    'line-height': '1.6',
                                  };
                                }
                                return null;
                              },
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),

                  // Bottom Action Buttons (Salin & Bagikan)
                  Container(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                    child: Row(
                      children: [
                        // Salin Button
                        Expanded(
                          child: OutlinedButton.icon(
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              foregroundColor: const Color(0xFF137065),
                              side: const BorderSide(color: Color(0xFF048C7C)),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            icon: const Icon(Icons.copy_rounded, size: 18),
                            label: Text(
                              'Salin',
                              style: GoogleFonts.poppins(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            onPressed: () => _copyToClipboard(data, categoryName),
                          ),
                        ),
                        const SizedBox(width: 12),
                        // Bagikan Button
                        Expanded(
                          child: ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              backgroundColor: const Color(0xFF048C7C),
                              foregroundColor: Colors.white,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            icon: const Icon(Icons.share_rounded, size: 18),
                            label: Text(
                              'Bagikan',
                              style: GoogleFonts.poppins(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            onPressed: () => _shareDoa(data, categoryName),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildError(
    BuildContext context,
    String contentId,
    DoaItemModel? fallbackItem,
    String categoryName,
  ) {
    if (fallbackItem != null) {
      final fallbackData = DoaData(
        id: fallbackItem.id,
        judul: fallbackItem.judul,
        updatedAt: '',
        arabic: fallbackItem.arab,
        transliteration: fallbackItem.latin,
        translations: fallbackItem.arti,
      );
      return _buildContent(context, fallbackData, categoryName, isLoading: false);
    }

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.cloud_off_rounded,
              size: 48,
              color: Colors.black38,
            ),
            const SizedBox(height: 12),
            Text(
              'Gagal memuat detail doa',
              style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.black54,
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF048C7C),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () => ref.invalidate(doaDetailProvider(contentId)),
              child: Text(
                'Coba Lagi',
                style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
