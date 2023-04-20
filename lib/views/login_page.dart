import 'package:appcertificate/controller/auth_service.dart';
import 'package:appcertificate/util/utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'certificate_page.dart';
import 'widgets/buttons.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return Scaffold(
        backgroundColor: Colors.white,
        resizeToAvoidBottomInset: false,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Stack(
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
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.only(left: 20.0),
              child: Text('Sistema Interno', style: kLoginSubtitleStyle(size)),
            ),
            SizedBox(height: size.height * 0.03),
            Padding(
              padding: const EdgeInsets.only(left: 20.0, right: 20),
              child: Column(
                children: [
                  FButton('ENTRAR COM GOOGLE',
                      const Color.fromARGB(255, 102, 125, 30), () async {
                    try {
                      await context.read<AuthService>().login();
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const certGenerate()));
                    } on FirebaseAuthException {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          content: Text("Erro na Autenticação")));
                    }
                  }),
                  SizedBox(height: size.height * 0.03),
                ],
              ),
            ),
          ],
        ));
  }
}
