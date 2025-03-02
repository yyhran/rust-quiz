class Question {
  final String id;
  final String title;
  final String description;
  final String codeSnippet;
  final List<String> options;
  final int correctAnswerIndex;
  final String explanation;
  final String hit;

  Question({
    required this.id,
    required this.title,
    required this.description,
    required this.codeSnippet,
    required this.options,
    required this.correctAnswerIndex,
    required this.explanation,
    required this.hit,
  });
}
