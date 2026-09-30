import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:masjid_app/core/theme/hudhud_theme.dart';

class HudhudSectionHeader extends StatelessWidget {
  const HudhudSectionHeader(
      {super.key, required this.title, this.actionLabel, this.onAction});

  final String title;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) => Row(
        children: [
          Expanded(
              child:
                  Text(title, style: Theme.of(context).textTheme.titleMedium)),
          if (actionLabel != null)
            TextButton(onPressed: onAction, child: Text(actionLabel!)),
        ],
      );
}

class HudhudActionRow extends StatelessWidget {
  const HudhudActionRow({
    super.key,
    required this.icon,
    required this.title,
    this.subtitle,
    this.trailing,
    this.onTap,
  });

  final IconData icon;
  final String title;
  final String? subtitle;
  final Widget? trailing;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final t = context.hudhud;
    return Semantics(
      button: onTap != null,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(t.radiusMd),
        child: ConstrainedBox(
          constraints: const BoxConstraints(minHeight: 56),
          child: Padding(
            padding: EdgeInsets.symmetric(
                horizontal: t.spaceMd, vertical: t.spaceSm),
            child: Row(
              children: [
                Icon(icon, color: t.terracotta, size: 22),
                SizedBox(width: t.spaceMd),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(title,
                          style: Theme.of(context).textTheme.titleSmall),
                      if (subtitle != null) ...[
                        const SizedBox(height: 2),
                        Text(subtitle!,
                            style: Theme.of(context).textTheme.bodySmall),
                      ],
                    ],
                  ),
                ),
                trailing ??
                    Icon(LucideIcons.chevronRight, color: t.muted, size: 19),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class HudhudServiceItem extends StatelessWidget {
  const HudhudServiceItem({
    super.key,
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final t = context.hudhud;
    return Semantics(
      button: true,
      label: 'Buka $label',
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(t.radiusMd),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: t.spaceSm),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: t.terracotta.withValues(alpha: .1),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: t.terracottaDark, size: 24),
              ),
              SizedBox(height: t.spaceSm),
              Text(label,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      color: t.charcoal, fontWeight: FontWeight.w600)),
            ],
          ),
        ),
      ),
    );
  }
}

class HudhudStatusChip extends StatelessWidget {
  const HudhudStatusChip({super.key, required this.label, this.icon});

  final String label;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    final t = context.hudhud;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: t.spaceMd, vertical: t.spaceSm),
      decoration: BoxDecoration(
        color: t.amber.withValues(alpha: .18),
        borderRadius: BorderRadius.circular(t.radiusMd),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, color: t.charcoal, size: 14),
            SizedBox(width: t.spaceXs)
          ],
          Flexible(
              child:
                  Text(label, style: Theme.of(context).textTheme.labelMedium)),
        ],
      ),
    );
  }
}

class HudhudIconButton extends StatelessWidget {
  const HudhudIconButton(
      {super.key,
      required this.icon,
      required this.tooltip,
      required this.onPressed});

  final IconData icon;
  final String tooltip;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) => IconButton(
        constraints: const BoxConstraints.tightFor(width: 48, height: 48),
        tooltip: tooltip,
        onPressed: onPressed,
        icon: Icon(icon),
      );
}

class HudhudStateView extends StatelessWidget {
  const HudhudStateView({
    super.key,
    required this.icon,
    required this.title,
    required this.message,
    this.actionLabel,
    this.onAction,
  });

  final IconData icon;
  final String title;
  final String message;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) => Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 34, color: context.hudhud.terracotta),
              const SizedBox(height: 12),
              Text(title,
                  style: Theme.of(context).textTheme.titleMedium,
                  textAlign: TextAlign.center),
              const SizedBox(height: 6),
              Text(message,
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium
                      ?.copyWith(color: context.hudhud.muted),
                  textAlign: TextAlign.center),
              if (actionLabel != null) ...[
                const SizedBox(height: 16),
                FilledButton(onPressed: onAction, child: Text(actionLabel!)),
              ],
            ],
          ),
        ),
      );
}
