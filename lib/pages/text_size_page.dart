import 'package:flutter/material.dart';
import 'package:jiwa_bakti/components/common/top_app_bar.dart';
import 'package:jiwa_bakti/components/test_size_page/text_size_main.dart';

class TextSizePage extends StatefulWidget {
  const TextSizePage({Key? key}) : super(key: key);

  @override
  State<TextSizePage> createState() => TextSizePageState();
}

class TextSizePageState extends State<TextSizePage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: TopAppBar(width: MediaQuery.of(context).size.width, allowBack: true,),
      body: const TextSizeMain(),
    );
  }
}
