import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:social_pedometer/utility/global_vars.dart';

class MobileLayout extends StatefulWidget {
  const MobileLayout({super.key});

  @override
  State<MobileLayout> createState() => _MobileLayoutState();
}

class _MobileLayoutState extends State<MobileLayout> {
  int _page = 0;
  late PageController pageController;
  @override
  void initState() {
    
    super.initState();
    pageController = PageController();
  }

  @override
  void dispose() {
    
    super.dispose();
    pageController.dispose();
  }

  void navigationTab(int page) {
    pageController.jumpToPage(page);
  }

  void onPageChanged(int page) {
    setState(() {
      _page = page;
    });
  }
  @override
  Widget build(BuildContext context) {
    Color primaryColor = Colors.white;
    Color secondaryColor = Colors.grey;

   
    return Scaffold(
      body: PageView(
        physics: const NeverScrollableScrollPhysics(),
        controller: pageController,
        onPageChanged: onPageChanged,
        children: homeScreenItems,
      ),
      bottomNavigationBar: CupertinoTabBar(
        backgroundColor: Colors.black,
        items: [
          BottomNavigationBarItem(
              icon: Icon(Icons.directions_walk, color : _page == 0 ? primaryColor : secondaryColor), label: '', backgroundColor: secondaryColor),
              BottomNavigationBarItem(
              icon: Icon(Icons.leaderboard, color : _page == 1 ? primaryColor : secondaryColor), label: '', backgroundColor: secondaryColor),
              BottomNavigationBarItem(
              icon: Icon(Icons.person, color : _page == 2 ? primaryColor : secondaryColor), label: '', backgroundColor: secondaryColor),
              
              
        ],onTap: navigationTab,
      ),
    );
  }
}
