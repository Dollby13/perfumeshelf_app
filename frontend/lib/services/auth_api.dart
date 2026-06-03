import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/app_user.dart';

class AuthApi {
  static const String baseUrl = 'http://127.0.0.1:8000/api';

  Future<AppUser> login({
    required String email,
    required String password,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/login'),
      headers: const {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({'email': email, 'password': password}),
    );

    return _parseAuthResponse(response);
  }

  Future<AppUser> register({
    required String name,
    required String email,
    required String password,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/register'),
      headers: const {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({'name': name, 'email': email, 'password': password}),
    );

    return _parseAuthResponse(response);
  }

  Future<AppUser> updateProfile(AppUser user) async {
    final response = await http.put(
      Uri.parse('$baseUrl/profile'),
      headers: const {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'email': user.email,
        'name': user.name,
        'phone': user.phone,
        'bio': user.bio,
        'profile_photo': user.profilePhoto,
      }),
    );

    return _parseAuthResponse(response);
  }

  Future<void> banUser({required String name, required String email}) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/users/by-name'),
      headers: const {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({'name': name, 'email': email}),
    );

    if (response.statusCode >= 400) {
      final body = jsonDecode(response.body) as Map<String, dynamic>;
      final message = _messageFromError(body);
      throw AuthApiException(message);
    }
  }

  AppUser _parseAuthResponse(http.Response response) {
    final body = jsonDecode(response.body) as Map<String, dynamic>;

    if (response.statusCode >= 400) {
      final message = _messageFromError(body);
      throw AuthApiException(message);
    }

    final user = body['user'] as Map<String, dynamic>;
    final role = user['role'] == 'admin' ? UserRole.admin : UserRole.user;

    return AppUser(
      name: user['name'] as String,
      email: user['email'] as String,
      password: '',
      role: role,
      phone: user['phone']?.toString() ?? '',
      bio: user['bio']?.toString() ?? '',
      profilePhoto: user['profile_photo']?.toString() ?? '',
    );
  }

  String _messageFromError(Map<String, dynamic> body) {
    final errors = body['errors'];

    if (errors is Map && errors.isNotEmpty) {
      final firstError = errors.values.first;
      if (firstError is List && firstError.isNotEmpty) {
        return firstError.first.toString();
      }
    }

    return body['message']?.toString() ?? 'Terjadi kesalahan';
  }
}

class AuthApiException implements Exception {
  final String message;

  AuthApiException(this.message);

  @override
  String toString() => message;
}
