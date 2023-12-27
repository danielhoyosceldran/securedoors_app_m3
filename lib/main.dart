import 'package:flutter/material.dart';
import 'package:securedoors_app/screen_partition.dart';
import 'package:securedoors_app/screen_space.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ACS',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        brightness: Brightness.light,
        useMaterial3: true,
        textTheme: const TextTheme(
          bodyMedium: TextStyle(fontSize: 20), // size of hello
        ),
        // see https://docs.flutter.dev/cookbook/design/themes
      ),
      home: ScreenPartition(id: "building"),
      debugShowCheckedModeBanner: false,
    );
  }
}