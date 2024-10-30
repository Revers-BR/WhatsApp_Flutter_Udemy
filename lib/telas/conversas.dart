import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:whats_app_flutter/model/conversa.dart';
import 'package:whats_app_flutter/model/usuario.dart';

class Conversas extends StatefulWidget {
  
  const Conversas({super.key});

  @override
  State<Conversas> createState() => _Conversas();
}

class _Conversas extends State<Conversas> {

  late String _idUsuarioLogado;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final StreamController _streamController = StreamController<QuerySnapshot>.broadcast();

  _recuperaDadosUsario(){

    final FirebaseAuth auth = FirebaseAuth.instance;
    final User? user = auth.currentUser;

    if(user != null) _idUsuarioLogado = user.uid;

    _adicionarListenerConversa();
  }

  _adicionarListenerConversa(){
    final stream = _firestore.collection("conversas")
      .doc(_idUsuarioLogado)
      .collection("ultima_conversa")
      .snapshots();

    stream.listen((event) { 
      _streamController.add(event);
    });
  }

  @override
  void dispose() {
    super.dispose();
    _streamController.close();
  }

  @override
  void initState() {
    super.initState();
    _recuperaDadosUsario();
  }

  @override
  Widget build(BuildContext context) { 
    
    final StreamBuilder streamBuilder = StreamBuilder(
      stream: _streamController.stream, 
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
          case ConnectionState.waiting:
            return const Center(
              child: Column(
                children: [
                  Text("Carregando conversas"),
                  CircularProgressIndicator()
                ],
              ),
            );
          case ConnectionState.active:
          case ConnectionState.done:

            if(snapshot.hasError) return const Text("Erro ao carregar dados!");

            if(!snapshot.hasData){
              return const Text(
                "Você não tem nenhuma conversa ainda!",
                style: TextStyle(
                  fontSize: 18, fontWeight: FontWeight.bold
                ),
              );
            } 

            QuerySnapshot querySnapshot = snapshot.data;

            return ListView.builder(
              itemCount: querySnapshot.docs.length,
              itemBuilder: ((context, index) {

                List<Conversa> conversas = querySnapshot.docs.map((item){

                  Conversa conversa = Conversa();

                  conversa.nome = item["nome"];
                  conversa.mensagem = item["mensagem"];
                  conversa.caminhoFoto = item["caminhoFoto"];
                  conversa.idRemetente = item["idRemetente"];
                  conversa.idDestinatario = item["idDestinatario"];
                  conversa.tipo = item["tipo"];

                  return conversa;
                }).toList();

                final Conversa conversa = conversas[index];

                final Usuario usuario = Usuario();

                usuario.nome = conversa.nome;
                usuario.idUsuario = conversa.idDestinatario!;
                usuario.urlImagem = conversa.caminhoFoto;

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
                    backgroundImage: NetworkImage(conversa.caminhoFoto)
                  ),
                  title: Text(
                    conversa.nome,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16
                    ),
                  ),
                  subtitle: Text(
                    conversa.tipo == "texto"
                      ? conversa.mensagem
                      : "Imagem.....",
                    style: const TextStyle(
                      color: Colors.grey,
                      fontSize: 14
                    ),
                  ),
                );
              })
            );
        }
      },
    );
    
    return Scaffold(     
      body: streamBuilder
    );
  }
}
