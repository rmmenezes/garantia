class CertificadoModel {
  String uid;
  String nomeCliente;
  String cpf;
  String data;
  String codigoJoia;
  String descricao;
  String vendedor;
  String banho;

  CertificadoModel(
      {required this.uid,
      required this.nomeCliente,
      required this.cpf,
      required this.data,
      required this.codigoJoia,
      required this.descricao,
      required this.vendedor,
      required this.banho});
}