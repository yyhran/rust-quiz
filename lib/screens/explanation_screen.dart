import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_highlight/flutter_highlight.dart';
import 'package:flutter_highlight/themes/github.dart';

import '../models/question.dart';

class ExplanationScreen extends StatelessWidget {
  final Question question;

  const ExplanationScreen({Key? key, required this.question}) : super(key: key);

  // 模拟获取新问题的异步方法
  Future<Question> _fetchNewQuestion() async {
    // 这里是本地题库示例，你可以将其替换为实际的数据源
    final List<Question> localQuestions = [
      Question(
        id: 'q1',
        title: 'Question 1',
        codeSnippet: 'fn main() { println!("Question 1"); }',
        currentIndex: 0,
        answer: 'Answer 1',
        explanation: 'Explanation for **Question 1** in Markdown.',
        hint: 'Hint for Question 1',
      ),
      Question(
        id: 'q2',
        title: 'Question 2',
        codeSnippet: 'fn main() { println!("Question 2"); }',
        currentIndex: 1,
        answer: 'Answer 2',
        explanation: 'Explanation for **Question 2** in Markdown.',
        hint: 'Hint for Question 2',
      ),
      Question(
        id: 'q3',
        title: 'Question 3',
        codeSnippet: 'fn main() { println!("Question 3"); }',
        currentIndex: 2,
        answer: 'Answer 3',
        explanation: 'Explanation for **Question 3** in Markdown.',
        hint: 'Hint for Question 3',
      ),
    ];

    // 查找当前题目的索引
    int currentIndex = localQuestions.indexWhere((q) => q.id == question.id);
    // 计算下一个题目的索引
    int nextIndex = currentIndex + 1;
    if (nextIndex >= localQuestions.length) {
      nextIndex = 0; // 若到最后，则从头开始
    }
    return localQuestions[nextIndex];
  }

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
                final newQuestion = await _fetchNewQuestion();
                // 返回新问题到上一级页面（QuizScreenState）
                Navigator.pop(context, newQuestion);
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
