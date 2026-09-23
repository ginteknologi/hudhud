class ShalatTimeItem {
  final int id;
  final String label;
  final String waktu; // Format HH:mm
  final String cardImage;
  final bool isActive;

  ShalatTimeItem({
    required this.id,
    required this.label,
    required this.waktu,
    required this.cardImage,
    this.isActive = false,
  });

  ShalatTimeItem copyWith({bool? isActive}) {
    return ShalatTimeItem(
      id: id,
      label: label,
      waktu: waktu,
      cardImage: cardImage,
      isActive: isActive ?? this.isActive,
    );
  }
}

class JadwalShalatModel {
  final String imsak;
  final String subuh;
  final String terbit;
  final String dzuhur;
  final String ashar;
  final String maghrib;
  final String isya;
  final String tanggal;

  JadwalShalatModel({
    required this.imsak,
    required this.subuh,
    required this.terbit,
    required this.dzuhur,
    required this.ashar,
    required this.maghrib,
    required this.isya,
    this.tanggal = '',
  });

  factory JadwalShalatModel.fromJson(Map<String, dynamic> json) {
    return JadwalShalatModel(
      imsak: json['imsak'] as String? ?? '04:15',
      subuh: json['fajr'] as String? ?? json['subuh'] as String? ?? '04:25',
      terbit: json['sunrise'] as String? ?? json['terbit'] as String? ?? '05:40',
      dzuhur: json['dhuhr'] as String? ?? json['dzuhur'] as String? ?? '11:55',
      ashar: json['asr'] as String? ?? json['ashar'] as String? ?? '15:10',
      maghrib: json['maghrib'] as String? ?? '18:00',
      isya: json['isha'] as String? ?? json['isya'] as String? ?? '19:10',
      tanggal: json['date'] as String? ?? '',
    );
  }

  List<ShalatTimeItem> toItems() {
    return [
      ShalatTimeItem(
        id: 1,
        label: 'Subuh',
        waktu: subuh,
        cardImage: 'assets/img/card/card_subuh.png',
      ),
      ShalatTimeItem(
        id: 2,
        label: 'Dzuhur',
        waktu: dzuhur,
        cardImage: 'assets/img/card/card_dzuhur.png',
      ),
      ShalatTimeItem(
        id: 3,
        label: 'Ashar',
        waktu: ashar,
        cardImage: 'assets/img/card/card_ashar.png',
      ),
      ShalatTimeItem(
        id: 4,
        label: 'Maghrib',
        waktu: maghrib,
        cardImage: 'assets/img/card/card_maghrib.png',
      ),
      ShalatTimeItem(
        id: 5,
        label: 'Isya',
        waktu: isya,
        cardImage: 'assets/img/card/card_isya.png',
      ),
    ];
  }
}
