//pages/signup_page.dart
import 'package:flutter/material.dart';
import 'package:jiwa_bakti/components/common/top_app_bar.dart';
import 'package:jiwa_bakti/components/signup_page/signup_main.dart';
import 'package:jiwa_bakti/models/social_signup_data.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({
    super.key,
    required this.option,
    this.socialData,
  });

  final String option;
  final SocialSignupData? socialData;

  @override
  State<SignupPage> createState() => SignupPageState();
}


class SignupPageState extends State<SignupPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.white,
      appBar: TopAppBar(width: MediaQuery.of(context).size.width, allowBack: true,),
      body: SignupMain(
        option: widget.option,
        socialData: widget.socialData,
      ),
    );
  }
}
