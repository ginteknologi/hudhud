import 'package:get/get.dart';

class ListAyatData {
  int surat;
  int ayat;
  String madinah;
  String arab;
  String latinKarakter;
  String arti;
  String alafasy;
  RxBool book;

  // Constructor
  ListAyatData({
    required this.ayat,
    required this.surat,
    required this.madinah,
    required this.arab,
    required this.latinKarakter,
    required this.arti,
    required this.alafasy,
    bool initialBook = false, // Nilai default untuk initialBook
  }) : book = RxBool(initialBook); // Inisialisasi book sebagai RxBool
}
