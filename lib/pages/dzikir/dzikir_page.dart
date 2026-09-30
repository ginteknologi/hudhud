import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:masjid_app/components/worship/worship_counter_control.dart';
import 'package:masjid_app/components/worship/worship_progress_indicator.dart';
import 'package:masjid_app/components/worship/worship_reader_scaffold.dart';
import 'package:masjid_app/components/worship/worship_scripture_block.dart';
import 'package:masjid_app/components/worship/worship_share_helper.dart';
import 'package:masjid_app/core/theme/hudhud_theme.dart';
import 'package:masjid_app/models/dzikir_data.dart';

class DzikirPage extends ConsumerStatefulWidget {
  const DzikirPage({super.key});

  @override
  ConsumerState<DzikirPage> createState() => _DzikirPageState();
}

class _DzikirPageState extends ConsumerState<DzikirPage> {
  // false = Dzikir Pagi, true = Dzikir Petang
  bool _isPetang = false;
  int _currentIndex = 0;
  late final PageController _pageController;

  // Hitungan tasbih per dzikir item (id -> count)
  final Map<int, int> _counts = {};

  // Pengaturan Tampilan & Font
  double _arabicFontSize = 22.0;
  bool _showLatin = true;
  bool _showTranslation = true;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    // Default waktu: sebelum jam 15:00 = Pagi, 15:00 ke atas / dini hari = Petang
    final hour = DateTime.now().hour;
    if (hour >= 15 || hour < 4) {
      _isPetang = true;
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  List<DzikirItem> get _currentList => _isPetang
      ? DzikirRepository.dzikirPetangList
      : DzikirRepository.dzikirPagiList;

  void _switchPeriod(bool toPetang) {
    if (_isPetang == toPetang) return;
    setState(() {
      _isPetang = toPetang;
      _currentIndex = 0;
    });
    if (_pageController.hasClients) {
      _pageController.jumpToPage(0);
    }
  }

  void _incrementCount(DzikirItem item) {
    setState(() {
      final current = _counts[item.id] ?? 0;
      if (current < item.targetCount) {
        _counts[item.id] = current + 1;
      } else {
        // Reset jika sudah selesai
        _counts[item.id] = 0;
      }
    });
  }

  void _goToIndex(int index) {
    if (index < 0 || index >= _currentList.length) return;
    final reducedMotion = MediaQuery.of(context).disableAnimations;
    final duration =
        reducedMotion ? Duration.zero : context.hudhud.motionNormal;

    setState(() => _currentIndex = index);
    if (_pageController.hasClients) {
      if (reducedMotion) {
        _pageController.jumpToPage(index);
      } else {
        _pageController.animateToPage(
          index,
          duration: duration,
          curve: Curves.easeInOut,
        );
      }
    }
  }

  void _copyDzikir(DzikirItem item) {
    final text = WorshipShareHelper.formatWorshipText(
      title: item.judul,
      subtitle:
          '(Dibaca ${item.targetCount}x - ${_isPetang ? "Dzikir Petang" : "Dzikir Pagi"})',
      arabic: item.arab,
      latin: _showLatin && item.transliterasi.isNotEmpty
          ? item.transliterasi
          : null,
      translation: _showTranslation && item.arti.isNotEmpty ? item.arti : null,
      source: item.faedah.isNotEmpty ? item.faedah : null,
    );
    WorshipShareHelper.copy(
        text: text, successMessage: 'Dzikir berhasil disalin');
  }

  void _shareDzikir(DzikirItem item) {
    final text = WorshipShareHelper.formatWorshipText(
      title: item.judul,
      subtitle:
          '(Dibaca ${item.targetCount}x - ${_isPetang ? "Dzikir Petang" : "Dzikir Pagi"})',
      arabic: item.arab,
      latin: _showLatin && item.transliterasi.isNotEmpty
          ? item.transliterasi
          : null,
      translation: _showTranslation && item.arti.isNotEmpty ? item.arti : null,
      source: item.faedah.isNotEmpty ? item.faedah : null,
    );
    WorshipShareHelper.share(text: text, subject: item.judul);
  }

  void _showSettingsSheet() {
    final t = context.hudhud;
    showModalBottomSheet(
      context: context,
      backgroundColor: t.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(t.radiusMd)),
      ),
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: EdgeInsets.fromLTRB(
                  t.spaceLg, t.spaceMd, t.spaceLg, t.spaceXl),
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
                  SizedBox(height: t.spaceLg),
                  Text(
                    'Pengaturan Tampilan & Font',
                    style: TextStyle(
                      fontFamily: 'Roboto',
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: t.charcoal,
                    ),
                  ),
                  const SizedBox(height: 16),
                  SwitchListTile(
                    contentPadding: EdgeInsets.zero,
                    activeTrackColor: t.terracotta,
                    title: Text(
                      'Tampilkan Teks Latin',
                      style: TextStyle(
                        fontFamily: 'Roboto',
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: t.charcoal,
                      ),
                    ),
                    subtitle: Text(
                      'Panduan bacaan transliterasi',
                      style: TextStyle(
                          fontFamily: 'Roboto', fontSize: 12, color: t.muted),
                    ),
                    value: _showLatin,
                    onChanged: (val) {
                      setModalState(() => _showLatin = val);
                      setState(() => _showLatin = val);
                    },
                  ),
                  const Divider(),
                  SwitchListTile(
                    contentPadding: EdgeInsets.zero,
                    activeTrackColor: t.terracotta,
                    title: Text(
                      'Tampilkan Terjemahan',
                      style: TextStyle(
                        fontFamily: 'Roboto',
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: t.charcoal,
                      ),
                    ),
                    subtitle: Text(
                      'Arti dalam Bahasa Indonesia',
                      style: TextStyle(
                          fontFamily: 'Roboto', fontSize: 12, color: t.muted),
                    ),
                    value: _showTranslation,
                    onChanged: (val) {
                      setModalState(() => _showTranslation = val);
                      setState(() => _showTranslation = val);
                    },
                  ),
                  const Divider(),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Ukuran Teks Arab',
                        style: TextStyle(
                          fontFamily: 'Roboto',
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: t.charcoal,
                        ),
                      ),
                      Text(
                        '${_arabicFontSize.toInt()} pt',
                        style: TextStyle(
                          fontFamily: 'Roboto',
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: t.terracotta,
                        ),
                      ),
                    ],
                  ),
                  SliderTheme(
                    data: SliderTheme.of(context).copyWith(
                      activeTrackColor: t.terracotta,
                      inactiveTrackColor: t.sand,
                      thumbColor: t.terracotta,
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
    final t = context.hudhud;
    final items = _currentList;
    final safeIndex =
        _currentIndex.clamp(0, items.isEmpty ? 0 : items.length - 1);
    final currentItem = items.isNotEmpty ? items[safeIndex] : null;

    return WorshipReaderScaffold(
      title: 'Dzikir Pagi & Petang',
      subtitle: _isPetang ? 'Al-Ma’tsurat Petang' : 'Al-Ma’tsurat Pagi',
      actions: [
        if (currentItem != null) ...[
          IconButton(
            constraints: const BoxConstraints(minWidth: 48, minHeight: 48),
            icon: const Icon(LucideIcons.copy, size: 20),
            tooltip: 'Salin',
            onPressed: () => _copyDzikir(currentItem),
          ),
          IconButton(
            constraints: const BoxConstraints(minWidth: 48, minHeight: 48),
            icon: const Icon(LucideIcons.share2, size: 20),
            tooltip: 'Bagikan',
            onPressed: () => _shareDzikir(currentItem),
          ),
        ],
        IconButton(
          constraints: const BoxConstraints(minWidth: 48, minHeight: 48),
          icon: const Icon(LucideIcons.settings2, size: 20),
          tooltip: 'Pengaturan Tampilan',
          onPressed: _showSettingsSheet,
        ),
      ],
      body: Column(
        children: [
          // Period Selector + Progress Indicator
          Padding(
            padding:
                EdgeInsets.fromLTRB(t.spaceLg, t.spaceSm, t.spaceLg, t.spaceMd),
            child: Column(
              children: [
                _buildPeriodSelector(t),
                const SizedBox(height: 12),
                WorshipProgressIndicator(
                  currentStep: safeIndex + 1,
                  totalSteps: items.length,
                  trailingLabel: currentItem != null
                      ? 'Target: ${currentItem.targetCount}x'
                      : null,
                ),
              ],
            ),
          ),
          // Single Focus PageView
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              itemCount: items.length,
              onPageChanged: (idx) => setState(() => _currentIndex = idx),
              itemBuilder: (ctx, i) {
                final item = items[i];
                return _buildFocusCard(context, item);
              },
            ),
          ),
          // Navigation Dock & Counter Control
          if (currentItem != null)
            _buildBottomDock(context, currentItem, safeIndex, items.length),
        ],
      ),
    );
  }

  Widget _buildPeriodSelector(HudhudTheme t) {
    return Container(
      height: t.controlHeight,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: t.surface,
        borderRadius: BorderRadius.circular(t.radiusMd),
        border: Border.all(color: t.outline),
      ),
      child: Row(
        children: [
          Expanded(
            child: _buildPeriodButton(
              title: 'Dzikir Pagi',
              icon: LucideIcons.sun,
              isActive: !_isPetang,
              onTap: () => _switchPeriod(false),
            ),
          ),
          const SizedBox(width: 4),
          Expanded(
            child: _buildPeriodButton(
              title: 'Dzikir Petang',
              icon: LucideIcons.moon,
              isActive: _isPetang,
              onTap: () => _switchPeriod(true),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPeriodButton({
    required String title,
    required IconData icon,
    required bool isActive,
    required VoidCallback onTap,
  }) {
    final t = context.hudhud;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(t.radiusSm),
        onTap: onTap,
        child: AnimatedContainer(
          duration: t.motionFast,
          decoration: BoxDecoration(
            color: isActive ? t.terracotta : Colors.transparent,
            borderRadius: BorderRadius.circular(t.radiusSm),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 16,
                color: isActive ? Colors.white : t.muted,
              ),
              const SizedBox(width: 8),
              Text(
                title,
                style: TextStyle(
                  fontFamily: 'Roboto',
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: isActive ? Colors.white : t.muted,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFocusCard(BuildContext context, DzikirItem item) {
    final t = context.hudhud;

    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: t.spaceLg, vertical: t.spaceSm),
      child: Container(
        padding: EdgeInsets.all(t.spaceLg),
        decoration: BoxDecoration(
          color: t.surface,
          borderRadius: BorderRadius.circular(t.radiusMd),
          border: Border.all(color: t.outline),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    item.judul,
                    style: TextStyle(
                      fontFamily: 'Roboto',
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: t.charcoal,
                      height: 1.3,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: t.sand,
                    borderRadius: BorderRadius.circular(t.radiusSm),
                    border: Border.all(color: t.outline),
                  ),
                  child: Text(
                    '${item.targetCount}x',
                    style: TextStyle(
                      fontFamily: 'Roboto',
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: t.terracotta,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Divider(),
            const SizedBox(height: 16),
            WorshipScriptureBlock(
              arabic: item.arab,
              latin: item.transliterasi,
              translation: item.arti,
              note: item.faedah.isNotEmpty ? 'Keutamaan: ${item.faedah}' : null,
              arabicFontSize: _arabicFontSize,
              showLatin: _showLatin,
              showTranslation: _showTranslation,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomDock(
    BuildContext context,
    DzikirItem item,
    int index,
    int total,
  ) {
    final t = context.hudhud;
    final currentCount = _counts[item.id] ?? 0;
    final canPrev = index > 0;
    final canNext = index < total - 1;

    return Container(
      padding: EdgeInsets.fromLTRB(t.spaceLg, t.spaceMd, t.spaceLg, t.spaceLg),
      decoration: BoxDecoration(
        color: t.surface,
        border: Border(top: BorderSide(color: t.outline)),
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            IconButton.outlined(
              constraints: const BoxConstraints(minWidth: 48, minHeight: 48),
              style: IconButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(t.radiusMd),
                ),
                side: BorderSide(
                    color:
                        canPrev ? t.outline : t.outline.withValues(alpha: 0.5)),
              ),
              icon: Icon(
                LucideIcons.chevronLeft,
                size: 20,
                color: canPrev ? t.charcoal : t.muted.withValues(alpha: 0.4),
              ),
              tooltip: 'Sebelumnya',
              onPressed: canPrev ? () => _goToIndex(index - 1) : null,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: WorshipCounterControl(
                count: currentCount,
                target: item.targetCount,
                onTap: () => _incrementCount(item),
              ),
            ),
            const SizedBox(width: 12),
            IconButton.outlined(
              constraints: const BoxConstraints(minWidth: 48, minHeight: 48),
              style: IconButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(t.radiusMd),
                ),
                side: BorderSide(
                    color:
                        canNext ? t.outline : t.outline.withValues(alpha: 0.5)),
              ),
              icon: Icon(
                LucideIcons.chevronRight,
                size: 20,
                color: canNext ? t.charcoal : t.muted.withValues(alpha: 0.4),
              ),
              tooltip: 'Berikutnya',
              onPressed: canNext ? () => _goToIndex(index + 1) : null,
            ),
          ],
        ),
      ),
    );
  }
}
