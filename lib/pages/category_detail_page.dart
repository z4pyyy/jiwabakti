import 'package:flutter/material.dart';
import 'package:jiwa_bakti/components/category_detail_page/category_detail_page_main.dart';
import 'package:jiwa_bakti/components/common/bottom_nav_bar.dart';

class CategoryDetailPage extends StatefulWidget{
  const CategoryDetailPage({super.key, required this.categoryId});

  final int categoryId;

  @override
  State<StatefulWidget> createState() => CategoryDetailPageState();
}

class CategoryDetailPageState extends State<CategoryDetailPage>{

  @override
  Widget build(BuildContext context){
    return Scaffold(
      body: CategoryDetailPageMain(categoryId: widget.categoryId),
      bottomNavigationBar: const BottomNavBar(index: 1,),
    );
  }
}