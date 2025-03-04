class Question {
  final String id;
  final String title;
  final String codeSnippet;
  final int correctIndex;
  final String explanation;
  final String hint;

  Question({
    required this.id,
    required this.title,
    required this.codeSnippet,
    required this.correctIndex,
    required this.explanation,
    required this.hint,
  });
}
