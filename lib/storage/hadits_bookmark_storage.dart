import 'package:masjid_app/core/storage/preferences_service.dart';

class HaditsBookmarkData {
  final String namaTabel;
  final String longNama;
  final int idKitab;
  final String kitabIndonesia;
  final int? idBab;
  final String? babIndonesia;
  final int noHdt;
  final int totalHadits;
  final String? snippet;

  const HaditsBookmarkData({
    required this.namaTabel,
    required this.longNama,
    required this.idKitab,
    required this.kitabIndonesia,
    this.idBab,
    this.babIndonesia,
    required this.noHdt,
    this.totalHadits = 0,
    this.snippet,
  });

  bool get isValid => namaTabel.isNotEmpty && noHdt > 0;
}

class HaditsBookmarkStorage {
  static const String _prefix = 'hadits_last_read';

  static void saveBookmark(HaditsBookmarkData data) {
    PreferencesService.setString('${_prefix}_namaTabel', data.namaTabel);
    PreferencesService.setString('${_prefix}_longNama', data.longNama);
    PreferencesService.setInt('${_prefix}_idKitab', data.idKitab);
    PreferencesService.setString('${_prefix}_kitabIndonesia', data.kitabIndonesia);
    if (data.idBab != null) {
      PreferencesService.setInt('${_prefix}_idBab', data.idBab!);
    } else {
      PreferencesService.remove('${_prefix}_idBab');
    }
    PreferencesService.setString('${_prefix}_babIndonesia', data.babIndonesia ?? '');
    PreferencesService.setInt('${_prefix}_noHdt', data.noHdt);
    PreferencesService.setInt('${_prefix}_totalHadits', data.totalHadits);
    PreferencesService.setString('${_prefix}_snippet', data.snippet ?? '');
  }

  static HaditsBookmarkData? getBookmark() {
    final namaTabel = PreferencesService.getString('${_prefix}_namaTabel');
    final noHdt = PreferencesService.getInt('${_prefix}_noHdt');
    if (namaTabel == null || namaTabel.isEmpty || noHdt == null || noHdt <= 0) {
      return null;
    }
    return HaditsBookmarkData(
      namaTabel: namaTabel,
      longNama: PreferencesService.getString('${_prefix}_longNama') ?? '',
      idKitab: PreferencesService.getInt('${_prefix}_idKitab') ?? 1,
      kitabIndonesia: PreferencesService.getString('${_prefix}_kitabIndonesia') ?? '',
      idBab: PreferencesService.getInt('${_prefix}_idBab'),
      babIndonesia: PreferencesService.getString('${_prefix}_babIndonesia'),
      noHdt: noHdt,
      totalHadits: PreferencesService.getInt('${_prefix}_totalHadits') ?? 0,
      snippet: PreferencesService.getString('${_prefix}_snippet'),
    );
  }

  static void clear() {
    PreferencesService.remove('${_prefix}_namaTabel');
    PreferencesService.remove('${_prefix}_longNama');
    PreferencesService.remove('${_prefix}_idKitab');
    PreferencesService.remove('${_prefix}_kitabIndonesia');
    PreferencesService.remove('${_prefix}_idBab');
    PreferencesService.remove('${_prefix}_babIndonesia');
    PreferencesService.remove('${_prefix}_noHdt');
    PreferencesService.remove('${_prefix}_totalHadits');
    PreferencesService.remove('${_prefix}_snippet');
  }
}
