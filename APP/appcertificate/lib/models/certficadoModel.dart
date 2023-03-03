class CertificadoModel {
  String uid;
  String nomeCliente;
  String data;
  String codigoJoia;
  String descricao;
  String vendedor;

  CertificadoModel(
      {required this.uid,
      required this.nomeCliente,
      required this.data,
      required this.codigoJoia,
      required this.descricao,
      required this.vendedor});
}

class ListaDeCertificados {
  late List<CertificadoModel> list;
}
