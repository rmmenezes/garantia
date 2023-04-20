import 'package:appcertificate/controller/firestore_service.dart';
import 'package:appcertificate/models/certficadoModel.dart';
import 'package:appcertificate/util/utils.dart';
import 'package:appcertificate/views/share_page.dart';
import 'package:appcertificate/views/widgets/buttons.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:universal_html/html.dart';
import 'package:image_picker_web/image_picker_web.dart';
import 'package:uuid/uuid.dart';

// ignore: camel_case_types
class certGenerate extends StatefulWidget {
  const certGenerate({super.key});

  @override
  State<certGenerate> createState() => _certGenerateState();
}

class _certGenerateState extends State<certGenerate> {
  var uuid = const Uuid().v1();
  final _formKey = GlobalKey<FormState>();
  Uint8List? _imageData;
  bool _imageDataBorder = false;
  bool isLoading = false;

  Future<void> _pickImage() async {
    final input = FileUploadInputElement();
    input.accept = 'image/*';
    input.click();

    input.onChange.listen((event) {
      final file = input.files!.first;
      final reader = FileReader();

      reader.onLoad.listen((event) {
        final buffer = reader.result as Uint8List;
        setState(() {
          _imageData = buffer;
        });
      });

      reader.readAsArrayBuffer(file);
    });
  }

  CertificadoModel certificado = CertificadoModel(
      uid: "",
      data: "",
      cpf: "",
      nomeCliente: "",
      descricao: "",
      vendedor: "",
      peca: "");

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          reverse: true,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Image.asset('assets/wallpaper.jpg',
                  height: size.height * 0.2,
                  width: size.width,
                  fit: BoxFit.cover),
              SizedBox(height: size.height * 0.03),
              Padding(
                  padding: const EdgeInsets.only(left: 20.0, right: 20),
                  child: Text('Registro de Certificado de Garantia',
                      style: kLoginSubtitleStyle(size))),
              SizedBox(height: size.height * 0.03),
              isLoading
                  ? const Center(child: Text("Aguarde..."))
                  : Padding(
                      padding: const EdgeInsets.only(left: 20.0, right: 20),
                      child: Form(
                        key: _formKey,
                        child: Column(children: [
                          // Imagem
                          GestureDetector(
                            onTap: _pickImage,
                            child: Container(
                              padding: const EdgeInsets.all(20.0),
                              width: 170.0,
                              height: 170.0,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: _imageDataBorder
                                    ? Border.all(
                                        color: Colors.red,
                                        width: 2.0,
                                        style: BorderStyle.solid)
                                    : null,
                                image: _imageData != null
                                    ? DecorationImage(
                                        fit: BoxFit.cover,
                                        image: MemoryImage(_imageData!),
                                      )
                                    : const DecorationImage(
                                        fit: BoxFit.cover,
                                        image: AssetImage('assets/upload.png'),
                                      ),
                              ),
                            ),
                          ),
                          SizedBox(height: size.height * 0.03),

                          // Idendificador
                          TextFormField(
                            enabled: false,
                            initialValue: uuid,
                            autofocus: false,
                            style: kTextFormFieldStyle(),
                            decoration: const InputDecoration(
                              labelText: "Identifiador do Certifiado:",
                              labelStyle: TextStyle(color: Colors.black),
                              border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(0)),
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Por favor, digite insira este campo.';
                              }
                              return null;
                            },
                            onSaved: (value) {
                              certificado.uid = uuid;
                            },
                          ),
                          SizedBox(height: size.height * 0.02),

                          // Peça
                          TextFormField(
                            inputFormatters: [
                              TextInputFormatter.withFunction(
                                  (oldValue, newValue) {
                                return TextEditingValue(
                                  text: newValue.text.toUpperCase(),
                                  selection: newValue.selection,
                                );
                              }),
                            ],
                            autofocus: false,
                            style: kTextFormFieldStyle(),
                            decoration: const InputDecoration(
                              labelText: "Peça:",
                              labelStyle: TextStyle(color: Colors.black),
                              border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(0)),
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Por favor, digite insira este campo.';
                              }
                              return null;
                            },
                            onSaved: (value) {
                              certificado.peca = value!;
                            },
                          ),
                          SizedBox(height: size.height * 0.02),

                          // Nome do(a) Cliente
                          TextFormField(
                            inputFormatters: [
                              TextInputFormatter.withFunction(
                                  (oldValue, newValue) {
                                return TextEditingValue(
                                  text: newValue.text.toUpperCase(),
                                  selection: newValue.selection,
                                );
                              }),
                            ],
                            autofocus: false,
                            style: kTextFormFieldStyle(),
                            decoration: const InputDecoration(
                              labelText: "Nome do(a) Cliente:",
                              labelStyle: TextStyle(color: Colors.black),
                              border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(0)),
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Por favor, digite insira este campo.';
                              }
                              return null;
                            },
                            onSaved: (value) {
                              certificado.nomeCliente = value!;
                            },
                          ),
                          SizedBox(height: size.height * 0.02),

                          // CPF
                          TextFormField(
                            keyboardType: TextInputType.number,
                            autofocus: false,
                            style: kTextFormFieldStyle(),
                            decoration: const InputDecoration(
                              labelText: "CPF:",
                              labelStyle: TextStyle(color: Colors.black),
                              border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(0)),
                              ),
                            ),
                            inputFormatters: [
                              MaskTextInputFormatter(
                                  mask: '###.###.###-##',
                                  filter: {'#': RegExp(r'[0-9]')})
                            ],
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Por favor, digite insira este campo.';
                              }
                              return null;
                            },
                            onSaved: (value) {
                              certificado.cpf = value!;
                            },
                          ),
                          SizedBox(height: size.height * 0.02),

                          // Garantía ate:
                          TextFormField(
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              MaskTextInputFormatter(
                                mask: '##/##/####',
                                filter: {"#": RegExp(r'[0-9]')},
                              ),
                            ],
                            autofocus: false,
                            style: kTextFormFieldStyle(),
                            decoration: const InputDecoration(
                              labelText: "Garantia até:",
                              labelStyle: TextStyle(color: Colors.black),
                              border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(0)),
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Por favor, digite insira este campo.';
                              }
                              if (value.length != 10) {
                                return 'Por favor, insira a data no formato dd/mm/yyyy';
                              }
                              return null;
                            },
                            onSaved: (value) {
                              certificado.data = value!;
                            },
                          ),

                          SizedBox(height: size.height * 0.02),

                          // Vendedor
                          TextFormField(
                            inputFormatters: [
                              TextInputFormatter.withFunction(
                                  (oldValue, newValue) {
                                return TextEditingValue(
                                  text: newValue.text.toUpperCase(),
                                  selection: newValue.selection,
                                );
                              }),
                            ],
                            autofocus: false,
                            style: kTextFormFieldStyle(),
                            decoration: const InputDecoration(
                              labelText: "Vendedor(a):",
                              labelStyle: TextStyle(color: Colors.black),
                              border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(0)),
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Por favor, digite insira este campo.';
                              }
                              return null;
                            },
                            onSaved: (value) {
                              certificado.vendedor = value!;
                            },
                          ),
                          SizedBox(height: size.height * 0.02),

                          // Descrição
                          TextFormField(
                            inputFormatters: [
                              TextInputFormatter.withFunction(
                                  (oldValue, newValue) {
                                return TextEditingValue(
                                  text: newValue.text.toUpperCase(),
                                  selection: newValue.selection,
                                );
                              }),
                            ],
                            minLines:
                                5, //Normal textInputField will be displayed
                            maxLines:
                                7, // when user presses enter it will adapt to it
                            autofocus: false,
                            style: kTextFormFieldStyle(),
                            decoration: const InputDecoration(
                              labelText: "Descrição:",
                              labelStyle: TextStyle(color: Colors.black),
                              border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(0)),
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Por favor, digite insira este campo.';
                              }
                              return null;
                            },
                            onSaved: (value) {
                              certificado.descricao = value!;
                            },
                          ),
                          SizedBox(height: size.height * 0.03),

                          //Botão Registrar
                          FButton('Registrar Certificado',
                              const Color.fromARGB(255, 4, 109, 27), () async {
                            if (_formKey.currentState!.validate()) {
                              _formKey.currentState?.save();
                              if (_imageData != null) {
                                setState(() {
                                  isLoading = true;
                                });
                                await Storage()
                                    .addCert(certificado, _imageData!);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content:
                                        Text('Certificado Gerado com Sucesso!'),
                                    backgroundColor:
                                        Color.fromARGB(255, 4, 109, 27),
                                  ),
                                );

                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => SharePage(
                                            certificado: certificado)));
                              } else {
                                setState(() {
                                  _imageDataBorder = true;
                                });
                                ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content: Text(
                                            'Por favor, selecione uma imagem.'),
                                        backgroundColor: Colors.red));
                              }
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text(
                                          'Por favor, verifique todos os campos.'),
                                      backgroundColor: Colors.red));
                            }
                            setState(() {
                              isLoading = false;
                            });
                          }),
                        ]),
                      ),
                    ),
              SizedBox(height: size.height * 0.03),
              Padding(
                  padding: EdgeInsets.only(
                      bottom: MediaQuery.of(context).viewInsets.bottom))
            ],
          ),
        ));
  }
}
