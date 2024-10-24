class Usuario {
  
  late String nome;
  late String email;
  late String senha;

  Map<String, dynamic> toMap () {

    return {
      
      "nome": nome,
      "email": email
    };
  }
}
