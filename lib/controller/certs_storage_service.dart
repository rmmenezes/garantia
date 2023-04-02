import 'package:appcertificate/models/certficadoModel.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

class CertsStorageService extends ChangeNotifier {
  late List<CertificadoModel> certList;
  User? currentUser;

  CertsStorageService(currentUser,) {
    certList = [];
  }

  fillCertsList(currentUser) {
    certList = [
      CertificadoModel(
          uid: "1",
          nomeCliente: "Rafael",
          cpf: "CPF",
          data: "22/22/22",
          codigoJoia: "0963",
          descricao: "a joia é joia rara",
          vendedor: "Aline",
          banho: "ouro"),
      CertificadoModel(
          uid: "1",
          nomeCliente: "Rafael",
          cpf: "CPF",
          data: "22/22/22",
          codigoJoia: "0963",
          descricao: "a joia é joia rara",
          vendedor: "Aline",
          banho: "ouro"),
      CertificadoModel(
          uid: "1",
          nomeCliente: "Rafael",
          cpf: "CPF",
          data: "22/22/22",
          codigoJoia: "0963",
          descricao: "a joia é joia rara",
          vendedor: "Aline",
          banho: "ouro"),
      CertificadoModel(
          uid: "1",
          nomeCliente: "Rafael",
          cpf: "CPF",
          data: "22/22/22",
          codigoJoia: "0963",
          descricao: "a joia é joia rara",
          vendedor: "Aline",
          banho: "ouro"),
      CertificadoModel(
          uid: "1",
          nomeCliente: "Rafael",
          cpf: "CPF",
          data: "22/22/22",
          codigoJoia: "0963",
          descricao: "a joia é joia rara",
          vendedor: "Aline",
          banho: "ouro"),
      CertificadoModel(
          uid: "1",
          nomeCliente: "Rafael",
          cpf: "CPF",
          data: "22/22/22",
          codigoJoia: "0963",
          descricao: "a joia é joia rara",
          vendedor: "Aline",
          banho: "ouro"),
      CertificadoModel(
          uid: "1",
          nomeCliente: "Rafael",
          cpf: "CPF",
          data: "22/22/22",
          codigoJoia: "0963",
          descricao: "a joia é joia rara",
          vendedor: "Aline",
          banho: "ouro"),
      CertificadoModel(
          uid: "1",
          nomeCliente: "Rafael",
          cpf: "CPF",
          data: "22/22/22",
          codigoJoia: "0963",
          descricao: "a joia é joia rara",
          vendedor: "Aline",
          banho: "ouro")
    ];
    notifyListeners();
  }

  registerCert(CertificadoModel newCert) {
    certList.add(newCert);
    notifyListeners();
  }

  getCertList() {
    certList = certList;
  }
}
