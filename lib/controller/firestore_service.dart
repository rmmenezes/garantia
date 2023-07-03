import 'dart:html';
import 'dart:ui';
import 'package:appcertificate/models/certficadoModel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/services.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:image/image.dart' as img;
import 'package:http/http.dart' as http;
import 'package:image/image.dart' as imgLib;

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
                  uid: doc['uid'],
                  nomeCliente: doc['nomeCliente'],
                  cpf: doc['cpf'],
                  data: doc['data'],
                  descricao: doc['descricao'],
                  vendedor: doc['vendedor'],
                  peca: doc['peca'],
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
        uid: snapshot.id,
        nomeCliente: snapshot['nomeCliente'],
        cpf: snapshot['cpf'],
        data: snapshot['data'],
        descricao: snapshot['descricao'],
        vendedor: snapshot['vendedor'],
        peca: snapshot['peca'],
      );
      return certificado;
    } catch (e) {
      return CertificadoModel(
          uid: '',
          nomeCliente: '',
          cpf: '',
          data: '',
          descricao: '',
          vendedor: '',
          peca: '');
    }
  }

  addCert(CertificadoModel certModel, Uint8List imageData) async {
    final pdfBytes =
        await PdfService().generateAndStoragePDF(certModel, imageData);
    final pdfRef = FirebaseStorage.instance
        .ref()
        .child('certificados/${certModel.uid}.pdf');
    await pdfRef.putData(pdfBytes);
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

  Uint8List transformToSquare(Uint8List img) {
    // Load the image using the image package
    imgLib.Image? image = imgLib.decodeImage(img);

    // Calculate the aspect ratio of the image
    double aspectRatio = image!.width.toDouble() / image.height.toDouble();

    // Determine the dimensions for the square image
    int size = image.width > image.height ? image.height : image.width;

    // Calculate the crop position
    int startX = (image.width - size) ~/ 2;
    int startY = (image.height - size) ~/ 2;

    // Crop the image to the square dimensions
    imgLib.Image croppedImage =
        imgLib.copyCrop(image, x: startX, y: startY, height: size, width: size);

    // Reduce the quality of the image to 50%
    Uint8List croppedImgBytes = imgLib.encodeJpg(croppedImage, quality: 50);

    return croppedImgBytes;
  }

  Future<PdfFont> loadOpenSansBoldFont() async {
    final fontData = await rootBundle.load("assets/OpenSans-Bold.ttf");
    return PdfTrueTypeFont(fontData.buffer.asUint8List(), 10);
  }

  Future<Uint8List> generateAndStoragePDF(
      CertificadoModel certificado, Uint8List img) async {
    final openSansBoldFont = await loadOpenSansBoldFont();
    print("GET");
    final inputBytes = await getModelo();
    print("GET");

    final PdfDocument document = PdfDocument(inputBytes: inputBytes);
    final page = document.pages[0];

    page.graphics.drawImage(
      PdfBitmap(transformToSquare(img)),
      const Rect.fromLTWH(22.226, 126.111, 75.133, 73.836),
    );
    page.graphics.drawString(
      certificado.uid,
      openSansBoldFont,
      brush: PdfSolidBrush(PdfColor(17, 82, 55)),
      bounds: const Rect.fromLTWH(120.978, 130.897, 215, 15),
    );
    page.graphics.drawString(
      certificado.peca,
      openSansBoldFont,
      brush: PdfSolidBrush(PdfColor(17, 82, 55)),
      bounds: const Rect.fromLTWH(134.224, 156.982, 144, 15),
    );
    page.graphics.drawString(
      certificado.data,
      openSansBoldFont,
      brush: PdfSolidBrush(PdfColor(17, 82, 55)),
      bounds: const Rect.fromLTWH(158.982, 182.908, 215, 15),
    );
    page.graphics.drawString(
      certificado.nomeCliente,
      openSansBoldFont,
      brush: PdfSolidBrush(PdfColor(17, 82, 55)),
      bounds: const Rect.fromLTWH(62.798, 207.497, 222, 15),
    );
    page.graphics.drawString(
      certificado.cpf,
      openSansBoldFont,
      brush: PdfSolidBrush(PdfColor(17, 82, 55)),
      bounds: const Rect.fromLTWH(49.672, 230.719, 215, 15),
    );
    page.graphics.drawString(
      certificado.vendedor,
      openSansBoldFont,
      brush: PdfSolidBrush(PdfColor(17, 82, 55)),
      bounds: const Rect.fromLTWH(107.293, 253.924, 170, 15),
    );
    page.graphics.drawString(
      certificado.descricao,
      openSansBoldFont,
      brush: PdfSolidBrush(PdfColor(17, 82, 55)),
      bounds: const Rect.fromLTWH(25.912, 276.328, 250, 60.560),
      format: PdfStringFormat(alignment: PdfTextAlignment.justify),
    );

    final bytes = await document.save();
    document.dispose();

    return Uint8List.fromList(bytes);
  }

  Future<String> getLinkPDF(uid) async {
    Reference ref =
        FirebaseStorage.instance.ref().child('certificados/$uid.pdf');
    return await ref.getDownloadURL();
  }
}
