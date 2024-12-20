import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:whats_app_flutter/firebase_options.dart';
import 'package:whats_app_flutter/route_generator.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: firebaseOptions
  );
  runApp(MaterialApp(
    theme: ThemeData(
      primaryColor: const Color(0xff075E54),
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xff075E54),
        foregroundColor: Colors.white,
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: Color(0xff075E54),
        foregroundColor: Colors.white,
      )
    ),
    initialRoute: "/",
    onGenerateRoute: RouteGenerator.generateRoute,
  ));
}

