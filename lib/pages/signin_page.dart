import 'package:flutter/material.dart';
import 'package:jiwa_bakti/components/signin_page/signin_app_bar.dart';
import 'package:jiwa_bakti/components/signin_page/signin_main.dart';

class SigninPage extends StatefulWidget {
  const SigninPage({Key? key}) : super(key: key);

  @override
  State<SigninPage> createState() => SigninPageState();
}

class SigninPageState extends State<SigninPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: SigninAppBar(width: MediaQuery.of(context).size.width),
      body: const SigninMain(),
    );
  }
}
