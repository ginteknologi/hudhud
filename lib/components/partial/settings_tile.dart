import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// Palet & kartu bersama untuk halaman bergaya pengaturan (Marbot, Profil,
/// Pengaturan Umum) supaya tampilannya konsisten dengan beranda.
const Color kTileAccent = Color(0xFF048C7C);
const Color kTileGold = Color(0xFFF9D576);
const Color kTileBorder = Color(0xFFE2EBE8);
const Color kTileTextDark = Color(0xFF2C3E50);
const Color kTileTextMuted = Color(0xFF7A8E88);
const Color kTilePageBg = Color(0xFFF8FAF9);

class SettingsPageHeader extends StatelessWidget {
  const SettingsPageHeader({
    super.key,
    required this.title,
    this.subtitle,
    this.leading,
  });

  final String title;
  final String? subtitle;
  final Widget? leading;

  @override
  Widget build(BuildContext context) {
    final topPadding = MediaQuery.of(context).padding.top;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light.copyWith(
        statusBarColor: Colors.transparent,
        statusBarBrightness: Brightness.dark,
        statusBarIconBrightness: Brightness.light,
      ),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.only(
          top: topPadding + 10,
          left: 14,
          right: 18,
          bottom: 16,
        ),
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF048C7C),
              Color(0xFF036F63),
              Color(0xFF02574D),
            ],
          ),
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(18),
            bottomRight: Radius.circular(18),
          ),
          boxShadow: [
            BoxShadow(
              color: Color(0x22048C7C),
              blurRadius: 10,
              offset: Offset(0, 3),
            ),
          ],
        ),
      child: Row(
        children: [
          if (leading != null) ...[leading!, const SizedBox(width: 8)],
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.3,
                  ),
                ),
                if (subtitle != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 2),
                    child: Text(
                      subtitle!,
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 11,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    ),
    );
  }
}

/// Tombol bulat di header bergaya beranda (kembali / aksi).
class SettingsHeaderButton extends StatelessWidget {
  const SettingsHeaderButton({super.key, required this.icon, this.onTap});

  final IconData icon;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: onTap,
        child: Container(
          height: 36,
          width: 36,
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.16),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, size: 20, color: Colors.white),
        ),
      ),
    );
  }
}

class SettingsSectionTitle extends StatelessWidget {
  const SettingsSectionTitle(this.title, {super.key});

  final String title;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.fromLTRB(18, 0, 18, 8),
        child: Text(
          title,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.bold,
            color: kTileTextDark,
            letterSpacing: 0.2,
          ),
        ),
      );
}

class SettingsCard extends StatelessWidget {
  const SettingsCard({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) => Container(
        margin: const EdgeInsets.symmetric(horizontal: 18),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: kTileBorder),
          boxShadow: [
            BoxShadow(
              color: kTileAccent.withValues(alpha: 0.05),
              blurRadius: 14,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: child,
      );
}

class SettingsIconBox extends StatelessWidget {
  const SettingsIconBox(this.icon, {super.key});

  final IconData icon;

  @override
  Widget build(BuildContext context) => Container(
        width: 38,
        height: 38,
        decoration: BoxDecoration(
          color: const Color(0xFFEAF5F2),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFD4EAE5), width: 0.8),
        ),
        child: Icon(icon, size: 19, color: kTileAccent),
      );
}

/// Switch dengan warna yang tegas di track aktif maupun non-aktif.
class SettingsSwitch extends StatelessWidget {
  const SettingsSwitch({super.key, required this.value, this.onChanged});

  final bool value;
  final ValueChanged<bool>? onChanged;

  @override
  Widget build(BuildContext context) => Switch(
        value: value,
        onChanged: onChanged,
        thumbColor: const WidgetStatePropertyAll(Colors.white),
        trackColor: WidgetStateProperty.resolveWith(
          (states) => states.contains(WidgetState.selected)
              ? kTileAccent
              : const Color(0xFFCBD6D2),
        ),
        trackOutlineColor:
            const WidgetStatePropertyAll(Colors.transparent),
      );
}

class SettingsSwitchRow extends StatelessWidget {
  const SettingsSwitchRow({
    super.key,
    required this.icon,
    required this.title,
    required this.value,
    this.subtitle,
    this.onChanged,
  });

  final IconData icon;
  final String title;
  final String? subtitle;
  final bool value;
  final ValueChanged<bool>? onChanged;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.fromLTRB(14, 6, 8, 6),
        child: Row(
          children: [
            SettingsIconBox(icon),
            const SizedBox(width: 12),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: kTileTextDark,
                      ),
                    ),
                    if (subtitle != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 2),
                        child: Text(
                          subtitle!,
                          style: const TextStyle(
                            fontSize: 11,
                            color: kTileTextMuted,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
            SettingsSwitch(value: value, onChanged: onChanged),
          ],
        ),
      );
}

class SettingsTapRow extends StatelessWidget {
  const SettingsTapRow({
    super.key,
    required this.icon,
    required this.title,
    this.subtitle,
    this.trailingText,
    this.trailing,
    this.onTap,
  });

  final IconData icon;
  final String title;
  final String? subtitle;
  final String? trailingText;
  final Widget? trailing;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) => Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(18),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
            child: Row(
              children: [
                SettingsIconBox(icon),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: kTileTextDark,
                        ),
                      ),
                      if (subtitle != null)
                        Padding(
                          padding: const EdgeInsets.only(top: 2),
                          child: Text(
                            subtitle!,
                            style: const TextStyle(
                              fontSize: 11,
                              color: kTileTextMuted,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                if (trailingText != null)
                  Text(
                    trailingText!,
                    style: const TextStyle(
                      fontSize: 12,
                      color: kTileTextMuted,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                if (trailing != null) trailing!,
                if (onTap != null)
                  const Icon(
                    Icons.chevron_right_rounded,
                    size: 20,
                    color: kTileTextMuted,
                  ),
              ],
            ),
          ),
        ),
      );
}

/// Deretan ikon sosial media dengan lebar terbagi rata (anti-overflow).
class SettingsSocialRow extends StatelessWidget {
  const SettingsSocialRow({
    super.key,
    required this.items,
    required this.onTap,
  });

  final List<Map<String, String>> items;
  final void Function(Map<String, String> item) onTap;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 14),
        child: Row(
          children: items.map((item) {
            return Expanded(
              child: Semantics(
                button: true,
                label: item['label'],
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(14),
                    onTap: () => onTap(item),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 6),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 42,
                            height: 42,
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: const Color(0xFFEAF5F2),
                              borderRadius: BorderRadius.circular(13),
                              border: Border.all(
                                color: const Color(0xFFD4EAE5),
                                width: 0.8,
                              ),
                            ),
                            child: SvgPicture.asset(
                              item['icon']!,
                              fit: BoxFit.contain,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            item['label']!,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 9.5,
                              fontWeight: FontWeight.w600,
                              color: kTileTextDark,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      );
}
