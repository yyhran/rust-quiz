import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/foundation.dart'; // 用于 ChangeNotifier
import 'package:shared_preferences/shared_preferences.dart';

import 'data/questions.dart';
import 'models/question.dart';
import 'screens/quiz_screen.dart';
import 'widgets/code_editor.dart';

// 应用状态管理（包含主题模式）
class AppState extends ChangeNotifier {
  bool _isDarkMode = false;

  bool get isDarkMode => _isDarkMode;

  ThemeMode get themeMode => _isDarkMode ? ThemeMode.dark : ThemeMode.light;

  void toggleTheme() async {
    _isDarkMode = !_isDarkMode;
    // 保存到本地存储
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isDarkMode', _isDarkMode);
    notifyListeners();
  }

  Future<void> loadThemePreference() async {
    final prefs = await SharedPreferences.getInstance();
    _isDarkMode = prefs.getBool('isDarkMode') ?? false;
    notifyListeners();
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 初始化本地存储
  final prefs = await SharedPreferences.getInstance();

  // 如果有需要可以在这里初始化其他服务（如 Hive）
  // await Hive.initFlutter();
  await initializeQuestions(); // 加载题目数据
  runApp(
    ChangeNotifierProvider(
      create: (context) => AppState()..loadThemePreference(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AppState>(
      builder: (context, appState, child) {
        return MaterialApp(
          title: 'Flutter Quiz',
          debugShowCheckedModeBanner: false,
          theme: ThemeData.light().copyWith(
            primaryColor: Colors.blue[800],
            colorScheme: ColorScheme.fromSwatch().copyWith(
              secondary: Colors.amber,
            ),
            textTheme: const TextTheme(
              bodyLarge: TextStyle(fontSize: 16.0),
              bodyMedium: TextStyle(fontSize: 14.0),
            ),
          ),
          darkTheme: ThemeData.dark().copyWith(
            colorScheme: ColorScheme.dark(
              primary: Colors.blue[300]!,
              secondary: Colors.amber[200]!,
            ),
            textTheme: const TextTheme(
              bodyLarge: TextStyle(color: Colors.white70),
            ),
          ),
          themeMode: appState.themeMode,
          home: const QuizHomePage(),
        );
      },
    );
  }
}

// 主页导航框架
class QuizHomePage extends StatelessWidget {
  const QuizHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('RustQuiz'),
        actions: [
          IconButton(
            icon: Icon(
              context.watch<AppState>().isDarkMode
                  ? Icons.light_mode
                  : Icons.dark_mode,
            ),
            onPressed: () => context.read<AppState>().toggleTheme(),
          ),
        ],
      ),
      body: QuizScreen(), // 主答题界面
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text('功能菜单'),
            ),
            ListTile(
              title: const Text('答题进度'),
              onTap: () {/* 导航到进度页面 */},
            ),
            ListTile(
              title: const Text('错题本'),
              onTap: () {/* 导航到错题本页面 */},
            ),
          ],
        ),
      ),
    );
  }
}
