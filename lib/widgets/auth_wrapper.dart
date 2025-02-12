import 'package:content2cart/screens/dashboard_screen.dart';
import 'package:content2cart/screens/home_screen.dart';
import 'package:content2cart/services/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthWrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: AuthService().authStateChanges,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return LoadingScreen();
        }

        if (snapshot.hasData) {
          return DashboardScreen();
        }

        return HomePage();
      },
    );
  }
}

class LoadingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: CircularProgressIndicator(), // You can customize this as needed
      ),
    );
  }
}
