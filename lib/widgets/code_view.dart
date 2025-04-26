import 'package:flutter/material.dart';
import 'package:flutter_syntax_view/flutter_syntax_view.dart';

class RustCodeView extends StatelessWidget {
  final String code;
  const RustCodeView({super.key, required this.code});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: SingleChildScrollView(
        // scrollDirection: Axis.horizontal,
        child: SyntaxView(
          code: code,
          syntax: Syntax.RUST,
          syntaxTheme: SyntaxTheme.gravityLight(),
          fontSize: 14.5,
          withLinesCount: true,
          withZoom: false,
          expanded: false,
          selectable: true,
        ),
      ),
    );
  }
}
