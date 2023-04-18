import 'dart:html';
import 'dart:html';
import 'package:appcertificate/models/certficadoModel.dart';
import 'package:appcertificate/util/utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image/image.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/services.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'dart:async';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_storage_web/firebase_storage_web.dart' as fb;

class Storage extends ChangeNotifier {
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
                  img: doc['img'],
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

  Future<CertificadoModel> getCertificado(String uid) async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('certificados')
          .doc(uid)
          .get();
      final certificado = CertificadoModel(
        img: snapshot['img'],
        uid: snapshot.id,
        nomeCliente: snapshot['nomeCliente'],
        cpf: snapshot['cpf'],
        data: snapshot['data'],
        codigoJoia: snapshot['codigoJoia'],
        descricao: snapshot['descricao'],
        vendedor: snapshot['vendedor'],
        banho: snapshot['banho'],
      );
      return certificado;
    } catch (e) {
      return CertificadoModel(
          img: '',
          uid: '',
          nomeCliente: '',
          cpf: '',
          data: '',
          codigoJoia: '',
          descricao: '',
          vendedor: '',
          banho: '');
    }
  }

  addCert(CertificadoModel certModel, Uint8List imageData) async {
    try {
      print("Armazenando a imagem");
      final storageRef =
          FirebaseStorage.instance.ref().child('images/${certModel.uid}.png');
      final uploadTask = storageRef.putData(convertToPng(imageData));
      final snapshot = await uploadTask.whenComplete(() {});
      final downloadUrl = await snapshot.ref.getDownloadURL();

      print("Iniciando Firestore");
      final certRef = FirebaseFirestore.instance
          .collection('certificados')
          .doc(certModel.uid);
      await certRef.set({
        'uid': certModel.uid,
        'nomeCliente': certModel.nomeCliente,
        'cpf': certModel.cpf,
        'data': certModel.data,
        'descricao': certModel.descricao,
        'vendedor': "Amanda",
        'banho': certModel.banho,
        'codigoJoia': certModel.codigoJoia,
        'img': downloadUrl,
      });

      print("Armazenando o PDF");
      final pdfBytes =
          await PdfService().generateAndStoragePDF(certModel, imageData);
      final pdfRef = FirebaseStorage.instance
          .ref()
          .child('certificados/${certModel.uid}.pdf');
      await pdfRef.putData(pdfBytes);

      notifyListeners();
    } catch (e) {
      print("Erro ao adicionar o certificado: $e");
      rethrow;
    }
  }
}

class PdfService {
  Future<Uint8List> getModelo() async {
    String filePath = 'assets/templates/certificado.pdf';
    Completer<Uint8List> completer = Completer<Uint8List>();
    HttpRequest request = HttpRequest();
    request.open('GET', filePath);
    request.responseType = 'arraybuffer';
    request.onLoad.listen((event) {
      Uint8List pdfBytes = Uint8List.view(request.response);
      completer.complete(pdfBytes);
    });
    request.send();
    return completer.future;
  }

  downloadPDF(String uid) async {
    Reference ref =
        FirebaseStorage.instance.ref().child('certificados/$uid.pdf');
    final url = await ref.getDownloadURL();
    final anchor = AnchorElement(href: url);
    anchor.download = 'certificado-$uid.pdf';
    anchor.click();
  }

  Future<Uint8List> generateAndStoragePDF(
      CertificadoModel certificado, Uint8List img) async {
    final inputBytes = await getModelo();
    final PdfDocument document = PdfDocument(inputBytes: inputBytes);
    final page = document.pages[0];

    page.graphics.drawImage(
      PdfBitmap(img),
      const Rect.fromLTWH(20.512, 127.00, 75.00, 73.836),
    );
    page.graphics.drawString(
      certificado.uid,
      PdfStandardFont(PdfFontFamily.helvetica, 10),
      bounds: const Rect.fromLTWH(118.797, 131.454, 157.105, 15),
    );
    page.graphics.drawString(
      certificado.banho,
      PdfStandardFont(PdfFontFamily.helvetica, 10),
      bounds: const Rect.fromLTWH(143.698, 157.988, 131.062, 15),
    );
    page.graphics.drawString(
      certificado.data,
      PdfStandardFont(PdfFontFamily.helvetica, 10),
      bounds: const Rect.fromLTWH(156.049, 184.072, 119.437, 15),
    );
    page.graphics.drawString(
      certificado.nomeCliente,
      PdfStandardFont(PdfFontFamily.helvetica, 10),
      bounds: const Rect.fromLTWH(46.709, 231.390, 229.028, 15),
    );
    page.graphics.drawString(
      certificado.cpf,
      PdfStandardFont(PdfFontFamily.helvetica, 10),
      bounds: const Rect.fromLTWH(46.709, 231.390, 229.028, 15),
    );
    page.graphics.drawString(
      certificado.descricao,
      PdfStandardFont(PdfFontFamily.helvetica, 10),
      bounds: const Rect.fromLTWH(23.340, 253.778, 251.981, 60.560),
      format: PdfStringFormat(alignment: PdfTextAlignment.justify),
    );

    final bytes = await document.save();
    document.dispose();

    return Uint8List.fromList(bytes);
  }
}
