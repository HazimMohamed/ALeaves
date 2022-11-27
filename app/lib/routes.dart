import 'package:flutter/widgets.dart';

import 'auth/login.dart';
import 'error_page/error_page.dart';
import 'auth/register.dart';

final routes =  <String, Widget Function(BuildContext)>{
  '/error': (context) => const ErrorPage(),
  '/auth/register': (context) => const Register(),
  '/auth/login': (context) => const Login(),
};