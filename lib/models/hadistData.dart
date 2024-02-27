class ListKitabData {
  int ID_Kitab;
  int? NoHdt,ID_Bab;
  String Kitab_Indonesia;
  String? Kitab_Arab;
  ListKitabData(
    {
      required this.ID_Kitab,
      required this.Kitab_Indonesia,
      this.Kitab_Arab,
      this.NoHdt,
      this.ID_Bab,
    }
  );
}

class ListBabData {
  int ID_Bab, ID_Kitab;
  String Bab_Indonesia, Bab_Arab;
  ListBabData(
    {
      required this.ID_Bab,
      required this.ID_Kitab,
      required this.Bab_Indonesia,
      required this.Bab_Arab,
    }
  );
}

class ListHadistData {
  int NoHdt;
  int? ID_Kitab, ID_Bab;
  String Isi_Indonesia, Isi_Arab;
  ListHadistData(
    {
      required this.NoHdt,
      this.ID_Bab,
      this.ID_Kitab,
      required this.Isi_Indonesia,
      required this.Isi_Arab,
    }
  );
}
