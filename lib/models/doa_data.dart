class DoaData {
  int id;
  int? idCategoryDoa;
  String judul, updatedAt;
  String? arabic, transliteration, translations, isi, opening;
  DoaData(
    {
      required this.id,
      required this.judul,
      required this.updatedAt,
      this.arabic,
      this.transliteration,
      this.translations,
      this.isi,
      this.opening,
    }
  );
}
