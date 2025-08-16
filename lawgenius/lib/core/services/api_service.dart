import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = "http://10.222.8.214:8000";

  static Future<void> pingBackend() async {
    final url = Uri.parse(
      "$baseUrl/ping",
    ); // Replace with an actual test endpoint

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print("Success: $data");
      } else {
        print("Failed with status: ${response.statusCode}");
      }
    } catch (e) {
      print("Connection error: $e");
    }
  }
}
