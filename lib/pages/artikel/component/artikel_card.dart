import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:masjid_app/pages/kajian/component/kajian_card.dart';

const Color artikelTeal = Color(0xFF048C7C);
const Color artikelTitle = Color(0xFF137065);
const Color artikelBorder = Color(0xFFE2EBE8);

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

/// Kartu artikel — [featured] = kartu besar (cover + judul di bawah),
/// selain itu baris kompak (thumbnail 68 + judul 2 baris).
/// Satu sumber visual untuk home, daftar artikel, dan "Artikel Lainnya".
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
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: artikelBorder),
        boxShadow: [
          BoxShadow(
            color: artikelTeal.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      clipBehavior: featured ? Clip.antiAlias : Clip.none,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: onTap,
          child: featured ? _featured() : _compact(),
        ),
      ),
    );
  }

  Widget _thumb(double size, {BorderRadius? radius}) {
    return ClipRRect(
      borderRadius: radius ?? BorderRadius.circular(12),
      child: SizedBox(
        width: size,
        height: size,
        child: image.isNotEmpty
            ? CachedNetworkImage(
                imageUrl: image,
                fit: BoxFit.cover,
                errorWidget: (_, __, ___) => const KajianFallbackImage(),
              )
            : const KajianFallbackImage(),
      ),
    );
  }

  Widget _meta(String label, {required IconData icon}) {
    return Row(
      children: [
        Icon(icon, size: 12, color: artikelTeal),
        const SizedBox(width: 4),
        Text(
          label,
          style: GoogleFonts.poppins(
            color: artikelTeal,
            fontSize: 11,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _featured() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 150,
          width: double.infinity,
          child: Stack(
            fit: StackFit.expand,
            children: [
              if (image.isNotEmpty)
                CachedNetworkImage(
                  imageUrl: image,
                  fit: BoxFit.cover,
                  errorWidget: (_, __, ___) => const KajianFallbackImage(),
                )
              else
                const KajianFallbackImage(),
              Positioned(
                top: 10,
                left: 10,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3.5),
                  decoration: BoxDecoration(
                    color: artikelTeal,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    'Artikel Utama',
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                cleanArtikelText(judul),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  color: artikelTitle,
                  height: 1.35,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _meta(dateLabel, icon: Icons.calendar_today_rounded),
                  Row(
                    children: [
                      Text(
                        'Baca Selengkapnya',
                        style: GoogleFonts.poppins(
                          color: artikelTeal,
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 3),
                      const Icon(
                        Icons.arrow_forward_ios_rounded,
                        size: 10,
                        color: artikelTeal,
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _compact() {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          _thumb(68),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  cleanArtikelText(judul),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                    color: const Color(0xFF2C3E50),
                    height: 1.35,
                  ),
                ),
                const SizedBox(height: 6),
                _meta(dateLabel, icon: Icons.access_time_rounded),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
