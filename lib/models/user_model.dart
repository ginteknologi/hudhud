class UserModel {
  final int id;
  final String name;
  final String email;
  final String photo;
  final int totalSedekah;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.photo,
    this.totalSedekah = 0,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] is int ? json['id'] as int : int.tryParse(json['id']?.toString() ?? '0') ?? 0,
      name: json['name'] as String? ?? json['nama'] as String? ?? 'Pengguna',
      email: json['email'] as String? ?? '',
      photo: json['photo'] as String? ?? '',
      totalSedekah: json['total_sedekah'] is int
          ? json['total_sedekah'] as int
          : int.tryParse(json['total_sedekah']?.toString() ?? '0') ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'photo': photo,
      'total_sedekah': totalSedekah,
    };
  }
}
