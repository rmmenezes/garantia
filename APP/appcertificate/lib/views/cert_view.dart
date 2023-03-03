import 'package:appcertificate/controller/simple_ui_controller.dart';
import 'package:appcertificate/models/certficadoModel.dart';
import 'package:appcertificate/util/constants.dart';
import 'package:appcertificate/views/widgets/buttons.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class CertView extends StatefulWidget {
  final CertificadoModel certificado;
  const CertView({super.key, required this.certificado});

  @override
  State<CertView> createState() => _CertViewState();
}

class _CertViewState extends State<CertView> {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    var theme = Theme.of(context);
    SimpleUIController simpleUIController = Get.put(SimpleUIController());

    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        backgroundColor: Colors.white,
        resizeToAvoidBottomInset: false,
        body: LayoutBuilder(
          builder: (context, constraints) {
            if (constraints.maxWidth > 600) {
              return _buildLargeScreen(size, simpleUIController, theme);
            } else {
              return _buildSmallScreen(size, simpleUIController, theme);
            }
          },
        ),
      ),
    );
  }

  final _formKey = GlobalKey<FormState>();

  /// For large screens
  Widget _buildLargeScreen(
      Size size, SimpleUIController simpleUIController, ThemeData theme) {
    return Row(
      children: [
        Expanded(
          flex: 4,
          child: RotatedBox(
              quarterTurns: 3,
              child: Image.asset('assets/wallpaper.jpg',
                  height: size.height * 0.3,
                  width: double.infinity,
                  fit: BoxFit.cover)),
        ),
        SizedBox(width: size.width * 0.06),
        Expanded(flex: 5, child: _buildMainBody(size, simpleUIController)),
      ],
    );
  }

  /// For Small screens
  Widget _buildSmallScreen(
      Size size, SimpleUIController simpleUIController, ThemeData theme) {
    return Container(
      child: _buildMainBody(size, simpleUIController),
    );
  }

  /// build screens
  Widget _buildMainBody(Size size, SimpleUIController simpleUIController) {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: size.width > 600
            ? MainAxisAlignment.start
            : MainAxisAlignment.start,
        children: [
          size.width > 600
              ? Container()
              : Image.asset('assets/wallpaper.jpg',
                  height: size.height * 0.2,
                  width: size.width,
                  fit: BoxFit.cover),
          SizedBox(height: size.height * 0.03),
          Padding(
              padding: const EdgeInsets.only(left: 20.0, right: 20),
              child: Text('Registro de Certificado de Garantia',
                  style: kLoginSubtitleStyle(size))),
          SizedBox(height: size.height * 0.03),
          Padding(
            padding: const EdgeInsets.only(left: 20.0, right: 20),
            child: Form(
              key: _formKey,
              child: Column(children: [
                Text("Ola ${widget.certificado.nomeCliente}"),
                SizedBox(height: size.height * 0.03),

                const Text(
                    "Obrigado por escolher nossas semijoias. Estamos agradecidos pelo seu apoio à nossa empresa. Esperamos que você tenha uma ótima experiência com sua nova semijoia."),

                SizedBox(height: size.height * 0.03),
                const Text(
                    "Este Certificado de Garantia garante que as semijoias adquiridas são feitas com materiais de alta qualidade e são sujeitas a rigoroso controle de qualidade antes de serem vendidas."),

                SizedBox(height: size.height * 0.03),
                const Text(
                    "Este Certificado de Garantia é válido por 06 meses a partir da data da compra e cobre danos ou defeitos de fabricação, perda do banho, ruptura de fechos e outros que possam ocorrer durante o uso normal das semijoias. Não sendo consideradas a garantia em caso de estiverem danificadas por sujeira, mal uso, quebradas, incompletas, arranhadas, amassadas ou avariadas."),

                SizedBox(height: size.height * 0.03),
                const Text(
                    "Para usufruir da garantia, basta entrar em contato conosco e fornecer uma cópia deste Certificado de Garantia juntamente com a joia. A equipe realizara a avaliação da semi-joia e caso seja comprovado o defeito faremos todos os esforços para corrigir o problema em um prazo de no máximo 30 (trinta) dias."),
                SizedBox(height: size.height * 0.03),

                //Botão Registrar
                FButton('Compartilhar', Color.fromARGB(255, 36, 166, 0), () {}),
              ]),
            ),
          ),
          SizedBox(height: size.height * 0.03),
          FButton("Print", Colors.black, printDoc)
        ]);
  }

  Future<void> printDoc() async {
    final doc = pw.Document();

    doc.addPage(pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return pw.Column(children: [
            pw.Padding(
                padding: const pw.EdgeInsets.only(left: 20.0, right: 20),
                child: pw.Text('Registro de Certificado de Garantia')),
            pw.Padding(
              padding: const pw.EdgeInsets.only(left: 20.0, right: 20),
              child: pw.Column(children: [
                pw.Text("Ola ${widget.certificado.nomeCliente}"),
                pw.Text(
                    "Obrigado por escolher nossas semijoias. Estamos agradecidos pelo seu apoio à nossa empresa. Esperamos que você tenha uma ótima experiência com sua nova semijoia."),
                pw.Text(
                    "Este Certificado de Garantia garante que as semijoias adquiridas são feitas com materiais de alta qualidade e são sujeitas a rigoroso controle de qualidade antes de serem vendidas."),
                pw.Text(
                    "Este Certificado de Garantia é válido por 06 meses a partir da data da compra e cobre danos ou defeitos de fabricação, perda do banho, ruptura de fechos e outros que possam ocorrer durante o uso normal das semijoias. Não sendo consideradas a garantia em caso de estiverem danificadas por sujeira, mal uso, quebradas, incompletas, arranhadas, amassadas ou avariadas."),
                pw.Text(
                    "Para usufruir da garantia, basta entrar em contato conosco e fornecer uma cópia deste Certificado de Garantia juntamente com a joia. A equipe realizara a avaliação da semi-joia e caso seja comprovado o defeito faremos todos os esforços para corrigir o problema em um prazo de no máximo 30 (trinta) dias."),
              ]),
            ),
          ]);

          // Center
        })); // Page
    await Printing.layoutPdf(
        onLayout: (PdfPageFormat format) async => doc.save());
  }
}
