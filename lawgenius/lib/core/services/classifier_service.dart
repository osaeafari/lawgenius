import 'dart:convert';
import 'package:http/http.dart' as http;

class ClassifierResult {
  final String intent;
  final Map<String, dynamic> best;
  final List<Map<String, dynamic>> all;
  final List<Map<String, dynamic>> answers;

  ClassifierResult({
    required this.intent,
    required this.best,
    required this.all,
    required this.answers,
  });
}

class ClassifierService {
  static Future<ClassifierResult?> classifyQuestion(String question) async {
    try {
      final url = Uri.parse('http://127.0.0.1:8000/query');
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"question": question}),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> result = jsonDecode(response.body);

        final intent = result['intent'] ?? "unknown";

        // ✅ Safely handle "best"
        final best =
            (result['best'] as Map<String, dynamic>?) ??
            {
              "agent": "system",
              "answer": "No answer available",
              "score": 0.0,
              "rationale": "Backend did not return a best response.",
            };

        // ✅ Safely handle "all"
        final List<dynamic> allList = (result['all'] as List<dynamic>?) ?? [];
        final all = allList.map((e) => e as Map<String, dynamic>).toList();

        // ✅ Safely handle "answers" (for general intent)
        final List<dynamic> answersList =
            (result['answers'] as List<dynamic>?) ?? [];
        final answers = answersList
            .map((e) => e as Map<String, dynamic>)
            .toList();

        return ClassifierResult(
          intent: intent,
          best: best,
          all: all,
          answers: answers,
        );
      } else {
        throw Exception("Backend error: ${response.statusCode}");
      }
    } catch (e) {
      print("❌ Error calling backend: $e");
      return null;
    }
  }
}
