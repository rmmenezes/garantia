import 'package:appcertificate/controller/auth_service.dart';
import 'package:appcertificate/models/certficadoModel.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';

class CertsService extends ChangeNotifier {
  late List<CertificadoModel> certList;
  User? currentUser;

  CertsService(context) {
    certList = [];
    fillCertsList();
  }

  fillCertsList() {
    certList = [
      CertificadoModel(
          uid: "1",
          nomeCliente: "Regiane Albano",
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
