// import 'package:flutter/material.dart';
// import 'package:recipe_book/pages/home_page.dart';
// import 'package:recipe_book/pages/splash_screen.dart';
// // import 'firebase_options.dart';

// void main() {
//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Recipe Book',
//       debugShowCheckedModeBanner: false,
//       initialRoute: '/',
//       routes: {
//         '/': (context) => const SplashScreen(),
//         '/home': (context) => const HomePage(),
//       },
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:recipe_book/pages/splash_screen.dart';
import 'package:recipe_book/pages/main_scaffold.dart'; // Import here

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Recipe Book',
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => const SplashScreen(),
        '/home': (context) => const MainScaffold(), // ✅ Updated
      },
    );
  }
}
