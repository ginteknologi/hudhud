class UserData {
  int id;
  String nama, email, photo;
  String? phone;
  UserData({
    required this.id,
    required this.nama,
    required this.email,
    this.photo = "https://nos.wjv-1.neo.id/marbot/assets/app_icon.png",
    this.phone,
  });
}
