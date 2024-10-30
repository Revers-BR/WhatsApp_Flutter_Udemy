import 'package:cloud_firestore/cloud_firestore.dart';

class Conversa {
  String? idRemetente;
  String? idDestinatario;
  final String nome;
  final String mensagem;
  final String caminhoFoto;
  String? tipo;

  Conversa(
    {
      required this.nome,
      required this.mensagem,
      required this.caminhoFoto
    }
  );

  salvarConversa() {

    FirebaseFirestore firestore = FirebaseFirestore.instance;

    firestore.collection("conversas")
      .doc(idRemetente)
      .collection("ultima_conversa")
      .doc(idDestinatario)
      .set( toMap() );
  }

  Map<String, dynamic> toMap(){

    return {
      "idRemetente": idRemetente,
      "idDestinatario": idDestinatario,
      "nome": nome,
      "mensagem": mensagem,
      "caminhoFoto": caminhoFoto,
      "tipo": tipo,
    };
  }
}