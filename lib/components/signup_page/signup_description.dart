import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';

class SignupDescription extends StatelessWidget {
  const SignupDescription({Key? key,}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Sudah mempunyai akaun? ",
              style: TextStyle(fontSize: 16,),
            ),
            InkWell(
              onTap: (){
                context.push("/signin");
              },
              child: const Text(
                "Daftar Masuk",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 15),
        const Text(
          "Berita JiwaBakti",
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 5),
        Text(
          "Akses tanpa had kepada berita yang tidak berat sebelah",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 10),
        Text(
          "Daftar percuma di aplikasi JiwaBakti memberi anda:",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            height: 1.3,
          ),
        ),
        const SizedBox(height: 15),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(Icons.check_circle_rounded, size: 28, color: Colors.green,),
            const SizedBox(width: 20,),
            Expanded(
              child: Text(
                "Akses tanpa had kepada berita JiwaBakti",
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 15),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(Icons.check_circle_rounded, size: 28, color: Colors.green,),
            const SizedBox(width: 20,),
            Expanded(
              child: Text(
                "Berita tertumpu industri, penghantaran ke peti masuk anda",
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 15),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(Icons.check_circle_rounded, size: 28, color: Colors.green,),
            const SizedBox(width: 20,),
            Expanded(
              child: Text(
                "Berita di hujung jari anda, dengan aplikasi JiwaBakti",
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
