class LokasiSayaData {
  String keteranganLokasi;
  double lat;
  double long;
  bool gpsizin;
  LokasiSayaData(
      {required this.keteranganLokasi,
      required this.lat,
      required this.long,
      this.gpsizin = true});
}
