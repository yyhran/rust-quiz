import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:math';

import '../data/questions.dart';
import '../widgets/code_editor.dart';
import '../widgets/dropdown.dart';
import '../widgets/hint.dart';
import 'explanation_screen.dart';
import '../models/question.dart';

class QuizScreen extends StatefulWidget {
  const QuizScreen({super.key});

  @override
  QuizScreenState createState() => QuizScreenState();
}

class QuizScreenState extends State<QuizScreen> {
  int _currentQuestionIndex = 0;
  bool _showHint = false;
  int _giveUpCount = 3;
  final List<String> _options = [
    'The program exhibits undefined behavior',
    'The program does not compile',
    'The program is guaranteed to output:'
  ];
  String? _selectedOption;
  String _correctAnswer = "1";
  Question _question = sampleQuestions[0] as Question;
  final random = Random();

  final Set<int> completedIndices = {};
  late List<int> notCompletedIndices;

  final TextEditingController _controller = TextEditingController();

  // 当用户点击圆形按钮时调用
  void _submitOption() {
    // 如果当前选中的是第三项，则认为输入框的内容有效，否则使用下拉框选项
    final String userAnswer = (_selectedOption == _options[2])
        ? _controller.text
        : _selectedOption ?? "";

    print("userAnster: $userAnswer");
    if (userAnswer.trim().toLowerCase() ==
        _correctAnswer.trim().toLowerCase()) {
      // 答案正确，跳转到下一个页面（这里仅做示例，实际可根据需求实现）
      // Navigator.push(context, MaterialPageRoute(builder: (context) => NextPage()));
      _showExplanation();
    } else {
      // 答案错误，弹出提示
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text("答案错误"), duration: Duration(seconds: 1) // 设置显示时间为2秒
            ),
      );
      if (_giveUpCount > 0) {
        setState(() {
          _giveUpCount--;
        });
      }
    }
  }

  void _handleGiveUp() {
    _showExplanation();
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

  void _showExplanation() async {
    // 跳转到 ExplanationScreen，并等待返回的新题目
    final newQuestion = await Navigator.push<int>(
      context,
      MaterialPageRoute(
        builder: (context) => ExplanationScreen(question: this._question),
      ),
    );
    // 如果有返回值，则更新题目
    if (newQuestion != null) {
      setState(() {
        // 标记当前题目已完成
        completedIndices.add(_currentQuestionIndex);
        notCompletedIndices.remove(_currentQuestionIndex);
        // 更新当前题目
        _currentQuestionIndex = _pickRandomQuestionIndex();
        _saveProgress(); // 保存进度

        this._currentQuestionIndex = newQuestion;
        _giveUpCount = 3;
        _controller.clear();
        _showHint = false;
        FocusScope.of(context).unfocus();
      });
    }
  }

  // 从未完成的题目中随机选取一个题目索引
  int _pickRandomQuestionIndex() {
    if (notCompletedIndices.isEmpty) {
      // 如果所有题目都已完成，则重置进度
      notCompletedIndices =
          List.generate(sampleQuestions.length, (index) => index);
      completedIndices.clear();
    }
    int randomIndex = random.nextInt(notCompletedIndices.length);
    return notCompletedIndices[randomIndex];
  }

  // 保存进度到 SharedPreferences
  Future<void> _saveProgress() async {
    final prefs = await SharedPreferences.getInstance();
    // 将 completedIndices 保存为字符串列表
    await prefs.setStringList(
      'completedIndices',
      completedIndices.map((e) => e.toString()).toList(),
    );
    await prefs.setInt('currentQuestionIndex', _currentQuestionIndex);
  }

  // 从 SharedPreferences 加载进度
  Future<void> _loadProgress() async {
    final prefs = await SharedPreferences.getInstance();
    final completedList = prefs.getStringList('completedIndices') ?? [];
    completedIndices.clear();
    completedIndices.addAll(completedList
        .map((e) => int.tryParse(e) ?? -1)
        .where((element) => element != -1));
    _currentQuestionIndex =
        prefs.getInt('currentQuestionIndex') ?? _pickRandomQuestionIndex();
    // 计算未完成的题目索引
    notCompletedIndices =
        List.generate(sampleQuestions.length, (index) => index)
            .where((index) => !completedIndices.contains(index))
            .toList();
  }

  @override
  void initState() {
    super.initState();
    // 默认选中第三个选项（索引从0开始）
    _selectedOption = _options[2];
    // _currentQuestionIndex = random.nextInt(36);
    notCompletedIndices =
        List.generate(sampleQuestions.length, (index) => index);
    if (!notCompletedIndices.contains(_currentQuestionIndex)) {
      _currentQuestionIndex = _pickRandomQuestionIndex();
    }
    setState(() {});
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // 如果进度未加载好，则显示加载指示器
    if (sampleQuestions.isEmpty || notCompletedIndices.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: const Text("Quiz")),
        body: const Center(child: CircularProgressIndicator()),
      );
    }
    // final question = sampleQuestions[_currentQuestionIndex];
    this._question = sampleQuestions[_currentQuestionIndex];
    final question = this._question;

    _correctAnswer = question.answer;

    return Scaffold(
      appBar: AppBar(
        // 进度显示 (已完成 / 总数)
        title:
            Text("进度 (${completedIndices.length}/${sampleQuestions.length})"),
      ),
      body: ListView(
        children: [
          // 代码编辑器
          Container(
            // color: Colors.blue,
            width: double.infinity,
            padding: EdgeInsets.all(4),
            child: RustCodeView(code: question.codeSnippet),
          ),
          SizedBox(height: 8),
          // 选项
          Container(
            // color: Colors.green,
            width: double.infinity,
            padding: EdgeInsets.all(8),
            child: QuizDropdown(
                options: _options,
                selectedValue: _selectedOption,
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedOption = newValue;
                  });
                }),
          ),
          SizedBox(height: 8),

          // 输入
          Container(
            // color: Colors.red,
            width: double.infinity,
            // padding: EdgeInsets.all(16),
            padding: const EdgeInsets.only(top: 4.0, bottom: 4.0, left: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                // 输入框部分，占据剩余宽度
                Expanded(
                  child: TextField(
                    controller: _controller,
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
                    _submitOption();
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
              // color: Colors.blue,
              width: double.infinity,
              padding: EdgeInsets.all(4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _currentQuestionIndex = _pickRandomQuestionIndex();
                        _saveProgress(); // 同样保存当前题目索引
                        _giveUpCount = 3;
                        _controller.clear();
                        _showHint = false;
                        FocusScope.of(context).unfocus();
                      });
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
                    onPressed: () async {
                      // 添加 async 关键字
                      if (_giveUpCount > 0) {
                        await showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text('提示'),
                              content: Text('请先尝试三次再放弃（剩余尝试次数：$_giveUpCount）'),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.of(context).pop(),
                                  child: const Text('确定'),
                                ),
                              ],
                            );
                          },
                        );
                      } else {
                        _handleGiveUp();
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color.fromARGB(255, 50, 50, 50),
                      minimumSize: const Size(100, 30),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.zero,
                      ),
                    ),
                    child: Text(
                      _giveUpCount > 0 ? "GIVE UP($_giveUpCount)" : "GIVE UP",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: _confirmHint,
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
          SizedBox(height: 8),
          // 解释信息
          if (_showHint) ToggleTextBox(text: question.hint)
        ],
      ),
    );
  }
}
