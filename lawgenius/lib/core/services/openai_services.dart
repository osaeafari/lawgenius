import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class OpenAIService {
  Future<String> sendMessage(String message) async {
    final apiKey = dotenv.env['OPENAI_API_KEY']; // Access inside method

    if (apiKey == null || apiKey.isEmpty) {
      return 'Error: API key is not set';
    }

    const endpoint = 'https://api.openai.com/v1/chat/completions';

    final response = await http.post(
      Uri.parse(endpoint),
      headers: {
        'Authorization': "Bearer $apiKey",
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        "model": "gpt-3.5-turbo",
        "messages": [
          {"role": "user", "content": message},
        ],
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['choices'][0]['message']['content'];
    } else {
      return 'Failed to get response. Try again.';
    }
  }
}
