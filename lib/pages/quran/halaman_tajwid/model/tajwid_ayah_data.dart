class AyahCoordinate {
  final int surahNumber;
  final int ayahNumber;
  final String surahName;
  final String arabicText;

  /// Bounding box utama [ymin, xmin, ymax, xmax] dinormalisasi 0..1000
  final List<double> boundingBox;

  /// Penanda nomor ayat (lingkaran) [ymin, xmin, ymax, xmax] 0..1000
  final List<double> markerBox;

  /// Potongan kotak baris-per-baris untuk penyorotan visual presisi [ymin, xmin, ymax, xmax]
  final List<List<double>> highlightBoxes;

  const AyahCoordinate({
    required this.surahNumber,
    required this.ayahNumber,
    required this.surahName,
    this.arabicText = '',
    required this.boundingBox,
    required this.markerBox,
    required this.highlightBoxes,
  });

  factory AyahCoordinate.fromJson(Map<String, dynamic> json,
      {String defaultSurahName = ''}) {
    List<double> parseBox(dynamic raw) {
      if (raw is List) {
        return raw.map((e) => (e as num).toDouble()).toList();
      }
      return [0.0, 0.0, 0.0, 0.0];
    }

    List<List<double>> parseHighlightBoxes(dynamic raw) {
      if (raw is List) {
        return raw.map((e) => parseBox(e)).toList();
      }
      return [];
    }

    final bBox = parseBox(json['bounding_box'] ?? json['boundingBox']);
    final mBox = parseBox(json['marker_box'] ?? json['markerBox']);
    var hBoxes =
        parseHighlightBoxes(json['highlight_boxes'] ?? json['highlightBoxes']);
    if (hBoxes.isEmpty && bBox.any((e) => e != 0.0)) {
      hBoxes = [bBox];
    }

    return AyahCoordinate(
      surahNumber: json['surah'] ?? json['surahNumber'] ?? 1,
      ayahNumber: json['ayah'] ?? json['ayahNumber'] ?? 1,
      surahName: json['surah_name'] ?? json['surahName'] ?? defaultSurahName,
      arabicText: json['text'] ?? json['arabicText'] ?? '',
      boundingBox: bBox,
      markerBox: mBox,
      highlightBoxes: hBoxes,
    );
  }

  /// Cek apakah titik koordinat (0..1000) berada di dalam penanda atau area ayat
  bool hitTest(double normY, double normX) {
    if (_inBox(markerBox, normY, normX)) return true;
    for (final box in highlightBoxes) {
      if (_inBox(box, normY, normX)) return true;
    }
    return false;
  }

  static bool _inBox(List<double> box, double y, double x) {
    if (box.length < 4) return false;
    return y >= box[0] && y <= box[2] && x >= box[1] && x <= box[3];
  }
}

/// Helper untuk ekstraksi koordinat ayat dari JSON data halaman
class TajwidAyahDataSource {
  /// Ekstrak daftar AyahCoordinate langsung dari item halaman di JSON
  static List<AyahCoordinate> fromPageItem(Map<String, dynamic> item) {
    final rawAyahs = item['ayahs'];
    if (rawAyahs is! List || rawAyahs.isEmpty) return const [];
    final surahName = (item['surat'] ?? '').toString();
    final result = <AyahCoordinate>[];
    for (final a in rawAyahs) {
      if (a is Map) {
        result.add(AyahCoordinate.fromJson(Map<String, dynamic>.from(a),
            defaultSurahName: surahName));
      }
    }
    return result;
  }
}
