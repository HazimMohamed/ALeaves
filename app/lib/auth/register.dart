import 'package:aleaves_app/model/image.dart';
import 'package:aleaves_app/service/auth_service.dart';
import 'package:flutter/material.dart';

import '../model/user.dart';
import 'form_validators.dart';

class Register extends StatefulWidget {
  const Register({Key? key}) : super(key: key);

  @override
  State<Register> createState() {
    return _RegisterState();
  }
}

class _RegisterState extends State<Register> {
  MaterialStateProperty<Color> buttonBackground =
  MaterialStateProperty.all(const Color.fromRGBO(3, 137, 245, 1));
  static const TextStyle buttonTextStyle =
  TextStyle(color: Color.fromRGBO(0, 0, 0, 1));
  String stagedPassword = '';
  AuthService authService = AuthService();
  dynamic error;

  _RegisterState();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  Container title() {
    return Container(
      padding: const EdgeInsets.fromLTRB(0, 100, 0, 30),
      child: const Text('Register for ALeaves'),
    );
  }

  TextFormField formFieldWithLabel(String label,
      TextEditingController? controller,
      {String? Function(String?)? validator,
        Function(String)? onChanged,
        bool isPasswordText = false}) {
    return TextFormField(
      decoration: InputDecoration(labelText: label),
      controller: controller,
      validator: validator,
      onChanged: onChanged,
      obscureText: isPasswordText,
    );
  }

  Widget maybeErrorMessage() {
    if (error != null) {
      return Text(error.toString());
    }
    return Container();
  }

  Container registrationForm() {
    return Container(
      padding: const EdgeInsets.fromLTRB(400, 10, 400, 50),
      child: Form(
          key: _formKey,
          child: Column(children: [
            maybeErrorMessage(),
            formFieldWithLabel('First Name', firstNameController,
                validator: requiredValidator),
            formFieldWithLabel('Last Name', lastNameController,
                validator: requiredValidator),
            formFieldWithLabel('Email', emailController,
                validator: emailValidator),
            formFieldWithLabel('Password', passwordController,
                validator: passwordValidator,
                onChanged: (newPassword) => {stagedPassword = newPassword},
                isPasswordText: true),
            formFieldWithLabel('Repeat Password', null,
                validator: (repeatPassword) =>
                    repeatPasswordValidator(stagedPassword, repeatPassword),
                isPasswordText: true),
          ])),
    );
  }

  void onRegisterPressed() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    try {
      await authService.attemptRegistration(
          user: User(
              givenName: firstNameController.text,
              familyName: lastNameController.text,
              emailAddress: emailController.text,
              images: <ALeavesImage>[]),
          password: passwordController.text);
      error = null;
    } catch (e) {
      error = e;
    }
    if (!mounted) return;

    if (error != null) {
      Navigator.popUntil(context, (route) => route.isFirst);
    }
    setState(() {});
  }

  TextButton registerButton() {
    return TextButton(
      onPressed: onRegisterPressed,
      style: ButtonStyle(backgroundColor: buttonBackground),
      child: const Text('Register', style: buttonTextStyle),
    );
  }

  Widget loginText() {
    return Container(margin: const EdgeInsets.only(top: 100), child:
        InkWell(
            child: const Text('Already have an account? Sign in.'),
            onTap: () =>
                Navigator.pushReplacementNamed(context, '/auth/login')));
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Column(children: [
        title(),
        registrationForm(),
        registerButton(),
        loginText()
      ]),
    );
  }
}
