import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:masjid_app/core/theme/hudhud_theme.dart';
import 'package:masjid_app/providers/quran_settings_providers.dart';
import 'package:masjid_app/providers/quran_ui_settings_provider.dart';

class AlquranPengaturanPage extends ConsumerWidget {
  const AlquranPengaturanPage({super.key});

  static const List<Map<String, String>> _qoriList = [
    {'id': 'ar.alafasy', 'name': 'Mishari Rashid'},
    {'id': 'ar.abdurrahmaansudais', 'name': 'As-Sudais'},
    {'id': 'ar.shaatree', 'name': 'Abu Bakr Ash-Shatri'},
    {'id': 'ar.saoodshuraym', 'name': 'Sa\'ud Ash-Shuraim'},
  ];

  void _showQoriPicker(BuildContext context, WidgetRef ref, String currentId) {
    final t = context.hudhud;
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(t.radiusMd)),
      ),
      backgroundColor: t.surface,
      builder: (bottomSheetContext) {
        return Padding(
          padding: EdgeInsets.fromLTRB(t.spaceLg, t.spaceLg, t.spaceLg, t.spaceXl),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: t.outline,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              SizedBox(height: t.spaceMd),
              Text(
                'Pilih Qori Murottal',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: t.charcoal),
              ),
              SizedBox(height: t.spaceSm),
              ..._qoriList.map((qori) {
                final isSelected = qori['id'] == currentId;
                return ListTile(
                  minTileHeight: t.controlHeight,
                  title: Text(
                    qori['name']!,
                    style: TextStyle(
                      fontWeight: isSelected ? FontWeight.w700 : FontWeight.normal,
                      color: isSelected ? t.terracottaDark : t.charcoal,
                    ),
                  ),
                  trailing: isSelected
                      ? Icon(LucideIcons.circleCheck, color: t.terracotta)
                      : null,
                  onTap: () {
                    ref
                        .read(quranUiSettingsProvider.notifier)
                        .setQori(qori['id']!);
                    Navigator.of(bottomSheetContext).pop();
                  },
                );
              }),
            ],
          ),
        );
      },
    );
  }

  Widget _layout(WidgetRef ref, BuildContext context) {
    final uiSettings = ref.watch(quranUiSettingsProvider);
    final uiNotifier = ref.read(quranUiSettingsProvider.notifier);
    final t = context.hudhud;

    final currentQoriName = _qoriList.firstWhere(
      (q) => q['id'] == uiSettings.selectedQori,
      orElse: () => {'id': 'ar.alafasy', 'name': 'Mishari Rashid'},
    )['name']!;

    return SafeArea(
      top: false,
      child: SingleChildScrollView(
        physics: const ClampingScrollPhysics(),
        padding: EdgeInsets.only(bottom: t.spaceXl),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 12),
                // Section: Tampilan & Ukuran Teks
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: t.spaceLg, vertical: t.spaceSm),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AutoSizeText(
                        'Tampilan & Tipografi',
                        maxLines: 1,
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w700,
                          color: t.charcoal,
                        ),
                      ),
                      AutoSizeText(
                        "Sesuaikan ukuran teks dan terjemahan Al-Qur'an",
                        maxLines: 1,
                        style: TextStyle(
                          fontWeight: FontWeight.w300,
                          color: t.muted,
                          fontSize:
                              Theme.of(context).textTheme.bodySmall?.fontSize,
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: t.spaceLg, vertical: t.spaceSm),
                  child: Container(
                    padding: EdgeInsets.all(t.spaceMd),
                    decoration: BoxDecoration(
                      color: t.surface,
                      borderRadius: BorderRadius.circular(t.radiusMd),
                      border: Border.all(color: t.outline),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Live Preview
                        Container(
                          width: double.infinity,
                          padding: EdgeInsets.all(t.spaceMd),
                          decoration: BoxDecoration(
                            color: t.sand,
                            borderRadius: BorderRadius.circular(t.radiusSm),
                            border: Border.all(color: t.outline),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Text(
                                "بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ",
                                textAlign: TextAlign.right,
                                textDirection: TextDirection.rtl,
                                style: TextStyle(
                                  fontFamily: GoogleFonts.amiriQuran().fontFamily,
                                  fontSize: uiSettings.arabicFontSize,
                                  fontWeight: FontWeight.bold,
                                  color: t.charcoal,
                                ),
                              ),
                              if (uiSettings.showLatin) ...[
                                const SizedBox(height: 6),
                                Text(
                                  "Bismillāhir-raḥmānir-raḥīm",
                                  style: TextStyle(
                                    fontSize: uiSettings.translationFontSize,
                                    fontStyle: FontStyle.italic,
                                    color: t.terracotta,
                                  ),
                                ),
                              ],
                              if (uiSettings.showTranslation) ...[
                                const SizedBox(height: 4),
                                Text(
                                  "Dengan nama Allah Yang Maha Pengasih, Maha Penyayang.",
                                  style: TextStyle(
                                    fontSize: uiSettings.translationFontSize,
                                    color: t.charcoal,
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                        const SizedBox(height: 14),

                        // Slider Font Arab
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text("Ukuran Huruf Arab",
                                style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                            Text("${uiSettings.arabicFontSize.toInt()} px",
                                style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w700,
                                    color: t.terracottaDark)),
                          ],
                        ),
                        Slider(
                          value: uiSettings.arabicFontSize,
                          min: 18.0,
                          max: 36.0,
                          divisions: 9,
                          activeColor: t.terracotta,
                          onChanged: (val) =>
                              uiNotifier.updateArabicFontSize(val),
                        ),

                        // Slider Font Terjemahan
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text("Ukuran Teks Terjemahan",
                                style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                            Text("${uiSettings.translationFontSize.toInt()} px",
                                style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w700,
                                    color: t.terracottaDark)),
                          ],
                        ),
                        Slider(
                          value: uiSettings.translationFontSize,
                          min: 11.0,
                          max: 20.0,
                          divisions: 9,
                          activeColor: t.terracotta,
                          onChanged: (val) =>
                              uiNotifier.updateTranslationFontSize(val),
                        ),

                        // Switch Toggles
                        SwitchListTile(
                          contentPadding: EdgeInsets.zero,
                          activeThumbColor: t.surface,
                          activeTrackColor: t.terracotta,
                          inactiveThumbColor: t.surface,
                          inactiveTrackColor: t.outline,
                          trackOutlineColor:
                              const WidgetStatePropertyAll(Colors.transparent),
                          title: Text('Tampilkan Transliterasi Latin',
                              style: TextStyle(color: t.charcoal)),
                          value: uiSettings.showLatin,
                          onChanged: (val) => uiNotifier.toggleLatin(val),
                        ),
                        SwitchListTile(
                          contentPadding: EdgeInsets.zero,
                          activeThumbColor: t.surface,
                          activeTrackColor: t.terracotta,
                          inactiveThumbColor: t.surface,
                          inactiveTrackColor: t.outline,
                          trackOutlineColor:
                              const WidgetStatePropertyAll(Colors.transparent),
                          title: Text('Tampilkan Terjemahan',
                              style: TextStyle(color: t.charcoal)),
                          value: uiSettings.showTranslation,
                          onChanged: (val) => uiNotifier.toggleTranslation(val),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 10),

                _sectionHeading(context, t, 'Umum & Audio', 'Pilihan qori dan audio murottal'),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: t.spaceLg, vertical: t.spaceSm),
                  child: Container(
                    constraints: BoxConstraints(minHeight: t.controlHeight),
                    padding: EdgeInsets.all(t.spaceMd),
                    decoration: BoxDecoration(
                      color: t.surface,
                      borderRadius: BorderRadius.circular(t.radiusMd),
                      border: Border.all(color: t.outline),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text('Qori Murottal', style: TextStyle(fontWeight: FontWeight.w700, color: t.charcoal)),
                              SizedBox(height: t.spaceXs),
                              Text('Pelafal audio saat memutar ayat', style: TextStyle(color: t.muted)),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        Material(
                          color: t.sand,
                          borderRadius: BorderRadius.circular(t.radiusSm),
                          child: InkWell(
                            onTap: () => _showQoriPicker(context, ref, uiSettings.selectedQori),
                            borderRadius: BorderRadius.circular(t.radiusSm),
                            child: ConstrainedBox(
                              constraints: BoxConstraints(minHeight: t.controlHeight),
                              child: Padding(
                                padding: EdgeInsets.symmetric(horizontal: t.spaceSm),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    ConstrainedBox(
                                      constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * .34),
                                      child: Text(currentQoriName, maxLines: 1, overflow: TextOverflow.ellipsis,
                                        style: TextStyle(fontWeight: FontWeight.w600, color: t.terracottaDark)),
                                    ),
                                    SizedBox(width: t.spaceXs),
                                    Icon(LucideIcons.chevronDown, size: 18, color: t.terracotta),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                _sectionHeading(context, t, 'Quran Media', 'Unduh data untuk penggunaan tanpa internet'),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: t.spaceLg, vertical: t.spaceSm),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Mushaf', style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700, color: t.charcoal)),
                      SizedBox(height: t.spaceSm),
                      _mediaCard(t,
                        icon: LucideIcons.bookOpen,
                        title: 'Mushaf Standar Indonesia',
                        trailing: Icon(LucideIcons.circleCheck, color: t.success),
                      ),
                      SizedBox(height: t.spaceSm),
                      _mediaCard(t,
                        icon: LucideIcons.bookOpen,
                        title: 'Mushaf Indonesia Tajwid',
                        trailing: _mediaAction(t, 'Unduh mushaf tajwid', LucideIcons.download, () async {
                          _showPopup(context);
                          ref.read(quranDownloadProvider.notifier).downloadFile('tajwid');
                        }),
                      ),
                      SizedBox(height: t.spaceSm),
                      _mediaCard(t,
                        icon: LucideIcons.bookOpen,
                        title: 'Mushaf Madinah',
                        trailing: _mediaAction(t, 'Unduh mushaf madinah', LucideIcons.download, () async {
                          _showPopup(context);
                          ref.read(quranDownloadProvider.notifier).downloadFile('madinah');
                        }),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: t.spaceLg, vertical: t.spaceSm),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Murottal', style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700, color: t.charcoal)),
                      SizedBox(height: t.spaceSm),
                      Container(
                        constraints: BoxConstraints(minHeight: t.controlHeight),
                        padding: EdgeInsets.all(t.spaceSm),
                        decoration: BoxDecoration(
                          color: t.surface,
                          borderRadius: BorderRadius.circular(t.radiusMd),
                          border: Border.all(color: t.outline),
                        ),
                        child: Row(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(t.radiusSm),
                              child: Image.asset('assets/img/murotal/mishari.jpg', height: 64, width: 64, fit: BoxFit.cover),
                            ),
                            SizedBox(width: t.spaceMd),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text('Mishari Alafasy', style: TextStyle(fontWeight: FontWeight.w700, color: t.charcoal)),
                                  SizedBox(height: t.spaceXs),
                                  Text('Mishari bin Rashed Alafasy', style: TextStyle(color: t.muted)),
                                ],
                              ),
                            ),
                          ],
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

  Widget _sectionHeading(BuildContext context, HudhudTheme t, String title, String subtitle) {
    return Padding(
      padding: EdgeInsets.fromLTRB(t.spaceLg, t.spaceMd, t.spaceLg, t.spaceSm),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700, color: t.charcoal)),
          SizedBox(height: t.spaceXs),
          Text(subtitle, style: Theme.of(context).textTheme.bodySmall?.copyWith(color: t.muted)),
        ],
      ),
    );
  }

  Widget _mediaCard(HudhudTheme t, {required IconData icon, required String title, required Widget trailing}) {
    return Container(
      constraints: BoxConstraints(minHeight: t.controlHeight),
      padding: EdgeInsets.symmetric(horizontal: t.spaceMd),
      decoration: BoxDecoration(
        color: t.surface,
        borderRadius: BorderRadius.circular(t.radiusMd),
        border: Border.all(color: t.outline),
      ),
      child: Row(
        children: [
          Icon(icon, size: 20, color: t.terracotta),
          SizedBox(width: t.spaceSm),
          Expanded(child: Text(title, style: TextStyle(color: t.charcoal, fontWeight: FontWeight.w600))),
          trailing,
        ],
      ),
    );
  }

  Widget _mediaAction(HudhudTheme t, String label, IconData icon, VoidCallback onPressed) {
    return IconButton(
      constraints: BoxConstraints.tightFor(width: t.controlHeight, height: t.controlHeight),
      tooltip: label,
      onPressed: onPressed,
      icon: Icon(icon, color: t.terracotta),
    );
  }

  void _showPopup(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (dialogContext) => Consumer(
        builder: (context, consumerRef, _) {
          final state = consumerRef.watch(quranDownloadProvider);
          final t = dialogContext.hudhud;
          return AlertDialog(
            backgroundColor: t.surface,
            surfaceTintColor: Colors.transparent,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(t.radiusMd)),
            title: Text('Mengunduh mushaf', style: TextStyle(color: t.charcoal, fontWeight: FontWeight.w700)),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                LinearProgressIndicator(
                  borderRadius: BorderRadius.circular(t.radiusSm),
                  color: t.terracotta,
                  backgroundColor: t.outline,
                  value: state.progresDownload,
                ),
                SizedBox(height: t.spaceSm),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('${state.totalTerDownload}/604', style: TextStyle(color: t.muted)),
                    Text('${state.persenDownload}%', style: TextStyle(color: t.charcoal, fontWeight: FontWeight.w600)),
                  ],
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  if (state.paused) {
                    consumerRef.read(quranDownloadProvider.notifier).resumeDownload();
                  } else {
                    consumerRef.read(quranDownloadProvider.notifier).pauseDownload();
                  }
                },
                child: Text(state.paused ? 'Lanjutkan' : 'Jeda', style: TextStyle(color: t.terracottaDark)),
              ),
            ],
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = context.hudhud;
    return Scaffold(
      backgroundColor: t.sand,
      appBar: AppBar(
        title: const Text("Pengaturan Al-Qur'an"),
        leading: IconButton(
          constraints: const BoxConstraints.tightFor(width: 48, height: 48),
          tooltip: 'Kembali',
          onPressed: () => Navigator.of(context).maybePop(),
          icon: const Icon(LucideIcons.arrowLeft),
        ),
      ),
      body: ref.watch(quranDownloadProvider).isLoadingList
          ? Center(child: CircularProgressIndicator(color: t.terracotta))
          : _layout(ref, context),
    );
  }
}
