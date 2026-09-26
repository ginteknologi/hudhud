import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:masjid_app/core/utils/map_launcher_helper.dart';
import 'package:masjid_app/models/nearby_masjid_model.dart';
import 'package:masjid_app/providers/location_provider.dart';
import 'package:masjid_app/providers/nearby_masjid_provider.dart';
import 'package:masjid_app/pages/masjid_terdekat/component/radar_search_loading_widget.dart';

enum ViewMode { list, map }

class CariMasjidPage extends ConsumerStatefulWidget {
  const CariMasjidPage({super.key});

  @override
  ConsumerState<CariMasjidPage> createState() => _CariMasjidPageState();
}

class _CariMasjidPageState extends ConsumerState<CariMasjidPage> {
  ViewMode _viewMode = ViewMode.list;
  final MapController _mapController = MapController();

  @override
  Widget build(BuildContext context) {
    final location = ref.watch(locationProvider);
    final selectedRadius = ref.watch(searchRadiusProvider);
    final asyncMasjids = ref.watch(nearbyMasjidsProvider);

    final userLat = location.latitude ?? -6.3688;
    final userLng = location.longitude ?? 106.8833;
    final userCenter = LatLng(userLat, userLng);

    return Scaffold(
      backgroundColor: const Color(0xFFF7FAF8),
      appBar: AppBar(
        title: const Text(
          'Masjid Terdekat',
          style: TextStyle(
            color: Color(0xFF1E293B),
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0.5,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Color(0xFF1E293B), size: 20),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          // Toggle View Mode (List <-> Map)
          IconButton(
            icon: Icon(
              _viewMode == ViewMode.list ? Icons.map_outlined : Icons.format_list_bulleted,
              color: const Color(0xFF048C7C),
            ),
            tooltip: _viewMode == ViewMode.list ? 'Tampilkan Peta' : 'Tampilkan Daftar',
            onPressed: () {
              setState(() {
                _viewMode = _viewMode == ViewMode.list ? ViewMode.map : ViewMode.list;
              });
            },
          ),
          IconButton(
            icon: const Icon(Icons.refresh, color: Color(0xFF048C7C)),
            tooltip: 'Segarkan',
            onPressed: () {
              ref.invalidate(nearbyMasjidsProvider);
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // 1. Lokasi Pengguna Banner
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            color: Colors.white,
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFF048C7C).withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.my_location,
                    color: Color(0xFF048C7C),
                    size: 18,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Lokasi Anda',
                        style: TextStyle(
                          fontSize: 11,
                          color: Color(0xFF64748B),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 1),
                      Text(
                        location.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF1E293B),
                        ),
                      ),
                    ],
                  ),
                ),
                TextButton.icon(
                  onPressed: location.loading
                      ? null
                      : () async {
                          final msg = await ref.read(locationProvider.notifier).detect();
                          if (msg != null && context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(msg)),
                            );
                          } else {
                            ref.invalidate(nearbyMasjidsProvider);
                          }
                        },
                  style: TextButton.styleFrom(
                    visualDensity: VisualDensity.compact,
                    foregroundColor: const Color(0xFF048C7C),
                  ),
                  icon: location.loading
                      ? const SizedBox(
                          width: 14,
                          height: 14,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.gps_fixed, size: 16),
                  label: Text(
                    location.loading ? 'Mencari...' : 'GPS',
                    style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),

          // 2. Filter Radius
          Container(
            padding: const EdgeInsets.fromLTRB(16, 4, 16, 10),
            color: Colors.white,
            child: Row(
              children: [
                const Text(
                  'Radius: ',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF64748B),
                  ),
                ),
                const SizedBox(width: 8),
                _buildRadiusChip(ref, selectedRadius, 1000, '1 km'),
                const SizedBox(width: 6),
                _buildRadiusChip(ref, selectedRadius, 3000, '3 km'),
                const SizedBox(width: 6),
                _buildRadiusChip(ref, selectedRadius, 5000, '5 km'),
                const Spacer(),
                // Quick Toggle Pill Button
                Container(
                  padding: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF1F5F9),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    children: [
                      _buildModeIcon(
                        icon: Icons.format_list_bulleted,
                        active: _viewMode == ViewMode.list,
                        onTap: () => setState(() => _viewMode = ViewMode.list),
                      ),
                      _buildModeIcon(
                        icon: Icons.map,
                        active: _viewMode == ViewMode.map,
                        onTap: () => setState(() => _viewMode = ViewMode.map),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const Divider(height: 1, color: Color(0xFFE2EBE8)),

          // 3. Konten Utama (List View atau Map View)
          Expanded(
            child: asyncMasjids.when(
              loading: () => _buildLoadingState(),
              error: (err, stack) => _buildErrorState(context, ref, err.toString()),
              data: (masjids) {
                if (_viewMode == ViewMode.map) {
                  return _buildFullMapView(userCenter, masjids);
                }

                if (masjids.isEmpty) {
                  return _buildEmptyState(ref);
                }

                return ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: masjids.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final item = masjids[index];
                    return _buildMasjidCard(context, item);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildModeIcon({
    required IconData icon,
    required bool active,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: active ? const Color(0xFF048C7C) : Colors.transparent,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Icon(
          icon,
          size: 16,
          color: active ? Colors.white : const Color(0xFF64748B),
        ),
      ),
    );
  }

  /// Tampilan Peta Interaktif OpenStreetMap (Free Version)
  Widget _buildFullMapView(LatLng userCenter, List<NearbyMasjid> masjids) {
    return Stack(
      children: [
        FlutterMap(
          mapController: _mapController,
          options: MapOptions(
            initialCenter: userCenter,
            initialZoom: 14.5,
            interactionOptions: const InteractionOptions(
              flags: InteractiveFlag.all,
            ),
          ),
          children: [
            // Tile Layer OpenStreetMap Resmi (100% Gratis & Bersih tanpa watermark API Key)
            TileLayer(
              urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
              userAgentPackageName: 'com.masjid.marbot',
            ),
            // Pin Lokasi User
            MarkerLayer(
              markers: [
                Marker(
                  point: userCenter,
                  width: 50,
                  height: 50,
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: const Color(0xFF0284C7),
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 2.5),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.2),
                              blurRadius: 6,
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.person_pin,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    ],
                  ),
                ),
                // Pin Masjid-masjid
                ...masjids.map((masjid) {
                  return Marker(
                    point: LatLng(masjid.latitude, masjid.longitude),
                    width: 44,
                    height: 44,
                    child: GestureDetector(
                      onTap: () {
                        _showMasjidDetailBottomSheet(context, masjid);
                      },
                      child: Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: const Color(0xFF048C7C),
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white, width: 2),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.25),
                                  blurRadius: 4,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: const Icon(
                              Icons.mosque,
                              color: Colors.white,
                              size: 18,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }),
              ],
            ),
          ],
        ),

        // Floating Action Button untuk re-center ke posisi user
        Positioned(
          right: 16,
          bottom: 24,
          child: FloatingActionButton.small(
            backgroundColor: Colors.white,
            foregroundColor: const Color(0xFF048C7C),
            elevation: 3,
            onPressed: () {
              _mapController.move(userCenter, 15);
            },
            child: const Icon(Icons.my_location),
          ),
        ),

        // Banner count masjid di atas peta
        Positioned(
          top: 12,
          left: 16,
          right: 16,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.95),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.08),
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.place, size: 16, color: Color(0xFF048C7C)),
                const SizedBox(width: 6),
                Text(
                  '${masjids.length} masjid ditemukan di sekitar Anda',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1E293B),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  /// Bottom Sheet saat Pin Masjid di Peta di-tap
  void _showMasjidDetailBottomSheet(BuildContext context, NearbyMasjid item) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return Container(
          margin: const EdgeInsets.all(16),
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                blurRadius: 16,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: const Color(0xFF048C7C).withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(
                      Icons.mosque,
                      color: Color(0xFF048C7C),
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.name,
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1E293B),
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'Jarak ~${item.formattedDistance} dari posisi Anda',
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF048C7C),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                item.address ?? 'Sekitar area lokasi Anda',
                style: const TextStyle(fontSize: 13, color: Color(0xFF64748B)),
              ),
              const SizedBox(height: 18),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF048C7C),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () {
                    Navigator.of(ctx).pop();
                    MapLauncherHelper.openMapDirection(
                      destinationLat: item.latitude,
                      destinationLng: item.longitude,
                      destinationName: item.name,
                    );
                  },
                  icon: const Icon(Icons.navigation, size: 18),
                  label: const Text(
                    'Buka Rute di Google Maps',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildRadiusChip(WidgetRef ref, int current, int value, String label) {
    final isSelected = current == value;
    return InkWell(
      onTap: () {
        ref.read(searchRadiusProvider.notifier).state = value;
      },
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF048C7C) : const Color(0xFFF1F5F9),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 11,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            color: isSelected ? Colors.white : const Color(0xFF475569),
          ),
        ),
      ),
    );
  }

  Widget _buildMasjidCard(BuildContext context, NearbyMasjid item) {
    return Container(
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
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () {
            MapLauncherHelper.openMapDirection(
              destinationLat: item.latitude,
              destinationLng: item.longitude,
              destinationName: item.name,
            );
          },
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Icon Masjid
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: const Color(0xFF048C7C).withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: SvgPicture.asset(
                      'assets/icons/wews.svg',
                      width: 24,
                      height: 24,
                      colorFilter: const ColorFilter.mode(
                        Color(0xFF048C7C),
                        BlendMode.srcIn,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),

                // Info Masjid
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.name,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF1E293B),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        item.address ?? 'Sekitar lokasi Anda',
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Color(0xFF64748B),
                          height: 1.3,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 3,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFF048C7C).withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(
                                  Icons.directions_walk,
                                  size: 14,
                                  color: Color(0xFF048C7C),
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  item.formattedDistance,
                                  style: const TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w700,
                                    color: Color(0xFF048C7C),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const Spacer(),
                          // Tombol Buka Rute
                          Row(
                            children: const [
                              Text(
                                'Buka Google Maps',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF048C7C),
                                ),
                              ),
                              SizedBox(width: 4),
                              Icon(
                                Icons.open_in_new,
                                size: 14,
                                color: Color(0xFF048C7C),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLoadingState() {
    return const Center(
      child: RadarSearchLoadingWidget(
        message: 'Mencari masjid & mushola terdekat...',
      ),
    );
  }

  Widget _buildEmptyState(WidgetRef ref) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.location_off_outlined, size: 56, color: Color(0xFF94A3B8)),
            const SizedBox(height: 16),
            const Text(
              'Tidak ada masjid ditemukan',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xFF334155),
              ),
            ),
            const SizedBox(height: 6),
            const Text(
              'Coba perbesar radius pencarian menjadi 3 km atau 5 km.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 13, color: Color(0xFF64748B)),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF048C7C),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              onPressed: () {
                ref.read(searchRadiusProvider.notifier).state = 5000;
              },
              child: const Text('Cari dalam Radius 5 km'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorState(BuildContext context, WidgetRef ref, String error) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.cloud_off, size: 56, color: Color(0xFFEF4444)),
            const SizedBox(height: 16),
            const Text(
              'Gagal Memuat Data',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 6),
            Text(
              'Periksa koneksi internet Anda atau coba lagi beberapa saat.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF048C7C),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              onPressed: () {
                ref.invalidate(nearbyMasjidsProvider);
              },
              icon: const Icon(Icons.refresh, size: 18),
              label: const Text('Coba Lagi'),
            ),
          ],
        ),
      ),
    );
  }
}
