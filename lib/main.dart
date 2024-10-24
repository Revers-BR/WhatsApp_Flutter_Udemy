import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:whats_app_flutter/firebase_options.dart';
import 'package:whats_app_flutter/login.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: firebaseOptions
  );
  runApp(MaterialApp(
    home: const Login(),
    theme: ThemeData(
      primaryColor: const Color(0xff075E54)
    ),
  ));
}

