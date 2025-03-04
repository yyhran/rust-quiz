import 'package:flutter/material.dart';

class QuizDropdown extends StatefulWidget {
  @override
  _QuizDropdownState createState() => _QuizDropdownState();
}

class _QuizDropdownState extends State<QuizDropdown> {
  String? _selectedValue;
  final List<String> _options = [
    'The program exhibits undefined behavior',
    'The program does not compile',
    'The program is guaranteed to output:' // 第三个选项
  ];

  @override
  void initState() {
    super.initState();
    // 默认选中第三个选项（索引从0开始）
    _selectedValue = _options[2];
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color.fromARGB(255, 50, 50, 50),
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          isExpanded: true,
          value: _selectedValue, // 自动显示第三个选项
          items: _options.map((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
          onChanged: (String? newValue) {
            setState(() => _selectedValue = newValue);
          },
        ),
      ),
    );
  }
}
