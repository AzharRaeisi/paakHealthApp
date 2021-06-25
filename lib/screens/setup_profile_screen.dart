import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:paakhealth/models/api_response.dart';
import 'package:paakhealth/models/setup_profile_model.dart';
import 'package:paakhealth/screens/enter_code_screen.dart';
import 'package:paakhealth/screens/home_screen.dart';
import 'package:paakhealth/screens/setup_profilee_screen.dart';
import 'package:paakhealth/screens/welcome_back_screen.dart';
import 'package:paakhealth/services/account_services.dart';
import 'package:paakhealth/util/colors.dart';
import 'package:paakhealth/util/prefernces.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SetupProfileScreen extends StatefulWidget {
  @override
  _SetupProfileScreenState createState() => _SetupProfileScreenState();
}

class _SetupProfileScreenState extends State<SetupProfileScreen> {
  GlobalKey<FormState> _key = GlobalKey<FormState>();
  TextEditingController _userNameController = new TextEditingController();
  TextEditingController _emailController = new TextEditingController();
  TextEditingController _phoneController = new TextEditingController();
  TextEditingController _passwordController = new TextEditingController();
  TextEditingController _confirmPasswordController =
      new TextEditingController();

  int _gender = 0;
  String gender = '';
  bool processing = false;

  @override
  void initState() {
    // TODO: implement initState
    checkUserStatus();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.all(30),
          child: SingleChildScrollView(
            child: Form(
              key: _key,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(child: Image.asset('assets/paakhealth.png')),
                  SizedBox(height: 20),
                  Text(
                    'Welcome',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: AppColors.primaryColor,
                        fontSize: 20),
                  ),
                  SizedBox(height: 25),
                  buildNameTextField(),
                  SizedBox(height: 14),
                  // buildEmailTextField(),
                  buildPhoneTextField(),
                  SizedBox(height: 14),
                  buildPasswordTextField(),
                  SizedBox(height: 14),
                  buildConfirmPasswordTextField(),
                  SizedBox(height: 14),
                  Row(
                    children: [
                      Expanded(
                        child: ListTile(
                          contentPadding: EdgeInsets.zero,
                          leading: Radio(
                            value: 1,
                            activeColor: AppColors.primaryColor,
                            groupValue: _gender,
                            onChanged: (value) {
                              _gender = value;
                              gender = 'male';
                              setState(() {});
                            },
                          ),
                          title: Text('Male'),
                        ),
                      ),
                      Expanded(
                        child: ListTile(
                          contentPadding: EdgeInsets.zero,
                          leading: Radio(
                            value: 2,
                            activeColor: AppColors.primaryColor,
                            groupValue: _gender,
                            onChanged: (value) {
                              _gender = value;
                              gender = 'female';
                              setState(() {});
                            },
                          ),
                          title: Text('Female'),
                        ),
                      ),
                    ],
                  ),
                  // Expanded(child: Container()),
                  SizedBox(height: 20),

                  processing
                      ? Center(child: CircularProgressIndicator())
                      : _primaryBtn(btnText: 'Next'),
                  SizedBox(height: 20),
                  _row(
                      firstStr: 'Already have an account?',
                      secondStr: 'Sign In')
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  TextFormField buildNameTextField() {
    return TextFormField(
      controller: _userNameController,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: (value) {
        if (value.length > 2)
          return null;
        else
          return 'Username must be at least of 3 characters';
      },
      decoration: InputDecoration(
          border: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey[100], width: 1.0),
              borderRadius: BorderRadius.circular(5)),
          hintText: 'Username'),
    );
  }

  TextFormField buildEmailTextField() {
    return TextFormField(
      controller: _emailController,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: (value) {
        if (RegExp(
                r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
            .hasMatch(value))
          return null;
        else {
          return 'Enter valid email.';
        }
      },
      decoration: InputDecoration(
          border: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey[100], width: 1.0),
              borderRadius: BorderRadius.circular(5)),
          hintText: 'Email'),
    );
  }

  TextFormField buildPhoneTextField() {
    return TextFormField(
      controller: _phoneController,
      maxLength: 10,
      keyboardType: TextInputType.number,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: (value) {
        if (value.length == 10)
          return null;
        else
          return 'Enter valid phone number';
      },
      decoration: InputDecoration(
          border: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey, width: 1.0),
              borderRadius: BorderRadius.circular(5)),
          hintText: 'Phone (343XXXXXXX)'),
    );
  }

  TextFormField buildPasswordTextField() {
    return TextFormField(
      controller: _passwordController,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      obscureText: true,
      validator: (value) {
        if (value.length > 5)
          return null;
        else
          return 'Username must be at least of 6 characters';
      },
      decoration: InputDecoration(
          border: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey[100], width: 1.0),
              borderRadius: BorderRadius.circular(5)),
          hintText: 'Password'),
    );
  }

  TextFormField buildConfirmPasswordTextField() {
    return TextFormField(
      controller: _confirmPasswordController,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      obscureText: true,
      validator: (value) {
        if (value == _passwordController.text)
          return null;
        else
          return 'Password not matched';
      },
      decoration: InputDecoration(
          border: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey[100], width: 1.0),
              borderRadius: BorderRadius.circular(5)),
          hintText: 'Re-enter Password'),
    );
  }

  Widget _primaryBtn({String btnText}) {
    return GestureDetector(
      onTap: () async {
        if (_key.currentState.validate()) {
          if (_gender == 0) {
            Get.snackbar('', 'Select gender.');
          } else {
            // SetupProfileModel model = SetupProfileModel(
            //     name: _userNameController.text,
            //     email: _emailController.text,
            //     gender: gender,
            //     profile_image: ''
            // );
            // Get.to(SetupProfileeScreen(model: model,));
            processing = true;
            setState(() {

            });
            // Get.to(EnterCodeScreen(phone: _phoneController.text));

            var accountServices = AccountServices();
            // todo change device token
            APIResponse response = await accountServices.signUp(
                name: _userNameController.text,
                phone: _phoneController.text,
                password: _passwordController.text,
                gender: gender,
                device_token: '1234');
            if (response != null) {
              if (response.status == '1') {
                Get.snackbar('', response.message);
                Get.to(EnterCodeScreen(phone: _phoneController.text));
              } else {
                Get.snackbar('', response.message);
              }
            } else {
              print('API response is null');
              Get.snackbar('', 'Oops! Server is Down');

            }

            processing = false;
            setState(() {

            });
          }
        }
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

  Widget _row({String firstStr, String secondStr}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          firstStr,
          style: TextStyle(color: Colors.grey[500]),
        ),
        SizedBox(width: 5),
        GestureDetector(
          onTap: () {
            if (processing)
              Get.snackbar('Processing', 'Please wait.');
            else
              Get.to(WelcomeBackScreen());
          },
          child: Text(
            secondStr,
            style: TextStyle(color: AppColors.primaryColor),
          ),
        )
      ],
    );
  }

  Future<void> checkUserStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString(SharedPreVariables.TOKEN);
    if (token != null)
      Get.offAll(() => HomeScreen());
  }


}
