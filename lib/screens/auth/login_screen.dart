import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:paakhealth/models/api_response.dart';
import 'package:paakhealth/screens/auth/signup_screen.dart';
import 'package:paakhealth/screens/auth/forgot_pass_screen.dart';
import 'package:paakhealth/screens/home/landing_screen.dart';
import 'package:paakhealth/screens/auth/verifyme_screen.dart';
import 'package:paakhealth/services/account_services.dart';
import 'package:paakhealth/util/colors.dart';
import 'package:paakhealth/util/font.dart';
import 'package:paakhealth/util/prefernces.dart';
import 'package:paakhealth/widgets/primaryButton.dart';
import 'package:paakhealth/widgets/toast/toast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:http/http.dart' as http;
class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
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
                  Center(child: Image.asset('assets/paakhealth.png')),
                  SizedBox(height: 20),
                  Text(
                    'Welcome Back',
                    style: TextStyle(
                      fontSize: 20.0,
                      fontFamily: AppFont.Gotham,
                      fontWeight: FontWeight.w700,
                      color: AppColors.primaryColor,
                    ),
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
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => VerifyMeScreen()));
                        },
                        child: Text(
                          'Verify me',
                          style: TextStyle(
                            fontFamily: AppFont.Gotham,
                            fontWeight: FontWeight.w500,
                            color: AppColors.primaryColor,
                          ),
                        )),
                  ),
                  SizedBox(height: 20),
                  isProcessing
                      ? Center(
                          child: CircularProgressIndicator(),
                        )
                      : _primaryBtn(btnText: 'SIGN IN'),
                  SizedBox(
                    height: 12,
                  ),
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
                            style: TextStyle(
                            fontFamily: AppFont.Gotham,
                            fontWeight: FontWeight.w400,
                            color: AppColors.textColor,
                          ),
                          ),
                        ),
                        VerticalDivider(
                          width: 20,
                        ),
                        GestureDetector(
                          onTap: () {
                            Get.to(() => ForgotPasswordScreen(
                                  val: true,
                                ));
                          },
                          child: Text(
                            'Forgot Password?',
                            style: TextStyle(
                              fontFamily: AppFont.Gotham,
                              fontWeight: FontWeight.w400,
                              color: AppColors.textColor,
                            ),
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
                      secondStr: 'Create Account'),
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
            // todo create account
            if (isProcessing)
              Get.snackbar('Processing', 'Please wait.');
            else
              Get.to(() => SignupScreen());
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
              ShowMessage.message(message: response.message);
              _setData(response.data);
              Get.offAll(HomeScreen());
            } else {
              ShowMessage.message(message: response.message);
            }
          } else {
            print('API response is null');
            ShowMessage.message(message: 'Oops! Server is Down');
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
      child: AppPrimaryButton(text: btnText,),
    );
  }

  // todo facebook and google icon sizes

  Widget _fbAndGmailRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: () async {
            // todo facebook button clicked
            if (isProcessing)
              Get.snackbar('Processing', 'Please wait.');
            else {
              print('you can login through facebook');

              final facebookLogin = FacebookLogin();
              final facebookLoginResult = await facebookLogin.logIn(['email']);

              // print(facebookLoginResult.accessToken);
              // print(facebookLoginResult.accessToken.token);
              // print(facebookLoginResult.accessToken.expires);
              // print(facebookLoginResult.accessToken.permissions);
              // print(facebookLoginResult.accessToken.userId);
              // print(facebookLoginResult.accessToken.isValid());
              //
              // print(facebookLoginResult.errorMessage);
              // print(facebookLoginResult.status);

              final token = facebookLoginResult.accessToken.token;

              /// for profile details also use the below code
              final graphResponse = await http.get(
                  Uri.parse('https://graph.facebook.com/v2.12/me?fields=name,picture.width(800).height(800),email&access_token=$token'));
              final profile = json.decode(graphResponse.body);
              print(profile['name']);
              print(profile['picture']);
              print(profile['email']);
              print(profile['id']);

              /*
                from profile you will get the below params
                {
                 "name": "Iiro Krankka",
                 "first_name": "Iiro",
                 "last_name": "Krankka",
                 "email": "iiro.krankka\u0040gmail.com",
                 "id": "<user id here>"
                }
               */
              // todo check
              socailLogIn(email: profile['email'], socialType: 'facebook', socialId: profile['id'], photoUrl: profile['picture']);
            }
          },
          child: CircleAvatar(
            radius: 20,
            backgroundColor: Colors.white,
            backgroundImage: AssetImage('assets/facebook.png'),
          ),
        ),
        SizedBox(width: 14),
        GestureDetector(
          onTap: () async {
            // todo google button clicked
            if (isProcessing)
              Get.snackbar('Processing', 'Please wait.');
            else {
              print('you can login through google');

              GoogleSignIn _googleSignIn = GoogleSignIn(
                scopes: [
                  'email',
                  // you can add extras if you require
                ],
              );

              _googleSignIn.signIn().then((GoogleSignInAccount acc) async {
                GoogleSignInAuthentication auth = await acc.authentication;
                print('================================================');
                print(acc.id);
                print(acc.email);
                print(acc.displayName);
                print(acc.photoUrl);
                print('================================================');
                print('================================================');

                // acc.authentication.then((GoogleSignInAuthentication auth) async {
                //   print(auth.idToken);
                //   print(auth.accessToken);
                // });

                socailLogIn(email: acc.email, photoUrl: acc.photoUrl, socialId: acc.id, socialType: 'google');

              });
            }
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

  Future<void> socailLogIn(
      {String email, String photoUrl, String socialId, String socialType}) async {
    Get.snackbar('Successful', 'Please wait...');
    var accountServices = AccountServices();
    // todo change device token

    APIResponse response = await accountServices.socialLogin(
      email: email,
      profile_image: photoUrl,
      social_id: socialId,
      social_type: socialType,
      device_token: 'token',
    );
    if (response != null) {
      if (response.status == '1') {
        ShowMessage.message(message: response.message);
        _setData(response.data);
        Get.offAll(HomeScreen());
      } else {
        ShowMessage.message(message: response.message);
      }
    } else {
      print('API response is null');
      ShowMessage.message(message: 'Oops! Server is Down');
    }

    setState(() {
      isProcessing = false;
    });
  }
}
