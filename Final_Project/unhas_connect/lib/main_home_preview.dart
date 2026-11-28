import 'package:flutter/material.dart';
import 'screens/home_page.dart';
import 'theme/app_colors.dart';

void main() => runApp(const HomePreviewApp());

class HomePreviewApp extends StatelessWidget {
  const HomePreviewApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'UNHAS CONNECT (Preview)',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: unhasMaroon),
        scaffoldBackgroundColor: unhasBackground,
      ),
      home: const HomePage(),
    );
  }
}