import 'package:flutter/material.dart';
import 'package:flutter_highlight/flutter_highlight.dart';
import 'package:flutter_highlight/themes/github.dart';

class RustCodeView extends StatelessWidget {
  final String code;
  const RustCodeView({super.key, required this.code});

  @override
  Widget build(BuildContext context) {
    return HighlightView(
      code,
      language: 'rust',
      theme: githubTheme,
      padding: const EdgeInsets.all(12),
      textStyle: const TextStyle(
        fontFamily: 'Source Code Pro',
        fontSize: 14,
      ),
    );
  }
}
