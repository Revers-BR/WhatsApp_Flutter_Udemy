import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:whats_app_flutter/model/mensagem.dart';
import 'package:whats_app_flutter/model/usuario.dart';

class Mensagem extends StatefulWidget {

  final Usuario contato;

  const Mensagem(this.contato, {super.key});

  @override
  State<Mensagem> createState() => _Mensagem();
}

class _Mensagem extends State<Mensagem> {

  late String _idUsuarioLogado;
  late String _idUsuarioDestinatario;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final TextEditingController _mensagemController = TextEditingController();

  void _enviarMensagem(){
    final textoMensagem = _mensagemController.text;

    if(textoMensagem.isNotEmpty){

      ModelMensagem mensagem = ModelMensagem();

      mensagem.idUsuario = _idUsuarioLogado;
      mensagem.mensagem = textoMensagem;
      mensagem.tipo = "texto";
      mensagem.urlImagem = "";

      _salvarMensagem(_idUsuarioLogado, _idUsuarioDestinatario, mensagem);

      _salvarMensagem(_idUsuarioDestinatario, _idUsuarioLogado, mensagem);

      _mensagemController.clear();
    }
  }

   _recuperaDadosUsario() {
    
    final User? usuarioLogado =  _auth.currentUser;
    if(usuarioLogado != null) _idUsuarioLogado = usuarioLogado.uid;
    _idUsuarioDestinatario = widget.contato.idUsuario;
  }

  _salvarMensagem(String idRemetente, String idDestinatario, ModelMensagem msg){
    
    _firestore.collection("mensagens")
      .doc(idRemetente)
      .collection(idDestinatario)
      .add(msg.toMap());
  }

  void _enviarFoto(){
    
  }

  @override
  void initState() {
    super.initState();
    _recuperaDadosUsario();
  }
  @override
  Widget build (BuildContext context ){

    final Widget caixaMensagem = Container(
      padding: const EdgeInsets.all(8),
      child: Row(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(right: 8),
              child: TextField(
                controller: _mensagemController,
                autofocus: true,
                keyboardType: TextInputType.text,
                style: const TextStyle(fontSize: 20),
                decoration: InputDecoration(
                  prefix: IconButton(
                    onPressed: _enviarFoto,
                    icon: const Icon(Icons.camera_alt)
                  ),
                  contentPadding: const EdgeInsets.fromLTRB(4, 2, 32, 8),
                  hintText: "Digite um mensagem......",
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(32)
                  )
                ),
              ),
            )
          ),
          FloatingActionButton(
            mini: true,
            onPressed: _enviarMensagem,
            child: const Icon(Icons.send),
          )
        ],
      ),
    );
  
    final StreamBuilder streamBuilder = StreamBuilder(
      stream: _firestore.collection("mensagens")
                .doc(_idUsuarioLogado)
                .collection(_idUsuarioDestinatario)
                .snapshots(), 
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
          case ConnectionState.waiting:
            return const Center(
              child: Column(
                children: [
                  Text("Carregando mensagens"),
                  CircularProgressIndicator()
                ],
              ),
            );
          case ConnectionState.active:
          case ConnectionState.done:

            final QuerySnapshot querySnapshot = snapshot.data;

            if(snapshot.hasError) return const Expanded(child: Text("Erro ao carregar dados!"));

            return Expanded(
              child: ListView.builder(
                itemCount: querySnapshot.docs.length,
                itemBuilder: (context, index) {

                  List<DocumentSnapshot> mensagens = querySnapshot.docs.toList();

                  DocumentSnapshot item = mensagens[index];

                  Alignment alignment = Alignment.centerRight;
                  Color color = const Color(0xffd2ffa5);

                  if(_idUsuarioLogado != item["idUsuario"]){
                    alignment = Alignment.centerLeft;
                    color = Colors.white;
                  }

                  double larguraContainer = MediaQuery.of(context).size.width * 0.8;

                  return Align(
                    alignment: alignment,
                    child: Padding(
                      padding: const EdgeInsetsDirectional.all(16),
                      child: Container(
                        width: larguraContainer,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: color,
                          borderRadius: BorderRadius.circular(8)
                        ),
                        child: Text(
                          item["mensagem"],
                          style: const TextStyle(fontSize: 18),
                        ),
                      ),
                    ) 
                    ,
                  );
                },
              )
            );
        }
      },
    );

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            CircleAvatar(
              maxRadius: 20,
              backgroundColor: Colors.grey,
              backgroundImage: widget.contato.urlImagem != null ?
                  NetworkImage(widget.contato.urlImagem!) : null
            ),
            Padding(
              padding: const EdgeInsets.only(left: 16),
              child: Text(widget.contato.nome),
            )
          ],
        )
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/imagens/bg.png"),
            fit: BoxFit.cover
          )
        ),
        child: SafeArea(
          child: Container(
            padding: const EdgeInsets.all(8),
            child: Column(
              children: [
                streamBuilder,
                caixaMensagem,
              ],
            ),
          )
        ),
      ),
    );
  }
}