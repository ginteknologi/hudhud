import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:masjid_app/components/layout/app_bar_ws.dart';
import 'package:masjid_app/components/partial/list_ui.dart';
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
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      backgroundColor: Colors.white,
      builder: (bottomSheetContext) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                "Pilih Qori Murottal",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              ..._qoriList.map((qori) {
                final isSelected = qori['id'] == currentId;
                return ListTile(
                  title: Text(
                    qori['name']!,
                    style: TextStyle(
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      color: isSelected ? const Color(0xFFD06A4C) : Colors.black87,
                    ),
                  ),
                  trailing: isSelected
                      ? const Icon(Icons.check_circle_rounded,
                          color: Color(0xFFD06A4C))
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

    final currentQoriName = _qoriList.firstWhere(
      (q) => q['id'] == uiSettings.selectedQori,
      orElse: () => {'id': 'ar.alafasy', 'name': 'Mishari Rashid'},
    )['name']!;

    return SafeArea(
      top: false,
      child: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: SingleChildScrollView(
            physics: const ClampingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                // Section: Tampilan & Ukuran Teks
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 21, vertical: 6),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AutoSizeText(
                        "Tampilan & Tipografi",
                        maxLines: 1,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                          fontSize:
                              Theme.of(context).textTheme.titleSmall?.fontSize,
                        ),
                      ),
                      AutoSizeText(
                        "Sesuaikan ukuran teks dan terjemahan Al-Qur'an",
                        maxLines: 1,
                        style: TextStyle(
                          fontWeight: FontWeight.w300,
                          color: const Color(0xFF929292),
                          fontSize:
                              Theme.of(context).textTheme.bodySmall?.fontSize,
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 21, vertical: 10),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Live Preview
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF8FAF9),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: const Color(0xFFE2E8F0)),
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
                                  color: const Color(0xFF1E293B),
                                ),
                              ),
                              if (uiSettings.showLatin) ...[
                                const SizedBox(height: 6),
                                Text(
                                  "Bismillāhir-raḥmānir-raḥīm",
                                  style: TextStyle(
                                    fontSize: uiSettings.translationFontSize,
                                    fontStyle: FontStyle.italic,
                                    color: const Color(0xFFD06A4C),
                                  ),
                                ),
                              ],
                              if (uiSettings.showTranslation) ...[
                                const SizedBox(height: 4),
                                Text(
                                  "Dengan nama Allah Yang Maha Pengasih, Maha Penyayang.",
                                  style: TextStyle(
                                    fontSize: uiSettings.translationFontSize,
                                    color: Colors.black87,
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
                                style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFFD06A4C))),
                          ],
                        ),
                        Slider(
                          value: uiSettings.arabicFontSize,
                          min: 18.0,
                          max: 36.0,
                          divisions: 9,
                          activeColor: const Color(0xFFD06A4C),
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
                                style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFFD06A4C))),
                          ],
                        ),
                        Slider(
                          value: uiSettings.translationFontSize,
                          min: 11.0,
                          max: 20.0,
                          divisions: 9,
                          activeColor: const Color(0xFFD06A4C),
                          onChanged: (val) =>
                              uiNotifier.updateTranslationFontSize(val),
                        ),

                        // Switch Toggles
                        SwitchListTile(
                          contentPadding: EdgeInsets.zero,
                          activeThumbColor: Colors.white,
                          activeTrackColor: const Color(0xFFD06A4C),
                          inactiveThumbColor: Colors.white,
                          inactiveTrackColor: Colors.grey.shade300,
                          trackOutlineColor:
                              WidgetStateProperty.all(Colors.transparent),
                          title: const Text("Tampilkan Transliterasi Latin",
                              style: TextStyle(fontSize: 13)),
                          value: uiSettings.showLatin,
                          onChanged: (val) => uiNotifier.toggleLatin(val),
                        ),
                        SwitchListTile(
                          contentPadding: EdgeInsets.zero,
                          activeThumbColor: Colors.white,
                          activeTrackColor: const Color(0xFFD06A4C),
                          inactiveThumbColor: Colors.white,
                          inactiveTrackColor: Colors.grey.shade300,
                          trackOutlineColor:
                              WidgetStateProperty.all(Colors.transparent),
                          title: const Text("Tampilkan Terjemahan",
                              style: TextStyle(fontSize: 13)),
                          value: uiSettings.showTranslation,
                          onChanged: (val) => uiNotifier.toggleTranslation(val),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 10),

                // Section: Umum
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 21, vertical: 6),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AutoSizeText(
                        "Umum & Audio",
                        maxLines: 1,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                          fontSize:
                              Theme.of(context).textTheme.titleSmall?.fontSize,
                        ),
                      ),
                      AutoSizeText(
                        "Pilihan qori dan audio murottal",
                        maxLines: 1,
                        style: TextStyle(
                          fontWeight: FontWeight.w300,
                          color: const Color(0xFF929292),
                          fontSize:
                              Theme.of(context).textTheme.bodySmall?.fontSize,
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 21, vertical: 10),
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  "Qori Murottal",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                    color: Colors.black87,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  "Pilihan pelafal audio saat memutar ayat",
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: Colors.grey.shade600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 8),
                          InkWell(
                            onTap: () => _showQoriPicker(
                                context, ref, uiSettings.selectedQori),
                            borderRadius: BorderRadius.circular(8),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 7),
                              decoration: BoxDecoration(
                                border: Border.all(
                                    color: const Color(0xFFD06A4C)),
                                borderRadius: BorderRadius.circular(8),
                                color: const Color(0xFFE6F4F2),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  ConstrainedBox(
                                    constraints: BoxConstraints(
                                      maxWidth:
                                          MediaQuery.of(context).size.width *
                                              0.34,
                                    ),
                                    child: Text(
                                      currentQoriName,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                        color: Color(0xFFD06A4C),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 4),
                                  const Icon(Icons.arrow_drop_down,
                                      size: 18, color: Color(0xFFD06A4C)),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    )),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 21, vertical: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AutoSizeText(
                        "Quran Media",
                        maxLines: 1,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                          fontSize:
                              Theme.of(context).textTheme.titleSmall?.fontSize,
                        ),
                      ),
                      AutoSizeText(
                        "Download data quran & murotal untuk pemkaian tanpa internet",
                        maxLines: 2,
                        style: TextStyle(
                          fontWeight: FontWeight.w300,
                          color: const Color(0xFF929292),
                          fontSize:
                              Theme.of(context).textTheme.bodySmall?.fontSize,
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 21, vertical: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AutoSizeText(
                        "Mushaf",
                        maxLines: 1,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                          fontSize:
                              Theme.of(context).textTheme.titleSmall?.fontSize,
                        ),
                      ),
                      ListItemUiWidget(
                        showIcon: IconPosition.both,
                        iconLeft: const Icon(
                          Icons.import_contacts_rounded,
                          color: Color(0xFFADADAD),
                        ),
                        id: 1,
                        typeDivider: TypeDivider.none,
                        title: "Mushaf Indonesia",
                        titleStyle: Theme.of(context)
                            .textTheme
                            .titleSmall
                            ?.copyWith(
                                fontWeight: FontWeight.w300,
                                color: Colors.black),
                        iconRight: Row(
                          children: [
                            Icon(
                              Icons.check_circle_outline_rounded,
                              color: Theme.of(context).primaryColor,
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Material(
                              color: Colors.transparent,
                              child: InkWell(
                                  onTap: () {},
                                  borderRadius: BorderRadius.circular(20),
                                  splashColor:
                                      Colors.green.withValues(alpha: 0.5),
                                  child: const Icon(
                                    Icons.delete_rounded,
                                    color: Colors.black,
                                  )),
                            )
                          ],
                        ),
                      ),
                      ListItemUiWidget(
                        showIcon: IconPosition.both,
                        iconLeft: const Icon(
                          Icons.import_contacts_rounded,
                          color: Color(0xFFADADAD),
                        ),
                        id: 1,
                        typeDivider: TypeDivider.none,
                        title: "Mushaf Indonesia Tajwid",
                        titleStyle: Theme.of(context)
                            .textTheme
                            .titleSmall
                            ?.copyWith(
                                fontWeight: FontWeight.w300,
                                color: Colors.black),
                        iconRight: Row(
                          children: [
                            Material(
                              color: Colors.transparent,
                              child: InkWell(
                                  onTap: () async {
                                    _showPopup(context);
                                    ref
                                        .read(quranDownloadProvider.notifier)
                                        .downloadFile("halaman");
                                  },
                                  borderRadius: BorderRadius.circular(20),
                                  splashColor:
                                      Colors.green.withValues(alpha: 0.5),
                                  child: const Icon(
                                    Icons.download_rounded,
                                    color: Colors.black,
                                  )),
                            )
                          ],
                        ),
                      ),
                      ListItemUiWidget(
                        showIcon: IconPosition.both,
                        iconLeft: const Icon(
                          Icons.import_contacts_rounded,
                          color: Color(0xFFADADAD),
                        ),
                        id: 1,
                        typeDivider: TypeDivider.none,
                        title: "Mushaf Indonesia",
                        titleStyle: Theme.of(context)
                            .textTheme
                            .titleSmall
                            ?.copyWith(
                                fontWeight: FontWeight.w300,
                                color: Colors.black),
                        iconRight: Row(
                          children: [
                            Material(
                              color: Colors.transparent,
                              child: InkWell(
                                  onTap: () {
                                    _showPopup(context);
                                  },
                                  borderRadius: BorderRadius.circular(20),
                                  splashColor:
                                      Colors.green.withValues(alpha: 0.5),
                                  child: const Icon(
                                    Icons.download_rounded,
                                    color: Colors.black,
                                  )),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 21, vertical: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AutoSizeText(
                        "Murotal",
                        maxLines: 1,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                          fontSize:
                              Theme.of(context).textTheme.titleSmall?.fontSize,
                        ),
                      ),
                      ListItemUiWidget(
                        showIcon: IconPosition.both,
                        iconLeft: ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.asset(
                              "assets/img/murotal/mishari.jpg",
                              height: 80,
                              width: 80,
                              fit: BoxFit.cover,
                            )),
                        id: 1,
                        typeDivider: TypeDivider.none,
                        title: "Mishari Alafasy",
                        subTitle: "Mishari bin Rashed Alafasy",
                        titleStyle: Theme.of(context)
                            .textTheme
                            .titleSmall
                            ?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Colors.black),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          )),
    );
  }

  void _showPopup(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext bc) {
          return Consumer(builder: (c, consumerRef, child) {
            final state = consumerRef.watch(quranDownloadProvider);
            return Dialog(
              elevation: 0,
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(7.0)),
              child: Container(
                  padding: const EdgeInsets.all(10),
                  width: MediaQuery.of(context).size.width,
                  height: 170,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Mendownload",
                        style: Theme.of(bc).textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.bold, color: Colors.black),
                      ),
                      const SizedBox(
                        height: 40,
                      ),
                      LinearProgressIndicator(
                        borderRadius: const BorderRadius.all(Radius.zero),
                        color: Theme.of(bc).primaryColor,
                        backgroundColor: const Color(0xFFD9D9D9),
                        value: state.progresDownload,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          AutoSizeText(
                            "${state.totalTerDownload}/604",
                            maxLines: 1,
                            style: TextStyle(
                              fontWeight: FontWeight.w300,
                              color: Colors.black,
                              fontSize: Theme.of(context)
                                  .textTheme
                                  .titleSmall
                                  ?.fontSize,
                            ),
                          ),
                          AutoSizeText(
                            "${state.persenDownload}%",
                            maxLines: 1,
                            style: TextStyle(
                              fontWeight: FontWeight.w300,
                              color: Colors.black,
                              fontSize: Theme.of(context)
                                  .textTheme
                                  .titleSmall
                                  ?.fontSize,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Align(
                          alignment: Alignment.centerRight,
                          child: state.paused
                              ? Material(
                                  color: Colors.transparent,
                                  child: InkWell(
                                      onTap: () {
                                        consumerRef
                                            .read(quranDownloadProvider.notifier)
                                            .resumeDownload();
                                      },
                                      borderRadius: BorderRadius.circular(20),
                                      splashColor:
                                          Colors.green.withValues(alpha: 0.5),
                                      child: Text("Lanjutkan",
                                          style: TextStyle(
                                            fontWeight: FontWeight.w300,
                                            color: Colors.black,
                                            fontSize: Theme.of(context)
                                                .textTheme
                                                .titleSmall
                                                ?.fontSize,
                                          ))),
                                )
                              : Material(
                                  color: Colors.transparent,
                                  child: InkWell(
                                      onTap: () {
                                        consumerRef
                                            .read(quranDownloadProvider.notifier)
                                            .cancelDownload();
                                      },
                                      borderRadius: BorderRadius.circular(20),
                                      splashColor:
                                          Colors.green.withValues(alpha: 0.5),
                                      child: Text("Pause",
                                          style: TextStyle(
                                            fontWeight: FontWeight.w300,
                                            color: Colors.black,
                                            fontSize: Theme.of(context)
                                                .textTheme
                                                .titleSmall
                                                ?.fontSize,
                                          ))),
                                ))
                    ],
                  )),
            );
          });
        });
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    SystemChrome.setSystemUIOverlayStyle(
        const SystemUiOverlayStyle(statusBarIconBrightness: Brightness.light));
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      extendBodyBehindAppBar: false,
      resizeToAvoidBottomInset: false,
      appBar: AppBarWSWidget.getAppbarWidget(
          title: "Pengaturan Alquran",
          context: context,
          elevation: 0,
          iconTheme: const IconThemeData(color: Colors.white),
          color: Colors.white,
          titleAlign: Alignment.centerLeft,
          backgroundColor: const Color(0xFFD06A4C)),
      body: ref.watch(quranDownloadProvider).isLoadingList
          ? const Center(child: CircularProgressIndicator())
          : _layout(ref, context),
    );
  }
}
