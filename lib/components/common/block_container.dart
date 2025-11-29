import 'package:flutter/material.dart';

class BlockContainer extends StatelessWidget {
  const BlockContainer({super.key, required this.child,});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        border: Border.symmetric(
          horizontal: BorderSide(
              color: Colors.grey,
              width: 0.3),
        ),
        color: Colors.white,
      ),
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
      child: child,
    );
  }
}
