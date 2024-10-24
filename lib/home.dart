import 'package:flutter/material.dart';
import 'package:whats_app_flutter/telas/contatos.dart';
import 'package:whats_app_flutter/telas/conversas.dart';

class Home extends StatefulWidget {
  
  const Home({super.key});

  @override
    State<Home> createState() => _Home();
}

class _Home extends State<Home> {

  final tabs = <Tab>[
    const Tab(
      child: Text("Conversas"),
    ),
    const Tab(
      child: Text("Contatos"),
    )
  ];

  final childrenTabView = [
    const Conversas(),
    const Contatos(),
  ];

  @override
  Widget build ( BuildContext context ) {
    
    return DefaultTabController(
      length: tabs.length, 
      child: Scaffold(
        appBar: AppBar(
          title: const Text("WhatsApp"),
          backgroundColor: const Color(0xff075E54),
          foregroundColor: Colors.white,
          bottom: TabBar(
            labelColor: Colors.white,
            labelStyle: const TextStyle(
              fontSize:18,
              fontWeight: FontWeight.bold
            ),
            indicatorWeight: 4,
            indicatorColor: Colors.white,
            tabs: tabs
          ),
        ),
        body: Scaffold(
          body: TabBarView(
            children: childrenTabView
          ),
        ),
      )
    );
  }
}
