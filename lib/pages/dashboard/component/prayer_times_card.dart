import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hijri/hijri_calendar.dart';
import 'package:intl/intl.dart';
import 'package:masjid_app/providers/jadwal_shalat_provider.dart';

class PrayerTimesCard extends ConsumerWidget {
  const PrayerTimesCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final countdownAsync = ref.watch(prayerCountdownProvider);

    final hijriNow = HijriCalendar.now();
    final hijriStr = '${hijriNow.hDay} ${hijriNow.longMonthName} ${hijriNow.hYear} H';
    final now = DateTime.now();
    final todayStr = DateFormat('EEEE, dd MMMM yyyy', 'id_ID').format(now);

    return countdownAsync.when(
      data: (info) {
        if (info == null) {
          return _buildLoadingCard(context);
        }

        final activeCard = info.nextShalat;
        final isDzuhur = activeCard.label == 'Dzuhur';
        final textColor = isDzuhur ? Colors.black87 : Colors.white;

        return Card(
          elevation: 2,
          color: const Color(0xFFF5F5F5),
          margin: const EdgeInsets.only(top: 15),
          clipBehavior: Clip.antiAlias,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: SizedBox(
            width: double.infinity,
            height: 220,
            child: Column(
              children: [
                // Top Banner with Active Prayer Art
                Expanded(
                  flex: 3,
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage(activeCard.cardImage),
                        fit: BoxFit.cover,
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Left: Hijri Date & Greg Date
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              AutoSizeText(
                                hijriStr,
                                maxLines: 1,
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: textColor,
                                ),
                              ),
                              const SizedBox(height: 4),
                              AutoSizeText(
                                todayStr,
                                maxLines: 1,
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.normal,
                                  color: textColor.withOpacity(0.9),
                                ),
                              ),
                            ],
                          ),
                        ),
                        // Right: Next Prayer Countdown Badge
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.35),
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: Colors.white.withOpacity(0.2)),
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                'Menuju ${activeCard.label}',
                                style: const TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                '- ${info.formattedRemaining}',
                                style: const TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF68D8D6),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                // Bottom Row: 5 Prayer Times List
                Container(
                  color: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: info.items.map((item) {
                      final isActive = item.isActive;
                      return Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                        decoration: BoxDecoration(
                          color: isActive ? const Color(0xFF048C7C) : Colors.transparent,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              item.label,
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: isActive ? FontWeight.bold : FontWeight.w500,
                                color: isActive ? Colors.white : Colors.black87,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              item.waktu,
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: isActive ? Colors.white : const Color(0xFF048C7C),
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          ),
        );
      },
      loading: () => _buildLoadingCard(context),
      error: (_, __) => _buildErrorCard(context, ref),
    );
  }

  Widget _buildLoadingCard(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 15),
      height: 220,
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFFE0E0E0),
        borderRadius: BorderRadius.circular(16),
      ),
      child: const Center(
        child: CircularProgressIndicator(color: Color(0xFF048C7C)),
      ),
    );
  }

  Widget _buildErrorCard(BuildContext context, WidgetRef ref) {
    return Container(
      margin: const EdgeInsets.only(top: 15),
      height: 120,
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'Gagal memuat jadwal shalat',
            style: TextStyle(fontSize: 13, color: Colors.black87),
          ),
          const SizedBox(height: 8),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF048C7C),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            onPressed: () => ref.refresh(jadwalShalatProvider),
            icon: const Icon(Icons.refresh, size: 16, color: Colors.white),
            label: const Text('Coba Lagi', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}
