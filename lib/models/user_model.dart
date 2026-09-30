class UserModel {
  final int id;
  final String name;
  final String email;
  final String photo;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.photo,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] is int ? json['id'] as int : int.tryParse(json['id']?.toString() ?? '0') ?? 0,
      name: json['name'] as String? ?? json['nama'] as String? ?? 'Pengguna',
      email: json['email'] as String? ?? '',
      photo: json['photo'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'photo': photo,
    };
  }
}
