import 'package:flutter/material.dart';
import 'package:jiwa_bakti/components/common/bottom_nav_bar.dart';
import 'package:jiwa_bakti/components/common/top_app_bar.dart';
import 'package:jiwa_bakti/components/terkini_page/terkini_page_main.dart';

class TerkiniPage extends StatefulWidget {
  const TerkiniPage({super.key, this.openArticleId});
  final int? openArticleId;

  @override
  State<TerkiniPage> createState() => TerkiniPageState();
}

class TerkiniPageState extends State<TerkiniPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: TerkiniPageMain(openArticleId: widget.openArticleId),
      bottomNavigationBar: const BottomNavBar(index: 0),
    );
  }
}