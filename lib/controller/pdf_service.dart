import 'package:appcertificate/models/certficadoModel.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/services.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'dart:async';
import 'dart:html';

class PdfService {
  Future<Uint8List> getPdf() async {
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
    // Obter uma referência para o arquivo PDF no Firebase Storage
    Reference ref =
        FirebaseStorage.instance.ref().child('certificados/$uid.pdf');

    // Obter a URL de download do arquivo PDF
    final url = await ref.getDownloadURL();

    // Crie um link de download para o arquivo PDF
    final anchor = AnchorElement(href: url);
    anchor.download = 'certificado-$uid.pdf';
    anchor.click();
  }

  Future<String> editAndSavePDF(CertificadoModel certificado) async {
    // Carrega o arquivo de modelo do certificado
    final Future<Uint8List> document = getPdf();

    // Espera pelo resultado de getPdf()
    final inputBytes = await document;

    // Carrega o documento PDF do modelo
    final PdfDocument pdfDocument = PdfDocument(inputBytes: inputBytes);

    // Edita o documento PDF com os dados do certificado
    final fiel = await editPdfWithCertificado(pdfDocument, certificado);

    final blob = Blob([fiel], 'application/pdf');

    // Cria uma referência para o Firebase Storage
    final storage = FirebaseStorage.instance;
    final reference =
        storage.ref().child("certificados/${certificado.uid}.pdf");

    // Faz o upload do Blob para o Firebase Storage
    final uploadTask = reference.putBlob(blob);
    await uploadTask;

    // Recupera a URL do arquivo salvo no Firebase Storage
    final downloadUrl = await reference.getDownloadURL();

    // Retorna a URL do arquivo no Firebase Storage
    return downloadUrl;
  }

  Future<Uint8List> editPdfWithCertificado(
      PdfDocument document, CertificadoModel certificado) async {
    final page = document.pages[0];
    page.graphics.drawImage(
      PdfBitmap(
          (await rootBundle.load('assets/avataJoia.png')).buffer.asUint8List()),
      Rect.fromLTWH(20.512, 127.00, 75.00, 73.836),
    );
    page.graphics.drawString(
      certificado.uid,
      PdfStandardFont(PdfFontFamily.helvetica, 10),
      bounds: Rect.fromLTWH(118.797, 131.454, 157.105, 15),
    );
    page.graphics.drawString(
      certificado.banho,
      PdfStandardFont(PdfFontFamily.helvetica, 10),
      bounds: Rect.fromLTWH(143.698, 157.988, 131.062, 15),
    );
    page.graphics.drawString(
      certificado.data,
      PdfStandardFont(PdfFontFamily.helvetica, 10),
      bounds: Rect.fromLTWH(156.049, 184.072, 119.437, 15),
    );
    page.graphics.drawString(
      certificado.nomeCliente,
      PdfStandardFont(PdfFontFamily.helvetica, 10),
      bounds: Rect.fromLTWH(62.794, 208, 214.647, 20),
    );
    page.graphics.drawString(
      certificado.cpf,
      PdfStandardFont(PdfFontFamily.helvetica, 10),
      bounds: Rect.fromLTWH(46.709, 231.390, 229.028, 15),
    );
    page.graphics.drawString(
      certificado.cpf,
      PdfStandardFont(PdfFontFamily.helvetica, 10),
      bounds: Rect.fromLTWH(46.709, 231.390, 229.028, 15),
    );
    page.graphics.drawString(
      certificado.descricao,
      PdfStandardFont(
        PdfFontFamily.helvetica,
        10,
      ),
      bounds: Rect.fromLTWH(23.340, 253.778, 251.981, 60.560),
      format: PdfStringFormat(alignment: PdfTextAlignment.justify),
    );
    final bytes = await document.save();
    document.dispose();

    return Uint8List.fromList(bytes);
  }
}
