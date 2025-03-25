import 'package:flutter/material.dart';

import '../data/questions_manager.dart';
import '../widgets/question_show.dart';
import '../widgets/dropdown.dart';
import '../widgets/hint.dart';
import '../widgets/quiz_button.dart';
import 'explanation_page.dart';

class QuizPage extends StatefulWidget {
  const QuizPage({super.key});

  @override
  QuizPageState createState() => QuizPageState();
}

class QuizPageState extends State<QuizPage> {
  bool _showHint = false;
  int _giveUpCount = 3;
  String? _selectedOption;
  final _qm = QuestionManager();
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  final List<String> _options = [
    'The program exhibits undefined behavior',
    'The program does not compile',
    'The program is guaranteed to output:'
  ];

  // 当用户点击圆形按钮时调用
  void _submitOption() {
    // 如果当前选中的是第三项，则认为输入框的内容有效，否则使用下拉框选项
    final String userAnswer = (_selectedOption == _options[2])
        ? _controller.text
        : _selectedOption ?? "";

    if (userAnswer.trim().toLowerCase() ==
        _qm.getQuestion().answer.trim().toLowerCase()) {
      _showExplanation();
    } else {
      // 答案错误，弹出提示
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Error!"), duration: Duration(seconds: 1)),
      );
      if (_giveUpCount > 0) {
        setState(() {
          _giveUpCount--;
        });
      }
    }
  }

  void _handleGiveUp() async {
    if (_giveUpCount > 0) {
      await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            insetPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            content: Text(
              'Please try three times before giving up (remaining attempts: $_giveUpCount)',
              style: const TextStyle(fontSize: 16),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
    } else {
      _showExplanation();
    }
  }

  Future<void> _confirmHint() async {
    if (_showHint == true) return;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Show hint?'),
          content: const Text('Have you really thought the question?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('CANCEL'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('YES'),
            ),
          ],
        );
      },
    );
    if (confirmed == true) {
      setState(() {
        _showHint = true;
      });
    }
  }

  void resetPageState() {
    _giveUpCount = 3;
    _controller.clear();
    _focusNode.unfocus();
    _showHint = false;
    FocusScope.of(context).unfocus();
  }

  void _showExplanation() async {
    // 跳转到 ExplanationPage，并等待返回的新题目
    final newQuestion = await Navigator.push<int>(
      context,
      MaterialPageRoute(
        builder: (context) => ExplanationPage(question: _qm.getQuestion()),
      ),
    );

    if (newQuestion != null) {
      _qm.nextQuestion();
      setState(() {
        resetPageState();
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _selectedOption = _options[2];
    setState(() {});
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_qm.getQuestion().title.replaceAll('-', ' ')),
      ),
      body: ListView(
        children: [
          // 代码编辑器
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(4),
            child: QuestionShow(
                code: _qm.getQuestion().codeSnippet,
                difficulty: _qm.getQuestion().difficulty),
          ),
          const SizedBox(height: 8),
          // 选项
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(8),
            child: QuizDropdown(
                options: _options,
                selectedValue: _selectedOption,
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedOption = newValue;
                  });
                }),
          ),
          const SizedBox(height: 8),

          // 输入
          Container(
            width: double.infinity,
            padding: const EdgeInsets.only(top: 4.0, bottom: 4.0, left: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                // 输入框部分，占据剩余宽度
                Expanded(
                  child: TextField(
                    controller: _controller,
                    focusNode: _focusNode,
                    decoration: const InputDecoration(
                      hintText: 'result',
                      // 只显示下划线
                      border: UnderlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () {
                    _submitOption();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 49, 110, 138),
                    shape: const CircleBorder(),
                    padding: const EdgeInsets.all(4),
                  ),
                  child: const Icon(
                    Icons.check,
                    size: 16,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          // 操作按钮
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                QuizButton(
                  text: "SKIP",
                  onPressed: () {
                    _qm.skipQuestion();
                    setState(() {
                      resetPageState();
                    });
                  },
                ),
                QuizButton(
                  text: _giveUpCount > 0 ? "GIVE UP($_giveUpCount)" : "GIVE UP",
                  onPressed: _handleGiveUp,
                ),
                QuizButton(
                  text: "HINT",
                  onPressed: _confirmHint,
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          // 解释信息
          if (_showHint) ToggleTextBox(text: _qm.getQuestion().hint)
        ],
      ),
    );
  }
}
