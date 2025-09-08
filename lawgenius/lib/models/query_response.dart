class AgentResponse {
  final String agent;
  final String answer;
  final double score;
  final String rationale;

  AgentResponse({
    required this.agent,
    required this.answer,
    required this.score,
    required this.rationale,
  });

  factory AgentResponse.fromJson(Map<String, dynamic> json) {
    return AgentResponse(
      agent: json['agent'] ?? '',
      answer: json['answer'] ?? '',
      score: (json['score'] as num?)?.toDouble() ?? 0.0,
      rationale: json['rationale'] ?? '',
    );
  }
}

class QueryResponse {
  final String intent;
  final AgentResponse best;
  final List<AgentResponse> all;

  QueryResponse({required this.intent, required this.best, required this.all});

  factory QueryResponse.fromJson(Map<String, dynamic> json) {
    return QueryResponse(
      intent: json['intent'] ?? 'general',
      best: AgentResponse.fromJson(json['best']),
      all: (json['all'] as List<dynamic>)
          .map((e) => AgentResponse.fromJson(e))
          .toList(),
    );
  }
}
