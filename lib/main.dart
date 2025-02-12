import 'package:content2cart/firebase_options.dart';
import 'package:content2cart/screens/dashboard_screen.dart';
import 'package:content2cart/screens/home_screen.dart';
import 'package:content2cart/services/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  await dotenv.load(fileName: ".env");
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Initialize auth persistence
  final authService = AuthService();
  await authService.initializeAuth();

  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      title: 'Content2Cart',
      theme: ThemeData(
        primaryColor: Colors.yellow,
        scaffoldBackgroundColor: Colors.white,
        fontFamily: 'Poppins',
        textTheme: const TextTheme(
          displayLarge: TextStyle(
            fontSize: 56,
            fontWeight: FontWeight.w900,
            color: Colors.black,
          ),
          headlineMedium: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.w800,
            color: Colors.black,
          ),
          titleLarge: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
          bodyLarge: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w400,
            color: Colors.black87,
          ),
        ),
      ),
      home: AuthStateWrapper(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class AuthStateWrapper extends StatelessWidget {
  final AuthService _authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: _authService.authStateChanges,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasData) {
          return DashboardScreen(); // Your authenticated screen
        }

        return HomePage(); // Your non-authenticated screen
      },
    );
  }
}
