// import 'package:firebase_core/firebase_core.dart';
// import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'firebase_options.dart';
// import 'pages/navbar/main_home.dart';
// import 'pages/exit_exam/import_exit_exam_questions.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'pages/auth/login_page.dart';
// import 'package:flutter_dotenv/flutter_dotenv.dart';

// Future<void> main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   // Load environment variables from .env file
//   try {
//     await dotenv.load(fileName: ".env");
//   } catch (e) {
//     // You may want to log or handle this error
//     debugPrint('Failed to load .env file: $e');
//   }

//   SharedPreferences prefs = await SharedPreferences.getInstance();

//   // Initialize Firebase only if not already initialized
//   if (Firebase.apps.isEmpty) {
//     await Firebase.initializeApp(
//       options: DefaultFirebaseOptions.currentPlatform,
//     );
//     print('Firebase initialized.');
//   } else {
//     print('Firebase already initialized.');
//   }

//   // Only sign out on app start if remember_me is not enabled
//   final rememberMe = prefs.getBool('remember_me') ?? false;
//   if (!rememberMe) {
//     await FirebaseAuth.instance.signOut();
//   }

//   String? savedTheme = prefs.getString('themeMode');
//   ThemeMode themeMode = savedTheme == 'dark'
//       ? ThemeMode.dark
//       : savedTheme == 'light'
//           ? ThemeMode.light
//           : ThemeMode.system;

//   runApp(MyApp(initialThemeMode: themeMode));
// }

// class MyApp extends StatefulWidget {
//   final ThemeMode initialThemeMode;
//   const MyApp({super.key, required this.initialThemeMode});
//   @override
//   State<MyApp> createState() => _MyAppState();
// }

// class _MyAppState extends State<MyApp> {
//   late ThemeMode themeMode = widget.initialThemeMode;
//   @override
//   void initState() {
//     super.initState();
//     _loadTheme();
//   }

//   // Load the saved theme mode from SharedPreferences
//   _loadTheme() async {
//     final prefs = await SharedPreferences.getInstance();
//     final savedTheme = prefs.getString('themeMode');
//     setState(() {
//       if (savedTheme == 'dark') {
//         themeMode = ThemeMode.dark;
//       } else if (savedTheme == 'light') {
//         themeMode = ThemeMode.light;
//       } else {
//         themeMode = ThemeMode.system; // Default to system theme
//       }
//     });
//   }

//   _saveTheme(ThemeMode theme) async {
//     final prefs = await SharedPreferences.getInstance();
//     if (theme == ThemeMode.dark) {
//       prefs.setString('themeMode', 'dark');
//     } else if (theme == ThemeMode.light) {
//       prefs.setString('themeMode', 'light');
//     } else {
//       prefs.setString('themeMode', 'system');
//     }
//   }

//   void toggleTheme() {
//     setState(() {
//       themeMode =
//           themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
//       _saveTheme(themeMode);
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       theme: ThemeData.light(),
//       darkTheme: ThemeData.dark(),
//       themeMode: themeMode,
//       routes: {
//         '/import-exit-exam-questions': (context) =>
//             const ImportExitExamQuestionsPage(),
//       },
//       home: StreamBuilder<User?>(
//         stream: FirebaseAuth.instance.authStateChanges(),
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return const Scaffold(
//                 body: Center(child: CircularProgressIndicator()));
//           }
//           if (snapshot.hasData) {
//             return MainHome(toggleTheme: toggleTheme);
//           } else {
//             return LoginPage(onLoginSuccess: () => setState(() {}));
//           }
//         },
//       ),
//     );
//   }
// }

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'firebase_options.dart';
import 'pages/navbar/main_home.dart';
import 'pages/exit_exam/import_exit_exam_questions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'pages/auth/login_page.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'pages/splash/splash.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Load environment variables from .env file
  try {
    await dotenv.load(fileName: ".env");
  } catch (e) {
    debugPrint('Failed to load .env file: $e');
  }

  SharedPreferences prefs = await SharedPreferences.getInstance();

  // Initialize Firebase only if not already initialized
  if (Firebase.apps.isEmpty) {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    print('Firebase initialized.');
  } else {
    print('Firebase already initialized.');
  }

  final rememberMe = prefs.getBool('remember_me') ?? false;
  if (!rememberMe) {
    await FirebaseAuth.instance.signOut();
  }

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
      home: FutureBuilder<SharedPreferences>(
        future: SharedPreferences.getInstance(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Scaffold(
                body: Center(child: CircularProgressIndicator()));
          }
          final prefs = snapshot.data!;
          final isFirstLaunch = prefs.getBool('isFirstLaunch');
          if (isFirstLaunch == null || isFirstLaunch == true) {
            return const Splash();
          } else {
            return StreamBuilder<User?>(
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
            );
          }
        },
      ),
    );
  }
}
