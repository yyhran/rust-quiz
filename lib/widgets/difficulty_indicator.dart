import 'package:flutter/material.dart';

class DifficultyIndicator extends StatelessWidget {
  final int difficulty;

  const DifficultyIndicator({super.key, required this.difficulty})
      : assert(difficulty >= 0 && difficulty <= 3);

  @override
  Widget build(BuildContext context) {
    const Color grey = Colors.grey;
    const Color green = Colors.green;
    const Color yellow = Colors.yellow;
    const Color red = Colors.red;

    List<Color> colors;
    switch (difficulty) {
      case 1:
        colors = [grey, grey, green];
        break;
      case 2:
        colors = [grey, yellow, yellow];
        break;
      case 3:
        colors = [red, red, red];
        break;
      case 0:
      default:
        colors = [grey, grey, grey];
        break;
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: colors
          .map((color) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 1.0),
                child: Icon(Icons.circle, size: 12, color: color),
              ))
          .toList(),
    );
  }
}
