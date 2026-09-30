import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:masjid_app/components/hudhud_ui.dart';
import 'package:masjid_app/core/theme/hudhud_theme.dart';
import 'package:masjid_app/models/quran_models.dart';
import 'package:masjid_app/providers/quran_provider.dart';

typedef QuranVerseSelection = ({int surah, int ayat});

class QuranVerseSearchSheet extends ConsumerStatefulWidget {
  const QuranVerseSearchSheet({super.key, this.initialSurahId});

  final int? initialSurahId;

  @override
  ConsumerState<QuranVerseSearchSheet> createState() =>
      _QuranVerseSearchSheetState();
}

class _QuranVerseSearchSheetState extends ConsumerState<QuranVerseSearchSheet> {
  final _verseSearch = TextEditingController();
  final _surahSearch = TextEditingController();
  int? _selectedSurahId;
  String _verseQuery = '';
  String _surahQuery = '';
  bool _choosingSurah = false;

  @override
  void initState() {
    super.initState();
    _selectedSurahId = widget.initialSurahId;
  }

  @override
  void dispose() {
    _verseSearch.dispose();
    _surahSearch.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final t = context.hudhud;
    final inset = MediaQuery.viewInsetsOf(context).bottom;
    final availableHeight = MediaQuery.sizeOf(context).height -
        inset -
        MediaQuery.paddingOf(context).top;
    final surahsAsync = ref.watch(surahListProvider(''));

    return Padding(
      padding: EdgeInsets.only(bottom: inset),
      child: SizedBox(
        height: availableHeight * 0.88,
        child: SafeArea(
          top: false,
          child: Padding(
            padding:
                EdgeInsets.fromLTRB(t.spaceLg, t.spaceMd, t.spaceLg, t.spaceLg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Center(
                  child: Container(
                    width: 36,
                    height: 4,
                    decoration: BoxDecoration(
                      color: t.outline,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                SizedBox(height: t.spaceMd),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        _choosingSurah ? 'Pilih surah' : 'Cari ayat',
                        style: Theme.of(context)
                            .textTheme
                            .titleLarge
                            ?.copyWith(color: t.charcoal),
                      ),
                    ),
                    IconButton(
                      tooltip:
                          _choosingSurah ? 'Kembali ke pencarian' : 'Tutup',
                      onPressed: () {
                        if (_choosingSurah) {
                          setState(() => _choosingSurah = false);
                        } else {
                          Navigator.of(context).pop();
                        }
                      },
                      icon: Icon(
                        _choosingSurah ? LucideIcons.arrowLeft : LucideIcons.x,
                        color: t.muted,
                      ),
                    ),
                  ],
                ),
                if (!_choosingSurah) ...[
                  Text(
                    'Cari teks Arab, Latin, atau terjemahan dalam surah pilihan.',
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall
                        ?.copyWith(color: t.muted),
                  ),
                  SizedBox(height: t.spaceLg),
                ],
                Expanded(
                  child: surahsAsync.when(
                    loading: () =>
                        const Center(child: CircularProgressIndicator()),
                    error: (_, __) => HudhudStateView(
                      icon: LucideIcons.wifiOff,
                      title: 'Daftar surah belum dimuat',
                      message: 'Periksa koneksi dan coba kembali.',
                      actionLabel: 'Coba lagi',
                      onAction: () => ref.invalidate(surahListProvider('')),
                    ),
                    data: (surahs) => surahs.isEmpty
                        ? HudhudStateView(
                            icon: LucideIcons.wifiOff,
                            title: 'Daftar surah belum dimuat',
                            message: 'Periksa koneksi dan coba kembali.',
                            actionLabel: 'Coba lagi',
                            onAction: () =>
                                ref.invalidate(surahListProvider('')),
                          )
                        : _choosingSurah
                            ? _buildSurahPicker(surahs)
                            : _buildVerseSearch(surahs),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSurahPicker(List<SurahModel> surahs) {
    final t = context.hudhud;
    final query = _surahQuery.toLowerCase();
    final matches = surahs.where((surah) {
      return query.isEmpty ||
          surah.nama.toLowerCase().contains(query) ||
          surah.arti.toLowerCase().contains(query) ||
          '${surah.id}' == query;
    }).toList();

    return Column(
      children: [
        TextField(
          controller: _surahSearch,
          autofocus: true,
          onChanged: (value) => setState(() => _surahQuery = value.trim()),
          decoration: const InputDecoration(
            hintText: 'Cari nama atau nomor surah',
            prefixIcon: Icon(LucideIcons.search),
          ),
        ),
        SizedBox(height: t.spaceSm),
        Expanded(
          child: matches.isEmpty
              ? const HudhudStateView(
                  icon: LucideIcons.searchX,
                  title: 'Surah tidak ditemukan',
                  message: 'Coba nama atau nomor surah yang lain.',
                )
              : ListView.separated(
                  itemCount: matches.length,
                  separatorBuilder: (_, __) => Divider(color: t.outline),
                  itemBuilder: (context, index) {
                    final surah = matches[index];
                    return ListTile(
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: t.spaceSm),
                      leading: CircleAvatar(
                        backgroundColor: t.terracotta.withValues(alpha: 0.10),
                        child: Text('${surah.id}',
                            style: TextStyle(color: t.terracottaDark)),
                      ),
                      title: Text(surah.nama),
                      subtitle:
                          Text('${surah.arti} • ${surah.jumlahAyat} ayat'),
                      selected: _selectedSurahId == surah.id,
                      onTap: () {
                        FocusManager.instance.primaryFocus?.unfocus();
                        setState(() {
                          _selectedSurahId = surah.id;
                          _choosingSurah = false;
                        });
                      },
                    );
                  },
                ),
        ),
      ],
    );
  }

  Widget _buildVerseSearch(List<SurahModel> surahs) {
    final t = context.hudhud;
    final selected = surahs.where((surah) => surah.id == _selectedSurahId);
    final surah = selected.isEmpty ? null : selected.first;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Material(
          color: t.sand,
          borderRadius: BorderRadius.circular(12),
          child: InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: () => setState(() => _choosingSurah = true),
            child: Container(
              constraints: const BoxConstraints(minHeight: 56),
              padding: EdgeInsets.symmetric(horizontal: t.spaceMd),
              decoration: BoxDecoration(
                border: Border.all(color: t.outline),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Icon(LucideIcons.bookOpen, color: t.terracottaDark, size: 20),
                  SizedBox(width: t.spaceMd),
                  Expanded(
                    child: Text(
                      surah == null ? 'Pilih surah' : surah.nama,
                      style: Theme.of(context)
                          .textTheme
                          .titleSmall
                          ?.copyWith(color: t.charcoal),
                    ),
                  ),
                  Text('Ganti', style: TextStyle(color: t.terracottaDark)),
                  Icon(LucideIcons.chevronDown,
                      color: t.terracottaDark, size: 18),
                ],
              ),
            ),
          ),
        ),
        SizedBox(height: t.spaceMd),
        TextField(
          controller: _verseSearch,
          enabled: surah != null,
          onChanged: (value) => setState(() => _verseQuery = value.trim()),
          decoration: InputDecoration(
            hintText: surah == null
                ? 'Pilih surah terlebih dahulu'
                : 'Cari kata atau potongan ayat',
            prefixIcon: const Icon(LucideIcons.search),
            suffixIcon: _verseQuery.isEmpty
                ? null
                : IconButton(
                    tooltip: 'Hapus pencarian',
                    onPressed: () => setState(() {
                      _verseSearch.clear();
                      _verseQuery = '';
                    }),
                    icon: const Icon(LucideIcons.x),
                  ),
          ),
        ),
        SizedBox(height: t.spaceSm),
        Expanded(
          child: surah == null
              ? const HudhudStateView(
                  icon: LucideIcons.bookOpen,
                  title: 'Pilih surah untuk mulai',
                  message: 'Pencarian dilakukan di dalam surah yang dipilih.',
                )
              : _buildVerseResults(surah),
        ),
      ],
    );
  }

  Widget _buildVerseResults(SurahModel surah) {
    final t = context.hudhud;
    final async = ref.watch(surahDetailProvider(surah.id));
    return async.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (_, __) => HudhudStateView(
        icon: LucideIcons.wifiOff,
        title: 'Ayat belum dimuat',
        message: 'Periksa koneksi dan coba kembali.',
        actionLabel: 'Coba lagi',
        onAction: () => ref.invalidate(surahDetailProvider(surah.id)),
      ),
      data: (verses) {
        if (verses.isEmpty) {
          return HudhudStateView(
            icon: LucideIcons.wifiOff,
            title: 'Ayat belum dimuat',
            message: 'Periksa koneksi dan coba kembali.',
            actionLabel: 'Coba lagi',
            onAction: () => ref.invalidate(surahDetailProvider(surah.id)),
          );
        }
        if (_verseQuery.isEmpty) {
          return const HudhudStateView(
            icon: LucideIcons.scanSearch,
            title: 'Cari dalam surah ini',
            message: 'Ketik kata dalam teks Arab, Latin, atau terjemahan.',
          );
        }

        final query = _verseQuery.toLowerCase();
        final matches = verses.where((verse) {
          return verse.arab.contains(_verseQuery) ||
              verse.madinah.contains(_verseQuery) ||
              verse.latin.toLowerCase().contains(query) ||
              verse.arti.toLowerCase().contains(query);
        }).toList();
        if (matches.isEmpty) {
          return HudhudStateView(
            icon: LucideIcons.searchX,
            title: 'Ayat tidak ditemukan',
            message: 'Coba kata lain dalam ${surah.nama}.',
          );
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: t.spaceXs, vertical: t.spaceSm),
              child: Text(
                '${matches.length} ayat ditemukan',
                style: Theme.of(context)
                    .textTheme
                    .labelMedium
                    ?.copyWith(color: t.muted),
              ),
            ),
            Expanded(
              child: ListView.separated(
                keyboardDismissBehavior:
                    ScrollViewKeyboardDismissBehavior.onDrag,
                itemCount: matches.length,
                separatorBuilder: (_, __) => Divider(color: t.outline),
                itemBuilder: (context, index) {
                  final verse = matches[index];
                  return ListTile(
                    contentPadding: EdgeInsets.symmetric(horizontal: t.spaceSm),
                    leading: CircleAvatar(
                      backgroundColor: t.amber.withValues(alpha: 0.18),
                      child: Text('${verse.ayat}',
                          style: TextStyle(color: t.terracottaDark)),
                    ),
                    title: Text(
                      verse.madinah.isNotEmpty ? verse.madinah : verse.arab,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.right,
                      style: TextStyle(
                        fontFamily: GoogleFonts.amiriQuran().fontFamily,
                        fontSize: 18,
                        color: t.charcoal,
                      ),
                    ),
                    subtitle: Text(
                      verse.arti,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(color: t.muted),
                    ),
                    onTap: () => Navigator.of(context).pop<QuranVerseSelection>(
                      (surah: surah.id, ayat: verse.ayat),
                    ),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }
}
