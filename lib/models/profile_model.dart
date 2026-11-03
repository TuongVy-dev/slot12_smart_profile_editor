class Profile {
  final String name;
  final String email;
  final String phone;

  const Profile({
    required this.name,
    required this.email,
    required this.phone,
  });

  Profile copyWith({
    String? name,
    String? email,
    String? phone,
  }) {
    return Profile(
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
    );
  }

  factory Profile.fromJson(Map<String, dynamic> json) {
    return Profile(
      name: (json['name'] ?? '').toString(),
      email: (json['email'] ?? '').toString(),
      phone: (json['phone'] ?? '').toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {'name': name, 'email': email, 'phone': phone};
  }
}
