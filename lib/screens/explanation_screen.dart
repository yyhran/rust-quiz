import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_highlight/flutter_highlight.dart';
import 'package:flutter_highlight/themes/github.dart';

import '../models/question.dart';

class ExplanationScreen extends StatelessWidget {
  final Question question;

  const ExplanationScreen({super.key, required this.question});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Explanation')),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          // 第一部分：显示原始代码（使用 HighlightView）
          Container(
            color: Colors.blue.shade50,
            child: HighlightView(
              question.codeSnippet,
              language: 'rust',
              theme: githubTheme,
              padding: const EdgeInsets.all(12),
              textStyle: const TextStyle(
                fontFamily: 'Source Code Pro',
                fontSize: 14,
              ),
            ),
          ),
          const SizedBox(height: 16),
          // 第二部分：显示正确答案
          Container(
            color: Colors.green.shade50,
            padding: const EdgeInsets.all(12),
            child: Text(
              question.answer,
              style: const TextStyle(fontSize: 18, color: Colors.black),
            ),
          ),
          const SizedBox(height: 16),
          // 第三部分：使用 Markdown 显示解释信息
          Container(
            color: Colors.yellow.shade50,
            padding: const EdgeInsets.all(12),
            child: MarkdownBody(
              data: question.explanation,
              styleSheet: MarkdownStyleSheet(
                p: const TextStyle(fontSize: 16, color: Colors.black87),
              ),
            ),
          ),
          const SizedBox(height: 16),
          // 第四部分：文本按钮，点击后获取新题并返回 QuizScreenState
          Center(
            child: TextButton(
              onPressed: () async {
                // 返回到上一级页面（QuizScreenState）
                Navigator.pop(context, 1);
              },
              child: const Text(
                "Next Question",
                style: TextStyle(fontSize: 16, color: Colors.blue),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
