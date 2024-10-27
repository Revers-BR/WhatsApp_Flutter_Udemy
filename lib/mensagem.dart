import 'package:flutter/material.dart';
import 'package:whats_app_flutter/model/usuario.dart';

class Mensagem extends StatefulWidget {

  final Usuario contato;

  const Mensagem(this.contato, {super.key});

  @override
  State<Mensagem> createState() => _Mensagem();
}

class _Mensagem extends State<Mensagem> {

  final TextEditingController _mensagemController = TextEditingController();

  void _enviarMensagem(){

  }

  void _enviarFoto(){
    
  }

  @override
  Widget build (BuildContext context ){

    final Widget caixaMensagem = Container(
      padding: EdgeInsets.all(8),
      child: Row(
        children: [
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(right: 8),
              child: TextField(
                controller: _mensagemController,
                autofocus: true,
                keyboardType: TextInputType.text,
                style: TextStyle(fontSize: 20),
                decoration: InputDecoration(
                  prefix: IconButton(
                    onPressed: _enviarFoto,
                    icon: Icon(Icons.camera_alt)
                  ),
                  contentPadding: EdgeInsets.fromLTRB(4, 2, 32, 8),
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
            child: Icon(Icons.send),
            mini: true,
            onPressed: _enviarMensagem,
          )
        ],
      ),
    );
  
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.contato.nome),
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/imagens/bg.png"),
            fit: BoxFit.cover
          )
        ),
        child: SafeArea(
          child: Container(
            padding: EdgeInsets.all(8),
            child: Column(
              children: [
                Text('ListView'),
                caixaMensagem,
              ],
            ),
          )
        ),
      ),
    );
  }
}