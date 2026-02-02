import 'package:flutter/material.dart';
import 'package:jiwa_bakti/components/common/top_app_bar.dart';
import 'package:jiwa_bakti/components/profile_page/edit_profile_main.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => EditProfilePageState();
}

class EditProfilePageState extends State<EditProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.white,
      appBar: TopAppBar(width: MediaQuery.of(context).size.width, allowBack: true),
      body: const EditProfileMain(),
    );
  }
}
