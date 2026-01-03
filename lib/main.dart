import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:live_score/sign_in_screen.dart';
import 'package:live_score/sign_up_screen.dart';
import 'firebase_options.dart';
import 'home_screen.dart';
import 'services/fcm_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await NotificationService().initNotification();
  runApp( MyApp());
}

class MyApp extends StatelessWidget {
   MyApp({super.key});

  FirebaseAuth auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: StreamBuilder<User?>(
        stream: auth.authStateChanges(),
        builder: (_, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return const Scaffold(
              body: Center(child: Text('Something went wrong!')),
            );
          }

          if (snapshot.hasData) {
            return const HomeScreen();
          }

          return const SignInScreen();


        },
      ),
    );
  }
}
