import 'package:flutter/material.dart';
import 'package:jiwa_bakti/components/common/bottom_nav_bar.dart';
import 'package:jiwa_bakti/components/common/top_app_bar.dart';
import 'package:jiwa_bakti/components/profile_page/profile_page_main.dart';

class ProfilePage extends StatefulWidget{
  const ProfilePage({super.key});

  @override
  State<StatefulWidget> createState() => ProfilePageState();
}

class ProfilePageState extends State<ProfilePage>{

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: TopAppBar(width: MediaQuery.sizeOf(context).width,),
      body: const ProfilePageMain(),
      bottomNavigationBar: const BottomNavBar(index: 3,),
    );
  }
}