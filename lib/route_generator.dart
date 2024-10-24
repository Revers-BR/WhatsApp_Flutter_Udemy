import 'package:flutter/material.dart';
import 'package:whats_app_flutter/cadastro.dart';
import 'package:whats_app_flutter/home.dart';
import 'package:whats_app_flutter/login.dart';

class RouteGenerator {

  static Route<dynamic> generateRoute(RouteSettings settings){

    dynamic instancia = const Login();

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