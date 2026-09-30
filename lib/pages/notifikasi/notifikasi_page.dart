import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:masjid_app/core/router/app_router.dart';
import 'package:masjid_app/core/theme/hudhud_theme.dart';
import 'package:masjid_app/providers/notifikasi_provider.dart';

class NotifikasiPage extends ConsumerWidget {
  const NotifikasiPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = context.hudhud;
    final listAsync = ref.watch(notifikasiListProvider);

    return Scaffold(
      backgroundColor: t.sand,
      appBar: AppBar(title: const Text('Notifikasi')),
      body: listAsync.when(
        data: (list) => list.isEmpty
            ? _emptyState(context)
            : ListView.separated(
                padding: EdgeInsets.all(t.spaceLg),
                itemCount: list.length,
                separatorBuilder: (_, __) => SizedBox(height: t.spaceSm),
                itemBuilder: (context, index) {
                  final item = list[index] as Map<String, dynamic>;
                  final type = item['jenis_notifikasi']?.toString() ?? '';
                  final createdAt = DateTime.tryParse(item['createdAt']?.toString() ?? '');
                  final dateLabel = createdAt == null
                      ? ''
                      : DateFormat('HH:mm, d MMM yyyy', 'id_ID').format(createdAt);
                  return _NotificationTile(
                    title: item['judul']?.toString() ?? 'Notifikasi',
                    category: type,
                    dateLabel: dateLabel,
                    onTap: type == 'transaksi'
                        ? () => context.push(
                              AppRoutes.notifikasiDetail.replaceFirst(
                                ':id',
                                item['id'].toString(),
                              ),
                            )
                        : null,
                  );
                },
              ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(
          child: Padding(
            padding: EdgeInsets.all(t.spaceLg),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(LucideIcons.wifiOff, size: 36, color: t.danger),
                SizedBox(height: t.spaceMd),
                Text(
                  'Gagal memuat notifikasi',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                SizedBox(height: t.spaceSm),
                Text(
                  'Periksa koneksi lalu coba kembali.',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: t.muted),
                ),
                SizedBox(height: t.spaceMd),
                FilledButton.icon(
                  onPressed: () => ref.invalidate(notifikasiListProvider),
                  icon: const Icon(LucideIcons.refreshCw, size: 18),
                  label: const Text('Coba lagi'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _emptyState(BuildContext context) {
    final t = context.hudhud;
    return Center(
      child: Padding(
        padding: EdgeInsets.all(t.spaceXl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(LucideIcons.bellOff, size: 40, color: t.muted),
            SizedBox(height: t.spaceMd),
            Text('Belum ada notifikasi', style: Theme.of(context).textTheme.titleMedium),
            SizedBox(height: t.spaceXs),
            Text(
              'Notifikasi baru akan muncul di sini.',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: t.muted),
            ),
          ],
        ),
      ),
    );
  }
}

class _NotificationTile extends StatelessWidget {
  const _NotificationTile({
    required this.title,
    required this.category,
    required this.dateLabel,
    required this.onTap,
  });

  final String title;
  final String category;
  final String dateLabel;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final t = context.hudhud;
    return Material(
      color: t.surface,
      borderRadius: BorderRadius.circular(t.radiusMd),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(t.radiusMd),
        child: Container(
          constraints: BoxConstraints(minHeight: t.controlHeight),
          padding: EdgeInsets.all(t.spaceMd),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(t.radiusMd),
            border: Border.all(color: t.outline),
          ),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: t.sand,
                  borderRadius: BorderRadius.circular(t.radiusSm),
                ),
                child: Icon(
                  category == 'transaksi' ? LucideIcons.receiptText : LucideIcons.bell,
                  size: 18,
                  color: t.terracotta,
                ),
              ),
              SizedBox(width: t.spaceMd),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: Theme.of(context).textTheme.titleSmall),
                    if (category.isNotEmpty) ...[
                      SizedBox(height: t.spaceXs),
                      Text(
                        category,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(color: t.muted),
                      ),
                    ],
                  ],
                ),
              ),
              SizedBox(width: t.spaceSm),
              if (dateLabel.isNotEmpty)
                Text(
                  dateLabel,
                  textAlign: TextAlign.end,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(color: t.muted),
                ),
              if (onTap != null) ...[
                SizedBox(width: t.spaceXs),
                Icon(LucideIcons.chevronRight, size: 18, color: t.muted),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
