import 'package:appcertificate/models/certficadoModel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class FirebaseStorage extends ChangeNotifier {
  List<CertificadoModel> _certsList = [];

  List<CertificadoModel> get userList => _certsList;

  set userList(List<CertificadoModel> value) {
    _certsList = value;
    notifyListeners();
  }

  Stream<List<CertificadoModel>> getCertsStream() {
    return FirebaseFirestore.instance
        .collection('certificados')
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => CertificadoModel(
                  uid: doc['uid'],
                  nomeCliente: doc['nomeCliente'],
                  cpf: doc['cpf'],
                  data: doc['data'],
                  descricao: doc['descricao'],
                  vendedor: doc['vendedor'],
                  banho: doc['banho'],
                  codigoJoia: doc['codigoJoia'],
                ))
            .toList());
  }

  void addCert(CertificadoModel certModel) {
    try {
      FirebaseFirestore.instance
          .collection('certificados')
          .doc() // generate a unique ID for the document
          .set({
        'uid': certModel.uid,
        'nomeCliente': certModel.nomeCliente,
        'cpf': certModel.cpf,
        'data': certModel.data,
        'descricao': certModel.descricao,
        'vendedor': "Amanda",
        'banho': certModel.banho,
        'codigoJoia': certModel.codigoJoia,
      });
      notifyListeners();
    } on Exception catch (e) {
      // TODO
    }
  }

  void removeCert(CertificadoModel certModel) {
    try {
      FirebaseFirestore.instance
          .collection('certificados')
          .doc(certModel.uid)
          .delete();
      notifyListeners();
    } on Exception catch (e) {
      // TODO
    }
  }
}
