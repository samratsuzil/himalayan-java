import 'package:flutter/material.dart';
import 'package:recipe_book/pages/home_page.dart';
// import 'package:recipe_book/screens/main_page.dart';
// import 'package:recipe_book/screens/backup/recipe_detail_page.dart';
// import 'package:recipe_book/screens/test_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Recipe Book',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: HomePage(),
    );
  }
}
