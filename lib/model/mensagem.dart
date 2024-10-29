class ModelMensagem {
  late String idUsuario;
  String? mensagem;
  String? urlImagem;
  late String tipo;

  Map<String, dynamic> toMap(){
    return {
      "idUsuario": idUsuario,
      "mensagem": mensagem,
      "urlImagem": urlImagem,
      "tipo": tipo
    };
  }
}