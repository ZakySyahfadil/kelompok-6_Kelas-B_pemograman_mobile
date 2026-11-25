
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/user_model.dart';
import '../services/user_service.dart';
import 'login_screen.dart';

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

        return HomeScreen(userData: userData);
      },
    );
  }
}

class HomeScreen extends StatelessWidget {
  final UserModel userData;

  const HomeScreen({
    super.key,
    required this.userData,
  });

  Future<void> _logout() async {
    await FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('UNHAS CONNECT'),
        actions: [
          IconButton(
            onPressed: _logout,
            icon: const Icon(Icons.logout),
            tooltip: 'Logout',
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.account_circle,
              size: 80,
              color: Colors.blue,
            ),
            const SizedBox(height: 16),
            const Text(
              'Selamat Datang di UNHAS CONNECT!',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Text('Nama: ${userData.name}'),
            Text('Email: ${userData.email}'),
            Text('Role: ${userData.role}'),

            if (userData.role == 'admin') ...[
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Selamat datang di Panel Admin!'),
                    ),
                  );
                },
                icon: const Icon(Icons.admin_panel_settings),
                label: const Text('Panel Admin'),
              ),
            ],
            
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: _logout,
              icon: const Icon(Icons.logout),
              label: const Text('Logout'),
            ),
          ],
        ),
      ),
    );
  }
}
