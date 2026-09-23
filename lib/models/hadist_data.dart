class ListKitabData {
  int idKitab;
  int? noHdt;
  int? idBab;
  String kitabIndonesia;
  String? kitabArab;

  ListKitabData({
    required this.idKitab,
    required this.kitabIndonesia,
    this.kitabArab,
    this.noHdt,
    this.idBab,
  });
}

class ListBabData {
  int idBab;
  int idKitab;
  String babIndonesia;
  String babArab;

  ListBabData({
    required this.idBab,
    required this.idKitab,
    required this.babIndonesia,
    required this.babArab,
  });
}

class ListHadistData {
  int noHdt;
  int? idKitab;
  int? idBab;
  String isiIndonesia;
  String isiArab;

  ListHadistData({
    required this.noHdt,
    this.idBab,
    this.idKitab,
    required this.isiIndonesia,
    required this.isiArab,
  });
}