import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:zwap_test/res/colors/colors.dart';

class BottomNav extends StatefulWidget {
  final int index;
  final Function(int) onTabTapped;

  const BottomNav({
    Key? key,
    this.index = 0,
    required this.onTabTapped,
  }) : super(key: key);

  @override
  State<BottomNav> createState() => _BottomNavState();
}

class _BottomNavState extends State<BottomNav> {
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.index;
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      showSelectedLabels: false,
      showUnselectedLabels: false,
      currentIndex: _currentIndex,
      onTap: (index) {
        setState(() {
          _currentIndex = index;
        });
        widget.onTabTapped(index);
      },
      fixedColor: AppColor.primaryDark,
      unselectedItemColor: Colors.black87,
      items: [
        BottomNavigationBarItem(
          icon: SvgPicture.asset(
            'assets/icons/home-inactive.svg',
            height: 24.0,
            width: 24.0,
          ),
          activeIcon: SvgPicture.asset(
            'assets/icons/home-active.svg',
            height: 24.0,
            width: 24.0,
          ),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: SvgPicture.asset(
            'assets/icons/search-inactive.svg',
            height: 24.0,
            width: 24.0,
          ),
          activeIcon: SvgPicture.asset(
            'assets/icons/search-active.svg',
            height: 24.0,
            width: 24.0,
          ),
          label: 'Explore',
        ),
        BottomNavigationBarItem(
          icon: SvgPicture.asset(
            'assets/icons/add-inactive.svg',
            height: 24.0,
            width: 24.0,
          ),
          activeIcon: SvgPicture.asset(
            'assets/icons/add-active.svg',
            height: 24.0,
            width: 24.0,
          ),
          label: 'Post',
        ),
        BottomNavigationBarItem(
          icon: SvgPicture.asset(
            'assets/icons/swap-inactive.svg',
            height: 24.0,
            width: 24.0,
          ),
          activeIcon: SvgPicture.asset(
            'assets/icons/swap-active.svg',
            height: 24.0,
            width: 24.0,
          ),
          label: 'Requests',
        ),
        BottomNavigationBarItem(
          icon: SvgPicture.asset(
            'assets/icons/chat-inactive.svg',
            height: 24.0,
            width: 24.0,
          ),
          activeIcon: SvgPicture.asset(
            'assets/icons/chat-active.svg',
            height: 24.0,
            width: 24.0,
          ),
          label: 'Chat',
        ),
      ],
    );
  }
}
