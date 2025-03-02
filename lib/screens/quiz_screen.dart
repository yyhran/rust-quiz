import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../data/questions.dart';
import '../widgets/code_editor.dart';

class QuizScreen extends StatefulWidget {
  @override
  _QuizScreenState createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  int _currentQuestionIndex = 0;
  int? _selectedAnswerIndex;
  bool _showExplanation = false;

  void _checkAnswer() {
    setState(() {
      _showExplanation = true;
    });
  }

  void _nextQuestion() {
    setState(() {
      _currentQuestionIndex++;
      _selectedAnswerIndex = null;
      _showExplanation = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final question = sampleQuestions[_currentQuestionIndex];

    return Scaffold(
      appBar: AppBar(
          title: Text(
              '题目 ${_currentQuestionIndex + 1}/${sampleQuestions.length}')),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 题目描述
            Text(question.description, style: TextStyle(fontSize: 18)),
            SizedBox(height: 16),

            // 代码编辑器
            RustCodeView(code: question.codeSnippet),
            SizedBox(height: 24),

            // 选项列表
            ...question.options.asMap().entries.map((entry) {
              final index = entry.key;
              final option = entry.value;

              return RadioListTile<int>(
                title: Text(option),
                value: index,
                groupValue: _selectedAnswerIndex,
                onChanged: (value) =>
                    setState(() => _selectedAnswerIndex = value),
              );
            }),

            // 解释信息
            if (_showExplanation)
              Padding(
                padding: EdgeInsets.only(top: 16),
                child: Text(
                  question.explanation,
                  style: TextStyle(color: Colors.green),
                ),
              ),

            Spacer(),

            // 操作按钮
            ElevatedButton(
              onPressed: _selectedAnswerIndex != null ? _checkAnswer : null,
              child: Text('提交答案'),
            ),
            ElevatedButton(
              onPressed: _nextQuestion,
              child: Text('下一题'),
            ),
          ],
        ),
      ),
    );
  }
}
