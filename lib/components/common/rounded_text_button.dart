import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class RoundedTextButton extends StatelessWidget {
  final Text text;
  final VoidCallback? onPressed;
  final Color foregroundColor;
  final Color backgroundColor;
  final BorderSide? borderSide;
  final EdgeInsetsGeometry? padding;

  const RoundedTextButton({
    super.key,
    required this.text,
    required this.onPressed,
    required this.foregroundColor,
    required this.backgroundColor,
    this.borderSide,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      style: buttonStyle,
      child: FittedBox(
        child: text,
      ),
    );
  }

  @protected
  ButtonStyle get buttonStyle {
    return ButtonStyle(
      foregroundColor: MaterialStateProperty.all<Color>(foregroundColor),
      backgroundColor: MaterialStateProperty.all<Color>(backgroundColor),
      padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
        padding ??
            EdgeInsets.symmetric(
              vertical: 10.sp,
              horizontal: 10.sp
            ),
      ),
      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(
            9.sp,
          ),
          side: borderSide ?? BorderSide.none,
        ),
      ),
    );
  }
}
