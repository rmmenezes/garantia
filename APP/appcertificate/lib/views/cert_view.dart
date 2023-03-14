import 'dart:io';
import 'dart:typed_data';
import 'package:appcertificate/controller/simple_ui_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:printing/printing.dart';

import '../util/constants.dart';

class CertView extends StatefulWidget {
  const CertView({super.key});

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
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          title: Text('MyApp'),
        ),
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
              child: Text('Certificado de Garantia',
                  style: kLoginSubtitleStyle(size))),
          SizedBox(height: size.height * 0.03),
          Expanded(
            child: SizedBox(
              height: 200,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(60, 0, 60, 30),
                child: Center(
                  child: PdfPreview(
                    build: (format) => generatePdf("dd"),
                  ),
                ),
              ),
            ),
          ),
        ]);
  }

  Future<Uint8List> generatePdf(String title) async {
    final directory = await getApplicationDocumentsDirectory();
    final path = '${directory.path}/output.pdf';

    return File(path).readAsBytes();
  }
}
