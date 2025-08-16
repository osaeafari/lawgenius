import 'dart:convert';
import 'package:http/http.dart' as http;

class ClassifierService {
  static Future<String?> classifyQuestion(String question) async {
    final url = Uri.parse('http://10.222.8.214:8000/classify');

    try {
      final response = await http
          .post(
            url,
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({'question': question}),
          )
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print("Response from backend: $data");
        return data['label']; // <- Must match what FastAPI returns
      } else {
        print('Classification failed with status: ${response.statusCode}');
        print('Response body: ${response.body}');
      }
    } catch (e) {
      print('Classification error: $e');
    }

    return null;
  }
}
