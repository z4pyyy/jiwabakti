import 'package:flutter/material.dart';
import 'package:jiwa_bakti/components/common/bottom_nav_bar.dart';
import 'package:jiwa_bakti/components/common/top_app_bar.dart';
import 'package:jiwa_bakti/components/saved_news_page/saved_news_page_main.dart';

class SavedNewsPage extends StatefulWidget{
  const SavedNewsPage({super.key});

  @override
  State<StatefulWidget> createState() => SavedNewsPageState();
}

class SavedNewsPageState extends State<SavedNewsPage>{

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: TopAppBar(width: MediaQuery.sizeOf(context).width, allowBack: true,),
      body: const SavedNewsPageMain(),
      bottomNavigationBar: const BottomNavBar(index: 3,),
    );
  }
}