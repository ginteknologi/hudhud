import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hijri/hijri_calendar.dart';
import 'package:intl/intl.dart';
import 'package:masjid_app/models/jadwal_imsakiah_item.dart';
import 'package:masjid_app/providers/jadwal_imsakiah_provider.dart';
import 'package:masjid_app/providers/location_provider.dart';
import 'package:share_plus/share_plus.dart';

class JadwalImsakiahPage extends ConsumerWidget {
  const JadwalImsakiahPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final location = ref.watch(locationProvider);
    final selectedDate = ref.watch(selectedImsakiahDateProvider);
    final jadwalAsync = ref.watch(jadwalImsakiahProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFF6F8F7),
      appBar: AppBar(
        backgroundColor: const Color(0xFF048C7C),
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'Jadwal Imsakiyah',
          style: GoogleFonts.plusJakartaSans(
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        actions: [
          IconButton(
            tooltip: 'Bagikan Jadwal',
            icon: const Icon(Icons.share_outlined),
            onPressed: () => _shareJadwal(context, ref, location.name, selectedDate, jadwalAsync.valueOrNull),
          ),
        ],
      ),
      body: RefreshIndicator(
        color: const Color(0xFF048C7C),
        onRefresh: () async {
          ref.invalidate(jadwalImsakiahProvider);
          await ref.read(jadwalImsakiahProvider.future);
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            children: [
              _buildHeaderSection(context, ref, location, selectedDate),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Column(
                  children: [
                    _buildMonthNavigator(context, ref, selectedDate),
                    const SizedBox(height: 12),
                    jadwalAsync.when(
                      data: (items) {
                        if (items.isEmpty) {
                          return _buildEmptyState(context, ref);
                        }
                        return Column(
                          children: [
                            _buildTodayHighlightCard(items),
                            const SizedBox(height: 16),
                            _buildTableCard(context, items),
                          ],
                        );
                      },
                      loading: () => _buildLoadingState(),
                      error: (err, _) => _buildErrorState(context, ref, err.toString()),
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderSection(
    BuildContext context,
    WidgetRef ref,
    SavedLocation location,
    DateTime selectedDate,
  ) {
    final hijriNow = HijriCalendar.now();
    final hijriStr = '${hijriNow.hDay} ${hijriNow.longMonthName} ${hijriNow.hYear} H';

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 20),
      decoration: const BoxDecoration(
        color: Color(0xFF048C7C),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(24),
          bottomRight: Radius.circular(24),
        ),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.location_on, color: Colors.white, size: 16),
                const SizedBox(width: 6),
                Flexible(
                  child: Text(
                    location.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.plusJakartaSans(
                      color: Colors.white,
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Text(
            hijriStr,
            style: GoogleFonts.plusJakartaSans(
              color: const Color(0xFFD0F0EA),
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMonthNavigator(
    BuildContext context,
    WidgetRef ref,
    DateTime selectedDate,
  ) {
    final monthName = DateFormat('MMMM yyyy', 'id_ID').format(selectedDate);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2EBE8)),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF048C7C).withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: const Icon(Icons.chevron_left, color: Color(0xFF048C7C)),
            onPressed: () {
              ref.read(selectedImsakiahDateProvider.notifier).state = DateTime(
                selectedDate.year,
                selectedDate.month - 1,
                1,
              );
            },
          ),
          Row(
            children: [
              const Icon(Icons.calendar_month, color: Color(0xFF048C7C), size: 18),
              const SizedBox(width: 8),
              Text(
                monthName,
                style: GoogleFonts.plusJakartaSans(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                  color: const Color(0xFF1F2937),
                ),
              ),
            ],
          ),
          IconButton(
            icon: const Icon(Icons.chevron_right, color: Color(0xFF048C7C)),
            onPressed: () {
              ref.read(selectedImsakiahDateProvider.notifier).state = DateTime(
                selectedDate.year,
                selectedDate.month + 1,
                1,
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildTodayHighlightCard(List<JadwalImsakiahItem> items) {
    final todayItem = items.where((it) => it.isToday).firstOrNull ?? items.firstOrNull;
    if (todayItem == null) return const SizedBox.shrink();

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF048C7C), Color(0xFF1DB4A2)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF048C7C).withValues(alpha: 0.25),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.2),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.today, color: Colors.white, size: 16),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    todayItem.isToday ? 'Hari Ini' : '${todayItem.hari}, ${todayItem.tanggal}',
                    style: GoogleFonts.plusJakartaSans(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              if (todayItem.isToday)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.25),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '${todayItem.hari}, ${todayItem.tanggal}',
                    style: GoogleFonts.plusJakartaSans(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: _buildTimeBox(
                  label: 'Imsak',
                  time: todayItem.imsak,
                  icon: Icons.alarm,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildTimeBox(
                  label: 'Berbuka (Maghrib)',
                  time: todayItem.berbuka,
                  icon: Icons.wb_twilight,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTimeBox({
    required String label,
    required String time,
    required IconData icon,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.white, size: 22),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: GoogleFonts.plusJakartaSans(
                    color: const Color(0xFFD0F0EA),
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  time,
                  style: GoogleFonts.plusJakartaSans(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTableCard(BuildContext context, List<JadwalImsakiahItem> items) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFE2EBE8)),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF048C7C).withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          // Header Table
          Container(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
            decoration: const BoxDecoration(
              color: Color(0xFF048C7C),
            ),
            child: Row(
              children: [
                _buildHeaderCell('No', flex: 1),
                _buildHeaderCell('Tanggal', flex: 3),
                _buildHeaderCell('Hari', flex: 3),
                _buildHeaderCell('Imsak', flex: 3),
                _buildHeaderCell('Berbuka', flex: 3),
              ],
            ),
          ),
          // Rows
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: items.length,
            separatorBuilder: (_, __) => const Divider(
              height: 1,
              thickness: 1,
              color: Color(0xFFF0F4F2),
            ),
            itemBuilder: (context, index) {
              final item = items[index];
              return Container(
                color: item.isToday ? const Color(0xFFE6F5F3) : Colors.transparent,
                padding: const EdgeInsets.symmetric(vertical: 11, horizontal: 8),
                child: Row(
                  children: [
                    _buildBodyCell(item.no.toString(), flex: 1, isBold: item.isToday),
                    _buildBodyCell(item.tanggal, flex: 3, isBold: item.isToday),
                    _buildBodyCell(item.hari, flex: 3, isBold: item.isToday),
                    _buildBodyCell(item.imsak, flex: 3, isBold: item.isToday, highlight: item.isToday),
                    _buildBodyCell(item.berbuka, flex: 3, isBold: item.isToday, highlight: item.isToday),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderCell(String label, {required int flex}) {
    return Expanded(
      flex: flex,
      child: Text(
        label,
        textAlign: TextAlign.center,
        style: GoogleFonts.plusJakartaSans(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
      ),
    );
  }

  Widget _buildBodyCell(
    String text, {
    required int flex,
    bool isBold = false,
    bool highlight = false,
  }) {
    return Expanded(
      flex: flex,
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: GoogleFonts.plusJakartaSans(
          fontSize: 12,
          fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
          color: highlight
              ? const Color(0xFF048C7C)
              : (isBold ? const Color(0xFF1F2937) : const Color(0xFF4B5563)),
        ),
      ),
    );
  }

  Widget _buildLoadingState() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 48),
      child: const Center(
        child: CircularProgressIndicator(
          color: Color(0xFF048C7C),
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context, WidgetRef ref) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 24),
      alignment: Alignment.center,
      child: Column(
        children: [
          const Icon(Icons.calendar_today_outlined, size: 48, color: Colors.grey),
          const SizedBox(height: 12),
          Text(
            'Data jadwal belum tersedia',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 12),
          OutlinedButton(
            onPressed: () => ref.invalidate(jadwalImsakiahProvider),
            child: const Text('Muat Ulang'),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(BuildContext context, WidgetRef ref, String error) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 36, horizontal: 24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2EBE8)),
      ),
      child: Column(
        children: [
          const Icon(Icons.wifi_off_rounded, color: Colors.orange, size: 44),
          const SizedBox(height: 12),
          Text(
            'Gagal memuat jadwal imsakiah',
            style: GoogleFonts.plusJakartaSans(
              fontWeight: FontWeight.bold,
              fontSize: 14,
              color: const Color(0xFF1F2937),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Pastikan koneksi internet aktif dan silakan coba lagi.',
            textAlign: TextAlign.center,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 12,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF048C7C),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            icon: const Icon(Icons.refresh, size: 18),
            label: const Text('Coba Lagi'),
            onPressed: () => ref.invalidate(jadwalImsakiahProvider),
          ),
        ],
      ),
    );
  }

  void _shareJadwal(
    BuildContext context,
    WidgetRef ref,
    String locationName,
    DateTime selectedDate,
    List<JadwalImsakiahItem>? items,
  ) {
    final monthStr = DateFormat('MMMM yyyy', 'id_ID').format(selectedDate);
    final todayItem = items?.where((it) => it.isToday).firstOrNull ?? items?.firstOrNull;

    final buffer = StringBuffer();
    buffer.writeln('🌙 *Jadwal Imsakiyah - $locationName*');
    buffer.writeln('📅 Periode: $monthStr\n');

    if (todayItem != null) {
      buffer.writeln('📌 *Hari Ini (${todayItem.hari}, ${todayItem.tanggal})*');
      buffer.writeln('• Imsak: ${todayItem.imsak} WIB');
      buffer.writeln('• Berbuka: ${todayItem.berbuka} WIB\n');
    }

    buffer.writeln('Dapatkan jadwal ibadah lengkap di aplikasi Marbot.');

    SharePlus.instance.share(
      ShareParams(
        text: buffer.toString(),
        subject: 'Jadwal Imsakiyah $monthStr - $locationName',
      ),
    );
  }
}
