class Question {
  final String id;
  final String title;
  final String codeSnippet;
  final int currentIndex;
  final String answer;
  final String explanation;
  final String hint;

  Question({
    required this.id,
    required this.title,
    required this.codeSnippet,
    required this.currentIndex,
    required this.answer,
    required this.explanation,
    required this.hint,
  });
}
