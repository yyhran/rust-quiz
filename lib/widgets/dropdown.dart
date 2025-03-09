import 'package:flutter/material.dart';

class QuizDropdown extends StatefulWidget {
  final String? selectedValue;
  final ValueChanged<String?> onChanged;
  final List<String> options;

  const QuizDropdown({
    Key? key,
    required this.selectedValue,
    required this.onChanged,
    this.options = const [
      'The program exhibits undefined behavior',
      'The program does not compile',
      'The program is guaranteed to output:'
    ],
  }) : super(key: key);

  @override
  _QuizDropdownState createState() => _QuizDropdownState();
}

class _QuizDropdownState extends State<QuizDropdown> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color.fromARGB(255, 50, 50, 50),
      // padding: EdgeInsets.symmetric(horizontal: 2),
      padding:
          const EdgeInsets.only(top: 4.0, bottom: 4.0, left: 4.0, right: 16.0),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          // isExpanded: true,
          value: widget.selectedValue, // 使用父组件传入的值
          items: widget.options.map((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
          onChanged: widget.onChanged,
        ),
      ),
    );
  }
}
