import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:masjid_app/components/worship/worship_reader_scaffold.dart';
import 'package:masjid_app/components/worship/worship_scripture_block.dart';
import 'package:masjid_app/components/worship/worship_state_views.dart';
import 'package:masjid_app/core/theme/hudhud_theme.dart';
import 'package:masjid_app/models/hadist_data.dart';
import 'package:masjid_app/providers/hadits_providers.dart';
import 'package:skeletonizer/skeletonizer.dart';

class HaditsTemaPage extends ConsumerWidget {
  const HaditsTemaPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final idParam = GoRouterState.of(context).pathParameters['id'];
    final temaId = int.tryParse(idParam ?? '');
    return temaId == null ? _buildDaftar(context, ref) : _buildIsi(context, ref, temaId);
  }

  // ─── Mode daftar ───────────────────────────────────────────

  Widget _buildDaftar(BuildContext context, WidgetRef ref) {
    final t = context.hudhud;
    final asyncTema = ref.watch(haditsTemaProvider);

    return WorshipReaderScaffold(
      title: 'Tema Pilihan',
      subtitle: 'Kumpulan hadits tematik',
      body: asyncTema.when(
        data: (temas) {
          if (temas.isEmpty) {
            return const WorshipEmptyView(
              title: 'Belum Ada Tema',
              message: 'Daftar tema hadits belum tersedia.',
            );
          }
          return ListView.separated(
            padding: EdgeInsets.fromLTRB(t.spaceLg, t.spaceSm, t.spaceLg, t.spaceXl),
            itemCount: temas.length,
            separatorBuilder: (_, __) => const SizedBox(height: 8),
            itemBuilder: (_, i) => _temaTile(context, temas[i]),
          );
        },
        loading: () => Skeletonizer(
          enabled: true,
          child: ListView.separated(
            padding: EdgeInsets.fromLTRB(t.spaceLg, t.spaceSm, t.spaceLg, t.spaceXl),
            itemCount: 8,
            separatorBuilder: (_, __) => const SizedBox(height: 8),
            itemBuilder: (_, i) => _temaTile(
              context,
              const HaditsTema(id: 0, nama: 'Nama tema sedang dimuat...', jumlah: 10),
            ),
          ),
        ),
        error: (_, __) => WorshipErrorView(
          title: 'Gagal Memuat Tema',
          message: 'Silakan periksa koneksi dan coba lagi.',
          onRetry: () => ref.invalidate(haditsTemaProvider),
        ),
      ),
    );
  }

  Widget _temaTile(BuildContext context, HaditsTema tema) {
    final t = context.hudhud;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(t.radiusMd),
        onTap: () => context.push('/hadits/tema/${tema.id}'),
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
                  child: Icon(LucideIcons.tag, size: 16, color: t.terracotta),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      tema.nama,
                      style: TextStyle(
                        fontFamily: 'Roboto',
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: t.charcoal,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${tema.jumlah} hadits',
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

  // ─── Mode isi ──────────────────────────────────────────────

  Widget _buildIsi(BuildContext context, WidgetRef ref, int temaId) {
    final t = context.hudhud;
    final temas = ref.watch(haditsTemaProvider).valueOrNull ?? const <HaditsTema>[];
    final asyncIsi = ref.watch(haditsTemaDetailProvider(temaId));

    var nama = 'Tema';
    for (final item in temas) {
      if (item.id == temaId) {
        nama = item.nama;
        break;
      }
    }

    final subtitle = asyncIsi.valueOrNull != null
        ? '${asyncIsi.valueOrNull!.length} hadits'
        : 'Memuat hadits...';

    return WorshipReaderScaffold(
      title: nama,
      subtitle: subtitle,
      body: asyncIsi.when(
        data: (items) {
          if (items.isEmpty) {
            return const WorshipEmptyView(
              title: 'Hadits Tidak Ditemukan',
              message: 'Tema ini belum memiliki hadits.',
            );
          }
          return ListView.separated(
            padding: EdgeInsets.fromLTRB(t.spaceLg, t.spaceSm, t.spaceLg, t.spaceXl),
            itemCount: items.length,
            separatorBuilder: (_, __) => const SizedBox(height: 10),
            itemBuilder: (_, i) => _koleksiCard(context, items[i]),
          );
        },
        loading: () => Skeletonizer(
          enabled: true,
          child: ListView.separated(
            padding: EdgeInsets.fromLTRB(t.spaceLg, t.spaceSm, t.spaceLg, t.spaceXl),
            itemCount: 4,
            separatorBuilder: (_, __) => const SizedBox(height: 10),
            itemBuilder: (_, i) => _koleksiCard(
              context,
              const HaditsKoleksi(
                id: 0,
                judul: 'Judul hadits sedang dimuat',
                arab: 'بِسْمِ اللَّهِ الرَّحْمَنِ الرَّحِيمِ',
                indo: 'Terjemahan hadits sedang dimuat di sini.',
              ),
            ),
          ),
        ),
        error: (_, __) => WorshipErrorView(
          title: 'Gagal Memuat Isi Tema',
          message: 'Silakan periksa koneksi dan coba lagi.',
          onRetry: () => ref.invalidate(haditsTemaDetailProvider(temaId)),
        ),
      ),
    );
  }

  Widget _koleksiCard(BuildContext context, HaditsKoleksi item) {
    final t = context.hudhud;

    return Container(
      padding: EdgeInsets.all(t.spaceLg),
      decoration: BoxDecoration(
        color: t.surface,
        borderRadius: BorderRadius.circular(t.radiusMd),
        border: Border.all(color: t.outline),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (item.judul.isNotEmpty) ...[
            Text(
              item.judul,
              style: TextStyle(
                fontFamily: 'Roboto',
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: t.terracotta,
              ),
            ),
            const SizedBox(height: 12),
            const Divider(),
            const SizedBox(height: 12),
          ],
          WorshipScriptureBlock(
            arabic: item.arab,
            translation: item.indo,
            arabicFontSize: 22,
          ),
        ],
      ),
    );
  }
}
