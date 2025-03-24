import 'package:flutter/material.dart';
import 'package:flutter_highlight/flutter_highlight.dart';
import 'package:flutter_highlight/themes/github.dart';
import 'package:rustquiz/data/questions_manager.dart';

class FavouriteScreen extends StatelessWidget {
  const FavouriteScreen({super.key});

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
                child: HighlightView(
                  codePreview,
                  language: 'rust',
                  theme: githubTheme,
                  padding: const EdgeInsets.all(12),
                  textStyle: const TextStyle(
                    fontFamily: 'Source Code Pro',
                    fontSize: 12,
                  ),
                ),
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
