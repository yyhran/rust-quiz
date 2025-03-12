import 'package:flutter/gestures.dart';

import '../models/question.dart';
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;

import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;

Future<List<Question>> loadQuestions() async {
  final String jsonString =
      await rootBundle.loadString('assets/questions.json');
  final List<dynamic> jsonList = json.decode(jsonString);
  return jsonList.map((jsonItem) => Question.fromJson(jsonItem)).toList();
}

List<Question> sampleQuestions = [];

Future<void> initializeQuestions() async {
  sampleQuestions = await loadQuestions();
}
