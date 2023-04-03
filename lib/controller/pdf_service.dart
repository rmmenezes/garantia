import 'package:appcertificate/models/certficadoModel.dart';
import 'package:flutter/services.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';

class PdfService {

  Future<Uint8List> getPdf() async {
    ByteData data = await rootBundle.load('templates/certificado.pdf');
    return data.buffer.asUint8List();
  }

  editpdf(CertificadoModel certificado) async {
    final PdfDocument document = PdfDocument(
        inputBytes: (await rootBundle.load('templates/certificado.pdf'))
            .buffer
            .asUint8List());

    PdfPage page = document.pages[0];

    page.graphics.drawImage(
        PdfBitmap((await rootBundle.load('assets/avataJoia.png'))
            .buffer
            .asUint8List()),
        const Rect.fromLTWH(20.512, 127.00, 75.00, 73.836));

    page.graphics.drawString(
        certificado.uid, PdfStandardFont(PdfFontFamily.helvetica, 10),
        bounds: const Rect.fromLTWH(118.797, 131.454, 157.105, 15));

    page.graphics.drawString(
        certificado.banho, PdfStandardFont(PdfFontFamily.helvetica, 10),
        bounds: const Rect.fromLTWH(143.698, 157.988, 131.062, 15));

    page.graphics.drawString(
        certificado.data, PdfStandardFont(PdfFontFamily.helvetica, 10),
        bounds: const Rect.fromLTWH(156.049, 184.072, 119.437, 15));

    page.graphics.drawString(
        certificado.nomeCliente, PdfStandardFont(PdfFontFamily.helvetica, 10),
        bounds: const Rect.fromLTWH(62.794, 208, 214.647, 20));

    page.graphics.drawString(
        certificado.cpf, PdfStandardFont(PdfFontFamily.helvetica, 10),
        bounds: const Rect.fromLTWH(46.709, 231.390, 229.028, 15));

    page.graphics.drawString(
        certificado.descricao,
        PdfStandardFont(
          PdfFontFamily.helvetica,
          10,
        ),
        bounds: const Rect.fromLTWH(23.340, 253.778, 251.981, 60.560),
        format: PdfStringFormat(alignment: PdfTextAlignment.justify));
  }
}
