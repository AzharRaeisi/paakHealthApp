import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:paakhealth/screens/blood_bank_screen.dart';
import 'package:paakhealth/screens/customer_addresses_screen.dart';
import 'package:paakhealth/screens/home_new_screen.dart';
import 'package:paakhealth/screens/my_appointment_screen.dart';
import 'package:paakhealth/screens/my_orders.dart';
import 'package:paakhealth/screens/wallet_screen.dart';
import 'package:paakhealth/util/colors.dart';
import 'package:paakhealth/util/prefernces.dart';
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
                            : NetworkImage(
                                customer_image,
                              ),
                      ),
                    ),
                    SizedBox(height: 14),
                    Text(
                      customer_name == null ? 'username' : customer_name,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          letterSpacing: 1,
                          fontSize: 20),
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
              _buildDrawerItem(title: 'Contact Us'),
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
      onTap: () {
        _selectItem = title;
        setState(() {});

        if (title == 'Home') {
          Navigator.pop(context);
          // Navigator.popUntil(context, ModalRoute.withName('/home'));
          Get.to(() => MainHomeScreen());

        } else if (title == 'My Appointments') {
          Navigator.pop(context);
          Get.to(() => MyAppointmentScreen());
        } else if (title == 'My Wallet') {
          Navigator.pop(context);
          Get.to(() => WalletScreen());
        } else if (title == 'Customer Addresses') {
          Navigator.pop(context);
          Get.to(() => CustomerAddressesScreen());
        } else if (title == 'Blood Bank') {
          Navigator.pop(context);
          Get.to(() => BloodBankScreen());
        } else if (title == 'My Orders') {
          Navigator.pop(context);

          Get.to(() => MyOrdersScreen());
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
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1,
                        fontSize: 16,
                        color: Colors.white),
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

  Future<void> setCustomerData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    customer_name = prefs.getString(SharedPreVariables.CUSTOMER_NAME);
    customer_image = prefs.getString(SharedPreVariables.CUSTOMER_IMAGE);
    setState(() {});
  }
}
