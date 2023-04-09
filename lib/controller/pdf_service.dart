import 'dart:typed_data';
import 'package:appcertificate/models/certficadoModel.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/services.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'package:universal_html/html.dart' as html;

class PdfService {
  Future<Uint8List> getPdf() async {
    ByteData data = await rootBundle.load('templates/certificado_output.pdf');
    return data.buffer.asUint8List();
  }

  Future<String> editAndSavePDF(CertificadoModel certificado) async {
    // Carrega o arquivo de modelo do certificado
    final bytes = await rootBundle.load('templates/certificado.pdf');
    final inputBytes = bytes.buffer.asUint8List();

    // Carrega o documento PDF do modelo
    final PdfDocument document = PdfDocument(inputBytes: inputBytes);

    // Edita o documento PDF com os dados do certificado
    final fiel = await editPdfWithCertificado(document, certificado);

    final blob = html.Blob([fiel], 'application/pdf');

    // Cria uma referência para o Firebase Storage
    final storage = FirebaseStorage.instance;
    final reference =
        storage.ref().child('certificados/certificado_output.pdf');

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
