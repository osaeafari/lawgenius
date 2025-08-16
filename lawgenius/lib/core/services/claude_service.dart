import 'dart:convert';
import 'package:http/http.dart' as http;

class ClaudeService {
  static Future<String> sendMessage(String message) async {
    final url = Uri.parse('https://your-meta-api.com/message');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'message': message}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['response'] ?? 'No response from Meta AI.';
    } else {
      return 'Meta AI error: ${response.statusCode}';
    }
  }
}
