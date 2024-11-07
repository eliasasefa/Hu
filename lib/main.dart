// import 'package:flutter/material.dart';
// import 'pages/navbar/main_home.dart'; // Import MainHome class

// void main() {
//   runApp(const MyApp());
// }

// class MyApp extends StatefulWidget {
//   const MyApp({super.key});

//   @override
//   State<MyApp> createState() => _MyAppState();
// }

// class _MyAppState extends State<MyApp> {
//   // Initialize the theme mode to system by default
//   ThemeMode themeMode = ThemeMode.light;

//   // Toggle between light and dark theme
//   void toggleTheme() {
//     setState(() {
//       themeMode =
//           (themeMode == ThemeMode.light) ? ThemeMode.dark : ThemeMode.light;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       home: MainHome(toggleTheme: toggleTheme),
//       theme: ThemeData.light(), // Light theme
//       darkTheme: ThemeData.dark(), // Dark theme
//       themeMode: themeMode,
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'pages/navbar/main_home.dart'; // Import MainHome class

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late ThemeMode themeMode;

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

  // Save the theme mode to SharedPreferences
  _saveTheme(ThemeMode theme) async {
    final prefs = await SharedPreferences.getInstance();
    if (theme == ThemeMode.dark) {
      prefs.setString('themeMode', 'dark');
    } else if (theme == ThemeMode.light) {
      prefs.setString('themeMode', 'light');
    }
  }

  // Toggle between light and dark theme
  void toggleTheme() {
    setState(() {
      themeMode =
          (themeMode == ThemeMode.light) ? ThemeMode.dark : ThemeMode.light;
      _saveTheme(themeMode); // Save the theme selection
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MainHome(
        toggleTheme: toggleTheme,
      ),
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      themeMode: themeMode,
    );
  }
}
