import 'package:get/get.dart';

class listayatData {
  int surat;
  int ayat;
  String madinah;
  String arab;
  String latin_karakter;
  String arti;
  String alafasy;
  RxBool book;

  // Constructor
  listayatData({
    required this.ayat,
    required this.surat,
    required this.madinah,
    required this.arab,
    required this.latin_karakter,
    required this.arti,
    required this.alafasy,
    bool initialBook = false, // Nilai default untuk initialBook
  }) : book = RxBool(initialBook); // Inisialisasi book sebagai RxBool
}
