import 'package:flutter/material.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Container(
          child: Center(
              child: Text(
        "Hello everyone",
        style: TextStyle(color: Theme.of(context).colorScheme.secondary),
      ))),
    );
  }
}
