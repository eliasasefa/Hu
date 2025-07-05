import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'firebase_options.dart';
import 'pages/navbar/main_home.dart';
import 'pages/exit_exam/take_exit_exam_page.dart';
import 'pages/exit_exam/import_exit_exam_questions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'pages/auth/login_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();

  // Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  String? savedTheme = prefs.getString('themeMode');
  ThemeMode themeMode = savedTheme == 'dark'
      ? ThemeMode.dark
      : savedTheme == 'light'
          ? ThemeMode.light
          : ThemeMode.system;

  runApp(MyApp(initialThemeMode: themeMode));
}

class MyApp extends StatefulWidget {
  final ThemeMode initialThemeMode;
  const MyApp({super.key, required this.initialThemeMode});
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late ThemeMode themeMode = widget.initialThemeMode;
  @override
  void initState() {
    super.initState();
    _loadTheme();
  }

  // Load the saved theme mode from SharedPreferences
  _loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final savedTheme = prefs.getString('themeMode');
    setState(() {
      if (savedTheme == 'dark') {
        themeMode = ThemeMode.dark;
      } else if (savedTheme == 'light') {
        themeMode = ThemeMode.light;
      } else {
        themeMode = ThemeMode.system; // Default to system theme
      }
    });
  }

  _saveTheme(ThemeMode theme) async {
    final prefs = await SharedPreferences.getInstance();
    if (theme == ThemeMode.dark) {
      prefs.setString('themeMode', 'dark');
    } else if (theme == ThemeMode.light) {
      prefs.setString('themeMode', 'light');
    } else {
      prefs.setString('themeMode', 'system');
    }
  }

  void toggleTheme() {
    setState(() {
      themeMode =
          themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
      _saveTheme(themeMode);
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      themeMode: themeMode,
      routes: {
        '/import-exit-exam-questions': (context) =>
            const ImportExitExamQuestionsPage(),
      },
      home: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
                body: Center(child: CircularProgressIndicator()));
          }
          if (snapshot.hasData) {
            return MainHome(toggleTheme: toggleTheme);
          } else {
            return LoginPage(onLoginSuccess: () => setState(() {}));
          }
        },
      ),
    );
  }
}
