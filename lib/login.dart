import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:whats_app_flutter/cadastro.dart';
import 'package:whats_app_flutter/home.dart';

class Login extends StatefulWidget {

  const Login({super.key});

  @override
  State<Login> createState() => _Login();
}

class _Login extends State<Login> {

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _senhaController = TextEditingController();

  String _erroMsg = "";

  void _validarCampos() async {

    final email = _emailController.text;
    final senha = _senhaController.text;

    if(email.isEmpty || senha.isEmpty){
      _erroMsg = "Todos os campos são obrigatório!";
    }else {
      final FirebaseAuth auth = FirebaseAuth.instance;

      auth.signInWithEmailAndPassword(
        email: email, 
        password: senha
      ).then(( value) =>
        Navigator.pushReplacementNamed(context, '/home')
      ).catchError((erro){
       
         _erroMsg = "Falha ao tentar se autenticar!";
         debugPrint("Erro auth: $erro");

         return {};
      });    
    }
  }

  @override
  void didChangeDependencies() {
      super.didChangeDependencies();
      
      final FirebaseAuth auth = FirebaseAuth.instance;

      final usuarioLogado = auth.currentUser;

      if(usuarioLogado != null){
        debugPrint("Usuario logado");
        // Adiciona um callback para garantir que o contexto esteja completamente montado
        WidgetsBinding.instance.addPostFrameCallback((_) {
          Navigator.pushReplacementNamed(context, '/home');
        });
      }
    }
  
  @override
  Widget build ( BuildContext context ) {

    return Scaffold(
      
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
                    "assets/imagens/logo.png",
                    width: 200, height: 150
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child:  TextField(
                    controller:  _emailController,
                    autofocus: true,
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
                  controller:  _senhaController,
                  keyboardType: TextInputType.text,
                  obscureText: true,
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
                    child: const Text("Entrar"),
                    onPressed: () => _validarCampos(),
                  ),             
                ),
                Center(
                  child: GestureDetector(
                    onTap:() => Navigator.pushReplacementNamed(context, '/cadastro'),
                    child: const Text( 
                      "Não tem conta? Cadastra-se!",
                      style:  TextStyle( color: Colors.white ),
                    )
                  )
                ),
                Center(
                  child: Text(
                    _erroMsg,
                      style: const TextStyle(color: Colors.white),
                  ),
                )
              ],
            ),
          )
        )
      )
    );
  }
}
