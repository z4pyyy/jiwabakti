import 'package:flutter/material.dart';

class CustomIconButton extends StatelessWidget {
  final double size;
  final IconData icon;
  final VoidCallback onPressed;
  final bool hide;

  const CustomIconButton({
    super.key,
    required this.size,
    required this.icon,
    required this.onPressed,
    this.hide = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: IconButton(
        color: hide
            ? Colors.white.withOpacity(0)
            : Colors.grey,
        icon: Icon(
          icon,
          size: size,
        ),
        onPressed: onPressed,
      ),
    );
  }
}
