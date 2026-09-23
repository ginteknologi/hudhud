import 'package:masjid_app/core/network/api_client.dart';
import 'package:masjid_app/core/network/api_endpoints.dart';

/// Service Quran tanpa GetX. Jalur utama halaman sudah lewat
/// lib/providers/quran_provider.dart; file ini dipertahankan untuk pemanggil lama.
class AlquranService {
  AlquranService({ApiClient? client}) : _client = client ?? ApiClient();

  final ApiClient _client;

  Future<dynamic> getList(dynamic search) async {
    final response = await _client.get<dynamic>(
      ApiEndpoints.quranSurah,
      queryParameters: {'search': search},
    );
    return response.data;
  }

  Future<dynamic> getRandom() async {
    final response = await _client.get<dynamic>(ApiEndpoints.quranRandom);
    return response.data;
  }

  Future<dynamic> getDetail(dynamic id) async {
    final response = await _client.get<dynamic>('${ApiEndpoints.quranDetail}/$id');
    return response.data;
  }
}
