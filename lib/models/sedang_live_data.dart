class SedangLiveData {
  int id;
  String masjid, title, subtittle, keterangan, image, link;
  SedangLiveData(
      {required this.id,
      required this.masjid,
      required this.title,
      required this.subtittle,
      required this.keterangan,
      required this.image,
      required this.link});

  factory SedangLiveData.fromJson(Map<String, dynamic> json) {
    return SedangLiveData(
      id: json['id'],
      masjid: json['masjid']['nama']!,
      title: json['title'],
      subtittle: json['subtitle'],
      keterangan: json['keterangan'],
      image: json['cover'],
      link: json['link'],
    );
  }
}
