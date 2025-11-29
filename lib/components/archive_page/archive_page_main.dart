import 'package:flutter/material.dart';
import 'package:jiwa_bakti/components/archive_page/archive_list.dart';

class ArchivePageMain extends StatefulWidget{
  const ArchivePageMain({super.key});

  @override
  State<StatefulWidget> createState() => ArchivePageMainState();
}

class ArchivePageMainState extends State<ArchivePageMain>{

  @override
  Widget build(BuildContext context){
    return const SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(height: 15,),
          ArchiveList(),
        ],
      ),
    );
  }
}