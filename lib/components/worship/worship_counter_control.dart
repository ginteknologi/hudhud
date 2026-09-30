import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:masjid_app/core/theme/hudhud_theme.dart';

class WorshipCounterControl extends StatelessWidget {
  const WorshipCounterControl({
    super.key,
    required this.count,
    required this.target,
    required this.onTap,
  });

  final int count;
  final int target;
  final VoidCallback onTap;

  bool get isCompleted => count >= target && target > 0;

  @override
  Widget build(BuildContext context) {
    final t = context.hudhud;

    return Semantics(
      button: true,
      label: isCompleted
          ? 'Selesai $count dari $target kali. Ketuk untuk mengulang.'
          : 'Hitung dzikir $count dari $target kali.',
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(t.radiusMd),
          onTap: () {
            if (isCompleted) {
              HapticFeedback.selectionClick();
            } else if (count + 1 >= target) {
              HapticFeedback.mediumImpact();
            } else {
              HapticFeedback.lightImpact();
            }
            onTap();
          },
          child: AnimatedContainer(
            duration: t.motionNormal,
            constraints: BoxConstraints(
              minHeight: t.controlHeight,
              minWidth: 120,
            ),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            decoration: BoxDecoration(
              color: isCompleted ? t.success.withValues(alpha: 0.12) : t.surface,
              borderRadius: BorderRadius.circular(t.radiusMd),
              border: Border.all(
                color: isCompleted ? t.success : t.outline,
                width: isCompleted ? 1.5 : 1,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (isCompleted) ...[
                  Icon(LucideIcons.circleCheck, size: 20, color: t.success),
                  const SizedBox(width: 8),
                  Text(
                    'Selesai ($count/$target)',
                    style: TextStyle(
                      fontFamily: 'Roboto',
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: t.success,
                    ),
                  ),
                ] else ...[
                  Icon(LucideIcons.fingerprint, size: 20, color: t.terracotta),
                  const SizedBox(width: 8),
                  Text(
                    '$count',
                    style: TextStyle(
                      fontFamily: 'Roboto',
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: t.terracotta,
                    ),
                  ),
                  Text(
                    ' / $target',
                    style: TextStyle(
                      fontFamily: 'Roboto',
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: t.muted,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
