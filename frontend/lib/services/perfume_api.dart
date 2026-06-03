import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/perfume.dart';

class PerfumeApi {
  static const String baseUrl = 'http://127.0.0.1:8000/api';

  Future<List<Perfume>> fetchPerfumes() async {
    final response = await http.get(
      Uri.parse('$baseUrl/perfumes'),
      headers: const {'Accept': 'application/json'},
    );

    final body = jsonDecode(response.body) as Map<String, dynamic>;
    final data = body['data'] as List<dynamic>;

    return data
        .map((item) => Perfume.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  Future<Perfume> createPerfume(Perfume perfume) async {
    final response = await http.post(
      Uri.parse('$baseUrl/perfumes'),
      headers: const {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(perfume.toJson()),
    );

    return _parsePerfume(response);
  }

  Future<Perfume> updatePerfume(Perfume perfume) async {
    if (perfume.id == null) return perfume;

    final response = await http.put(
      Uri.parse('$baseUrl/perfumes/${perfume.id}'),
      headers: const {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(perfume.toJson()),
    );

    return _parsePerfume(response);
  }

  Future<void> deletePerfume(Perfume perfume) async {
    if (perfume.id == null) return;

    await http.delete(
      Uri.parse('$baseUrl/perfumes/${perfume.id}'),
      headers: const {'Accept': 'application/json'},
    );
  }

  Perfume _parsePerfume(http.Response response) {
    final body = jsonDecode(response.body) as Map<String, dynamic>;
    final data = body['data'] as Map<String, dynamic>;

    return Perfume.fromJson(data);
  }
}
