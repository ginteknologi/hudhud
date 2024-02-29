class UserData {
  int id;
  int? total_sedekah;
  String nama, email,photo;
  String? phone;
  UserData(
      {required this.id,
      required this.nama,
      required this.email,
      this.photo = "https://nos.wjv-1.neo.id/marbot/assets/app_icon.png",
      this.total_sedekah,
      this.phone,
      });
}
