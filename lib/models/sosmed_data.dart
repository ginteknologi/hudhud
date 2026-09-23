class SosmedData {
  int id;
  String nama, type, link, icon;
  SosmedData(
      {required this.id,
      required this.nama,
      required this.type,
      required this.icon,
      required this.link});

  factory SosmedData.fromJson(Map<String, dynamic> json) {
    return SosmedData(
      id: json['id'],
      nama: json['nama'],
      type: json['type'],
      icon: json['icon'],
      link: json['link'],
    );
  }
}
