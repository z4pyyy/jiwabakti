import 'package:flutter/material.dart';
import 'package:jiwa_bakti/components/common/top_app_bar.dart';
import 'package:jiwa_bakti/components/signup_option_page/signup_option_page_main.dart';

class SignupOptionPage extends StatefulWidget {
  const SignupOptionPage({super.key});

  @override
  State<SignupOptionPage> createState() => SignupOptionPageState();
}

class SignupOptionPageState extends State<SignupOptionPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.white,
      appBar: TopAppBar(width: MediaQuery.of(context).size.width, allowBack: true,),
      body: const SignupOptionPageMain(),
    );
  }
}
