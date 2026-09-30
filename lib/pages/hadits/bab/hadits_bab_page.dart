import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:masjid_app/components/worship/worship_reader_scaffold.dart';
import 'package:masjid_app/components/worship/worship_state_views.dart';
import 'package:masjid_app/core/router/app_router.dart';
import 'package:masjid_app/core/theme/hudhud_theme.dart';
import 'package:masjid_app/models/hadist_data.dart';
import 'package:masjid_app/providers/hadits_providers.dart';
import 'package:skeletonizer/skeletonizer.dart';

class HaditsBabPage extends ConsumerWidget {
  const HaditsBabPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final namaTabel = GoRouterState.of(context).pathParameters['id'] ?? '';
    final books = ref.watch(haditsBooksProvider).valueOrNull ?? const <ImamData>[];
    final asyncBab = ref.watch(haditsBabProvider(namaTabel));

    ImamData? book;
    for (final b in books) {
      if (b.namaTabel == namaTabel) {
        book = b;
        break;
      }
    }
    final longNama = book?.longNama ?? 'Hadits ${namaTabel.toUpperCase()}';

    return WorshipReaderScaffold(
      title: longNama,
      subtitle: '${book?.hadits ?? 0} Hadits',
      body: asyncBab.when(
        data: (babs) => _buildBody(
          context,
          namaTabel,
          longNama,
          babs,
          book?.hadits ?? 0,
          isLoading: false,
        ),
        loading: () => _buildBody(
          context,
          namaTabel,
          longNama,
          List.generate(
            8,
            (i) => HaditsBab(
              id: i,
              nama: 'Nama bab sedang dimuat...',
              urutan: i + 1,
              noAwal: 1,
              noAkhir: 10,
            ),
          ),
          book?.hadits ?? 0,
          isLoading: true,
        ),
        error: (_, __) => WorshipErrorView(
          title: 'Gagal Memuat Bab Hadits',
          message: 'Silakan periksa koneksi dan coba lagi.',
          onRetry: () => ref.invalidate(haditsBabProvider(namaTabel)),
        ),
      ),
    );
  }

  Widget _buildBody(
    BuildContext context,
    String namaTabel,
    String longNama,
    List<HaditsBab> babs,
    int totalHadits, {
    required bool isLoading,
  }) {
    final t = context.hudhud;

    return Skeletonizer(
      enabled: isLoading,
      child: ListView.separated(
        padding: EdgeInsets.fromLTRB(t.spaceLg, t.spaceSm, t.spaceLg, t.spaceXl),
        itemCount: babs.length + 1,
        separatorBuilder: (_, __) => const SizedBox(height: 8),
        itemBuilder: (ctx, i) {
          if (i == 0) {
            return _buildAllHaditsTile(context, namaTabel, longNama, totalHadits);
          }
          return _buildBabTile(context, babs[i - 1], namaTabel, longNama);
        },
      ),
    );
  }

  Widget _buildAllHaditsTile(
    BuildContext context,
    String namaTabel,
    String longNama,
    int totalHadits,
  ) {
    final t = context.hudhud;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(t.radiusMd),
        onTap: () => context.push(
          AppRoutes.haditsListRoute.replaceFirst(':id', namaTabel),
        ),
        child: Container(
          constraints: BoxConstraints(minHeight: t.controlHeight),
          padding: EdgeInsets.all(t.spaceMd),
          decoration: BoxDecoration(
            color: t.terracotta,
            borderRadius: BorderRadius.circular(t.radiusMd),
          ),
          child: Row(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(t.radiusSm),
                ),
                child: const Center(
                  child: Icon(LucideIcons.bookOpen, size: 18, color: Colors.white),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Semua Hadits',
                      style: TextStyle(
                        fontFamily: 'Roboto',
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      totalHadits > 0 ? '$totalHadits hadits lengkap' : 'Seluruh kitab',
                      style: const TextStyle(
                        fontFamily: 'Roboto',
                        fontSize: 12,
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(LucideIcons.chevronRight, size: 18, color: Colors.white),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBabTile(
    BuildContext context,
    HaditsBab bab,
    String namaTabel,
    String longNama,
  ) {
    final t = context.hudhud;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(t.radiusMd),
        onTap: () => context.push(
          '${AppRoutes.haditsListRoute.replaceFirst(':id', namaTabel)}?bab=${bab.id}',
        ),
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
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: t.sand,
                  borderRadius: BorderRadius.circular(t.radiusSm),
                ),
                child: Center(
                  child: Text(
                    '${bab.urutan}',
                    style: TextStyle(
                      fontFamily: 'Roboto',
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: t.terracotta,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      bab.nama,
                      style: TextStyle(
                        fontFamily: 'Roboto',
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: t.charcoal,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      bab.noAwal == bab.noAkhir
                          ? 'Hadits ${bab.noAwal}'
                          : 'Hadits ${bab.noAwal}–${bab.noAkhir}',
                      style: TextStyle(
                        fontFamily: 'Roboto',
                        fontSize: 11,
                        color: t.muted,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(LucideIcons.chevronRight, size: 18, color: t.muted),
            ],
          ),
        ),
      ),
    );
  }
}
