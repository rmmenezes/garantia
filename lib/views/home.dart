import 'package:appcertificate/models/certficadoModel.dart';
import 'package:appcertificate/util/constants.dart';
import 'package:appcertificate/controller/simple_ui_controller.dart';
import 'package:appcertificate/views/cert_generate.dart';
import 'package:appcertificate/views/widgets/buttons.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<CertificadoModel> certificados = [
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
    return Center(
      child: _buildMainBody(size, simpleUIController),
    );
  }

  /// build screens
  Widget _buildMainBody(Size size, SimpleUIController simpleUIController) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment:
          size.width > 600 ? MainAxisAlignment.start : MainAxisAlignment.start,
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
            child: Text('Certificados Gerados', style: kLoginTitleStyle(size))),
        const SizedBox(height: 10),
        Padding(
            padding: const EdgeInsets.only(left: 20.0, right: 20),
            child: SizedBox(
              height: size.height * 0.2,
              child: ListView.builder(
                scrollDirection: Axis.vertical,
                itemCount: certificados.length,
                itemBuilder: (context, index) {
                  return SizedBox(
                    width: 100,
                    child: Card(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(certificados[index].nomeCliente),
                          const SizedBox(height: 8),
                          Text(
                              "Data de validade: ${certificados[index].data}"),
                        ],
                      ),
                    ),
                  );
                },
              ),
            )),
        SizedBox(height: size.height * 0.03),
        Padding(
          padding: const EdgeInsets.only(left: 20.0, right: 20),
          child: FButton(
              'Gerar Certificado', const Color.fromARGB(255, 98, 141, 95), () {
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => const certGenerate()));
          }),
        ),
        SizedBox(height: size.height * 0.03),
      ],
    );
  }
}
