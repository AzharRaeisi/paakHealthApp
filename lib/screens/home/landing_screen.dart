import 'package:flutter/material.dart';
import 'package:paakhealth/drawer/drawer.dart';
import 'package:paakhealth/screens/purchase/cart_screen.dart';
import 'package:paakhealth/screens/home/home_new_screen.dart';
import 'package:paakhealth/util/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // int _currentIndex = 1;
  // Widget currentScreen = MainHomeScreen();
  //
  // GlobalKey<ScaffoldState> _drawerKey = GlobalKey();



  // @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     // backgroundColor: Colors.red,
  //     key: _drawerKey,
  //     drawer: MainDrawer(),
  //     drawerEnableOpenDragGesture: false,
  //     bottomNavigationBar: BottomNavigationBar(
  //       currentIndex: _currentIndex,
  //       onTap: (value) {
  //         _currentIndex = value;
  //         switch (value) {
  //           case 0:
  //             _drawerKey.currentState.openDrawer();
  //             break;
  //           case 1:
  //             currentScreen = MainHomeScreen();
  //             break;
  //           case 2:
  //             currentScreen = CartScreen();
  //             break;
  //         }
  //         setState(() {});
  //       },
  //       selectedItemColor: AppColors.primaryColor,
  //       unselectedItemColor: Colors.grey,
  //       items: [
  //         BottomNavigationBarItem(
  //             icon: Icon(Icons.menu_outlined),
  //             // activeIcon: Icon(Icons.menu),
  //             label: ''),
  //         BottomNavigationBarItem(
  //             icon: Icon(Icons.home_outlined),
  //             activeIcon: Icon(Icons.home),
  //             label: ''),
  //         BottomNavigationBarItem(
  //             icon: Icon(Icons.shopping_cart_outlined),
  //             activeIcon: Icon(Icons.shopping_cart),
  //             label: ''),
  //       ],
  //     ),
  //     body: currentScreen,
  //   );
  // }

  PersistentTabController _controller;

  @override
  void initState() {
    super.initState();

    _controller = PersistentTabController(initialIndex: 0);

  }
  @override
  Widget build(BuildContext context) {
    return PersistentTabView(
      context,
      controller: _controller,
      screens: _buildScreens(),
      items: _navBarsItems(),
      confineInSafeArea: true,// Default is true.
      resizeToAvoidBottomInset: true, // This needs to be true if you want to move up the screen when keyboard appears. Default is true.
      hideNavigationBarWhenKeyboardShows: true, // Recommended to set 'resizeToAvoidBottomInset' as true while using this argument. Default is true.
      // decoration: NavBarDecoration(
      //   borderRadius: BorderRadius.circular(10.0),
      //   colorBehindNavBar: Colors.white,
      // ),
      popAllScreensOnTapOfSelectedTab: true,
      popActionScreens: PopActionScreensType.all,
      itemAnimationProperties: ItemAnimationProperties( // Navigation Bar's items animation properties.
        duration: Duration(milliseconds: 200),
        curve: Curves.ease,
      ),
      screenTransitionAnimation: ScreenTransitionAnimation( // Screen transition animation on change of selected tab.
        animateTabTransition: true,
        curve: Curves.ease,
        duration: Duration(milliseconds: 200),
      ),
      navBarStyle: NavBarStyle.style12, // Choose the nav bar style with this property.
    );
  }

  List<Widget> _buildScreens() {
    return [
      // MainDrawer(),
      // MainHomeScreen(),
      MainHomeScreen(),
      CartScreen()
    ];
  }

  List<PersistentBottomNavBarItem> _navBarsItems() {
    return [
      // PersistentBottomNavBarItem(
      //   icon: Icon(Icons.menu_outlined),
      //   activeColorPrimary: AppColors.primaryColor,
      //   inactiveColorPrimary: CupertinoColors.systemGrey,
      // ),
      PersistentBottomNavBarItem(
        icon: Icon(Icons.home),
        activeColorPrimary: AppColors.primaryColor,
        inactiveColorPrimary: CupertinoColors.systemGrey,
      ),
      PersistentBottomNavBarItem(
        icon: Icon(Icons.shopping_cart),
        activeColorPrimary: AppColors.primaryColor,
        inactiveColorPrimary: CupertinoColors.systemGrey,
      ),
    ];
  }


}
