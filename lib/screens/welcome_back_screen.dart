import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:paakhealth/models/api_response.dart';
import 'package:paakhealth/screens/forgot_pass_screen.dart';
import 'package:paakhealth/screens/home_screen.dart';
import 'package:paakhealth/screens/verifyme_screen.dart';
import 'package:paakhealth/services/account_services.dart';
import 'package:paakhealth/util/colors.dart';
import 'package:paakhealth/util/prefernces.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WelcomeBackScreen extends StatefulWidget {
  @override
  _WelcomeBackScreenState createState() => _WelcomeBackScreenState();
}

class _WelcomeBackScreenState extends State<WelcomeBackScreen> {
  GlobalKey<FormState> _key = GlobalKey<FormState>();
  TextEditingController _userNameController = new TextEditingController();
  TextEditingController _phoneController = new TextEditingController();
  TextEditingController _emailController = new TextEditingController();
  TextEditingController _passwordController = new TextEditingController();

  bool isProcessing = false;
  bool _rememberMe = false;

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
                  Image.asset('assets/paakhealth.png'),
                  SizedBox(height: 20),
                  Text(
                    'Welcome Back',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: AppColors.primaryColor,
                        fontSize: 20),
                  ),
                  SizedBox(height: 30),
                  SizedBox(height: 15),
                  // buildPhoneTextField(),
                  //
                  // SizedBox(height: 5),
                  // Text('or'),
                  // SizedBox(height: 5),
                  buildNameTextField(),
                  SizedBox(height: 15),
                  buildPasswordTextField(),
                  SizedBox(height: 20),
                  Align(
                    alignment: Alignment.centerRight,
                    child: GestureDetector(
                        onTap: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) => VerifyMeScreen()));
                        },
                        child: Text('Verify me', style: TextStyle(
                          color: AppColors.primaryColor
                        ),)),
                  ),
                  SizedBox(height: 20),
                  isProcessing
                      ? Center(
                          child: CircularProgressIndicator(),
                        )
                      : _primaryBtn(btnText: 'SIGN IN'),
                  SizedBox(height: 12,),
                  IntrinsicHeight(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [

                        GestureDetector(
                          onTap: () {
                            Get.to(() => ForgotPasswordScreen(
                              val: false,
                            ));
                          },
                          child: Text(
                            'Forgot Username?',
                            style: TextStyle(color: Colors.grey),
                          ),
                        ),
                        VerticalDivider(width: 20, ),
                        GestureDetector(
                          onTap: () {
                            Get.to(() => ForgotPasswordScreen(
                              val: true,
                            ));
                          },
                          child: Text(
                            'Forgot Password?',
                            style: TextStyle(color: Colors.grey),
                          ),
                        )
                      ],
                    ),
                  ),
                  SizedBox(height: 25),
                  Center(child: Text('Or')),
                  SizedBox(height: 25),
                  _fbAndGmailRow(),
                  SizedBox(height: 40),
                  _row(
                      firstStr: "Don't have account?",
                      secondStr: 'Create Account')
                ],
              ),
            ),
          ),
        ),
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
          prefixText: '+92',
          hintText: 'Mobile Number'),
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
      // validator: (value) {
      //   if (value.contains(RegExp(
      //       r"^[a-z]"))){
      //     if (RegExp(
      //         r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
      //         .hasMatch(value))
      //       return null;
      //     else {
      //       return 'Enter valid email.';
      //     }
      //   }else{
      //
      //     if (value.length == 10)
      //       return null;
      //     else
      //       return 'Enter valid phone number';
      //   }
      //
      // },
      decoration: InputDecoration(
          border: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey[100], width: 1.0),
              borderRadius: BorderRadius.circular(5)),
          hintText: 'Email or Mobile Number'),
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
            // todo create account
            if (isProcessing)
              Get.snackbar('Processing', 'Please wait.');
            else
              print('you can login through facebook');
          },
          child: Text(
            secondStr,
            style: TextStyle(color: AppColors.primaryColor),
          ),
        )
      ],
    );
  }

  Widget _primaryBtn({String btnText}) {
    return GestureDetector(
      onTap: () async {
        if (_key.currentState.validate()) {
          setState(() {
            isProcessing = true;
          });
          var accountServices = AccountServices();
          // todo change device token
          SharedPreferences prefs = await SharedPreferences.getInstance();
          String token = prefs.getString(SharedPreVariables.TOKEN);

          print(token);
          APIResponse response = await accountServices.login(
            name: _userNameController.text,
            password: _passwordController.text,
            device_token: 'token',
          );
          if (response != null) {
            if (response.status == '1') {
              Get.snackbar('', response.message);
              _setData(response.data);
              Get.offAll(HomeScreen());
            } else {
              Get.snackbar('', response.message);
            }
          } else {
            print('API response is null');
            Get.snackbar('', 'Oops! Server is Down');
          }
          setState(() {
            isProcessing = false;
          });
        }
        // Navigator.push(context,
        // MaterialPageRoute(
        //     settings: RouteSettings(name: "/home"),
        //     builder: (context) => HomeScreen()));
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


  // todo facebook and google icon sizes

  Widget _fbAndGmailRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: () {
            // todo facebook button clicked
            if (isProcessing)
              Get.snackbar('Processing', 'Please wait.');
            else
              print('you can login through facebook');
          },
          child: CircleAvatar(
            radius: 20,
            backgroundColor: Colors.white,
            backgroundImage: AssetImage('assets/facebook.png'),
          ),
        ),
        SizedBox(width: 14),
        GestureDetector(
          onTap: () {
            // todo google button clicked
            if (isProcessing)
              Get.snackbar('Processing', 'Please wait.');
            else
              print('you can login through facebook');
          },
          child: CircleAvatar(
            radius: 20,
            backgroundColor: Colors.red,
            backgroundImage: AssetImage('assets/google.png'),
          ),
        ),
      ],
    );
  }

  void _setData(Map<String, dynamic> data) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(SharedPreVariables.CUSTOMER_NAME,
        data[SharedPreVariables.CUSTOMER_NAME]);
    await prefs.setString(SharedPreVariables.CUSTOMER_IMAGE,
        data[SharedPreVariables.CUSTOMER_IMAGE]);
    await prefs.setString(
        SharedPreVariables.TOKEN, data[SharedPreVariables.TOKEN]);
    await prefs.setString(SharedPreVariables.REFRESH_TOKEN,
        data[SharedPreVariables.REFRESH_TOKEN]);
    await prefs.setInt(
        SharedPreVariables.EXPRIRY_TIME, data[SharedPreVariables.EXPRIRY_TIME]);
    DateTime expiryDateTime = DateTime.now().add(Duration(days: 30));
    await prefs.setString(
        SharedPreVariables.EXPRIRY_DATE, expiryDateTime.toString());

    await prefs.setInt(SharedPreVariables.WALLET_AMOUNT,
        data[SharedPreVariables.WALLET_AMOUNT]);
    await prefs.setInt(SharedPreVariables.IS_SET_PROFILE,
        data[SharedPreVariables.IS_SET_PROFILE]);

    // logger.i(prefs.getString('customer_name'));
    // logger.i(prefs.getString('customer_image'));
    // logger.i(prefs.getInt('cart_id'));
    // logger.i(prefs.getString('token'));
    // logger.i(prefs.getString('refresh_token'));
    // logger.i(prefs.getInt('expiry_time'));
  }
}
