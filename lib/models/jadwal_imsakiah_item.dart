class JadwalImsakiahItem {
  final int no;
  final String tanggal;
  final String hari;
  final String imsak;
  final String berbuka;
  final bool isToday;

  const JadwalImsakiahItem({
    required this.no,
    required this.tanggal,
    required this.hari,
    required this.imsak,
    required this.berbuka,
    this.isToday = false,
  });

  factory JadwalImsakiahItem.fromList(List<dynamic> row, {bool isToday = false}) {
    return JadwalImsakiahItem(
      no: int.tryParse(row.isNotEmpty ? row[0].toString() : '0') ?? 0,
      tanggal: row.length > 1 ? row[1].toString() : '',
      hari: row.length > 2 ? row[2].toString() : '',
      imsak: row.length > 3 ? row[3].toString() : '--:--',
      berbuka: row.length > 4 ? row[4].toString() : '--:--',
      isToday: isToday,
    );
  }

  JadwalImsakiahItem copyWith({
    int? no,
    String? tanggal,
    String? hari,
    String? imsak,
    String? berbuka,
    bool? isToday,
  }) {
    return JadwalImsakiahItem(
      no: no ?? this.no,
      tanggal: tanggal ?? this.tanggal,
      hari: hari ?? this.hari,
      imsak: imsak ?? this.imsak,
      berbuka: berbuka ?? this.berbuka,
      isToday: isToday ?? this.isToday,
    );
  }
}
