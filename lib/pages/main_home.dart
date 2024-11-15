import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:rg_mana/pages/home_page.dart';
import 'package:rg_mana/pages/notifications_page.dart';
import 'package:rg_mana/pages/profile_page.dart';
import 'package:rg_mana/pages/users_page.dart';

import 'GDGo.dart';

class MainHome extends StatefulWidget {
  MainHome({super.key});

  @override
  State<MainHome> createState() => _MainHomeState();
}

class _MainHomeState extends State<MainHome> {
  int _selectedIndex = 0;

  void _navigateBottomBar(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  final List _pages = [
    HomePage(),
    NotificationsPage(),
    GDGoPage(),
    UsersPage(),
    ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: 
        Container(
          width: MediaQuery.of(context).size.width,
          color: Colors.black,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 20.0),
            child:
              SafeArea(
                child: GNav(
                  backgroundColor: Colors.black,
                  color: Colors.white,
                  activeColor: Colors.white,
                  tabBackgroundColor: Colors.grey.shade800,
                  gap: 8,
                  onTabChange: _navigateBottomBar,
                  padding: EdgeInsets.all(16),
                  tabs: const [
                    GButton(
                      icon: Icons.home_rounded,
                      text: 'Home',
                      iconActiveColor: Color(0xFF3A86FF),
                    ),
                    GButton(
                      icon: Icons.favorite_rounded,
                      text: 'News',
                      iconActiveColor: Color(0xFFFF2929),
                    ),
                    GButton(
                      icon: Icons.add_box_rounded,
                      iconSize: 40,
                      iconActiveColor: Color(0xFF48CFCB),
                    ),
                    GButton(
                      icon: Icons.search_rounded,
                      text: 'Users',
                      iconActiveColor: Color(0xFFFFD166),
                    ),
                    GButton(
                      icon: Icons.account_circle_rounded,
                      text: 'Profile',
                      iconActiveColor: Color(0xFF06D6A0),
                    ),
                  ],
                ),
              ),
          ),
        )
    );
  }
}
