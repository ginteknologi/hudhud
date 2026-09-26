import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:masjid_app/configs/file_setup.dart';
import 'package:masjid_app/core/router/app_router.dart';
import 'package:masjid_app/pages/artikel/component/artikel_card.dart';
import 'package:masjid_app/pages/kajian/component/kajian_card.dart';
import 'package:masjid_app/providers/artikel_provider.dart';
import 'package:share_plus/share_plus.dart';

class DetailArtikelPage extends ConsumerWidget {
  const DetailArtikelPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final id =
        int.tryParse(GoRouterState.of(context).pathParameters['id'] ?? '') ?? 0;
    final detailAsync = ref.watch(artikelDetailProvider(id));

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
      ),
      child: Scaffold(
        backgroundColor: const Color(0xFFF8FAF9),
        body: SafeArea(
          child: detailAsync.when(
            data: (result) => result.detail.judul.isEmpty
                ? _buildMissing(context)
                : _buildBody(context, result),
            loading: () => const Center(
              child: CircularProgressIndicator(color: artikelTeal),
            ),
            error: (_, __) => _buildMissing(context),
          ),
        ),
      ),
    );
  }

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
                border: Border.all(color: artikelBorder),
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
                color: artikelTitle,
              ),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Text(
              'Artikel',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.poppins(
                fontSize: 19,
                fontWeight: FontWeight.bold,
                color: artikelTitle,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMissing(BuildContext context) {
    return Column(
      children: [
        _buildHeader(context),
        Expanded(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.article_outlined,
                    size: 48, color: Colors.black26),
                const SizedBox(height: 12),
                Text(
                  'Artikel tidak ditemukan',
                  style: GoogleFonts.poppins(fontSize: 13, color: Colors.black54),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBody(BuildContext context, ArtikelDetailResult result) {
    final detail = result.detail;
    final kategori = (detail.categoryArtikel?['nama'] ??
            detail.categoryArtikel?['name'] ??
            '')
        .toString();

    return Column(
      children: [
        _buildHeader(context),
        Expanded(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 28),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: AspectRatio(
                    aspectRatio: 16 / 9,
                    child: detail.image.isNotEmpty
                        ? CachedNetworkImage(
                            imageUrl: detail.image,
                            fit: BoxFit.cover,
                            errorWidget: (_, __, ___) =>
                                const KajianFallbackImage(),
                          )
                        : const KajianFallbackImage(),
                  ),
                ),
                const SizedBox(height: 16),
                if (kategori.isNotEmpty) _buildChip(kategori),
                const SizedBox(height: 10),
                Text(
                  cleanArtikelText(detail.judul),
                  style: GoogleFonts.poppins(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: artikelTitle,
                    height: 1.35,
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    const Icon(Icons.calendar_today_rounded,
                        size: 12, color: artikelTeal),
                    const SizedBox(width: 4),
                    Text(
                      formatArtikelDate(
                        detail.publishDate.isNotEmpty
                            ? detail.publishDate
                            : detail.updatedAt,
                      ),
                      style: GoogleFonts.poppins(
                        color: artikelTeal,
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 18),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: artikelBorder),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.04),
                        blurRadius: 10,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: HtmlWidget(
                    detail.isi ?? '',
                    customStylesBuilder: (element) {
                      if (element.localName == 'p') {
                        return {
                          'margin': '0px 0px 8px 0px',
                          'padding': '0px',
                          'text-align': 'justify',
                          'font-size': '13.5px',
                          'line-height': '1.7',
                        };
                      }
                      if (element.localName == 'br') {
                        return {'margin': '0px', 'padding': '0px'};
                      }
                      if (element.localName == 'h2' ||
                          element.localName == 'h3') {
                        return {
                          'font-size': '16px',
                          'font-weight': 'bold',
                          'color': '#137065',
                        };
                      }
                      return null;
                    },
                    textStyle: GoogleFonts.poppins(
                      fontSize: 13.5,
                      height: 1.7,
                      color: const Color(0xFF333333),
                    ),
                  ),
                ),
                const SizedBox(height: 18),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: artikelTeal,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () => _shareDetail(result),
                    icon: const Icon(Icons.share_rounded, size: 18),
                    label: Text(
                      'Bagikan Artikel',
                      style: GoogleFonts.poppins(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                if (result.lainnya.isNotEmpty) ...[
                  const SizedBox(height: 26),
                  Text(
                    'Artikel Lainnya',
                    style: GoogleFonts.poppins(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: artikelTitle,
                    ),
                  ),
                  const SizedBox(height: 12),
                  ...result.lainnya.map(
                    (item) => ArtikelCard(
                      judul: item.judul,
                      image: item.image,
                      dateLabel: formatArtikelDate(
                        item.publishDate.isNotEmpty
                            ? item.publishDate
                            : item.updatedAt,
                      ),
                      onTap: () => context.push(
                        AppRoutes.artikelDetail.replaceFirst(':id', '${item.id}'),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildChip(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: const Color(0xFFEAF5F2),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        label,
        style: GoogleFonts.poppins(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: artikelTeal,
        ),
      ),
    );
  }

  Future<void> _shareDetail(ArtikelDetailResult result) async {
    final detail = result.detail;
    final file = await downloadAndSaveFile(
      url: detail.image,
      pathsave: '/artikel',
    );
    final shared = await SharePlus.instance.share(
      ShareParams(files: [XFile(file)], text: result.share, subject: detail.judul),
    );
    if (shared.status == ShareResultStatus.success) {
      Fluttertoast.showToast(msg: 'Berhasil dishare');
    }
  }
}
