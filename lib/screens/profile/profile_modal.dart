class UserProfile {
  final String? name;
  final String? phone;
  final String? password;
  final String? avatar; 

  UserProfile({
    this.name,
    this.phone,
    this.password,
    this.avatar,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      name: json['name'],
      phone: json['phone'],
      password: json['password'],
      avatar: json['avatar'],

    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'phone': phone,
      'password': password,
      'avatar': avatar,
    };
  }
}
