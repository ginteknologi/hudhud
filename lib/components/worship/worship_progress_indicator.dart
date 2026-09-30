import 'package:flutter/material.dart';
import 'package:masjid_app/core/theme/hudhud_theme.dart';

class WorshipProgressIndicator extends StatelessWidget {
  const WorshipProgressIndicator({
    super.key,
    required this.currentStep,
    required this.totalSteps,
    this.labelPrefix = 'Bacaan',
    this.trailingLabel,
  });

  final int currentStep;
  final int totalSteps;
  final String labelPrefix;
  final String? trailingLabel;

  @override
  Widget build(BuildContext context) {
    final t = context.hudhud;
    final progress = totalSteps > 0
        ? (currentStep / totalSteps).clamp(0.0, 1.0)
        : 0.0;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '$labelPrefix $currentStep dari $totalSteps',
              style: TextStyle(
                fontFamily: 'Roboto',
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: t.muted,
              ),
            ),
            if (trailingLabel != null && trailingLabel!.isNotEmpty)
              Text(
                trailingLabel!,
                style: TextStyle(
                  fontFamily: 'Roboto',
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: t.terracotta,
                ),
              ),
          ],
        ),
        const SizedBox(height: 6),
        ClipRRect(
          borderRadius: BorderRadius.circular(2),
          child: LinearProgressIndicator(
            value: progress,
            minHeight: 4,
            backgroundColor: t.outline,
            valueColor: AlwaysStoppedAnimation<Color>(t.terracotta),
          ),
        ),
      ],
    );
  }
}
