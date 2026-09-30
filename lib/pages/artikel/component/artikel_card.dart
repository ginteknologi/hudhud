import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:masjid_app/core/theme/hudhud_theme.dart';

/// Bersihkan HTML dari judul artikel (backend mengirim judul ber-tag).
String cleanArtikelText(String text) {
  if (text.isEmpty) return '';
  return text
      .replaceAll(RegExp(r'<br\s*/?>', caseSensitive: false), ' ')
      .replaceAll(RegExp(r'</?p>', caseSensitive: false), ' ')
      .replaceAll(RegExp(r'<[^>]*>'), '')
      .replaceAll('&nbsp;', ' ')
      .replaceAll('&amp;', '&')
      .replaceAll('&quot;', '"')
      .replaceAll('&apos;', "'")
      .replaceAll('&#39;', "'")
      .replaceAll('&lt;', '<')
      .replaceAll('&gt;', '>')
      .replaceAll(RegExp(r'\s+'), ' ')
      .trim();
}

/// 'yyyy-MM-dd HH:mm:ss' → 'd MMMM yyyy'. Stempel dari DB sudah WIB, tanpa geser jam.
String formatArtikelDate(String raw) {
  if (raw.isEmpty) return '';
  final dt = DateTime.tryParse(raw);
  if (dt == null) return raw;
  try {
    return DateFormat('d MMMM yyyy', 'id_ID').format(dt);
  } catch (_) {
    return DateFormat('d MMMM yyyy').format(dt);
  }
}

/// Kartu artikel — featured menampilkan cover besar, lainnya thumbnail ringkas.
class ArtikelCard extends StatelessWidget {
  const ArtikelCard({
    super.key,
    required this.judul,
    required this.image,
    required this.dateLabel,
    this.featured = false,
    this.onTap,
  });

  final String judul;
  final String image;
  final String dateLabel;
  final bool featured;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final t = context.hudhud;
    return Container(
      margin: EdgeInsets.only(bottom: t.spaceMd),
      decoration: BoxDecoration(
        color: t.surface,
        borderRadius: BorderRadius.circular(t.radiusMd),
        border: Border.all(color: t.outline),
      ),
      clipBehavior: Clip.antiAlias,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(t.radiusMd),
          onTap: onTap,
          child: featured ? _featured(context) : _compact(context),
        ),
      ),
    );
  }

  Widget _thumb(BuildContext context, double size) {
    final t = context.hudhud;
    return ClipRRect(
      borderRadius: BorderRadius.circular(t.radiusSm),
      child: SizedBox(
        width: size,
        height: size,
        child: image.isNotEmpty
            ? CachedNetworkImage(
                imageUrl: image,
                fit: BoxFit.cover,
                errorWidget: (_, __, ___) => const ArtikelFallbackImage(),
              )
            : const ArtikelFallbackImage(),
      ),
    );
  }

  Widget _meta(BuildContext context, String label, {required IconData icon}) {
    final t = context.hudhud;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: t.muted),
        const SizedBox(width: 5),
        Flexible(
          child: Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontFamily: 'Roboto',
              fontSize: 11,
              color: t.muted,
            ),
          ),
        ),
      ],
    );
  }

  Widget _featured(BuildContext context) {
    final t = context.hudhud;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 160,
          width: double.infinity,
          child: Stack(
            fit: StackFit.expand,
            children: [
              if (image.isNotEmpty)
                CachedNetworkImage(
                  imageUrl: image,
                  fit: BoxFit.cover,
                  errorWidget: (_, __, ___) => const ArtikelFallbackImage(),
                )
              else
                const ArtikelFallbackImage(),
              Positioned(
                top: 10,
                left: 10,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                  decoration: BoxDecoration(
                    color: t.surface,
                    borderRadius: BorderRadius.circular(t.radiusSm),
                  ),
                  child: Text(
                    'Artikel Utama',
                    style: TextStyle(
                      fontFamily: 'Roboto',
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: t.terracotta,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.all(t.spaceMd),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                cleanArtikelText(judul),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontFamily: 'Roboto',
                  fontWeight: FontWeight.w700,
                  fontSize: 15,
                  color: t.charcoal,
                  height: 1.35,
                ),
              ),
              SizedBox(height: t.spaceSm),
              Wrap(
                spacing: t.spaceSm,
                runSpacing: t.spaceXs,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  _meta(context, dateLabel, icon: LucideIcons.calendarDays),
                  Text(
                    'Baca selengkapnya',
                    style: TextStyle(
                      fontFamily: 'Roboto',
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: t.terracotta,
                    ),
                  ),
                  Icon(LucideIcons.arrowRight, size: 14, color: t.terracotta),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _compact(BuildContext context) {
    final t = context.hudhud;
    return Padding(
      padding: EdgeInsets.all(t.spaceSm),
      child: Row(
        children: [
          _thumb(context, 72),
          SizedBox(width: t.spaceMd),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  cleanArtikelText(judul),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontFamily: 'Roboto',
                    fontWeight: FontWeight.w700,
                    fontSize: 13,
                    color: t.charcoal,
                    height: 1.35,
                  ),
                ),
                SizedBox(height: t.spaceXs),
                _meta(context, dateLabel, icon: LucideIcons.clock3),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ArtikelFallbackImage extends StatelessWidget {
  const ArtikelFallbackImage({super.key});

  @override
  Widget build(BuildContext context) {
    final t = context.hudhud;
    return Container(
      color: t.sand,
      child: Center(
        child: Icon(LucideIcons.newspaper, size: 44, color: t.terracotta),
      ),
    );
  }
}
