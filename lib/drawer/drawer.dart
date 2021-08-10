import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:paakhealth/models/api_response.dart';
import 'package:paakhealth/screens/address/address_book_screen.dart';
import 'package:paakhealth/screens/appointment/my_appointment_screen.dart';
import 'package:paakhealth/screens/auth/login_screen.dart';
import 'package:paakhealth/screens/blood_bank/blood_bank_screen.dart';
import 'package:paakhealth/screens/order/my_orders.dart';
import 'package:paakhealth/screens/profile/edit_profile_screen.dart';
import 'package:paakhealth/screens/wallet/wallet_screen.dart';
import 'package:paakhealth/services/account_services.dart';
import 'package:paakhealth/util/colors.dart';
import 'package:paakhealth/util/font.dart';
import 'package:paakhealth/util/prefernces.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MainDrawer extends StatefulWidget {
  final String title;

  const MainDrawer({Key key, this.title}) : super(key: key);

  @override
  _MainDrawerState createState() => _MainDrawerState();
}

class _MainDrawerState extends State<MainDrawer> {
  String customer_name;
  String customer_image;

  @override
  void initState() {
    setCustomerData();
    super.initState();
    if (widget.title != null) {
      _selectItem = widget.title;
    }
  }

  String _selectItem = '';

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(colors: [
          AppColors.primaryColor,
          AppColors.primaryColor,
        ])),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.symmetric(vertical: 40),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      height: 120,
                      width: 120,
                      child: CircleAvatar(
                        radius: MediaQuery.of(context).size.width / 3,
                        backgroundImage: customer_image == null
                            ? AssetImage('assets/avatar.png')
                            : customer_image.isEmpty
                                ? AssetImage('assets/avatar.png')
                                : NetworkImage(
                                    customer_image,
                                  ),
                      ),
                    ),
                    SizedBox(height: 14),
                    Text(
                      customer_name == null ? 'username' : customer_name,
                      style: TextStyle(
                        fontSize: 20.0,
                        fontFamily: AppFont.Gotham,
                        letterSpacing: 1,
                        fontWeight: FontWeight.w700,
                        color: AppColors.boxColor,
                      ),
                    ),
                  ],
                ),
              ),
              _buildDrawerItem(title: 'Home'),
              _buildDrawerItem(title: 'My Orders'),
              _buildDrawerItem(title: 'My Appointments'),
              _buildDrawerItem(title: 'Blood Bank'),
              _buildDrawerItem(title: 'My Wallet'),
              _buildDrawerItem(title: 'Customer Addresses'),
              // _buildDrawerItem(title: 'About Us'),
              _buildDrawerItem(title: 'Edit Profile'),
              _buildDrawerItem(title: 'Logout'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDrawerItem({String title}) {
    return GestureDetector(
      onTap: () async {
        _selectItem = title;
        setState(() {});

        // if (title == 'Home') {
        //   // Navigator.pop(context);
        // } else
        if (title == 'My Appointments') {
          // Navigator.pop(context);
          // Get.to(() => MyAppointmentScreen());
          pushNewScreen(
            context,
            screen: MyAppointmentScreen(),
            withNavBar: true, // OPTIONAL VALUE. True by default.
            pageTransitionAnimation: PageTransitionAnimation.cupertino,
          );
        } else if (title == 'My Wallet') {
          // Navigator.pop(context);
          // Get.to(() => WalletScreen());
          pushNewScreen(
            context,
            screen: WalletScreen(),
            withNavBar: true, // OPTIONAL VALUE. True by default.
            pageTransitionAnimation: PageTransitionAnimation.cupertino,
          );
        } else if (title == 'Customer Addresses') {
          // Navigator.pop(context);
          // Get.to(() => CustomerAddressesScreen());
          pushNewScreen(
            context,
            screen: CustomerAddressesScreen(),
            withNavBar: true, // OPTIONAL VALUE. True by default.
            pageTransitionAnimation: PageTransitionAnimation.cupertino,
          );
        } else if (title == 'Blood Bank') {
          // Navigator.pop(context);
          // Get.to(() => BloodBankScreen());
          pushNewScreen(
            context,
            screen: BloodBankScreen(),
            withNavBar: true, // OPTIONAL VALUE. True by default.
            pageTransitionAnimation: PageTransitionAnimation.cupertino,
          );
        } else if (title == 'My Orders') {
          // Navigator.pop(context);
          //
          // Get.to(() => MyOrdersScreen());
          pushNewScreen(
            context,
            screen: MyOrdersScreen(),
            withNavBar: true, // OPTIONAL VALUE. True by default.
            pageTransitionAnimation: PageTransitionAnimation.cupertino,
          );
        } else if (title == 'Edit Profile') {
          // Navigator.pop(context);

          // Get.to(() => EditProfileScreen());
          pushNewScreen(
            context,
            screen: EditProfileScreen(),
            withNavBar: true, // OPTIONAL VALUE. True by default.
            pageTransitionAnimation: PageTransitionAnimation.cupertino,
          );
        } else if (title == 'Logout') {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          prefs.clear();

          Navigator.pop(context);

          Get.offAll(() => LoginScreen());
        }
      },
      child: Column(
        children: [
          Container(
            color: Colors.grey[300],
            height: 3,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              (_selectItem == title)
                  ? Container(
                      color: Colors.white,
                      width: 12,
                      height: 44,
                    )
                  : Container(
                      color: Colors.transparent,
                      width: 12,
                      height: 44,
                    ),
              Expanded(
                child: Container(
                  padding: EdgeInsets.fromLTRB(35, 15, 0, 15),
                  child: Text(
                    title,
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      fontSize: 16.0,
                      fontFamily: AppFont.Gotham,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1,
                      color: AppColors.boxColor,
                    ),
                  ),
                ),
              )
            ],
          ),
          (title == 'Logout')
              ? Container(
                  color: Colors.grey[300],
                  height: 3,
                )
              : Container()
        ],
      ),
    );
  }

  Future<void> getProfile() async {
    var accountServices = AccountServices();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString(SharedPreVariables.TOKEN);

    print(token);
    APIResponse response = await accountServices.getProfile(token);
    if (response != null) {
      if (response.status == '1') {
        Map<String, dynamic> map = response.data;
        String imageUrl = map['profile_image'];

        await prefs.setString(SharedPreVariables.CUSTOMER_IMAGE, imageUrl);
        customer_image = imageUrl;

        setState(() {});
      } else {
        Get.snackbar('', response.message);
      }
    } else {
      print('API response is null');
      Get.snackbar('', 'Oops! Server is Down');
    }
  }

  Future<void> setCustomerData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    customer_name = prefs.getString(SharedPreVariables.CUSTOMER_NAME);
    customer_image = prefs.getString(SharedPreVariables.CUSTOMER_IMAGE);
    if (customer_image.isEmpty) {
      getProfile();
    }
    setState(() {});
  }
}
