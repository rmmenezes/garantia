import 'dart:typed_data';

class CertificadoModel {
  String img;
  String uid;
  String nomeCliente;
  String cpf;
  String data;
  String descricao;
  String vendedor;
  String peca;

  CertificadoModel(
      {required this.img,
      required this.uid,
      required this.nomeCliente,
      required this.cpf,
      required this.data,
      required this.descricao,
      required this.vendedor,
      required this.peca});
}
