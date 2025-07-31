import 'dart:convert';
import 'package:http/http.dart' as http;

class ClassifierService {
  static Future<String?> classifyQuestion(String question) async {
    final url = Uri.parse('http://10.0.2.2:8000/classify');

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'question': question}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['intent']; // Should return 'legal' or 'general'
      } else {
        print('Classification failed: ${response.statusCode}');
      }
    } catch (e) {
      print('Classification error: $e');
    }

    return null;
  }
}
