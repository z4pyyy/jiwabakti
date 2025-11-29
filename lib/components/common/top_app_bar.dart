import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';

class TopAppBar extends StatefulWidget implements PreferredSizeWidget {
  const TopAppBar({
    super.key,
    required this.width,
    this.allowBack = false,
  });

  final double height = 80;
  final double width;
  final bool allowBack;

  @override
  State<TopAppBar> createState() => TopAppBarState();

  @override
  Size get preferredSize => Size(width, height);
}

class TopAppBarState extends State<TopAppBar> {

  @override
  Widget build(BuildContext context) {

    return SafeArea(
      child: PreferredSize(
        preferredSize: Size.fromHeight(widget.height),
        child: Container(
          height: widget.height,
          decoration: const BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Color.fromRGBO(210, 210, 210, 0.4),
                spreadRadius: 0,
                blurRadius: 5,
                offset: Offset(0.0, 5),
              ),
            ],
            color: Colors.white,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if(widget.allowBack)
                IconButton(
                  onPressed: () => context.pop(),
                  icon: const Icon(FontAwesomeIcons.arrowLeftLong, size: 22,),
                ),
              Container(
                color: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Image.asset(
                  "assets/images/jb_logo.jpg",
                  fit: BoxFit.contain,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
