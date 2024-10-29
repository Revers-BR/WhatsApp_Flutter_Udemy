import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class Configuracoes extends StatefulWidget {

  const Configuracoes({super.key});

  @override
  State<Configuracoes> createState() => _Configuracoes();
}

class _Configuracoes extends State<Configuracoes> {

  File? _imagem;
  String? _idUsuarioLogado;
  bool _subindoImagem = false;
  String? _urlImagemRecuperada;
  final TextEditingController _nomeController = TextEditingController();
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  void _recuperarImagem(bool camera) async {

    final ImageSource source  = camera ? ImageSource.camera : ImageSource.gallery;

    final XFile? xFile = await ImagePicker().pickImage(source: source);

    if(xFile != null){
      setState(() {
        _subindoImagem = true;
        _imagem = File(xFile.path);
        _uploadImagem();
      });
    }
  }

  _uploadImagem(){

    FirebaseStorage firebaseStorage = FirebaseStorage.instance;
    Reference refRaiz = firebaseStorage.ref();
    Reference arquivo = refRaiz
      .child("perfil")
      .child("$_idUsuarioLogado.jpg");

    UploadTask task = arquivo.putFile(_imagem!);

    task.snapshotEvents.listen((TaskSnapshot snapshot) {

      switch (snapshot.state) {
        case TaskState.running:
          _subindoImagem = true;
          break;
        case TaskState.success:
          _subindoImagem = false;
          _recuperarImagemURL(snapshot);
          break;
        default:
          break;
      }
    });
  }

  _recuperarImagemURL(TaskSnapshot snapshot) async {
    String url = await snapshot.ref.getDownloadURL();

    _atualizarUrlImagemFireStore(url);

    setState(() {
      _urlImagemRecuperada = url;
    });
  }

  _atualizarUrlImagemFireStore(String url){

    final Map<String, dynamic> dadosAtualizar = {
      "urlImagem": url
    };

    _firebaseFirestore.collection("usuarios")
      .doc(_idUsuarioLogado)
      .update(dadosAtualizar);
  }

  void _atualizarNomeFireStore(){

    final String nome = _nomeController.text;

    final Map<String, String> data = {
      "nome": nome
    };

    _firebaseFirestore.collection("usuarios")
     .doc(_idUsuarioLogado)
     .update(data);
  }
  
  _recuperaDadosUsario() async {
    FirebaseAuth auth = FirebaseAuth.instance;

    final User? usuarioLogado =  auth.currentUser;
    if(usuarioLogado != null) _idUsuarioLogado = usuarioLogado.uid;

    final DocumentSnapshot documentSnapshot = await _firebaseFirestore.collection("usuarios")
      .doc(_idUsuarioLogado)
      .get();

    final Map<String, dynamic> dados = (documentSnapshot.data() as Map<String, dynamic>);

    _nomeController.text = dados['nome'];

    if(dados["urlImagem"] != null) setState(() => _urlImagemRecuperada = dados['urlImagem']);
  }

  @override
  void initState() {
    super.initState();
    _recuperaDadosUsario();
  }

  @override
  Widget build (BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Configurações"),
        backgroundColor: const Color(0xff075E54),
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                _subindoImagem ?
                  const CircularProgressIndicator() :
                  CircleAvatar(
                    radius: 100,
                    backgroundColor: Colors.grey,
                    backgroundImage: _urlImagemRecuperada != null ?
                        NetworkImage(_urlImagemRecuperada!) : null
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextButton(
                      onPressed: () => _recuperarImagem(true), 
                      child: const Text("Camera")
                    ),
                    TextButton(
                      onPressed: () => _recuperarImagem(false), 
                      child: const Text("Galeria")
                    ),
                  ],
                ),
                TextField(
                  controller: _nomeController,
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.fromLTRB(32, 16, 32, 16),
                    hintText: "Nome",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(32)
                    )
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 16),
                  child: ElevatedButton(
                    style: const ButtonStyle(
                      backgroundColor: MaterialStatePropertyAll(Colors.green),
                      foregroundColor: MaterialStatePropertyAll(Colors.white)
                    ),
                    onPressed: _atualizarNomeFireStore, 
                    child: const Text("Salvar")
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
 }