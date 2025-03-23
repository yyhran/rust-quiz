import 'package:flutter/material.dart';
import 'package:flutter_highlight/flutter_highlight.dart';
import 'package:flutter_highlight/themes/github.dart';
import 'package:rustquiz/widgets/difficulty_indicator.dart';

class RustCodeView extends StatelessWidget {
  final String code;
  final int difficulty;

  const RustCodeView({super.key, required this.difficulty, required this.code});

  @override
  Widget build(BuildContext context) {
    return Container(
        color: const Color.fromARGB(255, 50, 50, 50),
        child: Column(children: [
          SizedBox(
            height: 80,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                DifficultyIndicator(difficulty: difficulty),
                const Text("What is the output of this program?",
                    style: TextStyle(fontSize: 18)),
                const Icon(Icons.star, size: 32, color: Colors.yellow),
              ],
            ),
          ),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            child: HighlightView(
              code,
              language: 'rust',
              theme: githubTheme,
              padding: const EdgeInsets.all(12),
              textStyle: const TextStyle(
                fontFamily: 'Source Code Pro',
                fontSize: 14,
              ),
            ),
          ),
        ]));
  }
}
