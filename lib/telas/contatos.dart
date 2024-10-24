import 'package:flutter/material.dart';
import 'package:whats_app_flutter/model/conversa.dart';

class Contatos extends StatefulWidget {
  
  const Contatos({super.key});

  @override
  State<Contatos> createState() => _Contatos();
}

class _Contatos extends State<Contatos> {

  final List<Conversa> listaConversa = [
    const Conversa(
      nome: "Rivair", 
      mensagem: "Olá mundo 1", 
      caminhoFoto: "perfil2.jpg"
    ),
    const Conversa(
      nome: "Edineide", 
      mensagem: "Olá mundo 2", 
      caminhoFoto: "perfil1.jpg"
    ),
    const Conversa(
      nome: "Rafael", 
      mensagem: "Olá mundo 3", 
      caminhoFoto: "perfil3.jpg"
    ),
    const Conversa(
      nome: "Nathan", 
      mensagem: "Olá mundo 4", 
      caminhoFoto: "perfil4.jpg"
    ),
    const Conversa(
      nome: "Renato", 
      mensagem: "Olá mundo 5", 
      caminhoFoto: "perfil5.jpg"
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(     
      body: ListView.builder(
        itemCount: listaConversa.length,
        itemBuilder: ((context, index) {
          final Conversa conversa = listaConversa[index];

          return ListTile(
            contentPadding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
            leading: CircleAvatar(
              maxRadius: 30,
              backgroundColor: Colors.grey,
              backgroundImage: AssetImage("assets/imagens/${conversa.caminhoFoto}"),
            ),
            title: Text(
              conversa.nome,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16
              ),
            ),
          );
        })
      )
    );
  }
}
