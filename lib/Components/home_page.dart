import 'package:eyebaituna_app/Components/dashboard.dart';
import 'package:eyebaituna_app/Components/schedule_page.dart';
import 'package:eyebaituna_app/Components/user_profile.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePage();
}

class _HomePage extends State<HomePage> {
  int currentPageIndex = 0;

  void _navigateBottomBar(int index) {
    setState(() {
      currentPageIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: const <Widget>[
        Dashboard(),
        Schedule(),
        UserProfile(),
      ][currentPageIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentPageIndex,
        onTap: _navigateBottomBar,
        backgroundColor: const Color.fromRGBO(20, 21, 23, 1),
        showSelectedLabels: false,
        showUnselectedLabels: false,
        elevation: 25,
        items: const [
          BottomNavigationBarItem(
              activeIcon: Icon(Iconsax.setting_5,
                  color: Color.fromRGBO(120, 120, 250, 1)),
              icon: Icon(
                Iconsax.setting_5,
                color: Color.fromRGBO(167, 167, 204, 1),
              ),
              label: 'Dashboard'),
          BottomNavigationBarItem(
              activeIcon:
                  Icon(Iconsax.clock, color: Color.fromRGBO(120, 120, 250, 1)),
              icon:
                  Icon(Iconsax.clock, color: Color.fromRGBO(167, 167, 204, 1)),
              label: 'Schedule'),
          BottomNavigationBarItem(
              activeIcon:
                  Icon(Iconsax.user, color: Color.fromRGBO(120, 120, 250, 1)),
              icon: Icon(Iconsax.user, color: Color.fromRGBO(167, 167, 204, 1)),
              label: 'Profile')
        ],
      ),
    );
  }
}
