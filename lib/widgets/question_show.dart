import 'package:flutter/material.dart';
import 'package:rustquiz/data/questions_manager.dart';
import 'package:rustquiz/widgets/code_view.dart';
import 'package:rustquiz/widgets/difficulty_indicator.dart';

class QuestionShow extends StatefulWidget {
  final String code;
  final int difficulty;

  const QuestionShow({super.key, required this.difficulty, required this.code});

  @override
  QuestionShowState createState() => QuestionShowState();
}

class QuestionShowState extends State<QuestionShow> {
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
                  onTap: () async {
                    if (_qm.currentFavourite()) {
                      await _qm.removeFavourite();
                    } else {
                      await _qm.addFavourite();
                    }

                    setState(() {});
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
              child: RustCodeView(
                code: widget.code,
              )),
        ]));
  }
}
