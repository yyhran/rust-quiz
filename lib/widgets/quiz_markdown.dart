import 'package:flutter/material.dart';
import 'package:flutter_markdown_selectionarea/flutter_markdown.dart';

class QuizMarkdown extends StatelessWidget {
  final String data;
  final Color color;

  const QuizMarkdown({
    super.key,
    required this.data,
    this.color = const Color.fromARGB(255, 255, 254, 241),
  });

  @override
  Widget build(BuildContext context) {
    return SelectionArea(
      child: Container(
        color: color,
        padding: const EdgeInsets.all(12),
        child: MarkdownBody(
          data: data,
          styleSheet: MarkdownStyleSheet(
            // 内联代码样式
            a: const TextStyle(color: Colors.blue),
            p: const TextStyle(fontSize: 16, color: Colors.black),
            code: const TextStyle(
              color: Colors.deepOrange,
              backgroundColor: Colors.transparent,
            ),
            // 代码块样式
            codeblockDecoration: BoxDecoration(
              color: const Color.fromARGB(255, 245, 245, 245),
              borderRadius: BorderRadius.circular(4.0),
            ),
            codeblockPadding: const EdgeInsets.all(8.0),
          ),
        ),
      ),
    );
  }
}
