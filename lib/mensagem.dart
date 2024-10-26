import 'package:flutter/material.dart';
import 'package:whats_app_flutter/model/usuario.dart';

class Mensagem extends StatefulWidget {

  final Usuario contato;

  const Mensagem(this.contato, {super.key});

  @override
  State<Mensagem> createState() => _Mensagem();
}

class _Mensagem extends State<Mensagem> {

  @override
  Widget build (BuildContext context ){
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.contato.nome),
      ),
    );
  }
}