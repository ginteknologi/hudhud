import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:masjid_app/core/theme/hudhud_theme.dart';

class WorshipToolbarAction {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final Color? color;
  final bool isActive;

  const WorshipToolbarAction({
    required this.icon,
    required this.label,
    required this.onTap,
    this.color,
    this.isActive = false,
  });
}

class WorshipReaderToolbar extends StatelessWidget {
  const WorshipReaderToolbar({
    super.key,
    this.onCopy,
    this.onShare,
    this.onSettings,
    this.onBookmark,
    this.isBookmarked = false,
    this.extraActions,
  });

  final VoidCallback? onCopy;
  final VoidCallback? onShare;
  final VoidCallback? onSettings;
  final VoidCallback? onBookmark;
  final bool isBookmarked;
  final List<WorshipToolbarAction>? extraActions;

  @override
  Widget build(BuildContext context) {
    final t = context.hudhud;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (extraActions != null)
          ...extraActions!.map((action) => IconButton(
                constraints: const BoxConstraints(minWidth: 48, minHeight: 48),
                icon: Icon(
                  action.icon,
                  size: 20,
                  color: action.color ?? (action.isActive ? t.terracotta : t.charcoal),
                ),
                tooltip: action.label,
                onPressed: action.onTap,
              )),
        if (onBookmark != null)
          IconButton(
            constraints: const BoxConstraints(minWidth: 48, minHeight: 48),
            icon: Icon(
              isBookmarked ? LucideIcons.bookmarkCheck : LucideIcons.bookmark,
              size: 20,
              color: isBookmarked ? t.terracotta : t.charcoal,
            ),
            tooltip: isBookmarked ? 'Hapus Simpanan' : 'Simpan',
            onPressed: onBookmark,
          ),
        if (onCopy != null)
          IconButton(
            constraints: const BoxConstraints(minWidth: 48, minHeight: 48),
            icon: Icon(LucideIcons.copy, size: 20, color: t.charcoal),
            tooltip: 'Salin Teks',
            onPressed: onCopy,
          ),
        if (onShare != null)
          IconButton(
            constraints: const BoxConstraints(minWidth: 48, minHeight: 48),
            icon: Icon(LucideIcons.share2, size: 20, color: t.charcoal),
            tooltip: 'Bagikan',
            onPressed: onShare,
          ),
        if (onSettings != null)
          IconButton(
            constraints: const BoxConstraints(minWidth: 48, minHeight: 48),
            icon: Icon(LucideIcons.type, size: 20, color: t.charcoal),
            tooltip: 'Pengaturan Teks',
            onPressed: onSettings,
          ),
      ],
    );
  }
}
