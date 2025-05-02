import 'package:flutter/material.dart';

class MainPageWidget extends StatefulWidget {
  const MainPageWidget({super.key});

  @override
  State<MainPageWidget> createState() => _MainPageWidgetState();
}

class _MainPageWidgetState extends State<MainPageWidget> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Recipe Book'),
        ),
        body: Center(
          child: Text('Welcome to Recipe Book!'),
        ),
      ),
    );
  }
}
