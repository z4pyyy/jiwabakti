import 'package:flutter/material.dart';
import 'package:jiwa_bakti/themes/color_theme.dart';

class CustomDivider extends StatelessWidget {
  const CustomDivider({Key? key,}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Divider(
      thickness: 0.5,
      color: theme.primaryColor
    );
  }
}
