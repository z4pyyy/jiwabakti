import 'package:flutter/material.dart';
import 'package:jiwa_bakti/components/archive_page/archive_page_main.dart';
import 'package:jiwa_bakti/components/common/bottom_nav_bar.dart';
import 'package:jiwa_bakti/components/common/top_app_bar.dart';

class ArchivePage extends StatefulWidget{
  const ArchivePage({super.key});

  @override
  State<StatefulWidget> createState() => ArchivePageState();
}

class ArchivePageState extends State<ArchivePage>{

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: TopAppBar(width: MediaQuery.sizeOf(context).width,),
      body: const ArchivePageMain(),
      bottomNavigationBar: const BottomNavBar(index: 2,),
    );
  }
}