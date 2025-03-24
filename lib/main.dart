import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rustquiz/screens/favourite_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'data/questions_manager.dart';
import 'screens/quiz_screen.dart';

// 应用状态管理（包含主题模式）
class AppState extends ChangeNotifier {
  bool _isDarkMode = false;

  bool get isDarkMode => _isDarkMode;

  // ThemeMode get themeMode => _isDarkMode ? ThemeMode.dark : ThemeMode.light;
  ThemeMode get themeMode => ThemeMode.dark;

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

  await QuestionManager().initializeQuestions(); // 加载题目数据

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
            create: (context) => AppState()..loadThemePreference()),
        ChangeNotifierProvider(create: (context) => QuestionManager()),
      ],
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
class QuizHomePage extends StatefulWidget {
  const QuizHomePage({super.key});

  @override
  QuizHomePageState createState() => QuizHomePageState();
}

class QuizHomePageState extends State<QuizHomePage> {
  final GlobalKey<QuizScreenState> quizScreenKey = GlobalKey<QuizScreenState>();
  final qm = QuestionManager();

  // 打开收藏页面
  Future<void> _openFavourites() async {
    final selectedIndex = await Navigator.push<int>(
      context,
      MaterialPageRoute(builder: (context) => const FavouriteScreen()),
    );
    if (selectedIndex != null) {
      setState(() {
        quizScreenKey.currentState!.resetPageState();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Consumer<QuestionManager>(builder: (context, qm, child) {
          return Text(
              'RustQuiz #${qm.currentIndex} (${qm.completed.length}/${qm.questions.length})');
        }),
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
      body: QuizScreen(
        key: quizScreenKey,
      ), // 主答题界面
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text('Menu'),
            ),
            ListTile(
              title: const Text('Favourites'),
              onTap: () {
                Navigator.pop(context);
                _openFavourites();
              },
            ),
          ],
        ),
      ),
    );
  }
}
