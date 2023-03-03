import 'dart:io';
import 'package:appcertificate/controller/geral.dart';
import 'package:appcertificate/models/certficadoModel.dart';
import 'package:appcertificate/util/constants.dart';
import 'package:appcertificate/controller/simple_ui_controller.dart';
import 'package:appcertificate/views/cert_view.dart';
import 'package:appcertificate/views/widgets/buttons.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

// ignore: camel_case_types
class certGenerate extends StatefulWidget {
  const certGenerate({super.key});

  @override
  State<certGenerate> createState() => _certGenerateState();
}

class _certGenerateState extends State<certGenerate> {
  var _imageFile;
  CertificadoModel certificado = CertificadoModel(
      uid: "",
      data: "data",
      nomeCliente: "nome",
      codigoJoia: "codigoJoia",
      descricao: "descricao",
      vendedor: "vendedor");

  @override
  void initState() {
    super.initState();
    _imageFile = null;
  }

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
                // Imagem
                Container(
                  padding: const EdgeInsets.all(20.0),
                  width: 170.0,
                  height: 170.0,
                  decoration: BoxDecoration(
                    image: _imageFile != null
                        ? DecorationImage(
                            fit: BoxFit.cover,
                            image: FileImage(File(_imageFile!.path)))
                        : const DecorationImage(
                            fit: BoxFit.cover,
                            image: AssetImage('assets/avataJoia.png')),
                    borderRadius:
                        const BorderRadius.all(Radius.circular(100.0)),
                  ),
                ),

                SizedBox(height: size.height * 0.03),

                // Garantía ate:
                TextFormField(
                  autofocus: false,
                  style: kTextFormFieldStyle(),
                  decoration: const InputDecoration(
                    labelText: "Garantía ate:",
                    labelStyle: TextStyle(color: Colors.black),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(15)),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, digite seu email.';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    certificado.data = value!;
                  },
                ),
                SizedBox(height: size.height * 0.02),

                // Nome do(a) Cliente
                TextFormField(
                  autofocus: false,
                  style: kTextFormFieldStyle(),
                  decoration: const InputDecoration(
                    labelText: "Nome do(a) Cliente",
                    labelStyle: TextStyle(color: Colors.black),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(15)),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, digite seu email.';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    certificado.nomeCliente = value!;
                  },
                ),
                SizedBox(height: size.height * 0.02),

                // Codigo da Joia
                TextFormField(
                  autofocus: false,
                  style: kTextFormFieldStyle(),
                  decoration: const InputDecoration(
                    labelText: "Codigo da Joia",
                    labelStyle: TextStyle(color: Colors.black),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(15)),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, digite seu email.';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    certificado.codigoJoia = value!;
                  },
                ),
                SizedBox(height: size.height * 0.02),

                // Descrição
                TextFormField(
                  minLines: 5, //Normal textInputField will be displayed
                  maxLines: 7, // when user presses enter it will adapt to it
                  autofocus: false,
                  style: kTextFormFieldStyle(),
                  decoration: const InputDecoration(
                    labelText: "Descrição",
                    labelStyle: TextStyle(color: Colors.black),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(15)),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, digite seu email.';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    certificado.descricao = value!;
                  },
                ),
                SizedBox(height: size.height * 0.03),

                //Botão Registrar
                FButton('Reistrar Certificado',
                    const Color.fromARGB(255, 197, 3, 3), () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState?.save();
                    AwesomeDialog(
                      width: size.width * 0.4,
                      context: context,
                      dialogType: DialogType.success,
                      animType: AnimType.topSlide,
                      title: 'Certificado Registrado',
                      desc: 'Versão em PDF disponivel',
                      btnOkOnPress: () {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    CertView(certificado: certificado)));
                      },
                    ).show();
                  } else {
                    AwesomeDialog(
                      width: size.width * 0.4,
                      context: context,
                      dialogType: DialogType.error,
                      animType: AnimType.topSlide,
                      title: 'Erro',
                      desc: 'Verifique todos os campos',
                      btnCancelText: "Voltar",
                      btnCancelOnPress: () {},
                    ).show();
                  }
                }),
              ]),
            ),
          ),
          SizedBox(height: size.height * 0.03),
        ]);
  }
}
