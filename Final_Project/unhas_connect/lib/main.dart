
import 'package:flutter/material.dart';
import 'screens/home_page.dart';

// Warna utama UNHAS CONNECT
const Color unhasMaroon = Color(0xFF9E1B32);
const Color unhasBackground = Color(0xFFF7F7F9);

void main() {
  runApp(const UnhasConnectApp());
}

class UnhasConnectApp extends StatelessWidget {
  const UnhasConnectApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // Informasi aplikasi
      debugShowCheckedModeBanner: false,
      title: 'UNHAS CONNECT',

      // Tema global
      theme: ThemeData(
        useMaterial3: true,

        // Warna utama aplikasi
        colorScheme: ColorScheme.fromSeed(
          seedColor: unhasMaroon,
        ),

        // Warna background halaman
        scaffoldBackgroundColor: unhasBackground,

        // Tema AppBar
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          elevation: 0,
          centerTitle: false,
        ),
      ),

      // Halaman pertama
      home: const HomePage(),
    );
  }
}
