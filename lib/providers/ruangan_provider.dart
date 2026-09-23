import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:masjid_app/core/network/api_endpoints.dart';
import 'package:masjid_app/providers/api_providers.dart';

// Daftar jenis kegiatan (statis, dulu di RuanganController.getListKegiatan)
final List<Map<String, dynamic>> ruanganKegiatanList = [
  {
    "id": 1,
    "label": "Kajian umum",
    "subtitle": "Lorem ipsum dolor sit amet consectetur. Aliquam nibh sds sdd"
  },
  {
    "id": 1,
    "label": "Kajian umum",
    "subtitle": "Lorem ipsum dolor sit amet consectetur. Aliquam nibh sds sdd"
  },
  {
    "id": 1,
    "label": "Kajian umum",
    "subtitle": "Lorem ipsum dolor sit amet consectetur. Aliquam nibh sds sdd"
  },
  {
    "id": 1,
    "label": "Kajian umum",
    "subtitle": "Lorem ipsum dolor sit amet consectetur. Aliquam nibh sds sdd"
  },
  {
    "id": 1,
    "label": "Kajian umum",
    "subtitle": "Lorem ipsum dolor sit amet consectetur. Aliquam nibh sds sdd"
  },
  {
    "id": 1,
    "label": "Kajian umum",
    "subtitle": "Lorem ipsum dolor sit amet consectetur. Aliquam nibh sds sdd"
  },
  {
    "id": 1,
    "label": "Kajian umum",
    "subtitle": "Lorem ipsum dolor sit amet consectetur. Aliquam nibh sds sdd"
  },
];

// Jadwal booking per tanggal: GET /ruangan/booking?tanggal=&bulan=&tahun=
final jadwalRuanganProvider =
    FutureProvider.family<List<dynamic>, DateTime>((ref, tanggal) async {
  final apiClient = ref.watch(apiClientProvider);
  try {
    final response = await apiClient.get<List<dynamic>>(
      ApiEndpoints.bookingRuangan,
      queryParameters: {
        'tanggal': tanggal.day.toString(),
        'bulan': tanggal.month.toString(),
        'tahun': tanggal.year.toString(),
      },
      fromJson: (json) => json is List ? json : <dynamic>[],
    );
    return response.data ?? [];
  } catch (e) {
    return [];
  }
});

class BookingRuanganParams {
  final String tanggal;
  final String jamMulai;
  final String jamSelesai;
  final String namaKegiatan;
  final String permintaanKhusus;
  final String namaPemesan;
  final String kontakPemesan;

  BookingRuanganParams({
    required this.tanggal,
    required this.jamMulai,
    required this.jamSelesai,
    required this.namaKegiatan,
    required this.permintaanKhusus,
    required this.namaPemesan,
    required this.kontakPemesan,
  });

  Map<String, dynamic> toJson() => {
        'tanggal': tanggal,
        'jam_mulai': jamMulai,
        'jam_selesai': jamSelesai,
        'nama_kegiatan': namaKegiatan,
        'permintaan_khusus': permintaanKhusus,
        'nama_pemesan': namaPemesan,
        'kontak_pemesan': kontakPemesan,
      };
}

class BookingRuanganNotifier extends StateNotifier<AsyncValue<bool>> {
  final Ref ref;

  BookingRuanganNotifier(this.ref) : super(const AsyncValue.data(false));

  Future<bool> booking(BookingRuanganParams params) async {
    state = const AsyncValue.loading();
    try {
      final apiClient = ref.read(apiClientProvider);
      final response = await apiClient.post<dynamic>(
        ApiEndpoints.bookingRuangan,
        data: params.toJson(),
      );
      state = AsyncValue.data(response.success);
      return response.success;
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
      return false;
    }
  }
}

final bookingRuanganProvider =
    StateNotifierProvider.autoDispose<BookingRuanganNotifier, AsyncValue<bool>>(
        (ref) {
  return BookingRuanganNotifier(ref);
});
