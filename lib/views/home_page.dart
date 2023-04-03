import 'package:appcertificate/controller/auth_service.dart';
import 'package:appcertificate/controller/certs_service.dart';
import 'package:appcertificate/controller/simple_ui_controller.dart';
import 'package:appcertificate/controller/firestore_service.dart';
import 'package:appcertificate/models/certficadoModel.dart';
import 'package:appcertificate/util/constants.dart';
import 'package:appcertificate/views/cert_generate.dart';
import 'package:appcertificate/views/widgets/buttons.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    var theme = Theme.of(context);

    Provider.of<CertsService>(context).currentUser =
        Provider.of<AuthService>(context).usuario;

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
        Expanded(
          flex: 5,
          child: SingleChildScrollView(
            child: _buildMainBody(size, simpleUIController),
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
    return SingleChildScrollView(
      child: Center(
        child: Column(
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
                child: Text('Certificados Gerados',
                    style: kLoginTitleStyle(size * 0.5))),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.only(left: 20.0, right: 20),
              child: SizedBox(
                height: size.height * 0.65,
                child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('certificados')
                      .snapshots(),
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    }

                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Text('Loading...');
                    }

                    final certList = snapshot.data!.docs.map((doc) {
                      final data = doc.data() as Map<String, dynamic>;
                      return CertificadoModel(
                          uid: doc.id,
                          nomeCliente: data['nomeCliente'],
                          cpf: data['cpfCliente'],
                          data: data['data'],
                          codigoJoia: data['codigoJoia'],
                          vendedor: data['vendedor'],
                          descricao: data['descricao'],
                          banho: data['banho']);
                    }).toList();

                    context.read<CertsService>().certList = certList;

                    return ListView.builder(
                      scrollDirection: Axis.vertical,
                      itemCount: certList.length,
                      itemBuilder: (context, index) {
                        return Card(
                          elevation: 4.0,
                          color: Colors.grey[100],
                          child: Container(
                            padding: const EdgeInsets.all(20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("ID: ${certList[index].uid}"),
                                const SizedBox(height: 5),
                                Text("Cliente: ${certList[index].nomeCliente}"),
                                const SizedBox(height: 5),
                                Text(
                                    "Data de validade: ${certList[index].data}"),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 20),
              child: FButton(
                  'Gerar Certificado', const Color.fromARGB(255, 98, 141, 95),
                  () {
                FirebaseStorage().addCert(
                    Provider.of<CertsService>(context, listen: false)
                        .certList[0]);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const certGenerate(),
                  ),
                );
              }),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
