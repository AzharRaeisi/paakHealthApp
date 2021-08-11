import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:paakhealth/models/api_response.dart';
import 'package:paakhealth/screens/home/landing_screen.dart';
import 'package:paakhealth/screens/auth/reset_password_screen.dart';
import 'package:paakhealth/services/account_services.dart';
import 'package:paakhealth/util/colors.dart';
import 'package:paakhealth/util/font.dart';
import 'package:paakhealth/util/prefernces.dart';
import 'package:paakhealth/widgets/toast/toast.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EnterCodeScreen extends StatefulWidget {
  final String phone;
  final bool forgetPassword;

  const EnterCodeScreen(
      {Key key, @required this.phone, @required this.forgetPassword})
      : super(key: key);

  @override
  _EnterCodeScreenState createState() => _EnterCodeScreenState();
}

class _EnterCodeScreenState extends State<EnterCodeScreen> {
  String _verificationCode;
  bool processing = false;

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
                'Enter Code',
                style: TextStyle(
                  fontSize: 20.0,
                  fontFamily: AppFont.Gotham,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primaryColor,
                ),
              ),
              SizedBox(height: 30),

              Text('Enter the code we sent via SMS to +92-${widget.phone}',
                textAlign: TextAlign.center,
                style: TextStyle(
                fontFamily: AppFont.Gotham,
                fontWeight: FontWeight.w400,
                color: AppColors.textColor,
              ),),
              SizedBox(height: 15),
              _buildPinField(),
              SizedBox(
                height: 20,
              ),
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.center,
              //   children: [
              //     Text(
              //       "Didn't receive the code? ",
              //       style: TextStyle(
              //         fontSize: 12,
              //         fontFamily: AppFont.Gotham,
              //         fontWeight: FontWeight.w400,
              //         color: AppColors.textColor,
              //       ),
              //     ),
              //     TextButton(
              //         onPressed: () {
              //
              //         },
              //         child: Text(
              //           "RESEND",
              //           style: TextStyle(
              //             fontSize: 14,
              //             fontFamily: AppFont.Gotham,
              //             fontWeight: FontWeight.w500,
              //             color: AppColors.primaryColor,
              //           ),
              //         ))
              //   ],
              // ),
              SizedBox(
                height: 14,
              ),
              Expanded(child: Container()),
              processing
                  ? Center(
                      child: CircularProgressIndicator(),
                    )
                  : Container(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPinField() {
    return PinCodeTextField(
      length: 6,
      obscureText: false,
      animationType: AnimationType.fade,
      pinTheme: PinTheme(
        activeColor: AppColors.primaryColor,
        inactiveColor: Colors.grey[100],
        inactiveFillColor: Colors.grey[100],
        shape: PinCodeFieldShape.box,
        borderRadius: BorderRadius.circular(5),
        fieldHeight: 50,
        fieldWidth: 40,
        activeFillColor: Colors.white,
      ),
      animationDuration: Duration(milliseconds: 300),
      // backgroundColor: Colors.blue.shade50,
      enableActiveFill: true,
      // errorAnimationController: errorController,
      // controller: textEditingController,
      onCompleted: (pin) async {
        print("Completed");
        // _verificationCode = pin;
        toggleOnProceesing();
        try {
          // todo reCaptcha disabled... test it
          print('inside try block');
          FirebaseAuth.instance
              .setSettings(appVerificationDisabledForTesting: true);
          await FirebaseAuth.instance
              .signInWithCredential(PhoneAuthProvider.credential(
                  verificationId: _verificationCode, smsCode: pin))
              .then((value) async {
            print('inside  then part');

            if (value.user != null) {
              print('user logged in');
              // todo call the /check-verification-code api
              if (widget.forgetPassword) {
                Get.to(() => ResetPasswordScreen(phone: widget.phone));
              } else {
                callCheckVerificationCode();
              }
            } else {
              ShowMessage.message(message: value.toString());

              print('user not logged in');
            }
          }).catchError((onError) {
            print('catchprintError()');
            print(onError.hashCode);
            print(onError.toString());
            if (onError.hashCode == 81129831) {
              print('Invalid Code');
              ShowMessage.message(title: 'Failed', message: 'Invalid Code Entered or Code Expired');
            }
            else if (onError.hashCode == 21005953) {
              print('Invalid Code');
              ShowMessage.message(title: 'Failed', message: 'The sms code has expired');
            }else{
              ShowMessage.message(title: 'Failed', message: onError.toString());
            }
          });
        } catch (e) {
          print('e.toString()');
          print(e.toString());
          ShowMessage.message(title: 'catch ', message: e.toString());

          FocusScope.of(context).unfocus();
        }
        _verificationCode = '';
        toggleOffProceesing();
      },
      onChanged: (value) {
        print(value);
      },
      beforeTextPaste: (text) {
        print("Allowing to paste $text");
        //if you return true then it will show the paste confirmation dialog. Otherwise if false, then nothing will happen.
        //but you can show anything you want here, like your pop up saying wrong paste format or etc
        return true;
      },
      appContext: context,
    );
  }

  @override
  void initState() {
    super.initState();
    _verifyPhone();
    print(widget.phone);
  }

  _verifyPhone() async {
    FirebaseAuth.instance.setSettings(appVerificationDisabledForTesting: true);
    await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: '+92${widget.phone}',
        verificationCompleted: (PhoneAuthCredential credential) async {
          await FirebaseAuth.instance
              .signInWithCredential(credential)
              .then((value) async {
            if (value.user != null) {
              print('user logged in');
              // value.user.phoneNumber
              // todo call the /check-verification-code api
              if (widget.forgetPassword) {
                Get.to(() => ResetPasswordScreen(phone: widget.phone));
              } else {
                callCheckVerificationCode();
              }
            }
          });
        },
        verificationFailed: (FirebaseAuthException e) {
          print(e.message);
          print(e.message);
        },
        codeSent: (String verificationID, int resendToken) {
          print('verificationID');
          print(verificationID);
          setState(() {
            _verificationCode = verificationID;
          });
        },
        codeAutoRetrievalTimeout: (String verificationID) {
          // setState(() {
          _verificationCode = verificationID;
          // });
        },
        timeout: Duration(seconds: 120));
  }

  void toggleOnProceesing() {
    processing = true;
    setState(() {});
  }

  void toggleOffProceesing() {
    processing = false;
    setState(() {});
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
    await prefs.setString(SharedPreVariables.IS_SET_PROFILE,
        data[SharedPreVariables.IS_SET_PROFILE]);

    // logger.i(prefs.getString('customer_name'));
    // logger.i(prefs.getString('customer_image'));
    // logger.i(prefs.getInt('cart_id'));
    // logger.i(prefs.getString('token'));
    // logger.i(prefs.getString('refresh_token'));
    // logger.i(prefs.getInt('expiry_time'));
  }

  Future<void> callCheckVerificationCode() async {
    var accountServices = AccountServices();
    // todo change device token
    APIResponse response =
        await accountServices.checkVerificationCode(phone: widget.phone);
    if (response != null) {
      if (response.status == '1') {
        ShowMessage.message(message: response.message);
        _setData(response.data);
        Get.to(HomeScreen());
      } else {
        ShowMessage.message(message: response.message);
      }
    } else {
      print('API response is null');
      ShowMessage.message(message: 'Oops! Server is Down');
    }
  }
}
