import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:masjid_app/models/kajian_model.dart';

/// Bersihkan teks kajian dari tag HTML & entitas (data dari backend bisa mentah).
String cleanKajianText(String text) {
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

/// Kartu kajian gaya home (thumbnail + gradient + badge + play).
/// `width`/`height` null = ikut constraint induk (dipakai grid).
class KajianCard extends StatelessWidget {
  const KajianCard({
    super.key,
    required this.item,
    required this.tag,
    required this.badgeColor,
    this.onTap,
    this.width = 215,
    this.height = 140,
  });

  final KajianModel? item; // null = placeholder (skeleton / data kosong)
  final String tag;
  final Color badgeColor;
  final VoidCallback? onTap;
  final double? width;
  final double? height;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      margin: width == null ? null : const EdgeInsets.only(right: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2EBE8), width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          child: Stack(
            fit: StackFit.expand,
            children: [
              if (item?.image.isNotEmpty == true)
                CachedNetworkImage(
                  imageUrl: item!.image,
                  fit: BoxFit.cover,
                  errorWidget: (_, __, ___) => const KajianFallbackImage(),
                )
              else
                const KajianFallbackImage(),

              // Gradient overlay untuk keterbacaan teks
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black.withValues(alpha: 0.25),
                      Colors.transparent,
                      Colors.black.withValues(alpha: 0.85),
                    ],
                  ),
                ),
              ),

              // Badge pojok kiri atas
              Positioned(
                top: 10,
                left: 10,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 3.5,
                  ),
                  decoration: BoxDecoration(
                    color: badgeColor,
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.2),
                        blurRadius: 4,
                      ),
                    ],
                  ),
                  child: Text(
                    tag,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.3,
                    ),
                  ),
                ),
              ),

              // Play button tengah
              Center(
                child: Container(
                  height: 36,
                  width: 36,
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.45),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.7),
                      width: 1.5,
                    ),
                  ),
                  child: const Icon(
                    Icons.play_arrow_rounded,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
              ),

              // Judul + ustadz
              Positioned(
                left: 10,
                right: 10,
                bottom: 10,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      cleanKajianText(item?.judul ?? '').isEmpty
                          ? 'Kajian Masjid'
                          : cleanKajianText(item!.judul),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      item != null && item!.ustadz.isNotEmpty
                          ? cleanKajianText(item!.ustadz)
                          : (cleanKajianText(item?.subjudul ?? '').isNotEmpty
                              ? cleanKajianText(item!.subjudul)
                              : 'Masjid An-Ni’mah'),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Color(0xFFF9D576),
                        fontSize: 10.5,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class KajianFallbackImage extends StatelessWidget {
  const KajianFallbackImage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF0D6357),
            Color(0xFF1E8D7F),
          ],
        ),
      ),
      child: Center(
        child: Opacity(
          opacity: 0.25,
          child: Image.asset(
            'assets/icons/app_icon.png',
            height: 60,
            width: 60,
          ),
        ),
      ),
    );
  }
}
