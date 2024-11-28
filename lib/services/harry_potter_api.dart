import 'dart:convert';
import 'package:http/http.dart' as http;

class HarryPotterAPI {
  static const _baseUrl = 'https://hp-api.onrender.com/api/characters';

  static Future<List<dynamic>> fetchCharacters() async {
    final response = await http.get(Uri.parse(_baseUrl));
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to fetch characters');
    }
  }
}
