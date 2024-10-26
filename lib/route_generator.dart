import 'package:flutter/material.dart';
import 'package:whats_app_flutter/cadastro.dart';
import 'package:whats_app_flutter/configuracoes.dart';
import 'package:whats_app_flutter/home.dart';
import 'package:whats_app_flutter/login.dart';
import 'package:whats_app_flutter/mensagem.dart';
import 'package:whats_app_flutter/model/usuario.dart';

class RouteGenerator {

  static Route<dynamic> generateRoute(RouteSettings settings){

    Widget instancia = const Login();

    final Usuario? contato = settings.arguments != null
      ? settings.arguments as Usuario : null;

    switch (settings.name) {
      case "/":
      case "/login":   
        break;
      case "/cadastro":
        instancia = const Cadastro();   
        break;
      case "/home":
        instancia = const Home();   
        break;
      case "/configuracoes":
        instancia = const Configuracoes();
        break;
      case "/mensagem":
        instancia = Mensagem(contato!);
      default:
        return _erroRota();
    }

    return MaterialPageRoute(
      builder: (_) => instancia
    );
  }

  static Route<dynamic> _erroRota(){
    return MaterialPageRoute(
      builder: (_){
        return Scaffold(
          appBar: AppBar(title: const Text("Tela não encontrada!")),
          body: const Center(
            child: Text("Tela não encontrado!"),
          ),
        );
      } 
    );
  }
}