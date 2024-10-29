class Usuario {
  
  late String idUsuario;
  late String nome;
  late String email;
  late String senha;
  String? urlImagem;

  Map<String, dynamic> toMap () {

    return {
      
      "nome": nome,
      "email": email
    };
  }
}
