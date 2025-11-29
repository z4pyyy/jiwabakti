import 'package:flutter/material.dart';
import 'package:jiwa_bakti/components/archive_detail_page/archive_detail_page_main.dart';
import 'package:jiwa_bakti/components/common/bottom_nav_bar.dart';

class ArchiveDetailPage extends StatefulWidget{
  const ArchiveDetailPage({super.key, required this.year, required this.month});

  final int year;
  final int month;

  @override
  State<StatefulWidget> createState() => ArchiveDetailPageState();
}

class ArchiveDetailPageState extends State<ArchiveDetailPage>{

  @override
  Widget build(BuildContext context){
    return Scaffold(
      body: ArchiveDetailPageMain(year: widget.year, month: widget.month,),
      bottomNavigationBar: const BottomNavBar(index: 2,),
    );
  }
}