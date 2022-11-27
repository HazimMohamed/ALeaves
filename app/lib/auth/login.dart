import 'package:aleaves_app/auth/form_validators.dart';
import 'package:aleaves_app/service/auth_service.dart';
import 'package:flutter/material.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() {
    return _LoginState();
  }
}

class _LoginState extends State<Login> {
  MaterialStateProperty<Color> buttonBackground =
      MaterialStateProperty.all(const Color.fromRGBO(3, 137, 245, 1));
  static const TextStyle buttonTextStyle =
      TextStyle(color: Color.fromRGBO(0, 0, 0, 1));
  static const TextStyle forgotPasswordStyle =
      TextStyle(color: Color.fromRGBO(0, 0, 230, 1));

  TextEditingController emailController =
      TextEditingController(text: 'hazimmohamedmhs@gmail.com');
  TextEditingController passwordController =
      TextEditingController(text: 'mypassword!');

  AuthService authService = AuthService();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  dynamic error;

  void attemptLogin() async {
    if (!(_formKey.currentState?.validate() ?? false)) {
      return;
    }
    try {
      await authService.attemptLogin(
          email: emailController.text, password: passwordController.text);
      error = null;
    } catch (e) {
      error = e;
    }

    setState(() {});

    if (!mounted) {
      return;
    }

    if (error == null) {
      Navigator.popUntil(context, (route) => route.isFirst);
    }
  }

  Widget loginButton() {
    return Container(
      padding: const EdgeInsets.only(top: 25),
      child: TextButton(
        onPressed: attemptLogin,
        style: ButtonStyle(backgroundColor: buttonBackground),
        child: const Text('Login', style: buttonTextStyle),
      ),
    );
  }

  Widget title() {
    return Container(
      padding: const EdgeInsets.only(top: 50),
      child: const Text('Login to ALeaves'),
    );
  }

  Widget forgotPasswordText() {
    return Container(
        padding: const EdgeInsets.only(top: 10),
        child: const Text('Forgot password?', style: forgotPasswordStyle));
  }

  Widget loginComponent() {
    return Container(
      padding: const EdgeInsets.fromLTRB(400, 50, 400, 100),
      child: Form(
          key: _formKey,
          child: Column(children: [
            title(),
            TextFormField(
              decoration: const InputDecoration(labelText: 'Email'),
              controller: emailController,
              validator: (email) => emailValidator(email),
            ),
            TextFormField(
                decoration: const InputDecoration(labelText: 'Password'),
                controller: passwordController),
            forgotPasswordText(),
            loginButton()
          ])),
    );
  }

  Widget registrationText() {
    return InkWell(
        child: const Text('Don\'t have an account? Register.'),
        onTap: () => Navigator.pushReplacementNamed(context, '/auth/register'));
  }

  Widget maybeError() {
    final errorMessage = error == null
        ? Container()
        : Text(
            error.toString(),
            style: const TextStyle(color: Color.fromRGBO(255, 0, 0, 1)),
          );
    return Container(
        margin: const EdgeInsets.only(top: 300), child: errorMessage);
  }

  @override
  Widget build(BuildContext context) {
    return Material(
        child: Column(
      children: [maybeError(), loginComponent(), registrationText()],
    ));
  }
}
