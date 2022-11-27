import 'package:flutter/material.dart';

class ErrorPageArguments {
  String header;

  String subHeader;

  ErrorPageArguments({required this.header, required this.subHeader});
}

class ErrorPage extends StatelessWidget {
  const ErrorPage({super.key});

  ErrorPageArguments? _getArguments(BuildContext context) {
    return (ModalRoute.of(context)?.settings.arguments as ErrorPageArguments);
  }

  Widget toHomepageText(context) {
    return InkWell(
        child: const Text('Go to homepage.'),
        onTap: () => Navigator.popUntil(context, (route) => route.isFirst));
  }

  @override
  Widget build(BuildContext context) {
    final arguments = _getArguments(context);
    String header = arguments?.header ?? 'An Error Occurred';
    String subheader =
        arguments?.subHeader ?? 'We don\'t tell you what happened...';
    return Center(
        child: Column(
      children: [const Text('ERROR'), Text(header), Text(subheader), toHomepageText(context)],
    ));
  }
}
