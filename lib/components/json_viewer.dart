import 'package:flutter/material.dart';
import 'dart:convert';

class JsonViewer extends StatelessWidget {
  final Map<String, dynamic> jsonData;

  const JsonViewer({super.key, required this.jsonData});

  @override
  Widget build(BuildContext context) {
    String jsonString = jsonEncode(jsonData);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Text(
        jsonString,
        style: const TextStyle(
          fontSize: 16,
          fontFamily: 'Courier',
          color: Colors.black,
        ),
      ),
    );
  }
}
