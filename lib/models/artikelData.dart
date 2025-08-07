class ArtikelData {
  int id;
  String judul, publish_date, updatedAt, image;
  String? isi, idCategoryArtikel;
  Map? category_artikel;
  ArtikelData(
      {required this.id,
      required this.judul,
      required this.image,
      required this.updatedAt,
      required this.publish_date,
      this.idCategoryArtikel,
      this.isi,
      this.category_artikel});
}
