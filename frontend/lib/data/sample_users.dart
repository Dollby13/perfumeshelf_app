import '../models/app_user.dart';

const sampleUsers = [
  AppUser(
    name: 'Admin PerfumeShelf',
    email: 'admin@perfumeshelf.com',
    password: 'admin123',
    role: UserRole.admin,
  ),
  AppUser(
    name: 'User PerfumeShelf',
    email: 'user@perfumeshelf.com',
    password: 'user123',
    role: UserRole.user,
  ),
];

AppUser? findUserByCredential(String email, String password) {
  final normalizedEmail = email.trim().toLowerCase();

  for (final user in sampleUsers) {
    if (user.email == normalizedEmail && user.password == password) {
      return user;
    }
  }

  return null;
}
