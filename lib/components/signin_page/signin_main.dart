import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:jiwa_bakti/components/common/custom_divider.dart';
import 'package:jiwa_bakti/components/signin_page/signin_card.dart';

class SigninMain extends StatefulWidget {
  const SigninMain({Key? key}) : super(key: key);

  @override
  State<SigninMain> createState() => SigninMainState();
}

class SigninMainState extends State<SigninMain> {

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Selamat datang",
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 5),
          const Text(
            "Masukkan alamat e-mel dan kata laluan anda untuk daftar masuk ke aplikasi JiwaBakti anda.",
            style: TextStyle(
              fontSize: 16,
              height: 1.3,
            ),
          ),
          const SizedBox(height: 5),
          const CustomDivider(),
          const SizedBox(height: 5),
          const Text(
            "Belum mempunyai akaun?",
            style: TextStyle(
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 10),
          InkWell(
            onTap: (){
              context.push("/signup-option");
            },
            child: const Text(
              "Daftar di sini",
              style: TextStyle(
                fontSize: 16,
                decoration: TextDecoration.underline,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const SizedBox(height: 30),
          const SigninCard(),
          const SizedBox(height: 60),
        ],
      )
    );
  }
}
