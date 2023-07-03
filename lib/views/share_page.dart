import 'package:appcertificate/controller/firestore_service.dart';
import 'package:appcertificate/models/certficadoModel.dart';
import 'package:appcertificate/views/widgets/buttons.dart';
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';

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

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Image.asset('assets/wallpaper.jpg',
                  height: size.height * 0.2,
                  width: size.width,
                  fit: BoxFit.cover),
              SizedBox(height: size.height * 0.03),
              const Padding(
                  padding: EdgeInsets.only(left: 20.0, right: 20),
                  child: Text('Certificado de Garantia',
                      style: TextStyle(fontSize: 20))),
              SizedBox(height: size.height * 0.03),
              Padding(
                padding: const EdgeInsets.fromLTRB(60, 0, 60, 30),
                child: Column(
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text("ID:${widget.certificado.uid}"),
                    ),
                    SizedBox(height: size.height * 0.01),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text("Peça: ${widget.certificado.nomeCliente}"),
                    ),
                    SizedBox(height: size.height * 0.01),
                    Align(
                      alignment: Alignment.centerLeft,
                      child:
                          Text("Data de Validade: ${widget.certificado.data}"),
                    ),
                    SizedBox(height: size.height * 0.01),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                          "Nome Cliente: ${widget.certificado.nomeCliente}"),
                    ),
                    SizedBox(height: size.height * 0.01),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text("CPF: ${widget.certificado.cpf}"),
                    ),
                    SizedBox(height: size.height * 0.01),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text("Vendedor: ${widget.certificado.vendedor}"),
                    ),
                    SizedBox(height: size.height * 0.01),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text("Descrição: ${widget.certificado.descricao}"),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.fromLTRB(60, 0, 60, 30),
                child: Column(
                  children: [
                    SizedBox(height: size.height * 0.02),
                    FButton(
                      "Download do PDF",
                      const Color.fromARGB(255, 125, 36, 30),
                      () async => await PdfService()
                          .downloadPDF(widget.certificado.uid),
                    ),
                    SizedBox(height: size.height * 0.01),
                    FButton(
                      "Compartilhar PDF",
                      const Color.fromARGB(255, 102, 125, 30),
                      () async {
                        await _onShare(context, widget.certificado.uid);
                      },
                    ),
                  ],
                ),
              ),
            ]),
      ),
    );
  }

  _onShare(context, uid) async {
    final box = context.findRenderObject() as RenderBox?;
    print(uid);
    String url = await PdfService().getLinkPDF(uid);
    print('URL de download: $url');
    String msg =
        'Olá, cliente Juvi! Segue abaixo o link para acessar o seu certificado de garantia:\n\n$url';
    print(msg);
    await Share.share(msg,
        sharePositionOrigin: box!.localToGlobal(Offset.zero) & box.size);
  }
}
