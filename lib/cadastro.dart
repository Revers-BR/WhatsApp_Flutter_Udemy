import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:whats_app_flutter/model/usuario.dart';

class Cadastro extends StatefulWidget {
  
  const Cadastro({super.key});

  @override
  State<Cadastro> createState() => _Cadastro();
}

class _Cadastro extends State<Cadastro> {

  TextEditingController nomeController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController senhaController = TextEditingController();

  String _msgErro = "";

  void _validarCampos () {
    
    final String nome = nomeController.text;
    final String email = emailController.text;
    final String senha = senhaController.text;

    if(nome.isEmpty || email.isEmpty || senha.isEmpty ) {
      
      setState(() => _msgErro = "Todos os campos são obrigatório!");
    }else {
      
      setState(() => _msgErro = "");

      Usuario usuario = Usuario();
      usuario.nome = nome;
      usuario.email = email;
      usuario.senha = senha;

      _cadastrarUsuario(usuario);
    }
  }

  void _cadastrarUsuario ( Usuario usuario) {

    FirebaseAuth firebaseAuth = FirebaseAuth.instance;

    firebaseAuth.createUserWithEmailAndPassword(
      email: usuario.email, 
      password: usuario.senha
    ).then((value) {

      FirebaseFirestore store = FirebaseFirestore.instance;

      store.collection("usuarios")
        .doc(value.user!.uid)
        .set(usuario.toMap());

      Navigator.pushNamedAndRemoveUntil(context, '/home',(_) => false);
    }).catchError((erro){
      
      _msgErro = "$erro";
    });
  }

  @override
  Widget build ( BuildContext context) {
    
    return Scaffold(
      
      appBar: AppBar(
        
        title: const Text("Cadastro"),
        foregroundColor: Colors.white,
        backgroundColor: const Color(0xff075E54),
      ),
      body: Container(
        decoration: const BoxDecoration(
          color: Color(0xff075E54),
        ),
        padding: const EdgeInsets.all(16),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Image.asset(
                    "assets/imagens/usuario.png",
                    width: 200, height: 150
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child:  TextField(
                    controller: nomeController,
                    autofocus: true,
                    keyboardType: TextInputType.text,
                    style: const TextStyle(fontSize:16),
                    decoration: const InputDecoration(
                      contentPadding: EdgeInsets.fromLTRB(32, 16,32 ,16 ),
                      filled: true,
                      fillColor: Colors.white,
                      hintText:"Nome",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(32)),
                      )
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child:  TextField(
                    controller: emailController,
                    keyboardType: TextInputType.emailAddress,
                    style: const TextStyle(fontSize:16),
                    decoration: const InputDecoration(
                      contentPadding: EdgeInsets.fromLTRB(32, 16,32 ,16 ),
                      filled: true,
                      fillColor: Colors.white,
                      hintText:"E-mail",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(32)),
                      )
                    ),
                  ),
                ),
                TextField(
                  controller:  senhaController,
                  obscureText: true,
                  keyboardType: TextInputType.text,
                  style: const TextStyle(fontSize:16),
                  decoration: const InputDecoration(
                    contentPadding: EdgeInsets.fromLTRB(32, 16,32 ,16 ),
                    filled: true,
                    fillColor: Colors.white,
                    hintText:"Senha",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(32)),
                    )
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only( top: 16, bottom: 10),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                     foregroundColor: Colors.white,
                     backgroundColor: Colors.green,
                     shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                      side:const BorderSide( color: Colors.green)
                     )
                    ),
                    child: const Text("Cadastrar"),
                    onPressed:() => _validarCampos() ,             
                  ),
                ),
                Center(
                  child: Text(
                    _msgErro,
                    style: const TextStyle(
                      color: Colors.red
                    ),
                  ),
                )
              ],
            ),
          )
        )
      ),
    );
  }
}
