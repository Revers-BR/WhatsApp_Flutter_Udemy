import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:whats_app_flutter/telas/contatos.dart';
import 'package:whats_app_flutter/telas/conversa.dart';

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

  final List<String> itensMenu = [
    "Configurações","Deslogar"
  ];

  final childrenTabView = [
    const Conversas(),
    const Contatos(),
  ];

  _escolhaMenuItem(String valorSelecionado){
    
    switch (valorSelecionado) {
      case "Configurações":
        Navigator.pushNamed(context, "/configuracoes");
        break;
      case "Deslogar":
        _deslogarUsuario();
        break;
    }
  }

  _deslogarUsuario() async {
    final FirebaseAuth auth = FirebaseAuth.instance;

    await auth.signOut();

    if(mounted){
      Navigator.pushReplacementNamed(context, '/login');
    }
  }

  _verificarUsuarioLogado(){
    final FirebaseAuth auth = FirebaseAuth.instance;

    final usuarioLogado = auth.currentUser;

    if(usuarioLogado == null) Navigator.pushReplacementNamed(context, '/login');
  }

  @override
  void initState() {
    super.initState();
    _verificarUsuarioLogado();
  }
  
  @override
  Widget build ( BuildContext context ) {
    
    return DefaultTabController(
      length: tabs.length, 
      child: Scaffold(
        appBar: AppBar(
          title: const Text("WhatsApp"),
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
          actions: [
            PopupMenuButton<String>(
              onSelected: _escolhaMenuItem,
              itemBuilder: (context){
                return itensMenu.map((String item){
                  return PopupMenuItem<String>(
                    value: item,
                    child: Text(item)
                  );
                }).toList();
              }
            )
          ],
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
