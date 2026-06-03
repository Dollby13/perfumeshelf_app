enum UserRole { admin, user }

class AppUser {
  final String name;
  final String email;
  final String password;
  final UserRole role;
  final String phone;
  final String bio;

  const AppUser({
    required this.name,
    required this.email,
    required this.password,
    required this.role,
    this.phone = '',
    this.bio = '',
  });

  AppUser copyWith({
    String? name,
    String? email,
    String? password,
    UserRole? role,
    String? phone,
    String? bio,
  }) {
    return AppUser(
      name: name ?? this.name,
      email: email ?? this.email,
      password: password ?? this.password,
      role: role ?? this.role,
      phone: phone ?? this.phone,
      bio: bio ?? this.bio,
    );
  }
}
