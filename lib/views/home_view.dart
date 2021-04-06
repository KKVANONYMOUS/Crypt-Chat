import 'package:crypt_chat/views/chat_rooms_view.dart';
import 'package:crypt_chat/views/profile_view.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _pageIndex = 0;
  PageController _pageController;

  List<Widget> tabPages = [
   ChatRooms(),
   ProfileScreen(),
  ];

  @override
  void initState(){
    super.initState();
    _pageController = PageController(initialPage: _pageIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        bottomNavigationBar:BottomNavigationBar(
          currentIndex: _pageIndex,
          type: BottomNavigationBarType.fixed,
          onTap: onTabTapped,
          items: [
            BottomNavigationBarItem(
                icon: Icon(Icons.message_rounded), label: "Chats"),
            BottomNavigationBarItem(
                icon: CircleAvatar(
                  backgroundImage: AssetImage("assets/images/user_avatar.png"),
                  radius: 12,
                ),
                label: "Profile"),
          ],

        ),
      body: PageView(
        children: tabPages,
        onPageChanged: onPageChanged,
        controller: _pageController,
    ),
    );
  }
  void onPageChanged(int page) {
    setState(() {
      this._pageIndex = page;
    });
  }

  void onTabTapped(int index) {
    this._pageController.animateToPage(index,duration: const Duration(milliseconds: 300),curve: Curves.easeInOut);
  }
}
