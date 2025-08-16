import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'package:http/http.dart' as http;

class GeminiService {
  static Future<String> sendMessage(String message) async {
    final apiKey = dotenv.env['GEMINI_API_KEY']; // Access inside method

    if (apiKey == null || apiKey.isEmpty) {
      return 'Error: API key is not set';
    }
    final url = Uri.parse('https://your-gemini-api.com/message');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'message': message}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['response'] ?? 'No response from Gemini.';
    } else {
      return 'Gemini error: ${response.statusCode}';
    }
  }
}
