import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'screens/auth_wrapper.dart';

// Warna utama UNHAS CONNECT
const Color unhasMaroon = Color(0xFF9E1B32);
const Color unhasBackground = Color(0xFFF7F7F9);

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Inisialisasi Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const UnhasConnectApp());
}

class UnhasConnectApp extends StatelessWidget {
  const UnhasConnectApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'UNHAS CONNECT',

      // Tema global aplikasi
      theme: ThemeData(
        useMaterial3: true,

        // Warna utama
        colorScheme: ColorScheme.fromSeed(
          seedColor: unhasMaroon,
        ),

        // Background halaman
        scaffoldBackgroundColor: unhasBackground,

        // Tema AppBar
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          elevation: 0,
          centerTitle: false,
        ),
      ),

      // Pemeriksaan autentikasi sebelum masuk Home
      home: const AuthWrapper(),
    );
  }
}
