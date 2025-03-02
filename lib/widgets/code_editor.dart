import 'package:flutter/material.dart';
import 'package:flutter_highlight/flutter_highlight.dart';
import 'package:flutter_highlight/themes/monokai-sublime.dart';

class RustCodeView extends StatelessWidget {
  final String code;

  const RustCodeView({Key? key, required this.code}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return HighlightView(
      // 传入你的 Rust 代码
      code,
      // 指定语言为 "rust"
      language: 'rust',
      // 选择你喜欢的主题，这里用的是 Monokai Sublime
      theme: monokaiSublimeTheme,
      padding: const EdgeInsets.all(12),
      textStyle: const TextStyle(
        fontFamily: 'Source Code Pro',
        fontSize: 14,
      ),
    );
  }
}
