import 'package:appcertificate/controller/firestore_service.dart';
import 'package:appcertificate/controller/simple_ui_controller.dart';
import 'package:appcertificate/models/certficadoModel.dart';
import 'package:appcertificate/views/widgets/buttons.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../util/utils.dart';

class SharePage extends StatefulWidget {
  final CertificadoModel certificado;
  const SharePage({Key? key, required this.certificado}) : super(key: key);

  @override
  State<SharePage> createState() => _SharePageState();
}

class _SharePageState extends State<SharePage> {
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

  /// For large screens
  Widget _buildLargeScreen(
      Size size, SimpleUIController simpleUIController, ThemeData theme) {
    return Stack(
      children: [
        Row(
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
        ),
        Positioned(
          top: 10,
          left: 10,
          child: ElevatedButton(
            style: OutlinedButton.styleFrom(
                backgroundColor: Colors.transparent,
                side: const BorderSide(color: Colors.transparent)),
            child: Row(
              children: const [
                Icon(Icons.arrow_back),
                SizedBox(width: 5),
                Text("Voltar"),
              ],
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
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
              child: Text('Certificado de Garantia',
                  style: kLoginSubtitleStyle(size))),
          SizedBox(height: size.height * 0.03),
          Expanded(
            child: SizedBox(
              height: 200,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(60, 0, 60, 30),
                child: Column(
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text("ID:${widget.certificado.uid}",
                          style: kLoginTermsAndPrivacyStyle(size)),
                    ),
                    SizedBox(height: size.height * 0.01),
                    Align(
                        alignment: Alignment.centerLeft,
                        child: Text("Peça: ${widget.certificado.nomeCliente}",
                            style: kLoginTermsAndPrivacyStyle(size))),
                    SizedBox(height: size.height * 0.01),
                    Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                            "Data de Validade: ${widget.certificado.data}",
                            style: kLoginTermsAndPrivacyStyle(size))),
                    SizedBox(height: size.height * 0.01),
                    Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                            "Nome Cliente: ${widget.certificado.nomeCliente}",
                            style: kLoginTermsAndPrivacyStyle(size))),
                    SizedBox(height: size.height * 0.01),
                    Align(
                        alignment: Alignment.centerLeft,
                        child: Text("CPF: ${widget.certificado.cpf}",
                            style: kLoginTermsAndPrivacyStyle(size))),
                    SizedBox(height: size.height * 0.01),
                    Align(
                        alignment: Alignment.centerLeft,
                        child: Text("Vendedor: ${widget.certificado.vendedor}",
                            style: kLoginTermsAndPrivacyStyle(size))),
                    SizedBox(height: size.height * 0.01),
                    Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                            "Descrição: ${widget.certificado.descricao}",
                            style: kLoginTermsAndPrivacyStyle(size))),
                    SizedBox(height: size.height * 0.02),
                    FButton(
                        "Download do PDF",
                        const Color.fromARGB(255, 102, 125, 30),
                        () => PdfService().downloadPDF(widget.certificado.uid)),
                  ],
                ),
              ),
            ),
          ),
        ]);
  }
}
