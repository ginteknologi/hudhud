import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:masjid_app/core/router/app_router.dart';
import 'package:masjid_app/core/theme/hudhud_theme.dart';
import 'package:masjid_app/providers/hadits_providers.dart';

class HaditsLastReadCard extends ConsumerWidget {
  const HaditsLastReadCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = context.hudhud;
    final entries = ref.watch(haditsBookmarkProvider);
    final bookmark = entries.isEmpty ? null : entries.first;
    final hasBookmark = bookmark != null && bookmark.isValid;

    final title = hasBookmark ? bookmark.longNama : "Hadits Arba'in An-Nawawiyah";
    final detail = hasBookmark
        ? 'Hadits No. ${bookmark.noHdt}'
            '${(bookmark.babIndonesia ?? '').isNotEmpty ? ' • ${bookmark.babIndonesia}' : ''}'
        : 'Mulai pelajari 42 hadits pokok Rasulullah SAW';

    return Container(
      decoration: BoxDecoration(
        color: t.surface,
        borderRadius: BorderRadius.circular(t.radiusMd),
        border: Border.all(color: t.outline),
      ),
      padding: EdgeInsets.all(t.spaceLg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    LucideIcons.bookmarkCheck,
                    size: 16,
                    color: t.terracotta,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    hasBookmark ? 'Terakhir Dibaca' : 'Rekomendasi Baca',
                    style: TextStyle(
                      fontFamily: 'Roboto',
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: t.terracotta,
                    ),
                  ),
                ],
              ),
              if (hasBookmark)
                IconButton(
                  constraints: const BoxConstraints(minWidth: 48, minHeight: 48),
                  icon: Icon(LucideIcons.trash2, size: 16, color: t.muted),
                  tooltip: 'Hapus Riwayat',
                  onPressed: () {
                    ref.read(haditsBookmarkProvider.notifier).clearAll();
                    Fluttertoast.showToast(
                      msg: 'Riwayat dibaca dibersihkan',
                      backgroundColor: const Color(0xFFD06A4C),
                      textColor: Colors.white,
                    );
                  },
                ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontFamily: 'Roboto',
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: t.charcoal,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            detail,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontFamily: 'Roboto',
              fontSize: 13,
              color: t.muted,
            ),
          ),
          const SizedBox(height: 14),
          FilledButton.icon(
            onPressed: () => context.push(
              hasBookmark
                  ? '${AppRoutes.haditsListRoute.replaceFirst(':id', bookmark.namaTabel)}?mulai=${bookmark.noHdt}'
                  : AppRoutes.haditsListRoute.replaceFirst(':id', 'arbain'),
            ),
            style: FilledButton.styleFrom(
              minimumSize: Size(double.infinity, t.controlHeight),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(t.radiusMd),
              ),
            ),
            icon: const Icon(LucideIcons.arrowRight, size: 16),
            label: Text(hasBookmark ? 'Lanjutkan Baca' : 'Mulai Baca'),
          ),
        ],
      ),
    );
  }
}
