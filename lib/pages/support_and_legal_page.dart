import 'package:flutter/material.dart';
import 'package:jiwa_bakti/components/common/top_app_bar.dart';
import 'package:jiwa_bakti/components/support_and_legal_page/support_and_legal_main.dart';

class SupportAndLegalPage extends StatefulWidget {
  const SupportAndLegalPage({super.key});

  @override
  State<SupportAndLegalPage> createState() => SupportAndLegalPageState();
}

class SupportAndLegalPageState extends State<SupportAndLegalPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: TopAppBar(width: MediaQuery.of(context).size.width, allowBack: true,),
      body: const SupportAndLegalMain(),
    );
  }
}
