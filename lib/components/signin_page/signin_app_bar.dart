import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:jiwa_bakti/components/common/custom_icon_button.dart';
import 'package:jiwa_bakti/components/common/logo_image.dart';

class SigninAppBar extends StatefulWidget implements PreferredSizeWidget {
  const SigninAppBar({
    super.key,
    required this.width,
  });

  final double height = 80;
  final double width;

  @override
  State<SigninAppBar> createState() => SigninAppBarState();

  @override
  Size get preferredSize => Size(width, height);
}

class SigninAppBarState extends State<SigninAppBar> {

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: PreferredSize(
        preferredSize: Size.fromHeight(widget.height),
        child: Container(
          height: widget.height,
          decoration: const BoxDecoration(
            color: Colors.white,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CustomIconButton(
                icon: Icons.close,
                size: 30,
                onPressed: (){},
                hide: true,
              ),
              LogoImage(
                width: widget.width*0.65
              ),
              CustomIconButton(
                icon: Icons.close,
                size: 30,
                onPressed: (){
                  context.pop();
                },
              ),
            ]
          ),
        ),
      ),
    );
  }
}
