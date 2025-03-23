import 'package:flutter/material.dart';
import 'package:flutter_highlight/flutter_highlight.dart';
import 'package:flutter_highlight/themes/github.dart';
import 'package:rustquiz/data/questions_manager.dart';
import 'package:rustquiz/widgets/difficulty_indicator.dart';

class RustCodeView extends StatefulWidget {
  final String code;
  final int difficulty;

  const RustCodeView({super.key, required this.difficulty, required this.code});

  @override
  RustCodeViewState createState() => RustCodeViewState();
}

class RustCodeViewState extends State<RustCodeView> {
  final _qm = QuestionManager();

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
                DifficultyIndicator(difficulty: widget.difficulty),
                const Text("What is the output of this program?",
                    style: TextStyle(fontSize: 18)),
                // const Icon(Icons.star, size: 32, color: Colors.yellow),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      if (_qm.currentFavourite()) {
                        _qm.removeFavourite();
                      } else {
                        _qm.addFavourite();
                      }
                    });
                  },
                  child: Icon(
                    Icons.star,
                    size: 32,
                    color: _qm.currentFavourite()
                        ? Colors.yellow
                        : const Color.fromARGB(255, 150, 150, 150),
                  ),
                )
              ],
            ),
          ),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            child: HighlightView(
              widget.code,
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
