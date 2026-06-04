import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/perfume.dart';
import 'api_config.dart';

class PerfumeApi {
  static String get baseUrl => ApiConfig.baseUrl;
  final String token;

  const PerfumeApi({this.token = ''});

  Future<List<Perfume>> fetchPerfumes() async {
    final response = await http.get(
      Uri.parse('$baseUrl/perfumes'),
      headers: _headers(),
    );

    if (response.statusCode >= 400) {
      throw PerfumeApiException(_messageFromError(response));
    }

    final body = jsonDecode(response.body) as Map<String, dynamic>;
    final data = body['data'] as List<dynamic>;

    return data
        .map((item) => Perfume.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  Future<Perfume> createPerfume(Perfume perfume) async {
    final response = await http.post(
      Uri.parse('$baseUrl/perfumes'),
      headers: _headers(json: true),
      body: jsonEncode(perfume.toJson()),
    );

    return _parsePerfume(response);
  }

  Future<Perfume> updatePerfume(Perfume perfume) async {
    if (perfume.id == null) return perfume;

    final response = await http.put(
      Uri.parse('$baseUrl/perfumes/${perfume.id}'),
      headers: _headers(json: true),
      body: jsonEncode(perfume.toJson()),
    );

    return _parsePerfume(response);
  }

  Future<void> deletePerfume(Perfume perfume) async {
    if (perfume.id == null) return;

    final response = await http.delete(
      Uri.parse('$baseUrl/perfumes/${perfume.id}'),
      headers: _headers(),
    );

    if (response.statusCode >= 400) {
      throw PerfumeApiException(_messageFromError(response));
    }
  }

  Perfume _parsePerfume(http.Response response) {
    if (response.statusCode >= 400) {
      throw PerfumeApiException(_messageFromError(response));
    }

    final body = jsonDecode(response.body) as Map<String, dynamic>;
    final data = body['data'] as Map<String, dynamic>;

    return Perfume.fromJson(data);
  }

  Map<String, String> _headers({bool json = false}) {
    return {
      'Accept': 'application/json',
      if (json) 'Content-Type': 'application/json',
      if (token.isNotEmpty) 'Authorization': 'Bearer $token',
    };
  }

  String _messageFromError(http.Response response) {
    try {
      final body = jsonDecode(response.body) as Map<String, dynamic>;
      final errors = body['errors'];

      if (errors is Map && errors.isNotEmpty) {
        final firstError = errors.values.first;
        if (firstError is List && firstError.isNotEmpty) {
          return firstError.first.toString();
        }
      }

      return body['message']?.toString() ?? 'Terjadi kesalahan pada API parfum';
    } catch (_) {
      return 'Terjadi kesalahan pada API parfum';
    }
  }
}

class PerfumeApiException implements Exception {
  final String message;

  PerfumeApiException(this.message);

  @override
  String toString() => message;
}
