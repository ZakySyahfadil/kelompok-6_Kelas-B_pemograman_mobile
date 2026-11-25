<<<<<<< HEAD

import 'package:flutter/material.dart';
import 'screens/home_page.dart';

// Warna utama UNHAS CONNECT
const Color unhasMaroon = Color(0xFF9E1B32);
const Color unhasBackground = Color(0xFFF7F7F9);

void main() {
  runApp(const UnhasConnectApp());
=======

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'screens/auth_wrapper.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
>>>>>>> c444b1f258ccd65bf35d6b028060f7744c9fe685
}

class UnhasConnectApp extends StatelessWidget {
  const UnhasConnectApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
<<<<<<< HEAD
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
=======
      debugShowCheckedModeBanner: false,
      title: 'UNHAS CONNECT',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
>>>>>>> c444b1f258ccd65bf35d6b028060f7744c9fe685
        ),
        useMaterial3: true,
      ),
<<<<<<< HEAD

      // Halaman pertama
      home: const HomePage(),
=======
      home: const AuthWrapper(),
>>>>>>> c444b1f258ccd65bf35d6b028060f7744c9fe685
    );
  }
}
