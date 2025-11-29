import 'package:flutter/material.dart';
import 'package:jiwa_bakti/components/category_page/category_page_main.dart';
import 'package:jiwa_bakti/components/common/bottom_nav_bar.dart';
import 'package:jiwa_bakti/components/common/top_app_bar.dart';

class CategoryPage extends StatefulWidget{
  const CategoryPage({super.key});

  @override
  State<StatefulWidget> createState() => CategoryPageState();
}

class CategoryPageState extends State<CategoryPage>{

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: TopAppBar(width: MediaQuery.sizeOf(context).width,),
      body: const CategoryPageMain(),
      bottomNavigationBar: const BottomNavBar(index: 1,),
    );
  }
}