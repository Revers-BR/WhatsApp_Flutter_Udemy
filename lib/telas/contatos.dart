import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:whats_app_flutter/model/conversa.dart';
import 'package:whats_app_flutter/model/usuario.dart';

class Contatos extends StatefulWidget {
  
  const Contatos({super.key});

  @override
  State<Contatos> createState() => _Contatos();
}

class _Contatos extends State<Contatos> {

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String? _emailUsuarioLogado;
  // ignore: unused_field
  String? _idUsuarioLogado;

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

  void _recuperaDadosUsario() {

    final User? usuarioLogado = _auth.currentUser;

    if(usuarioLogado != null){
      _emailUsuarioLogado = usuarioLogado.email;
      _idUsuarioLogado = usuarioLogado.uid;
    }
  }

  Future<List<Usuario>> _recuperaContatosFirebase() async {

    final QuerySnapshot<Map<String, dynamic>> querySnapShot = await _firestore
      .collection("usuarios")
      .get();

    final List<Usuario> usuarios = querySnapShot.docs.where((element){
      return element.data()["email"] != _emailUsuarioLogado;
    }).map(( doc){
      final Map<String, dynamic> data = doc.data();
      
      final Usuario usuario = Usuario();
    
      usuario.idUsuario = doc.id;
      usuario.nome = data["nome"];
      usuario.email = data["email"];
      usuario.urlImagem = data["urlImagem"];

      return usuario;
    }).toList();

    return usuarios;
  }

  @override
  void initState() {
    super.initState();
    _recuperaDadosUsario();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(     
      body: FutureBuilder<List<Usuario>>(
        future: _recuperaContatosFirebase(), 
        builder: (context, snapshot) {
          Widget widget = const Center(
            child: Text("Nenhum contato cadastrado!"),
          );

          switch (snapshot.connectionState) {
            case ConnectionState.active:
            case ConnectionState.waiting:
              widget = const Center(
                child: Column(
                  children: [
                    Text("Carregando contatos!"),
                    CircularProgressIndicator()
                  ],
                ),
              );
              break;
            case ConnectionState.done:
              final List<Usuario>? usuarios = snapshot.data;

              widget =   ListView.builder(
                itemCount: usuarios!.length,
                itemBuilder: ((context, index) {
                  final Usuario usuario = usuarios[index];

                  return ListTile(
                    onTap: () => Navigator.pushNamed(
                      context, 
                      "/mensagem",
                      arguments: usuario
                    ),
                    contentPadding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                    leading: CircleAvatar(
                      maxRadius: 30,
                      backgroundColor: Colors.grey,
                      backgroundImage: usuario.urlImagem != null?
                        NetworkImage(usuario.urlImagem!):
                        null,
                    ),
                    title: Text(
                      usuario.nome,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16
                      ),
                    ),
                  );
                })
              );        
              break;
            default:
          }

          return widget;
        }
      )
    );
  }
}
