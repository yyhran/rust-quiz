import 'package:flutter/gestures.dart';

import '../models/question.dart';
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:math';

class QuestionManager {
  static final QuestionManager _qm = QuestionManager._internal();
  QuestionManager._internal();

  factory QuestionManager() {
    return _qm;
  }

  List<Question> questions = [];
  int _currentIndex = 0;
  final Set<int> completed = {};
  List<int> notCompleted = [];

  Question getQuestion() {
    return questions[_currentIndex];
  }

  void skipQuestion() {
    _currentIndex = _pickRandomQuestionIndex();
    _saveProgress();
  }

  void nextQuestion() {
    print("completed add ${_currentIndex}");
    completed.add(_currentIndex);
    print("notCompleted remove ${_currentIndex}");
    notCompleted.remove(_currentIndex);
    _currentIndex = _pickRandomQuestionIndex();
    print("_currentIndex remove ${_currentIndex}");
    _saveProgress();
  }

  void summitQuestion() {}

  Future<List<Question>> loadQuestions() async {
    final String jsonString =
        await rootBundle.loadString('assets/questions.json');
    final List<dynamic> jsonList = json.decode(jsonString);
    return jsonList.map((jsonItem) => Question.fromJson(jsonItem)).toList();
  }

// 从未完成的题目中随机选取一个题目索引
  int _pickRandomQuestionIndex() {
    if (notCompleted.isEmpty) {
      // 如果所有题目都已完成，则重置进度
      notCompleted = List.generate(questions.length, (index) => index);
      completed.clear();
    }
    int randomIndex = Random().nextInt(notCompleted.length);
    return notCompleted[randomIndex];
  }

  // 保存进度到 SharedPreferences
  Future<void> _saveProgress() async {
    final prefs = await SharedPreferences.getInstance();
    // 将 completedIndices 保存为字符串列表
    await prefs.setStringList(
      'completed',
      completed.map((e) => e.toString()).toList(),
    );
    await prefs.setInt('currentIndex', _currentIndex);
  }

  // 从 SharedPreferences 加载进度
  Future<void> _loadProgress() async {
    final prefs = await SharedPreferences.getInstance();
    final completedList = prefs.getStringList('completed') ?? [];
    completed.clear();
    completed.addAll(completedList
        .map((e) => int.tryParse(e) ?? -1)
        .where((element) => element != -1));
    _currentIndex = prefs.getInt('currentIndex') ?? _pickRandomQuestionIndex();
    // 计算未完成的题目索引
    notCompleted = List.generate(questions.length, (index) => index)
        .where((index) => !completed.contains(index))
        .toList();
  }

  Future<void> initializeQuestions() async {
    questions = await loadQuestions();
    await _loadProgress();
  }
}
