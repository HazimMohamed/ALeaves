import 'package:flutter/material.dart';

import 'homepage/homepage.dart';
import 'routes.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Aleaves',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      routes: routes,
      home: const MyHomePage(),
    );
  }
}