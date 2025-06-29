import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:i_chef_application/constants/colors.dart';
import 'package:i_chef_application/view/pages/main_page/sub_pages/calender_page.dart';
import 'package:i_chef_application/view/pages/main_page/sub_pages/favourite_page.dart';
import 'package:i_chef_application/view/pages/main_page/sub_pages/generate_page.dart';
import 'package:i_chef_application/view/pages/main_page/sub_pages/home_page.dart';
import 'package:i_chef_application/view/pages/main_page/sub_pages/search_page.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final GlobalKey<CurvedNavigationBarState> _bottomNavigationBarKey =
      GlobalKey();

  final List<Widget> mainPages = [
    GeneratePage(),
    SearchPage(),
    HomePage(),
    FavouritePage(),
    CalenderPage(),
  ];

  int _selectedIndex = 2;

  void _onNavBarTap(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: CurvedNavigationBar(
        key: _bottomNavigationBarKey,
        index: _selectedIndex,
        items: [
          Icon(Icons.edit),
          Icon(Icons.search),
          Icon(Icons.home_outlined),
          Icon(Icons.favorite_outline_rounded),
          Icon(Icons.calendar_month),
        ],
        onTap: _onNavBarTap,
        buttonBackgroundColor: mainColor,
      ),
      body: Center(child: mainPages[_selectedIndex]),
    );
  }
}
