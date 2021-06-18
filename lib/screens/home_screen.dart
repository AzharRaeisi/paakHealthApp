import 'package:flutter/material.dart';
import 'package:paakhealth/drawer/drawer.dart';
import 'package:paakhealth/screens/cart_screen.dart';
import 'package:paakhealth/screens/home_new_screen.dart';
import 'package:paakhealth/screens/main_screen.dart';
import 'package:paakhealth/util/colors.dart';
class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {


  int _currentIndex = 1;
  Widget currentScreen = MainHomeScreen();

  GlobalKey<ScaffoldState> _drawerKey = GlobalKey();




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.red,
      key: _drawerKey,
      drawer: MainDrawer(),
      drawerEnableOpenDragGesture: false,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (value) {
          _currentIndex = value;
          switch (value) {
            case 0:
              _drawerKey.currentState.openDrawer();
              break;
            case 1:
              currentScreen = MainHomeScreen();
              break;
            case 2:
              currentScreen = CartScreen();
              break;
          }
          setState(() {});
        },
        selectedItemColor: AppColors.primaryColor,
        unselectedItemColor: Colors.grey,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.menu_outlined),
            // activeIcon: Icon(Icons.menu),
            label: ''
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              activeIcon: Icon(Icons.home),
              label: ''
              ),
          BottomNavigationBarItem(
              icon: Icon(Icons.shopping_cart_outlined),
              activeIcon: Icon(Icons.shopping_cart),
              label: ''
              ),
        ],
      ),
      body: currentScreen,
    );
  }



}
