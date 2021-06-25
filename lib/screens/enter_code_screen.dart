import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:paakhealth/models/api_response.dart';
import 'package:paakhealth/screens/setup_profile_screen.dart';
import 'package:paakhealth/screens/setup_profilee_screen.dart';
import 'package:paakhealth/services/account_services.dart';
import 'package:paakhealth/util/colors.dart';
import 'package:paakhealth/util/prefernces.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EnterCodeScreen extends StatefulWidget {
  final String phone;

  const EnterCodeScreen({Key key, @required this.phone}) : super(key: key);

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
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryColor,
                    fontSize: 20),
              ),
              SizedBox(height: 30),

              Text('Enter the code we sent via SMS'),
              SizedBox(height: 15),
              _buildPinField(),
              Expanded(child: Container()),
              processing
                  ? Center(
                      child: CircularProgressIndicator(),
                    )
                  : Container(),
              // : _primaryBtn(btnText: 'Verify me'),
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

                      callCheckVerificationCode();
                    } else {
                      Get.snackbar('then else',value.toString());

                      print('user not logged in');
                    }
          }).catchError((onError){
            print('catchprintError()');
            print(onError.hashCode);
            print(onError.toString());
            if (onError.hashCode == 81129831){
              print('Invalid Code');
              Get.snackbar('Failed', 'Invalid Code Entered or Code Expired');
            }
            if (onError.hashCode == 21005953){
              print('Invalid Code');
              Get.snackbar('Failed', 'The sms code has expired');
            }
          });
        } catch (e) {
          print('e.toString()');
          print(e.toString());
          Get.snackbar('catch ',e.toString());

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

  Widget _primaryBtn({String btnText}) {
    return GestureDetector(
      onTap: () async {
        if (_verificationCode.isNotEmpty) {
          toggleOnProceesing();
          try {
            // todo reCaptcha disabled... test it
            FirebaseAuth.instance
                .setSettings(appVerificationDisabledForTesting: true);
            await FirebaseAuth.instance
                .signInWithCredential(PhoneAuthProvider.credential(
                    verificationId: _verificationCode,
                    smsCode: _verificationCode))
                .then((value) async {
              if (value.user != null) {
                print('user logged in');
                // todo call the /check-verification-code api
                callCheckVerificationCode();
              } else {
                print('user not logged in');
              }
            });
          } catch (e) {
            FocusScope.of(context).unfocus();
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

  @override
  void initState() {
    _verifyPhone();
    super.initState();
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
            callCheckVerificationCode();
          }
        });
      },
      verificationFailed: (FirebaseAuthException e) {
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
      timeout: Duration(seconds: 120)
    );
  }

  void toggleOnProceesing() {
    processing = true;
    setState(() {});
  }

  void toggleOffProceesing() {
    processing = false;
    setState(() {});
  }


  void _setData(Map<String, dynamic> data) async{

    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(SharedPreVariables.CUSTOMER_NAME, data[SharedPreVariables.CUSTOMER_NAME]);
    await prefs.setString(SharedPreVariables.CUSTOMER_IMAGE, data[SharedPreVariables.CUSTOMER_IMAGE]);
    await prefs.setString(SharedPreVariables.TOKEN, data[SharedPreVariables.TOKEN]);
    await prefs.setString(SharedPreVariables.REFRESH_TOKEN, data[SharedPreVariables.REFRESH_TOKEN]);
    await prefs.setInt(SharedPreVariables.EXPRIRY_TIME, data[SharedPreVariables.EXPRIRY_TIME]);
    DateTime expiryDateTime =  DateTime.now().add(Duration(days: 30));
    await prefs.setString(SharedPreVariables.EXPRIRY_DATE, expiryDateTime.toString());

    await prefs.setInt(SharedPreVariables.WALLET_AMOUNT, data[SharedPreVariables.WALLET_AMOUNT]);
    await prefs.setString(SharedPreVariables.IS_SET_PROFILE, data[SharedPreVariables.IS_SET_PROFILE]);

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
    APIResponse response = await accountServices.checkVerificationCode(phone: widget.phone);
    if (response != null){
      if (response.status == '1'){
        Get.snackbar('', response.message);
        _setData(response.data);
        Get.to(SetupProfileeScreen());

      }else{
        Get.snackbar('', response.message);
      }
    }else{
      print('API response is null');
      Get.snackbar('','Oops! Server is Down');
    }

  }
}
