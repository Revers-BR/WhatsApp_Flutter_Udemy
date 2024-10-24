import 'package:flutter/material.dart';

class Conversas extends StatefulWidget {
  
  const Conversas({super.key});

  @override
  State<Conversas> createState() => _Conversas();
}

class _Conversas extends State<Conversas> {

  @override
  Widget build(BuildContext context) { 
    return const Scaffold(     
      body: Center(
        child: Text("Conversas"),
      ),
    );
  }
}
