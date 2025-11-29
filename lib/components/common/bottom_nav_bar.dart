import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';

class BottomNavBar extends StatefulWidget {
  const BottomNavBar({super.key, required this.index, this.showAllUnselected = false});

  final int index;
  final bool showAllUnselected;

  @override
  State<BottomNavBar> createState() => BottomNavBarState();
}

class BottomNavBarState extends State<BottomNavBar> {
  int _currentIndex = 0;

  static final Map<int, String> _bottomBarRouteMap = {
    0: "/",
    1: "/category",
    2: "/archive",
    3: "/profile"
  };

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.index;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
      ),
      child: Container(
          decoration: const BoxDecoration(
            boxShadow: [
              BoxShadow(
                  color: Color.fromRGBO(210, 210, 210, 1.0),
                  spreadRadius: 0,
                  blurRadius: 6),
            ],
          ),
          child: ClipRRect(
            child: BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              currentIndex: _currentIndex,
              backgroundColor: Colors.white,
              selectedItemColor: Colors.black,
              unselectedItemColor: Colors.grey,
              showUnselectedLabels: true,
              selectedIconTheme: IconTheme.of(context).copyWith(
                color: Colors.black,
              ),
              unselectedIconTheme: IconTheme.of(context).copyWith(
                color: Colors.grey.withOpacity(0.85),
              ),
              selectedLabelStyle: const TextStyle(fontSize: 12),
              unselectedLabelStyle: const TextStyle(fontSize: 12),
              items: const [
                BottomNavigationBarItem(
                    icon: Icon(Icons.trending_up_rounded, size: 28,),
                    label: "Terkini",
                    backgroundColor: Colors.white),
                BottomNavigationBarItem(
                    icon: Icon(FontAwesomeIcons.list, size: 24,),
                    label: "Kategori",
                    backgroundColor: Colors.white),
                BottomNavigationBarItem(
                    icon: Icon(FontAwesomeIcons.boxArchive, size: 24,),
                    label: "Arkib",
                    backgroundColor: Colors.white),
                BottomNavigationBarItem(
                    icon: Icon(FontAwesomeIcons.circleUser, size: 24,),
                    label: "Profil",
                    backgroundColor: Colors.white),
              ],
              onTap: (value) {
                setState(() {
                  _currentIndex = value;
                  context.push(_bottomBarRouteMap[_currentIndex] ?? "/");
                });
              },
            ),
          )
        )
    );
  }
}