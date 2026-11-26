
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/user_model.dart';
import '../services/user_service.dart';
import 'login_screen.dart';
import 'home_page.dart';

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, authSnapshot) {
        if (authSnapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final user = authSnapshot.data;

        if (user == null) {
          return const LoginScreen();
        }

        return UserDataWrapper(uid: user.uid);
      },
    );
  }
}

class UserDataWrapper extends StatelessWidget {
  final String uid;

  const UserDataWrapper({
    super.key,
    required this.uid,
  });

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<UserModel?>(
      stream: UserService().watchUser(uid),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (snapshot.hasError) {
          return Scaffold(
            body: Center(
              child: Text('Gagal mengambil data pengguna: ${snapshot.error}'),
            ),
          );
        }

        final userData = snapshot.data;

        if (userData == null) {
          return const Scaffold(
            body: Center(
              child: Text('Data profil pengguna tidak ditemukan.'),
            ),
          );
        }

        return const HomePage();
      },
    );
  }
}

