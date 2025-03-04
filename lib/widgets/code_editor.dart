import 'package:flutter/material.dart';
import 'package:flutter_highlight/flutter_highlight.dart';
import 'package:flutter_highlight/themes/github.dart';
import 'package:flutter_highlight/themes/monokai-sublime.dart';

class RustCodeView extends StatelessWidget {
  final String code;

  const RustCodeView({Key? key, required this.code}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        color: Color.fromARGB(255, 50, 50, 50),
        child: Column(children: [
          SizedBox(
            height: 80,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    Icon(Icons.circle, size: 12),
                    SizedBox(height: 2),
                    Icon(Icons.circle, size: 12),
                    SizedBox(height: 2),
                    Icon(Icons.circle, size: 12),
                  ],
                ),
                Text("What is the output of this program?",
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
