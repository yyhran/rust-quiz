import 'package:flutter/material.dart';
import 'package:rustquiz/widgets/quiz_markdown.dart';

class ToggleTextBox extends StatefulWidget {
  final String text;

  const ToggleTextBox({super.key, required this.text});

  @override
  ToggleTextBoxState createState() => ToggleTextBoxState();
}

class ToggleTextBoxState extends State<ToggleTextBox> {
  bool _isTextVisible = true;

  void _toggle() {
    setState(() {
      _isTextVisible = !_isTextVisible;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.yellow.shade100,
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // 上半部分：按钮
          InkWell(
            onTap: _toggle,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 8),
              decoration: const BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: Color.fromARGB(255, 30, 30, 30), // 稍暗的颜色作为分隔线
                    width: 1.0,
                  ),
                ),
              ),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  _isTextVisible ? "HIDE HINT" : "SHOW HINT",
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
          ),
          // 下半部分：文本
          Visibility(
            visible: _isTextVisible,
            child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                child:
                    QuizMarkdown(data: widget.text, color: Colors.transparent)),
          ),
        ],
      ),
    );
  }
}
