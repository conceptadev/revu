import 'package:flutter/material.dart';
import 'package:revue_app/screens/chat.screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Revue',
      theme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      // darkTheme: ThemeData.dark(useMaterial3: true),
      home: const ChatScreen(),
    );
  }
}
