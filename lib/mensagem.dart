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

      _mensagemController.clear();
    }
  }

   _recuperaDadosUsario() {
    FirebaseAuth auth = FirebaseAuth.instance;

    final User? usuarioLogado =  auth.currentUser;
    if(usuarioLogado != null) _idUsuarioLogado = usuarioLogado.uid;
    _idUsuarioDestinatario = widget.contato.idUsuario;
  }

  _salvarMensagem(String idRemetente, String idDestinatario, ModelMensagem msg){
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    firestore.collection("mensagens")
      .doc(idRemetente)
      .collection(idDestinatario)
      .add(msg.toMap());
  }

  void _enviarFoto(){
    
  }

  final List<String> mensagens = [
    "Integer sollicitudin neque sit amet ipsum dignissim, at posuere ipsum laoreet.",
    "Vivamus scelerisque sem in venenatis consectetur.",
    "Phasellus tempus purus eu interdum auctor.",
    "In eget quam at nunc commodo congue nec quis ante.",
    "Praesent malesuada velit vel turpis viverra facilisis.,"

    "Phasellus varius est sed leo viverra ultrices.",
    "Sed eget nisi pulvinar magna blandit feugiat id in purus.",
    "Aliquam ullamcorper neque quis sapien tincidunt, a commodo eros dapibus.",
    "Integer a sapien imperdiet justo pellentesque semper.",
    "Donec placerat lorem sit amet mauris sagittis, in blandit urna congue.",
  ];

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
            child: const Icon(Icons.send),
            mini: true,
            onPressed: _enviarMensagem,
          )
        ],
      ),
    );
  
    final Widget listView = Expanded(
      child: ListView.builder(
        itemCount: mensagens.length,
        itemBuilder: (context, index) {

          Alignment alignment = Alignment.centerRight;
          Color color = const Color(0xffd2ffa5);

          if(index % 2 == 0){
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
                  mensagens[index],
                  style: const TextStyle(fontSize: 18),
                ),
              ),
            ) 
            ,
          );
        },
      )
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
              padding: EdgeInsets.only(left: 16),
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
                listView,
                caixaMensagem,
              ],
            ),
          )
        ),
      ),
    );
  }
}