import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

import '../models/app_user.dart';
import 'api_config.dart';

class AuthApi {
  static String get baseUrl => ApiConfig.baseUrl;
  static const String _tokenKey = 'perfumeshelf_auth_token';
  static const _storage = FlutterSecureStorage();

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

    return _parseUserResponse(response);
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

    return _parseUserResponse(response);
  }

  Future<AppUser> updateProfile(AppUser user) async {
    final response = await http.put(
      Uri.parse('$baseUrl/profile'),
      headers: _headers(token: user.token, json: true),
      body: jsonEncode({
        'name': user.name,
        'phone': user.phone,
        'bio': user.bio,
        'profile_photo': user.profilePhoto,
      }),
    );

    return _parseUserResponse(response, fallbackToken: user.token);
  }

  Future<AppUser> fetchProfile(String token) async {
    final response = await http.get(
      Uri.parse('$baseUrl/profile'),
      headers: _headers(token: token),
    );

    return _parseUserResponse(response, fallbackToken: token);
  }

  Future<void> logout(String token) async {
    if (token.isNotEmpty) {
      await http.post(
        Uri.parse('$baseUrl/logout'),
        headers: _headers(token: token),
      );
    }

    await clearStoredToken();
  }

  Future<void> banUser({
    required String name,
    required String email,
    required String token,
  }) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/users/by-name'),
      headers: _headers(token: token, json: true),
      body: jsonEncode({'name': name, 'email': email}),
    );

    if (response.statusCode >= 400) {
      final body = jsonDecode(response.body) as Map<String, dynamic>;
      final message = _messageFromError(body);
      throw AuthApiException(message);
    }
  }

  Future<String?> readStoredToken() async {
    try {
      return await _storage
          .read(key: _tokenKey)
          .timeout(const Duration(milliseconds: 500));
    } catch (_) {
      return null;
    }
  }

  Future<void> clearStoredToken() async {
    try {
      await _storage.delete(key: _tokenKey);
    } catch (_) {}
  }

  Map<String, String> _headers({String token = '', bool json = false}) {
    return {
      'Accept': 'application/json',
      if (json) 'Content-Type': 'application/json',
      if (token.isNotEmpty) 'Authorization': 'Bearer $token',
    };
  }

  Future<AppUser> _parseUserResponse(
    http.Response response, {
    String fallbackToken = '',
  }) async {
    final body = jsonDecode(response.body) as Map<String, dynamic>;

    if (response.statusCode >= 400) {
      final message = _messageFromError(body);
      throw AuthApiException(message);
    }

    final user = body['user'] as Map<String, dynamic>;
    final role = user['role'] == 'admin' ? UserRole.admin : UserRole.user;
    final token = body['token']?.toString() ?? fallbackToken;

    if (token.isNotEmpty && body.containsKey('token')) {
      await _saveToken(token);
    }

    return AppUser(
      name: user['name'] as String,
      email: user['email'] as String,
      password: '',
      role: role,
      phone: user['phone']?.toString() ?? '',
      bio: user['bio']?.toString() ?? '',
      profilePhoto: user['profile_photo']?.toString() ?? '',
      token: token,
    );
  }

  Future<void> _saveToken(String token) async {
    try {
      await _storage.write(key: _tokenKey, value: token);
    } catch (_) {}
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
