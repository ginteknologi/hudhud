class UserData {
  int id;
  int? total_sedekah;
  String nama, email,photo;
  String? phone;
  UserData(
      {required this.id,
      required this.nama,
      required this.email,
      required this.photo,
      this.total_sedekah,
      this.phone,
      });
}
