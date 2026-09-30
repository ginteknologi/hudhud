import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hijri/hijri_calendar.dart';
import 'package:intl/intl.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:masjid_app/core/theme/hudhud_theme.dart';
import 'package:masjid_app/models/jadwal_imsakiah_item.dart';
import 'package:masjid_app/providers/jadwal_imsakiah_provider.dart';
import 'package:masjid_app/providers/location_provider.dart';
import 'package:share_plus/share_plus.dart';

class JadwalImsakiahPage extends ConsumerWidget {
  const JadwalImsakiahPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = context.hudhud;
    final location = ref.watch(locationProvider);
    final selectedDate = ref.watch(selectedImsakiahDateProvider);
    final jadwalAsync = ref.watch(jadwalImsakiahProvider);

    return Scaffold(
      backgroundColor: t.sand,
      appBar: AppBar(
        title: const Text('Jadwal Imsakiyah'),
        actions: [
          IconButton(
            constraints: const BoxConstraints.tightFor(width: 48, height: 48),
            tooltip: 'Bagikan jadwal',
            icon: const Icon(LucideIcons.share2),
            onPressed: () => _shareJadwal(
              location.name,
              selectedDate,
              jadwalAsync.valueOrNull,
            ),
          ),
        ],
      ),
      body: RefreshIndicator(
        color: t.terracotta,
        onRefresh: () async {
          ref.invalidate(jadwalImsakiahProvider);
          await ref.read(jadwalImsakiahProvider.future);
        },
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding:
              EdgeInsets.fromLTRB(t.spaceLg, t.spaceMd, t.spaceLg, t.spaceXl),
          children: [
            _locationBanner(context, location),
            SizedBox(height: t.spaceMd),
            _monthNavigator(context, ref, selectedDate),
            SizedBox(height: t.spaceMd),
            jadwalAsync.when(
              data: (items) => items.isEmpty
                  ? _emptyState(context, ref)
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        _todayCard(context, items),
                        SizedBox(height: t.spaceMd),
                        _tableCard(context, items),
                      ],
                    ),
              loading: () => _loadingState(context),
              error: (_, __) => _errorState(context, ref),
            ),
          ],
        ),
      ),
    );
  }

  Widget _locationBanner(BuildContext context, SavedLocation location) {
    final t = context.hudhud;
    final hijriNow = HijriCalendar.now();
    return Container(
      constraints: BoxConstraints(minHeight: t.controlHeight),
      padding: EdgeInsets.all(t.spaceMd),
      decoration: BoxDecoration(
        color: t.surface,
        borderRadius: BorderRadius.circular(t.radiusMd),
        border: Border.all(color: t.outline),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(LucideIcons.mapPin, size: 18, color: t.terracotta),
              SizedBox(width: t.spaceSm),
              Expanded(
                child: Text(
                  '${location.name}${location.isGps ? '' : ' (perkiraan)'}',
                  style: TextStyle(
                      fontFamily: 'Roboto',
                      fontWeight: FontWeight.w600,
                      color: t.charcoal),
                ),
              ),
            ],
          ),
          SizedBox(height: t.spaceXs),
          Text(
            '${hijriNow.hDay} ${hijriNow.longMonthName} ${hijriNow.hYear} H',
            style: TextStyle(fontFamily: 'Roboto', color: t.muted),
          ),
        ],
      ),
    );
  }

  Widget _monthNavigator(
      BuildContext context, WidgetRef ref, DateTime selectedDate) {
    final t = context.hudhud;
    final monthName = DateFormat('MMMM yyyy', 'id_ID').format(selectedDate);
    return Container(
      constraints: BoxConstraints(minHeight: t.controlHeight),
      padding: EdgeInsets.symmetric(horizontal: t.spaceSm),
      decoration: BoxDecoration(
        color: t.surface,
        borderRadius: BorderRadius.circular(t.radiusMd),
        border: Border.all(color: t.outline),
      ),
      child: Row(
        children: [
          IconButton(
            constraints: const BoxConstraints.tightFor(width: 48, height: 48),
            tooltip: 'Bulan sebelumnya',
            icon: Icon(LucideIcons.chevronLeft, color: t.terracotta),
            onPressed: () => ref
                .read(selectedImsakiahDateProvider.notifier)
                .state = DateTime(selectedDate.year, selectedDate.month - 1, 1),
          ),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(LucideIcons.calendarDays, size: 18, color: t.terracotta),
                SizedBox(width: t.spaceSm),
                Flexible(
                  child: Text(
                    monthName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        fontFamily: 'Roboto',
                        fontWeight: FontWeight.w700,
                        color: t.charcoal),
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            constraints: const BoxConstraints.tightFor(width: 48, height: 48),
            tooltip: 'Bulan berikutnya',
            icon: Icon(LucideIcons.chevronRight, color: t.terracotta),
            onPressed: () => ref
                .read(selectedImsakiahDateProvider.notifier)
                .state = DateTime(selectedDate.year, selectedDate.month + 1, 1),
          ),
        ],
      ),
    );
  }

  Widget _todayCard(BuildContext context, List<JadwalImsakiahItem> items) {
    final t = context.hudhud;
    final item =
        items.where((it) => it.isToday).firstOrNull ?? items.firstOrNull;
    if (item == null) return const SizedBox.shrink();
    return Container(
      padding: EdgeInsets.all(t.spaceMd),
      decoration: BoxDecoration(
        color: t.surface,
        borderRadius: BorderRadius.circular(t.radiusMd),
        border: Border.all(color: t.outline),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(LucideIcons.calendarCheck, size: 20, color: t.terracotta),
              SizedBox(width: t.spaceSm),
              Expanded(
                child: Text(
                  item.isToday ? 'Hari ini' : '${item.hari}, ${item.tanggal}',
                  style: TextStyle(
                      fontFamily: 'Roboto',
                      fontWeight: FontWeight.w700,
                      color: t.charcoal),
                ),
              ),
              if (item.isToday)
                Flexible(
                  child: Text(
                    '${item.hari}, ${item.tanggal}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.end,
                    style: TextStyle(
                        fontFamily: 'Roboto', fontSize: 12, color: t.muted),
                  ),
                ),
            ],
          ),
          SizedBox(height: t.spaceMd),
          LayoutBuilder(
            builder: (context, constraints) {
              final timeCards = [
                _timeBox(context, 'Imsak', item.imsak, LucideIcons.alarmClock),
                _timeBox(context, 'Berbuka', item.berbuka, LucideIcons.sunset),
              ];
              if (constraints.maxWidth < 340) {
                return Column(
                  children: [
                    timeCards[0],
                    SizedBox(height: t.spaceSm),
                    timeCards[1],
                  ],
                );
              }
              return Row(
                children: [
                  Expanded(child: timeCards[0]),
                  SizedBox(width: t.spaceSm),
                  Expanded(child: timeCards[1]),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _timeBox(
      BuildContext context, String label, String time, IconData icon) {
    final t = context.hudhud;
    return Container(
      constraints: BoxConstraints(minHeight: t.controlHeight),
      padding: EdgeInsets.symmetric(horizontal: t.spaceSm, vertical: t.spaceSm),
      decoration: BoxDecoration(
        color: t.sand,
        borderRadius: BorderRadius.circular(t.radiusSm),
        border: Border.all(color: t.outline),
      ),
      child: Row(
        children: [
          Icon(icon, size: 18, color: t.terracotta),
          SizedBox(width: t.spaceSm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      fontFamily: 'Roboto', fontSize: 12, color: t.muted),
                ),
                Text(
                  time,
                  maxLines: 1,
                  style: TextStyle(
                      fontFamily: 'Roboto',
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: t.charcoal),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _tableCard(BuildContext context, List<JadwalImsakiahItem> items) {
    final t = context.hudhud;
    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: t.surface,
        borderRadius: BorderRadius.circular(t.radiusMd),
        border: Border.all(color: t.outline),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: SizedBox(
          width: 560,
          child: Column(
            children: [
              _tableRow(
                  context, const ['No', 'Tanggal', 'Hari', 'Imsak', 'Berbuka'],
                  header: true),
              for (var index = 0; index < items.length; index++) ...[
                if (index > 0) Divider(height: 1, color: t.outline),
                _tableRow(
                  context,
                  [
                    items[index].no.toString(),
                    items[index].tanggal,
                    items[index].hari,
                    items[index].imsak,
                    items[index].berbuka,
                  ],
                  highlighted: items[index].isToday,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _tableRow(BuildContext context, List<String> cells,
      {bool header = false, bool highlighted = false}) {
    final t = context.hudhud;
    const flexes = [1, 3, 3, 3, 3];
    return Container(
      constraints: BoxConstraints(minHeight: t.controlHeight),
      color: header
          ? t.terracotta
          : highlighted
              ? t.amber.withValues(alpha: .16)
              : t.surface,
      padding: EdgeInsets.symmetric(horizontal: t.spaceSm, vertical: t.spaceXs),
      child: Row(
        children: [
          for (var i = 0; i < cells.length; i++)
            Expanded(
              flex: flexes[i],
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: t.spaceXs),
                child: Text(
                  cells[i],
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Roboto',
                    fontWeight: header || highlighted
                        ? FontWeight.w700
                        : FontWeight.normal,
                    color: header
                        ? Colors.white
                        : highlighted
                            ? t.terracottaDark
                            : t.charcoal,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _loadingState(BuildContext context) => Padding(
        padding: EdgeInsets.all(context.hudhud.spaceXl),
        child: Center(
            child: CircularProgressIndicator(color: context.hudhud.terracotta)),
      );

  Widget _emptyState(BuildContext context, WidgetRef ref) {
    return _stateCard(
      context,
      icon: LucideIcons.calendarDays,
      title: 'Data jadwal belum tersedia',
      action: FilledButton(
        onPressed: () => ref.invalidate(jadwalImsakiahProvider),
        child: const Text('Muat ulang'),
      ),
    );
  }

  Widget _errorState(BuildContext context, WidgetRef ref) => _stateCard(
        context,
        icon: LucideIcons.wifiOff,
        title: 'Gagal memuat jadwal imsakiyah',
        message: 'Periksa koneksi internet lalu coba kembali.',
        action: FilledButton.icon(
          onPressed: () => ref.invalidate(jadwalImsakiahProvider),
          icon: const Icon(LucideIcons.refreshCw, size: 18),
          label: const Text('Coba lagi'),
        ),
      );

  Widget _stateCard(BuildContext context,
      {required IconData icon,
      required String title,
      String? message,
      required Widget action}) {
    final t = context.hudhud;
    return Container(
      constraints: BoxConstraints(minHeight: t.controlHeight),
      padding: EdgeInsets.all(t.spaceLg),
      decoration: BoxDecoration(
        color: t.surface,
        borderRadius: BorderRadius.circular(t.radiusMd),
        border: Border.all(color: t.outline),
      ),
      child: Column(
        children: [
          Icon(icon, size: 32, color: t.terracotta),
          SizedBox(height: t.spaceSm),
          Text(title,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleSmall),
          if (message != null) ...[
            SizedBox(height: t.spaceXs),
            Text(message,
                textAlign: TextAlign.center,
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium
                    ?.copyWith(color: t.muted)),
          ],
          SizedBox(height: t.spaceMd),
          action,
        ],
      ),
    );
  }

  Future<void> _shareJadwal(String locationName, DateTime selectedDate,
      List<JadwalImsakiahItem>? items) async {
    final monthStr = DateFormat('MMMM yyyy', 'id_ID').format(selectedDate);
    final todayItem =
        items?.where((it) => it.isToday).firstOrNull ?? items?.firstOrNull;
    final buffer = StringBuffer()
      ..writeln('🌙 *Jadwal Imsakiyah - $locationName*')
      ..writeln('📅 Periode: $monthStr\n');
    if (todayItem != null) {
      buffer
        ..writeln('📌 *Hari Ini (${todayItem.hari}, ${todayItem.tanggal})*')
        ..writeln('• Imsak: ${todayItem.imsak} WIB')
        ..writeln('• Berbuka: ${todayItem.berbuka} WIB\n');
    }
    buffer.writeln('Dapatkan jadwal ibadah lengkap di aplikasi Hudhud.');
    await SharePlus.instance.share(
      ShareParams(
          text: buffer.toString(),
          subject: 'Jadwal Imsakiyah $monthStr - $locationName'),
    );
  }
}
