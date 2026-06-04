enum UserRole { admin, user }

class AppUser {
  final String name;
  final String email;
  final String password;
  final UserRole role;
  final String phone;
  final String bio;
  final String profilePhoto;
  final String token;

  const AppUser({
    required this.name,
    required this.email,
    required this.password,
    required this.role,
    this.phone = '',
    this.bio = '',
    this.profilePhoto = '',
    this.token = '',
  });

  AppUser copyWith({
    String? name,
    String? email,
    String? password,
    UserRole? role,
    String? phone,
    String? bio,
    String? profilePhoto,
    String? token,
  }) {
    return AppUser(
      name: name ?? this.name,
      email: email ?? this.email,
      password: password ?? this.password,
      role: role ?? this.role,
      phone: phone ?? this.phone,
      bio: bio ?? this.bio,
      profilePhoto: profilePhoto ?? this.profilePhoto,
      token: token ?? this.token,
    );
  }
}
