import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:i_chef_application/constants/colors.dart';
import 'package:i_chef_application/provider/user_data_provider.dart';
import 'package:i_chef_application/view/pages/ai_chat_page/ai_chat_page.dart';
import 'package:i_chef_application/view/pages/main_page/sub_pages/calender_page.dart';
import 'package:i_chef_application/view/pages/main_page/sub_pages/favourite_page.dart';
import 'package:i_chef_application/view/pages/main_page/sub_pages/home_page.dart';
import 'package:i_chef_application/view/pages/main_page/sub_pages/search_page.dart';

class MainPage extends ConsumerStatefulWidget {
  const MainPage({super.key});

  @override
  ConsumerState<MainPage> createState() => _MainPageState();
}

class _MainPageState extends ConsumerState<MainPage> {
  final GlobalKey<CurvedNavigationBarState> _bottomNavigationBarKey =
      GlobalKey();

  final List<Widget> mainPages = [
    AiChatPage(),
    SearchPage(),
    HomePage(),
    FavouritePage(),
    CalenderPage(),
  ];

  int _selectedIndex = 2;

  @override
  void initState() {
    _updateUserOnce();

    super.initState();
  }

  // Only update once when the page is first built
  Future<void> _updateUserOnce() async {
    final userDataNotifier = ref.read(userDataProvider.notifier);

    try {
      await userDataNotifier
          .getUserDataFromFirebase(); // or updateUserInFirebase()
      // Optionally: show a toast/snackBar for success
    } catch (e) {
      debugPrint("Failed to update user data: $e");
    }
  }

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
        items: const [
          Icon(Icons.chat),
          Icon(Icons.search),
          Icon(Icons.home_outlined),
          Icon(Icons.favorite_outline_rounded),
          Icon(Icons.calendar_month),
        ],
        onTap: _onNavBarTap,
        buttonBackgroundColor: mainColor,
      ),
      body: mainPages[_selectedIndex],
    );
  }
}
