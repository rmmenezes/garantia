import 'package:appcertificate/controller/auth_service.dart';
import 'package:appcertificate/controller/simple_ui_controller.dart';
import 'package:appcertificate/util/constants.dart';
import 'package:appcertificate/views/home_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import 'widgets/buttons.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  FirebaseAuth auth = FirebaseAuth.instance;
  bool loading = false;
  User? user;

  SimpleUIController simpleUIController = Get.put(SimpleUIController());

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    var theme = Theme.of(context);

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
          )),
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
                fit: BoxFit.cover),
          ),
        ),
        SizedBox(width: size.width * 0.06),
        Expanded(
          flex: 5,
          child: _buildMainBody(size, simpleUIController),
        ),
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

  Widget _buildMainBody(
    Size size,
    SimpleUIController simpleUIController,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment:
          size.width > 600 ? MainAxisAlignment.center : MainAxisAlignment.start,
      children: [
        size.width > 600
            ? Container()
            : Stack(
                children: [
                  Image.asset('assets/wallpaper.jpg',
                      height: size.height * 0.2,
                      width: size.width,
                      fit: BoxFit.cover),
                ],
              ),
        SizedBox(height: size.height * 0.03),
        Padding(
          padding: const EdgeInsets.only(left: 20.0),
          child: Text('Login', style: kLoginTitleStyle(size)),
        ),
        const SizedBox(
          height: 10,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 20.0),
          child: Text('Sistema Interno', style: kLoginSubtitleStyle(size)),
        ),
        SizedBox(height: size.height * 0.03),
        Padding(
          padding: const EdgeInsets.only(left: 20.0, right: 20),
          child: Column(
            children: [
              FButton(
                  'ENTRAR COM GOOGLE', const Color.fromARGB(255, 102, 125, 30),
                  () async {
                setState(() => loading = true);
                try {
                  await context.read<AuthService>().login();
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const HomePage()));
                } on FirebaseAuthException {
                  setState(() => loading = false);
                  ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Erro na Autenticação")));
                }
              }),
               SizedBox(height: size.height * 0.03),
            ],
          ),
        ),
      ],
    );
  }
}
