class KategoriDoaData {
  int id;
  int? list;
  String name, updatedAt;
  KategoriDoaData(
    {
      required this.id,
      required this.name,
      required this.updatedAt,
      this.list,
    }
  );
}
