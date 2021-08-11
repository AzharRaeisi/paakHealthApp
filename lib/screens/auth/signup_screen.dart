import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:paakhealth/models/api_response.dart';
import 'package:paakhealth/screens/auth/enter_code_screen.dart';
import 'package:paakhealth/screens/home/landing_screen.dart';
import 'package:paakhealth/screens/auth/login_screen.dart';
import 'package:paakhealth/services/account_services.dart';
import 'package:paakhealth/util/colors.dart';
import 'package:paakhealth/util/font.dart';
import 'package:paakhealth/util/prefernces.dart';
import 'package:paakhealth/widgets/primaryButton.dart';
import 'package:paakhealth/widgets/toast/toast.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignupScreen extends StatefulWidget {
  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
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
                      fontSize: 20.0,
                      fontFamily: AppFont.Gotham,
                      fontWeight: FontWeight.w700,
                      color: AppColors.primaryColor,
                    ),
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
                          title: Text('Male', style: TextStyle(
                            fontFamily: AppFont.Gotham,
                            fontWeight: FontWeight.w400,
                            color: AppColors.textColor,
                          ),),
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
                          title: Text('Female', style: TextStyle(
                            fontFamily: AppFont.Gotham,
                            fontWeight: FontWeight.w400,
                            color: AppColors.textColor,
                          ),),
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
          hintText: 'Username',
        labelStyle: TextStyle(
          fontSize: 12.0,
          fontFamily: AppFont.Gotham,
          fontWeight: FontWeight.w400,
          color: AppColors.textColor,
        ),
        hintStyle: TextStyle(
          fontSize: 12.0,
          fontFamily: AppFont.Gotham,
          fontWeight: FontWeight.w400,
          color: AppColors.textColor,
        ),
      ),
      style: TextStyle(
        fontSize: 12.0,
        fontFamily: AppFont.Gotham,
        fontWeight: FontWeight.w400,
        color: AppColors.textColor,
      ),
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
          hintText: 'Email',
        labelStyle: TextStyle(
          fontSize: 12.0,
          fontFamily: AppFont.Gotham,
          fontWeight: FontWeight.w400,
          color: AppColors.textColor,
        ),
        hintStyle: TextStyle(
          fontSize: 12.0,
          fontFamily: AppFont.Gotham,
          fontWeight: FontWeight.w400,
          color: AppColors.textColor,
        ),
      ),
      style: TextStyle(
        fontSize: 12.0,
        fontFamily: AppFont.Gotham,
        fontWeight: FontWeight.w400,
        color: AppColors.textColor,
      ),
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
          hintText: 'Phone (343XXXXXXX)',
        labelStyle: TextStyle(
          fontSize: 12.0,
          fontFamily: AppFont.Gotham,
          fontWeight: FontWeight.w400,
          color: AppColors.textColor,
        ),
        hintStyle: TextStyle(
          fontSize: 12.0,
          fontFamily: AppFont.Gotham,
          fontWeight: FontWeight.w400,
          color: AppColors.textColor,
        ),
      ),
      style: TextStyle(
        fontSize: 12.0,
        fontFamily: AppFont.Gotham,
        fontWeight: FontWeight.w400,
        color: AppColors.textColor,
      ),
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
          hintText: 'Password',
        labelStyle: TextStyle(
          fontSize: 12.0,
          fontFamily: AppFont.Gotham,
          fontWeight: FontWeight.w400,
          color: AppColors.textColor,
        ),
        hintStyle: TextStyle(
          fontSize: 12.0,
          fontFamily: AppFont.Gotham,
          fontWeight: FontWeight.w400,
          color: AppColors.textColor,
        ),
      ),
      style: TextStyle(
        fontSize: 12.0,
        fontFamily: AppFont.Gotham,
        fontWeight: FontWeight.w400,
        color: AppColors.textColor,
      ),
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
          hintText: 'Re-enter Password',
        labelStyle: TextStyle(
          fontSize: 12.0,
          fontFamily: AppFont.Gotham,
          fontWeight: FontWeight.w400,
          color: AppColors.textColor,
        ),
        hintStyle: TextStyle(
          fontSize: 12.0,
          fontFamily: AppFont.Gotham,
          fontWeight: FontWeight.w400,
          color: AppColors.textColor,
        ),
      ),
      style: TextStyle(
        fontSize: 12.0,
        fontFamily: AppFont.Gotham,
        fontWeight: FontWeight.w400,
        color: AppColors.textColor,
      ),
    );
  }

  Widget _primaryBtn({String btnText}) {
    return GestureDetector(
      onTap: () async {
        if (_key.currentState.validate()) {
          if (_gender == 0) {
            ShowMessage.message(message: 'Select gender.');
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
                ShowMessage.message(message: response.message);
                Get.to(EnterCodeScreen(phone: _phoneController.text));
              } else {
                ShowMessage.message(message: response.message);
              }
            } else {
              print('API response is null');
              ShowMessage.message(message: 'Oops! Server is Down');

            }

            processing = false;
            setState(() {

            });
          }
        }
      },
      child: AppPrimaryButton(text: btnText,),
    );
  }

  Widget _row({String firstStr, String secondStr}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          firstStr,
          style: TextStyle(
            fontFamily: AppFont.Gotham,
            fontWeight: FontWeight.w400,
            color: AppColors.textColor,
          ),
        ),
        SizedBox(width: 5),
        GestureDetector(
          onTap: () {
            if (processing)
              Get.snackbar('Processing', 'Please wait.');
            else
              Get.back();
          },
          child: Text(
            secondStr,
            style: TextStyle(
              fontFamily: AppFont.Gotham,
              fontWeight: FontWeight.w500,
              color: AppColors.primaryColor,
            ),
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
