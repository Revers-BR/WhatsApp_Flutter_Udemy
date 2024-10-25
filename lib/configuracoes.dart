import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class Configuracoes extends StatefulWidget {

  const Configuracoes({super.key});

  @override
  State<Configuracoes> createState() => _Configuracoes();
}

class _Configuracoes extends State<Configuracoes> {

  void _recuperarImagem(bool camera) async {

    final ImageSource source  = camera ? ImageSource.camera : ImageSource.gallery;

    final XFile? xFile = await ImagePicker().pickImage(source: source);

    if(xFile != null){
      final File imagemSelecionado = File(xFile.path);

      debugPrint(imagemSelecionado.path);
    }
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
                const CircleAvatar(
                  radius: 100,
                  backgroundColor: Colors.grey,
                  backgroundImage: AssetImage("assets/imagens/perfil2.jpg"),
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
                    onPressed: (){}, 
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