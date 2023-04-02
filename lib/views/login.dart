import 'package:appcertificate/controller/auth.dart';
import 'package:appcertificate/views/home.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../util/constants.dart';
import '../controller/simple_ui_controller.dart';
import 'widgets/buttons.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginView extends StatefulWidget {
  const LoginView({Key? key}) : super(key: key);

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

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
            child: Image.asset(
              'assets/wallpaper.jpg',
              height: size.height * 0.3,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
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
          child: Text(
            'Login',
            style: kLoginTitleStyle(size),
          ),
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
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  style: kTextFormFieldStyle(),
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.person),
                    hintText: 'Email',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(15)),
                    ),
                  ),
                ),

                SizedBox(height: size.height * 0.02),

                /// password
                TextFormField(
                  style: kTextFormFieldStyle(),
                  controller: passwordController,
                  obscureText: simpleUIController.isObscure.value,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.lock_open),
                    suffixIcon: IconButton(
                      icon: Icon(simpleUIController.isObscure.value
                          ? Icons.visibility
                          : Icons.visibility_off),
                      onPressed: () {
                        simpleUIController.isObscureActive();
                      },
                    ),
                    hintText: 'Senha',
                    border: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(15)),
                    ),
                  ),
                ),

                SizedBox(height: size.height * 0.02),

                ElevatedButton(
                  onPressed: () async {
                    // Chama o método signInWithGoogle()
                    final User? user = await Authentication().signInWithGoogle(context: context);

                    if (user != null) {
                      // Login com sucesso, redireciona para a próxima página
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => Home()),
                      );
                    } else {
                      // Login falhou, mostra uma mensagem de erro
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Login falhou')),
                      );
                    }
                  },
                  child: Text('Login com Google'),
                ),

                /// Login Button
                FButton('Login com Email', const Color.fromARGB(255, 9, 85, 1),
                    () {}),
                SizedBox(height: size.height * 0.02),
                FButton(
                    'Login com Google', const Color.fromARGB(255, 197, 3, 3),
                    () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const Home(),
                    ),
                  );
                }),
                SizedBox(height: size.height * 0.03),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
