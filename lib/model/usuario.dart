class Usuario {
  
  late String _nome;
  late String _email;
  late String _senha;

  set nome (String value ) => _nome = value;
  set email (String value ) => _email = value;
  set senha (String value ) => _senha = value;

  String get nome => _nome;
  String get email => _email;
  String get senha => _senha;

  Map<String, dynamic> toMap () {

    return {
      
      "nome": nome,
      "email": email
    };
  }
}
