import 'package:flutter/material.dart';
import 'package:rustquiz/data/questions_manager.dart';
import 'package:rustquiz/widgets/code_view.dart';

class FavouritePage extends StatelessWidget {
  const FavouritePage({super.key});

  String _getCodePreview(String code) {
    List<String> lines = code.split('\n');
    if (lines.length > 8) {
      lines = lines.sublist(0, 8);
    }
    return lines.join('\n');
  }

  @override
  Widget build(BuildContext context) {
    final qm = QuestionManager();
    // 从收藏索引中获取对应的题目
    final favouriteIndices = qm.favourites.toList();
    final favouriteQuestions =
        favouriteIndices.map((index) => qm.questions[index]).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Favourites'),
      ),
      body: ListView.separated(
        itemCount: favouriteQuestions.length,
        separatorBuilder: (context, index) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          final question = favouriteQuestions[index];
          final codePreview = _getCodePreview(question.codeSnippet);
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 16.0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4.0),
            ),
            color: const Color.fromARGB(255, 50, 50, 50),
            child: ListTile(
              title: Row(
                children: [
                  const Icon(
                    Icons.play_arrow,
                    color: Colors.grey,
                    size: 32,
                  ),
                  Text("#${favouriteIndices[index]} ${question.title}"),
                ],
              ),
              subtitle: SizedBox(
                width: double.infinity,
                child: RustCodeView(code: codePreview),
              ),
              onTap: () {
                qm.setCurrentIndex(favouriteIndices[index]);
                Navigator.pop(context, 1);
              },
            ),
          );
        },
      ),
    );
  }
}
