import 'dart:convert';
import 'package:http/http.dart' as http;

class CurrencyAPI {
  static const _baseUrl = 'https://api.exchangerate.host/latest';

  static Future<Map<String, dynamic>> fetchRates() async {
    final response = await http.get(Uri.parse(_baseUrl));
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to fetch currency rates');
    }
  }
}
