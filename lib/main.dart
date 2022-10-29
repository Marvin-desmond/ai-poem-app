import 'package:flutter/material.dart';
import 'package:ai_poem_app/second_screen.dart';
import 'package:ai_poem_app/first_screen.dart';

void main() {
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'AI Poem App',
      initialRoute: '/',
      routes: {
        '/': (context) => const HomeScreen(),
        '/second': (context) => const SecondScreen(),
      },
    ),
  );
}
