import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../data/questions.dart';
import '../widgets/code_editor.dart';
import '../widgets/dropdown.dart';

class QuizScreen extends StatefulWidget {
  const QuizScreen({super.key});

  @override
  QuizScreenState createState() => QuizScreenState();
}

class QuizScreenState extends State<QuizScreen> {
  int _currentQuestionIndex = 0;
  bool _showExplanation = false;

  void _checkAnswer() {
    setState(() {
      _showExplanation = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    final question = sampleQuestions[_currentQuestionIndex];

    return Scaffold(
      // appBar: AppBar(
      //     // title: Text('Question ${_currentQuestionIndex + 1}/${sampleQuestions.length}')
      //     ),
      body: ListView(
        children: [
          // 代码编辑器
          Container(
            color: Colors.blue,
            width: double.infinity,
            padding: EdgeInsets.all(4),
            child: RustCodeView(code: question.codeSnippet),
          ),
          SizedBox(height: 8),
          Container(
            color: Colors.green,
            width: double.infinity,
            padding: EdgeInsets.all(8),
            child: QuizDropdown(),
          ),
          SizedBox(height: 8),

          // 输入
          Container(
            color: Colors.red,
            width: double.infinity,
            // padding: EdgeInsets.all(16),
            padding: const EdgeInsets.only(top: 4.0, bottom: 4.0, left: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                // 输入框部分，占据剩余宽度
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'result',
                      // 只显示下划线
                      border: UnderlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                // 圆形按钮，按钮上有√图标
                ElevatedButton(
                  onPressed: () {
                    // 按钮点击事件
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        Color.fromARGB(255, 49, 110, 138), // 设置按钮的背景色为淡蓝色
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
          SizedBox(height: 8),
          // 操作按钮
          Container(
              color: Colors.orange,
              width: double.infinity,
              padding: EdgeInsets.all(4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      // SKIP 按钮的点击逻辑
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color.fromARGB(255, 50, 50, 50),
                      minimumSize: const Size(100, 30),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.zero,
                      ),
                    ),
                    child: const Text(
                      "SKIP",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      // GIVE UP(3) 按钮的点击逻辑
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color.fromARGB(255, 50, 50, 50),
                      minimumSize: const Size(100, 30),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.zero,
                      ),
                    ),
                    child: const Text(
                      "GIVE UP(3)",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      // HINT 按钮的点击逻辑
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color.fromARGB(255, 50, 50, 50),
                      minimumSize: const Size(100, 30),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.zero,
                      ),
                    ),
                    child: const Text(
                      "HINT",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              )),

          // 解释信息
          if (_showExplanation)
            Padding(
              padding: EdgeInsets.only(top: 16),
              child: Text(
                question.explanation,
                style: TextStyle(color: Colors.green),
              ),
            ),
        ],
      ),
    );
  }
}
