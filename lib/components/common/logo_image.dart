import 'package:flutter/widgets.dart';

class LogoImage extends StatelessWidget {
  static const String _logoImagePath = 'assets/images/jb_logo.jpg';
  final double? width;
  final double? height;

  const LogoImage({
    super.key,
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      _logoImagePath,
      width: width,
      height: height,
      fit: BoxFit.contain,
    );
  }
}
