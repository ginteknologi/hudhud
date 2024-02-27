class ArtikelData {
  int id;
  String judul, updatedAt, image;
  String? isi, idCategoryArtikel; 
  Map? category;
  ArtikelData(
      {required this.id,
      required this.judul,
      required this.updatedAt,
      required this.image,
      this.idCategoryArtikel,
      this.isi,
      this.category
      });
}
