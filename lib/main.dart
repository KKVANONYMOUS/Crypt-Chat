import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:crypt_chat/views/welcome_view.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    title: 'CryptChat',
    theme: ThemeData(
      primaryColor: Color(0xFF6F35A5),
      scaffoldBackgroundColor: Colors.white,
    ),
    home:WelcomeScreen(),
  ));
}

