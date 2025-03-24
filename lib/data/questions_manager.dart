import 'dart:collection';

import 'package:flutter/foundation.dart';

import '../models/question.dart';
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:math';

class QuestionManager extends ChangeNotifier {
  static final QuestionManager _qm = QuestionManager._internal();
  QuestionManager._internal();

  factory QuestionManager() {
    return _qm;
  }

  int _currentIndex = 0;
  List<Question> _questions = [];
  final Set<int> _favourites = {};
  final Set<int> _completed = {};
  List<int> _notCompleted = [];

  int get currentIndex => _currentIndex;
  UnmodifiableListView<Question> get questions =>
      UnmodifiableListView(_questions);
  UnmodifiableListView<int> get favourites => UnmodifiableListView(_favourites);
  UnmodifiableListView<int> get completed => UnmodifiableListView(_completed);
  UnmodifiableListView<int> get notCompleted =>
      UnmodifiableListView(_notCompleted);

  Question getQuestion() => _questions[_currentIndex];

  void setCurrentIndex(int index) {
    _currentIndex = index;
  }

  void skipQuestion() async {
    _currentIndex = _pickRandomQuestionIndex();
    await _saveProgress();
  }

  void nextQuestion() async {
    _completed.add(_currentIndex);
    _notCompleted.remove(_currentIndex);
    _currentIndex = _pickRandomQuestionIndex();
    await _saveProgress();
  }

  bool currentFavourite() => _favourites.contains(_currentIndex);

  void addFavourite() async {
    _favourites.add(_currentIndex);
    await _saveProgress();
  }

  void removeFavourite() async {
    _favourites.remove(_currentIndex);
    await _saveProgress();
  }

  Future<List<Question>> loadQuestions() async {
    final String jsonString =
        await rootBundle.loadString('assets/questions.json');
    final List<dynamic> jsonList = json.decode(jsonString);
    return jsonList.map((jsonItem) => Question.fromJson(jsonItem)).toList();
  }

// 从未完成的题目中随机选取一个题目索引
  int _pickRandomQuestionIndex() {
    if (_notCompleted.isEmpty) {
      // 如果所有题目都已完成，则重置进度
      _notCompleted = List.generate(_questions.length, (index) => index);
      _completed.clear();
    }
    int randomIndex = Random().nextInt(_notCompleted.length);
    return _notCompleted[randomIndex];
  }

  // 保存进度到 SharedPreferences
  Future<void> _saveProgress() async {
    final prefs = await SharedPreferences.getInstance();
    // 将 completedIndices 保存为字符串列表
    await prefs.setStringList(
      'completed',
      _completed.map((e) => e.toString()).toList(),
    );
    await prefs.setStringList(
      'favourites',
      _favourites.map((e) => e.toString()).toList(),
    );
    await prefs.setInt('currentIndex', _currentIndex);
    notifyListeners();
  }

  // 从 SharedPreferences 加载进度
  Future<void> _loadProgress() async {
    final prefs = await SharedPreferences.getInstance();
    final completedList = prefs.getStringList('completed') ?? [];
    _completed.clear();
    _completed.addAll(completedList
        .map((e) => int.tryParse(e) ?? -1)
        .where((element) => element != -1));
    _currentIndex = prefs.getInt('currentIndex') ?? _pickRandomQuestionIndex();
    final favouritesList = prefs.getStringList('favourites') ?? [];
    _favourites.clear();
    _favourites.addAll(
        favouritesList.map((e) => int.tryParse(e) ?? -1).where((e) => e != -1));
    // 计算未完成的题目索引
    _notCompleted = List.generate(_questions.length, (index) => index)
        .where((index) => !_completed.contains(index))
        .toList();
  }

  Future<void> initializeQuestions() async {
    _questions = await loadQuestions();
    await _loadProgress();
  }
}
