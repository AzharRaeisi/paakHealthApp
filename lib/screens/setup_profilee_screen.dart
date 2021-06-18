import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:paakhealth/models/api_response.dart';
import 'package:paakhealth/models/setup_profile_model.dart';
import 'package:paakhealth/screens/welcome_back_screen.dart';
import 'package:paakhealth/services/account_services.dart';
import 'package:paakhealth/util/colors.dart';
import 'package:paakhealth/util/prefernces.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SetupProfileeScreen extends StatefulWidget {


  const SetupProfileeScreen({Key key}) : super(key: key);

  @override
  _SetupProfileeScreenState createState() => _SetupProfileeScreenState();
}

class _SetupProfileeScreenState extends State<SetupProfileeScreen> {
  File _image;

  void getImage(ImageSource source) async {
    final pickedFile = await ImagePicker().getImage(source: source);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.all(30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.asset('assets/paakhealth.png'),
              SizedBox(height: 20),
              Text(
                'Set Up Profile',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryColor,
                    fontSize: 20),
              ),
              SizedBox(height: 30),
              Text('Upload Picture'),
              SizedBox(height: 10),
              Text(
                'Click the avatar to select your photo.',
                style: TextStyle(fontSize: 10),
              ),
              SizedBox(height: 30),
              GestureDetector(
                onTap: () {
                  getImage(ImageSource.gallery);
                },
                child: Container(
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(50.0)),
                    ),
                    alignment: Alignment.center,
                    padding: EdgeInsets.symmetric(vertical: 5),
                    child: CircleAvatar(
                      radius: MediaQuery.of(context).size.width / 3,
                      backgroundImage: _image == null
                          ? AssetImage('assets/avatar.png')
                          : FileImage(_image),
                    )),
              ),
              Expanded(child: Container()),
              _primaryBtn(btnText: 'Next'),
              SizedBox(height: 14),
              GestureDetector(
                onTap: () {
                  saveProfile('');
                },
                child: Center(child: Text('Skip >')),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _primaryBtn({String btnText}) {
    return GestureDetector(
      onTap: () async {
        // todo pass profile image url
        saveProfile('');
      },
      child: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: <Color>[
              Color(0xFF69C4F0),
              Color(0xFF00B2EE),
            ],
          ),
          borderRadius: BorderRadius.all(Radius.circular(5.0)),
        ),
        alignment: Alignment.center,
        padding: EdgeInsets.symmetric(vertical: 15),
        child: Text(
          btnText,
          style: TextStyle(color: Colors.white, fontSize: 18),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  saveProfile(String profile) async {
    var accountServices = AccountServices();
    // todo change device token
    // SharedPreferences prefs = await SharedPreferences.getInstance();
    // String token = prefs.getString(SharedPreVariables.TOKEN);
    // APIResponse response = await accountServices.saveProfile(
    //   token: token,
    //   name: widget.model.name,
    //   email: widget.model.email,
    //   gender: widget.model.gender,
    //   profile_image: profile,
    // );
    // if (response != null) {
    //   if (response.status == '1') {
    //     Get.snackbar('', response.message);
    //     Get.to(WelcomeBackScreen());
    //   } else {
    //     Get.snackbar('', response.message);
    //   }
    // } else {
    //   print('API response is null');
    //   Get.snackbar('', 'Oops! Server is Down');
    // }
  }

  Widget _profileImage() {
    return Stack(
      children: [
        CircleAvatar(
          radius: MediaQuery.of(context).size.width / 4,
          backgroundImage: _image == null
              ? AssetImage('assets/avatar.png')
              : FileImage(_image),
        )
      ],
    );
  }

  // return IconButton(
  // icon: Icon(Icons.camera_alt),
  // onPressed: () {
  // showModalBottomSheet(
  // context: context,
  // builder: ((builder) => bottomSheet()),
  // );
  // });

  Widget bottomSheet() {
    return Container(
      height: 100,
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Choose Profile Photo'),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextButton.icon(
                  onPressed: () {
                    getImage(ImageSource.camera);
                  },
                  icon: Icon(Icons.camera),
                  label: Text('Camera')),
              TextButton.icon(
                  onPressed: () {
                    getImage(ImageSource.gallery);
                  },
                  icon: Icon(Icons.image),
                  label: Text('Gallery')),
            ],
          ),
        ],
      ),
    );
  }
}
