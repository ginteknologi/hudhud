import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:masjid_app/components/hudhud_ui.dart';
import 'package:masjid_app/configs/file_setup.dart';
import 'package:masjid_app/core/router/app_router.dart';
import 'package:masjid_app/core/theme/hudhud_theme.dart';
import 'package:masjid_app/pages/artikel/component/artikel_card.dart';
import 'package:masjid_app/providers/artikel_provider.dart';
import 'package:share_plus/share_plus.dart';

class DetailArtikelPage extends ConsumerWidget {
  const DetailArtikelPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = context.hudhud;
    final id =
        int.tryParse(GoRouterState.of(context).pathParameters['id'] ?? '') ?? 0;
    final detailAsync = ref.watch(artikelDetailProvider(id));

    return Scaffold(
      backgroundColor: t.sand,
      appBar: AppBar(title: const Text('Artikel')),
      body: SafeArea(
        child: detailAsync.when(
          data: (result) => result.detail.judul.isEmpty
              ? _missing(context)
              : _body(context, result),
          loading: () => Center(
            child: CircularProgressIndicator(color: t.terracotta),
          ),
          error: (_, __) => _missing(context),
        ),
      ),
    );
  }

  Widget _missing(BuildContext context) => HudhudStateView(
        icon: LucideIcons.newspaper,
        title: 'Artikel tidak ditemukan',
        message: 'Artikel mungkin sudah tidak tersedia.',
      );

  Widget _body(BuildContext context, ArtikelDetailResult result) {
    final t = context.hudhud;
    final detail = result.detail;
    final category = (detail.categoryArtikel?['nama'] ??
            detail.categoryArtikel?['name'] ??
            '')
        .toString();

    return SingleChildScrollView(
      physics:
          const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
      padding: EdgeInsets.fromLTRB(t.spaceLg, t.spaceMd, t.spaceLg, t.spaceXl),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(t.radiusMd),
            child: AspectRatio(
              aspectRatio: 16 / 9,
              child: detail.image.isNotEmpty
                  ? CachedNetworkImage(
                      imageUrl: detail.image,
                      fit: BoxFit.cover,
                      errorWidget: (_, __, ___) => const ArtikelFallbackImage(),
                    )
                  : const ArtikelFallbackImage(),
            ),
          ),
          SizedBox(height: t.spaceMd),
          if (category.isNotEmpty) ...[
            Container(
              constraints: BoxConstraints(minHeight: t.controlHeight),
              alignment: Alignment.centerLeft,
              child: Container(
                padding: EdgeInsets.symmetric(
                    horizontal: t.spaceSm, vertical: t.spaceXs),
                decoration: BoxDecoration(
                  color: t.surface,
                  borderRadius: BorderRadius.circular(t.radiusSm),
                  border: Border.all(color: t.outline),
                ),
                child: Text(
                  category,
                  style: TextStyle(
                      fontFamily: 'Roboto',
                      color: t.terracottaDark,
                      fontWeight: FontWeight.w600),
                ),
              ),
            ),
            SizedBox(height: t.spaceSm),
          ],
          Text(
            cleanArtikelText(detail.judul),
            style: TextStyle(
              fontFamily: 'Roboto',
              fontSize: 20,
              fontWeight: FontWeight.w700,
              height: 1.35,
              color: t.charcoal,
            ),
          ),
          SizedBox(height: t.spaceSm),
          Row(
            children: [
              Icon(LucideIcons.calendarDays, size: 16, color: t.muted),
              SizedBox(width: t.spaceXs),
              Text(
                formatArtikelDate(detail.publishDate.isNotEmpty
                    ? detail.publishDate
                    : detail.updatedAt),
                style: TextStyle(fontFamily: 'Roboto', color: t.muted),
              ),
            ],
          ),
          SizedBox(height: t.spaceMd),
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(t.spaceMd),
            decoration: BoxDecoration(
              color: t.surface,
              borderRadius: BorderRadius.circular(t.radiusMd),
              border: Border.all(color: t.outline),
            ),
            child: HtmlWidget(
              detail.isi ?? '',
              customStylesBuilder: (element) {
                if (element.localName == 'p') {
                  return {
                    'margin': '0 0 8px 0',
                    'text-align': 'justify',
                    'line-height': '1.7'
                  };
                }
                if (element.localName == 'h2' || element.localName == 'h3') {
                  return {
                    'font-size': '1.2em',
                    'font-weight': 'bold',
                    'color':
                        '#${t.terracottaDark.toARGB32().toRadixString(16).substring(2)}',
                  };
                }
                return null;
              },
              textStyle: TextStyle(
                fontFamily: 'Roboto',
                fontSize: 15,
                height: 1.7,
                color: t.charcoal,
              ),
            ),
          ),
          SizedBox(height: t.spaceMd),
          SizedBox(
            width: double.infinity,
            child: FilledButton.icon(
              style: FilledButton.styleFrom(
                minimumSize: Size(0, t.controlHeight),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(t.radiusMd)),
              ),
              onPressed: () => _shareDetail(result),
              icon: const Icon(LucideIcons.share2, size: 18),
              label: const Text('Bagikan Artikel'),
            ),
          ),
          if (result.lainnya.isNotEmpty) ...[
            SizedBox(height: t.spaceXl),
            Text('Artikel Lainnya',
                style: Theme.of(context).textTheme.titleMedium),
            SizedBox(height: t.spaceSm),
            ...result.lainnya.map(
              (item) => ArtikelCard(
                judul: item.judul,
                image: item.image,
                dateLabel: formatArtikelDate(item.publishDate.isNotEmpty
                    ? item.publishDate
                    : item.updatedAt),
                onTap: () => context.push(
                    AppRoutes.artikelDetail.replaceFirst(':id', '${item.id}')),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Future<void> _shareDetail(ArtikelDetailResult result) async {
    final detail = result.detail;
    final file =
        await downloadAndSaveFile(url: detail.image, pathsave: '/artikel');
    final shared = await SharePlus.instance.share(
      ShareParams(
          files: [XFile(file)], text: result.share, subject: detail.judul),
    );
    if (shared.status == ShareResultStatus.success) {
      Fluttertoast.showToast(msg: 'Berhasil dishare');
    }
  }
}
