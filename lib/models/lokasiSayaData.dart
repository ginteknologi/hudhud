class LokasiSayaData {
  String keteranganLokasi;
  double lat;
  double lang;
  bool gpsizin;
  LokasiSayaData(
      {required this.keteranganLokasi,
      required this.lat,
      required this.lang,
      this.gpsizin = true});
}
