import 'package:cloud_firestore/cloud_firestore.dart';

class Conversa {
  String? idRemetente;
  String? idDestinatario;
  late String nome;
  late String mensagem;
  late String caminhoFoto;
  String? tipo;

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