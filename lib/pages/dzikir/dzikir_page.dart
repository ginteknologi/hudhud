import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:masjid_app/models/dzikir_data.dart';
import 'package:masjid_app/pages/dzikir/component/dzikir_header_painter.dart';
import 'package:share_plus/share_plus.dart';

class DzikirPage extends ConsumerStatefulWidget {
  const DzikirPage({super.key});

  @override
  ConsumerState<DzikirPage> createState() => _DzikirPageState();
}

class _DzikirPageState extends ConsumerState<DzikirPage> {
  // false = Dzikir Pagi, true = Dzikir Petang
  bool _isPetang = false;

  // Hitungan tasbih per dzikir item (id -> count)
  final Map<int, int> _counts = {};

  // Pengaturan Tampilan & Font
  double _arabicFontSize = 21.0;
  bool _showLatin = true;
  bool _showTranslation = true;

  @override
  void initState() {
    super.initState();
    // Default waktu disesuaikan otomatis dengan jam saat ini:
    // Sebelum jam 15:00 = Dzikir Pagi, 15:00 ke atas = Dzikir Petang
    final hour = DateTime.now().hour;
    if (hour >= 15 || hour < 4) {
      _isPetang = true;
    }
  }

  void _incrementCount(DzikirItem item) {
    HapticFeedback.lightImpact();
    setState(() {
      final current = _counts[item.id] ?? 0;
      if (current < item.targetCount) {
        _counts[item.id] = current + 1;
        if (_counts[item.id] == item.targetCount) {
          HapticFeedback.mediumImpact();
        }
      } else {
        // Reset jika sudah selesai
        _counts[item.id] = 0;
      }
    });
  }

  void _copyToClipboard(DzikirItem item) {
    final buffer = StringBuffer();
    buffer.writeln(item.judul);
    buffer.writeln('(Dibaca ${item.targetCount}x)');
    buffer.writeln();
    buffer.writeln(item.arab);
    buffer.writeln();
    if (_showLatin && item.transliterasi.isNotEmpty) {
      buffer.writeln(item.transliterasi);
      buffer.writeln();
    }
    if (_showTranslation) {
      buffer.writeln('Artinya:');
      buffer.writeln('"${item.arti}"');
      buffer.writeln();
    }
    if (item.faedah.isNotEmpty) {
      buffer.writeln('Keutamaan: ${item.faedah}');
      buffer.writeln();
    }
    buffer.writeln("(Dibagikan melalui Aplikasi Masjid An-Ni'mah - Marbot)");

    Clipboard.setData(ClipboardData(text: buffer.toString().trim()));
    Fluttertoast.showToast(
      msg: 'Teks Dzikir berhasil disalin',
      backgroundColor: const Color(0xFF048C7C),
      textColor: Colors.white,
    );
  }

  void _shareDzikir(DzikirItem item) {
    final buffer = StringBuffer();
    buffer.writeln(item.judul);
    buffer.writeln('(Dibaca ${item.targetCount}x)');
    buffer.writeln();
    buffer.writeln(item.arab);
    buffer.writeln();
    if (_showLatin && item.transliterasi.isNotEmpty) {
      buffer.writeln(item.transliterasi);
      buffer.writeln();
    }
    if (_showTranslation) {
      buffer.writeln('Artinya:');
      buffer.writeln('"${item.arti}"');
      buffer.writeln();
    }
    if (item.faedah.isNotEmpty) {
      buffer.writeln('Keutamaan: ${item.faedah}');
      buffer.writeln();
    }
    buffer.writeln("Dibagikan melalui Aplikasi Masjid An-Ni'mah - Marbot");

    SharePlus.instance.share(
      ShareParams(
        text: buffer.toString().trim(),
        subject: item.judul,
      ),
    );
  }

  void _showSettingsSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Colors.black12,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Pengaturan Tampilan & Font',
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF137065),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Toggle Transliterasi (Latin)
                  SwitchListTile(
                    contentPadding: EdgeInsets.zero,
                    activeTrackColor: const Color(0xFF048C7C),
                    title: Text(
                      'Tampilkan Teks Latin',
                      style: GoogleFonts.poppins(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF2D3748),
                      ),
                    ),
                    subtitle: Text(
                      'Menampilkan panduan bacaan transliterasi latin',
                      style: GoogleFonts.poppins(fontSize: 11, color: Colors.black45),
                    ),
                    value: _showLatin,
                    onChanged: (val) {
                      setModalState(() => _showLatin = val);
                      setState(() => _showLatin = val);
                    },
                  ),

                  const Divider(height: 12),

                  // Toggle Terjemahan (Arti)
                  SwitchListTile(
                    contentPadding: EdgeInsets.zero,
                    activeTrackColor: const Color(0xFF048C7C),
                    title: Text(
                      'Tampilkan Terjemahan (Arti)',
                      style: GoogleFonts.poppins(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF2D3748),
                      ),
                    ),
                    subtitle: Text(
                      'Menampilkan terjemahan bahasa Indonesia',
                      style: GoogleFonts.poppins(fontSize: 11, color: Colors.black45),
                    ),
                    value: _showTranslation,
                    onChanged: (val) {
                      setModalState(() => _showTranslation = val);
                      setState(() => _showTranslation = val);
                    },
                  ),

                  const Divider(height: 16),

                  // Slider Ukuran Teks Arab
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Ukuran Teks Arab',
                        style: GoogleFonts.poppins(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF2D3748),
                        ),
                      ),
                      Text(
                        '${_arabicFontSize.toInt()} pt',
                        style: GoogleFonts.poppins(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF048C7C),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  SliderTheme(
                    data: SliderTheme.of(context).copyWith(
                      activeTrackColor: const Color(0xFF048C7C),
                      inactiveTrackColor: const Color(0xFFE2EBE8),
                      thumbColor: const Color(0xFF137065),
                    ),
                    child: Slider(
                      value: _arabicFontSize,
                      min: 17.0,
                      max: 32.0,
                      divisions: 5,
                      onChanged: (val) {
                        setModalState(() => _arabicFontSize = val);
                        setState(() => _arabicFontSize = val);
                      },
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF8FAF9),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: const Color(0xFFE2EBE8)),
                    ),
                    child: Text(
                      'سُبْحَانَ اللَّهِ وَبِحَمْدِهِ',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.amiri(
                        fontSize: _arabicFontSize,
                        color: const Color(0xFF2D3748),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final list = _isPetang
        ? DzikirRepository.dzikirPetangList
        : DzikirRepository.dzikirPagiList;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
      ),
      child: Scaffold(
        body: DzikirAnimatedBackground(
          isPetang: _isPetang,
          child: SafeArea(
            bottom: false,
            child: CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                // Top Header Section
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 12, 20, 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Top Nav Bar Row
                        Row(
                          children: [
                            InkWell(
                              onTap: () => Navigator.of(context).pop(),
                              borderRadius: BorderRadius.circular(12),
                              child: Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: Colors.white.withValues(alpha: 0.20),
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: Colors.white.withValues(alpha: 0.30),
                                  ),
                                ),
                                child: const Icon(
                                  Icons.arrow_back_rounded,
                                  size: 20,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            const Spacer(),
                            // Settings Action Button (Font & Display)
                            InkWell(
                              onTap: _showSettingsSheet,
                              borderRadius: BorderRadius.circular(12),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 7,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.white.withValues(alpha: 0.20),
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: Colors.white.withValues(alpha: 0.30),
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    const Icon(
                                      Icons.tune_rounded,
                                      size: 16,
                                      color: Colors.white,
                                    ),
                                    const SizedBox(width: 6),
                                    Text(
                                      'Tampilan',
                                      style: GoogleFonts.poppins(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 18),

                        // Title & Subtitle Overlay
                        Text(
                          _isPetang ? 'Dzikir Petang' : 'Dzikir Pagi',
                          style: GoogleFonts.poppins(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            letterSpacing: 0.2,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          _isPetang
                              ? 'Kumpulan dzikir & wirid sunnah di waktu sore/malam'
                              : 'Kumpulan dzikir & wirid sunnah pembuka pagi hari',
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            color: Colors.white.withValues(alpha: 0.90),
                          ),
                        ),

                        const SizedBox(height: 18),

                        // Time Switcher Toggle (Pagi / Petang)
                        Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: Colors.black.withValues(alpha: 0.25),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: Colors.white.withValues(alpha: 0.20),
                            ),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: _buildTimeTab(
                                  title: 'Dzikir Pagi',
                                  icon: Icons.wb_sunny_rounded,
                                  isSelected: !_isPetang,
                                  onTap: () {
                                    if (_isPetang) {
                                      setState(() => _isPetang = false);
                                    }
                                  },
                                ),
                              ),
                              const SizedBox(width: 4),
                              Expanded(
                                child: _buildTimeTab(
                                  title: 'Dzikir Petang',
                                  icon: Icons.nightlight_round,
                                  isSelected: _isPetang,
                                  onTap: () {
                                    if (!_isPetang) {
                                      setState(() => _isPetang = true);
                                    }
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 16),

                        // Section Info Bar
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Rangkaian Bacaan',
                              style: GoogleFonts.poppins(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.18),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                '${list.length} Dzikir',
                                style: GoogleFonts.poppins(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                // List of Semi-Transparent Dzikir Cards
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 36),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final item = list[index];
                        return FadeInUp(
                          key: ValueKey('${_isPetang ? "petang" : "pagi"}_${item.id}'),
                          duration: Duration(milliseconds: 140 + (index * 25).clamp(0, 250)),
                          child: _buildDzikirCard(context, item, index),
                        );
                      },
                      childCount: list.length,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTimeTab({
    required String title,
    required IconData icon,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.15),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 16,
              color: isSelected ? const Color(0xFF137065) : Colors.white70,
            ),
            const SizedBox(width: 6),
            Text(
              title,
              style: GoogleFonts.poppins(
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                color: isSelected ? const Color(0xFF137065) : Colors.white70,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDzikirCard(BuildContext context, DzikirItem item, int index) {
    final currentCount = _counts[item.id] ?? 0;
    final isCompleted = currentCount >= item.targetCount;

    // Kartu beropasitas tinggi agar animasi di background tetap terlihat lembut,
    // namun teks di dalam kartu tetap 100% sangat kontras dan jelas.
    final cardBgColor = Colors.white.withValues(alpha: isCompleted ? 0.96 : 0.92);

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: cardBgColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isCompleted
              ? const Color(0xFF66BB6A)
              : Colors.white.withValues(alpha: 0.6),
          width: isCompleted ? 1.5 : 1.0,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 14,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header Card: Badge Nomor, Judul & Target Hitungan
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: isCompleted
                  ? const Color(0xFFE8F5E9).withValues(alpha: 0.95)
                  : const Color(0xFFF1F8F5).withValues(alpha: 0.95),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
              border: Border(
                bottom: BorderSide(
                  color: isCompleted
                      ? const Color(0xFFC8E6C9)
                      : const Color(0xFFE2EBE8),
                ),
              ),
            ),
            child: Row(
              children: [
                // Nomor Urut
                Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    color: isCompleted
                        ? const Color(0xFF4CAF50)
                        : const Color(0xFF048C7C).withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child: Text(
                      '${index + 1}',
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: isCompleted ? Colors.white : const Color(0xFF048C7C),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                // Judul
                Expanded(
                  child: Text(
                    item.judul,
                    style: GoogleFonts.poppins(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF137065),
                    ),
                  ),
                ),
                // Badge Target Count
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: isCompleted
                        ? const Color(0xFF4CAF50)
                        : const Color(0xFFE8F5F1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '${item.targetCount}x',
                    style: GoogleFonts.poppins(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: isCompleted ? Colors.white : const Color(0xFF048C7C),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Reading Section
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Arabic Text Container (Solid white & contrast border)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: const Color(0xFFE2EBE8)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.02),
                        blurRadius: 4,
                        offset: const Offset(0, 1),
                      ),
                    ],
                  ),
                  child: Text(
                    item.arab,
                    textAlign: TextAlign.right,
                    textDirection: TextDirection.rtl,
                    style: GoogleFonts.amiri(
                      fontSize: _arabicFontSize,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF1A202C),
                      height: 2.1,
                    ),
                  ),
                ),

                // Transliterasi (Latin) - Dikontrol via Toggle
                if (_showLatin && item.transliterasi.isNotEmpty) ...[
                  const SizedBox(height: 12),
                  Text(
                    item.transliterasi,
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      fontStyle: FontStyle.italic,
                      color: const Color(0xFF4A5568),
                      height: 1.45,
                    ),
                  ),
                ],

                // Arti / Terjemahan - Dikontrol via Toggle
                if (_showTranslation) ...[
                  const SizedBox(height: 10),
                  Text(
                    item.arti,
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      color: const Color(0xFF2D3748),
                      height: 1.45,
                    ),
                  ),
                ],

                // Faedah / Riwayat Hadits
                if (item.faedah.isNotEmpty) ...[
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFF9E6),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: const Color(0xFFFFE082)),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(
                          Icons.lightbulb_outline_rounded,
                          size: 16,
                          color: Color(0xFFF57F17),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            item.faedah,
                            style: GoogleFonts.poppins(
                              fontSize: 11,
                              color: const Color(0xFF6D4C41),
                              height: 1.4,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),

          // Bottom Action: Tasbih Counter & Quick Actions (Salin & Share)
          Container(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 14),
            child: Row(
              children: [
                // Tasbih Counter Tap Button
                Expanded(
                  child: InkWell(
                    onTap: () => _incrementCount(item),
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 9, horizontal: 12),
                      decoration: BoxDecoration(
                        color: isCompleted
                            ? const Color(0xFF4CAF50)
                            : const Color(0xFFE8F5F1),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: isCompleted
                              ? const Color(0xFF388E3C)
                              : const Color(0xFF048C7C).withValues(alpha: 0.3),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            isCompleted ? Icons.check_circle_rounded : Icons.fingerprint_rounded,
                            size: 18,
                            color: isCompleted ? Colors.white : const Color(0xFF048C7C),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            isCompleted
                                ? 'Selesai ($currentCount/${item.targetCount})'
                                : 'Ketuk: $currentCount / ${item.targetCount}',
                            style: GoogleFonts.poppins(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: isCompleted ? Colors.white : const Color(0xFF048C7C),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                // Salin Icon Button
                IconButton(
                  icon: const Icon(Icons.copy_rounded, size: 18),
                  tooltip: 'Salin Teks',
                  color: const Color(0xFF137065),
                  onPressed: () => _copyToClipboard(item),
                ),
                // Share Icon Button
                IconButton(
                  icon: const Icon(Icons.share_rounded, size: 18),
                  tooltip: 'Bagikan',
                  color: const Color(0xFF048C7C),
                  onPressed: () => _shareDzikir(item),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
