import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:masjid_app/models/quran_models.dart';
import 'package:masjid_app/providers/quran_ayat_providers.dart';

enum MushafFilterTab { halaman, juz, surah }

Future<void> showMushafFilterBottomSheet({
  required BuildContext context,
  required int currentHal,
  required String currentSurah,
  required List<Map<String, dynamic>> listSurah,
  required void Function(int page) onSelectPage,
  MushafFilterTab initialTab = MushafFilterTab.halaman,
}) {
  return showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.white,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
    ),
    builder: (bottomSheetContext) {
      return MushafFilterBottomSheet(
        currentHal: currentHal,
        currentSurah: currentSurah,
        listSurah: listSurah,
        onSelectPage: onSelectPage,
        initialTab: initialTab,
      );
    },
  );
}

class MushafFilterBottomSheet extends ConsumerStatefulWidget {
  final int currentHal;
  final String currentSurah;
  final List<Map<String, dynamic>> listSurah;
  final void Function(int page) onSelectPage;
  final MushafFilterTab initialTab;

  const MushafFilterBottomSheet({
    super.key,
    required this.currentHal,
    required this.currentSurah,
    required this.listSurah,
    required this.onSelectPage,
    this.initialTab = MushafFilterTab.halaman,
  });

  @override
  ConsumerState<MushafFilterBottomSheet> createState() =>
      _MushafFilterBottomSheetState();
}

class _MushafFilterBottomSheetState
    extends ConsumerState<MushafFilterBottomSheet> {
  late int _selectedTabIndex;
  late final TextEditingController _pageController;
  final TextEditingController _searchJuzController = TextEditingController();
  final TextEditingController _searchSurahController = TextEditingController();

  String _searchJuzQuery = '';
  String _searchSurahQuery = '';
  String? _pageErrorText;
  int _targetPage = 1;

  // Cache peta halaman awal untuk setiap nama surah dari aset mushaf
  final Map<String, int> _surahStartPages = {};

  @override
  void initState() {
    super.initState();
    _selectedTabIndex = widget.initialTab.index;
    _targetPage = widget.currentHal.clamp(1, 604);
    _pageController = TextEditingController(text: _targetPage.toString());

    // Indeks halaman awal surah dari listSurah
    for (final item in widget.listSurah) {
      final name = (item['surat'] ?? '').toString().trim().toLowerCase();
      final hal = int.tryParse('${item['hal']}') ?? 1;
      if (name.isNotEmpty && !_surahStartPages.containsKey(name)) {
        _surahStartPages[name] = hal;
      }
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    _searchJuzController.dispose();
    _searchSurahController.dispose();
    super.dispose();
  }

  void _onPageInputChanged(String val) {
    if (val.trim().isEmpty) {
      setState(() {
        _pageErrorText = 'Nomor halaman tidak boleh kosong';
      });
      return;
    }
    final parsed = int.tryParse(val.trim());
    if (parsed == null || parsed < 1 || parsed > 604) {
      setState(() {
        _pageErrorText = 'Nomor halaman harus antara 1 - 604';
      });
    } else {
      setState(() {
        _pageErrorText = null;
        _targetPage = parsed;
      });
    }
  }

  void _adjustPage(int delta) {
    int next = _targetPage + delta;
    if (next < 1) next = 1;
    if (next > 604) next = 604;
    _pageController.text = next.toString();
    setState(() {
      _targetPage = next;
      _pageErrorText = null;
    });
  }

  void _setPageDirect(int page) {
    _pageController.text = page.toString();
    setState(() {
      _targetPage = page;
      _pageErrorText = null;
    });
  }

  void _confirmGoToPage(int page) {
    Navigator.of(context).pop();
    widget.onSelectPage(page);
  }

  int _getSurahStartPage(String surahNama, int fallbackIndex) {
    final lower = surahNama.trim().toLowerCase();
    if (_surahStartPages.containsKey(lower)) {
      return _surahStartPages[lower]!;
    }
    // Jika tidak cocok persis, cari yang mirip
    for (final entry in _surahStartPages.entries) {
      if (entry.key.contains(lower) || lower.contains(entry.key)) {
        return entry.value;
      }
    }
    return fallbackIndex;
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return Padding(
      padding: EdgeInsets.only(bottom: bottomInset),
      child: Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.85,
        ),
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Handle bar
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
            const SizedBox(height: 14),

            // Header: Judul & tombol tutup
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Row(
                  children: [
                    Icon(
                      Icons.menu_book_rounded,
                      color: Color(0xFF048C7C),
                      size: 22,
                    ),
                    SizedBox(width: 8),
                    Text(
                      "Navigasi Mushaf",
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
                IconButton(
                  visualDensity: VisualDensity.compact,
                  icon: const Icon(
                    Icons.close_rounded,
                    size: 22,
                    color: Colors.black54,
                  ),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Segmented Tab Selector
            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: const Color(0xFFF1F5F5),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  _buildTabButton(
                    index: 0,
                    icon: Icons.filter_none_rounded,
                    label: "Halaman",
                  ),
                  _buildTabButton(
                    index: 1,
                    icon: Icons.bookmarks_rounded,
                    label: "Juz",
                  ),
                  _buildTabButton(
                    index: 2,
                    icon: Icons.auto_stories_rounded,
                    label: "Surah",
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Konten Tab Aktif
            Expanded(
              child: _buildActiveTabContent(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTabButton({
    required int index,
    required IconData icon,
    required String label,
  }) {
    final isSelected = _selectedTabIndex == index;
    return Expanded(
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: () {
          setState(() {
            _selectedTabIndex = index;
          });
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 9),
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFF048C7C) : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: const Color(0xFF048C7C).withValues(alpha: 0.25),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : null,
          ),
          alignment: Alignment.center,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 16,
                color: isSelected ? Colors.white : Colors.black54,
              ),
              const SizedBox(width: 6),
              Text(
                label,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: isSelected ? Colors.white : Colors.black87,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActiveTabContent() {
    switch (_selectedTabIndex) {
      case 0:
        return _buildHalamanTab();
      case 1:
        return _buildJuzTab();
      case 2:
      default:
        return _buildSurahTab();
    }
  }

  // ==========================================
  // TAB 1: LOMPAT HALAMAN
  // ==========================================
  Widget _buildHalamanTab() {
    final milestonePages = [1, 50, 100, 200, 300, 400, 500, 604];

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Info posisi saat ini
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: const Color(0xFFE6F4F2),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFBBE5E0)),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.info_outline_rounded,
                  color: Color(0xFF048C7C),
                  size: 20,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    "Sedang membaca ${widget.currentSurah} • Hal. ${widget.currentHal} dari 604",
                    style: const TextStyle(
                      fontSize: 12.5,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF048C7C),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),

          // Input Nomor Halaman
          const Text(
            "Masukkan Nomor Halaman (1 - 604):",
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _pageController,
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            decoration: InputDecoration(
              prefixIcon: const Icon(
                Icons.find_in_page_rounded,
                color: Color(0xFF048C7C),
              ),
              suffixIcon: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (_pageController.text.isNotEmpty)
                    IconButton(
                      icon: const Icon(Icons.clear_rounded, size: 18),
                      onPressed: () {
                        _pageController.clear();
                        _onPageInputChanged('');
                      },
                    ),
                ],
              ),
              hintText: "Contoh: 150",
              hintStyle: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.normal,
                color: Colors.black38,
              ),
              errorText: _pageErrorText,
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Color(0xFFCBD5E1)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide:
                    const BorderSide(color: Color(0xFF048C7C), width: 1.8),
              ),
            ),
            onChanged: _onPageInputChanged,
          ),
          const SizedBox(height: 14),

          // Stepper Cepat (-10, -1, +1, +10)
          Row(
            children: [
              _buildStepButton(label: "-10", delta: -10),
              const SizedBox(width: 8),
              _buildStepButton(label: "-1", delta: -1),
              const SizedBox(width: 8),
              _buildStepButton(label: "+1", delta: 1),
              const SizedBox(width: 8),
              _buildStepButton(label: "+10", delta: 10),
            ],
          ),
          const SizedBox(height: 18),

          // Milestone Chips
          const Text(
            "Lompat Cepat ke Halaman Penting:",
            style: TextStyle(
              fontSize: 12.5,
              fontWeight: FontWeight.w600,
              color: Colors.black54,
            ),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: milestonePages.map((hal) {
              final isTarget = _targetPage == hal;
              return ActionChip(
                label: Text("Hal. $hal"),
                labelStyle: TextStyle(
                  fontSize: 12,
                  fontWeight: isTarget ? FontWeight.bold : FontWeight.w500,
                  color: isTarget ? Colors.white : const Color(0xFF048C7C),
                ),
                backgroundColor:
                    isTarget ? const Color(0xFF048C7C) : const Color(0xFFE6F4F2),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                  side: BorderSide(
                    color: isTarget
                        ? const Color(0xFF048C7C)
                        : const Color(0xFFBBE5E0),
                  ),
                ),
                onPressed: () => _setPageDirect(hal),
              );
            }).toList(),
          ),
          const SizedBox(height: 24),

          // Tombol Konfirmasi Lompat Halaman
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF048C7C),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 0,
            ),
            icon: const Icon(Icons.arrow_forward_rounded, size: 20),
            label: Text(
              "Buka Halaman $_targetPage",
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
            onPressed: _pageErrorText == null
                ? () => _confirmGoToPage(_targetPage)
                : null,
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }

  Widget _buildStepButton({required String label, required int delta}) {
    return Expanded(
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 10),
          side: const BorderSide(color: Color(0xFFCBD5E1)),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          backgroundColor: const Color(0xFFF8FAFC),
        ),
        onPressed: () => _adjustPage(delta),
        child: Text(
          label,
          style: const TextStyle(
            fontSize: 12.5,
            fontWeight: FontWeight.bold,
            color: Color(0xFF048C7C),
          ),
        ),
      ),
    );
  }

  // ==========================================
  // TAB 2: LOMPAT JUZ (1 - 30)
  // ==========================================
  Widget _buildJuzTab() {
    final query = _searchJuzQuery.toLowerCase().trim();
    final filteredJuz = kQuranJuzList.where((j) {
      if (query.isEmpty) return true;
      return j.juzNumber.toString() == query ||
          j.name.toLowerCase().contains(query) ||
          j.startSurahName.toLowerCase().contains(query);
    }).toList();

    return Column(
      children: [
        TextField(
          controller: _searchJuzController,
          decoration: InputDecoration(
            hintText: "Cari nomor juz (1-30) atau nama surah...",
            hintStyle: const TextStyle(fontSize: 13),
            prefixIcon: const Icon(Icons.search_rounded, size: 20),
            suffixIcon: _searchJuzQuery.isNotEmpty
                ? IconButton(
                    icon: const Icon(Icons.clear_rounded, size: 18),
                    onPressed: () {
                      _searchJuzController.clear();
                      setState(() {
                        _searchJuzQuery = '';
                      });
                    },
                  )
                : null,
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Color(0xFFCBD5E1)),
            ),
          ),
          onChanged: (val) {
            setState(() {
              _searchJuzQuery = val;
            });
          },
        ),
        const SizedBox(height: 10),
        Expanded(
          child: filteredJuz.isEmpty
              ? const Center(
                  child: Text(
                    "Juz tidak ditemukan",
                    style: TextStyle(color: Colors.black54, fontSize: 13),
                  ),
                )
              : ListView.separated(
                  itemCount: filteredJuz.length,
                  separatorBuilder: (_, __) => const Divider(
                    height: 1,
                    color: Color(0xFFF1F5F5),
                  ),
                  itemBuilder: (context, index) {
                    final juz = filteredJuz[index];
                    final isCurrentJuz = widget.currentHal >= juz.startPage &&
                        widget.currentHal <= juz.endPage;

                    return ListTile(
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 2,
                      ),
                      selected: isCurrentJuz,
                      selectedTileColor: const Color(0xFFE6F4F2),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      leading: Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          color: isCurrentJuz
                              ? const Color(0xFF048C7C)
                              : const Color(0xFFE6F4F2),
                          shape: BoxShape.circle,
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          "${juz.juzNumber}",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 12.5,
                            color: isCurrentJuz
                                ? Colors.white
                                : const Color(0xFF048C7C),
                          ),
                        ),
                      ),
                      title: Text(
                        juz.name,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: isCurrentJuz
                              ? FontWeight.bold
                              : FontWeight.w600,
                          color: isCurrentJuz
                              ? const Color(0xFF048C7C)
                              : Colors.black87,
                        ),
                      ),
                      subtitle: Text(
                        "Mulai ${juz.startSurahName} : Ayat ${juz.startAyat}",
                        style: const TextStyle(
                          fontSize: 11.5,
                          color: Colors.black54,
                        ),
                      ),
                      trailing: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: isCurrentJuz
                              ? const Color(0xFF048C7C)
                              : const Color(0xFFF1F5F9),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          "Hal. ${juz.startPage}",
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: isCurrentJuz
                                ? Colors.white
                                : const Color(0xFF048C7C),
                          ),
                        ),
                      ),
                      onTap: () => _confirmGoToPage(juz.startPage),
                    );
                  },
                ),
        ),
      ],
    );
  }

  // ==========================================
  // TAB 3: PILIH SURAH (1 - 114)
  // ==========================================
  Widget _buildSurahTab() {
    final surahAsync = ref.watch(surahListRawProvider(''));

    return Column(
      children: [
        TextField(
          controller: _searchSurahController,
          decoration: InputDecoration(
            hintText: "Cari nama surah atau nomor...",
            hintStyle: const TextStyle(fontSize: 13),
            prefixIcon: const Icon(Icons.search_rounded, size: 20),
            suffixIcon: _searchSurahQuery.isNotEmpty
                ? IconButton(
                    icon: const Icon(Icons.clear_rounded, size: 18),
                    onPressed: () {
                      _searchSurahController.clear();
                      setState(() {
                        _searchSurahQuery = '';
                      });
                    },
                  )
                : null,
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Color(0xFFCBD5E1)),
            ),
          ),
          onChanged: (val) {
            setState(() {
              _searchSurahQuery = val;
            });
          },
        ),
        const SizedBox(height: 10),
        Expanded(
          child: surahAsync.when(
            loading: () => const Center(
              child: CircularProgressIndicator(color: Color(0xFF048C7C)),
            ),
            error: (_, __) => _buildFallbackSurahListFromLocal(),
            data: (surahList) {
              if (surahList.isEmpty) {
                return _buildFallbackSurahListFromLocal();
              }
              final query = _searchSurahQuery.toLowerCase().trim();
              final filtered = surahList.where((s) {
                if (query.isEmpty) return true;
                final idStr = (s['id'] ?? '').toString();
                final name = (s['nama'] ?? '').toString().toLowerCase();
                return idStr == query || name.contains(query);
              }).toList();

              if (filtered.isEmpty) {
                return const Center(
                  child: Text(
                    "Surah tidak ditemukan",
                    style: TextStyle(color: Colors.black54, fontSize: 13),
                  ),
                );
              }

              return ListView.separated(
                itemCount: filtered.length,
                separatorBuilder: (_, __) => const Divider(
                  height: 1,
                  color: Color(0xFFF1F5F5),
                ),
                itemBuilder: (context, idx) {
                  final s = filtered[idx];
                  final surahNama = (s['nama'] ?? '').toString();
                  final surahId = (s['id'] ?? (idx + 1)).toString();
                  final startPage = _getSurahStartPage(surahNama, idx + 1);
                  final isCurrent = widget.currentSurah.toLowerCase() ==
                      surahNama.toLowerCase();

                  return ListTile(
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 2,
                    ),
                    selected: isCurrent,
                    selectedTileColor: const Color(0xFFE6F4F2),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    leading: Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: isCurrent
                            ? const Color(0xFF048C7C)
                            : const Color(0xFFE6F4F2),
                        shape: BoxShape.circle,
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        surahId,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 12.5,
                          color: isCurrent
                              ? Colors.white
                              : const Color(0xFF048C7C),
                        ),
                      ),
                    ),
                    title: Text(
                      surahNama,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight:
                            isCurrent ? FontWeight.bold : FontWeight.w600,
                        color: isCurrent
                            ? const Color(0xFF048C7C)
                            : Colors.black87,
                      ),
                    ),
                    subtitle: Text(
                      "${s['tipe'] ?? ''} • ${s['ayat'] ?? ''} Ayat • Hal. $startPage",
                      style: const TextStyle(
                        fontSize: 11.5,
                        color: Colors.black54,
                      ),
                    ),
                    trailing: Text(
                      (s['arab'] ?? '').toString(),
                      style: TextStyle(
                        fontFamily: GoogleFonts.amiriQuran().fontFamily,
                        fontSize: 17,
                        color: const Color(0xFF048C7C),
                      ),
                    ),
                    onTap: () => _confirmGoToPage(startPage),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }

  /// Fallback daftar surah jika koneksi API sedang bermasalah,
  /// diambil langsung dari cache halaman lokal aset `listSurah`.
  Widget _buildFallbackSurahListFromLocal() {
    final uniqueSurahs = <Map<String, dynamic>>[];
    final seen = <String>{};

    for (final item in widget.listSurah) {
      final name = (item['surat'] ?? '').toString();
      if (name.isNotEmpty && !seen.contains(name)) {
        seen.add(name);
        uniqueSurahs.add({
          'nama': name,
          'hal': item['hal'],
        });
      }
    }

    final query = _searchSurahQuery.toLowerCase().trim();
    final filtered = uniqueSurahs.where((s) {
      if (query.isEmpty) return true;
      return s['nama'].toString().toLowerCase().contains(query);
    }).toList();

    return ListView.separated(
      itemCount: filtered.length,
      separatorBuilder: (_, __) => const Divider(
        height: 1,
        color: Color(0xFFF1F5F5),
      ),
      itemBuilder: (context, idx) {
        final s = filtered[idx];
        final name = s['nama'].toString();
        final hal = int.tryParse('${s['hal']}') ?? (idx + 1);
        final isCurrent =
            widget.currentSurah.toLowerCase() == name.toLowerCase();

        return ListTile(
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
          selected: isCurrent,
          selectedTileColor: const Color(0xFFE6F4F2),
          leading: Text(
            "${idx + 1}",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: isCurrent ? const Color(0xFF048C7C) : Colors.black54,
            ),
          ),
          title: Text(
            name,
            style: TextStyle(
              fontSize: 14,
              fontWeight: isCurrent ? FontWeight.bold : FontWeight.w600,
              color: isCurrent ? const Color(0xFF048C7C) : Colors.black87,
            ),
          ),
          trailing: Text(
            "Hal. $hal",
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Color(0xFF048C7C),
              fontSize: 12,
            ),
          ),
          onTap: () => _confirmGoToPage(hal),
        );
      },
    );
  }
}
