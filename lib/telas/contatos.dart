import 'package:flutter/material.dart';

class Contatos extends StatefulWidget {
  
  const Contatos({super.key});

  @override
  State<Contatos> createState() => _Contatos();
}

class _Contatos extends State<Contatos> {

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text("Contatos"),
      ),
    );
  }
}
