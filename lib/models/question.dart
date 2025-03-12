class Question {
  final String id;
  final String title;
  final String codeSnippet;
  final int currentIndex;
  final int difficulty;
  final String answer;
  final String explanation;
  final String hint;

  Question({
    required this.id,
    required this.title,
    required this.codeSnippet,
    required this.currentIndex,
    required this.difficulty,
    required this.answer,
    required this.explanation,
    required this.hint,
  });

  factory Question.fromJson(Map<String, dynamic> json) {
    return Question(
      id: json['id'] as String,
      title: json['title'] as String,
      codeSnippet: json['codeSnippet'] as String,
      currentIndex: json['currentIndex'] as int,
      difficulty: json['difficulty'] as int,
      answer: json['answer'] as String,
      explanation: json['explanation'] as String,
      hint: json['hint'] as String,
    );
  }
}
