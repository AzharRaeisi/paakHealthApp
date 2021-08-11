import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:paakhealth/models/api_response.dart';
import 'package:paakhealth/screens/auth/enter_code_screen.dart';
import 'package:paakhealth/services/account_services.dart';
import 'package:paakhealth/util/colors.dart';
import 'package:paakhealth/util/font.dart';
import 'package:paakhealth/widgets/primaryButton.dart';
import 'package:paakhealth/widgets/toast/toast.dart';

class ForgotPasswordScreen extends StatefulWidget {
  final bool val;

  const ForgotPasswordScreen({Key key, @required this.val}) : super(key: key);

  @override
  _ForgotPasswordScreenState createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  GlobalKey<FormState> _key = GlobalKey<FormState>();
  TextEditingController _phoneController = new TextEditingController();
  bool isProcessing = false;

  bool forgetPassword;
  String username = '';

  @override
  Widget build(BuildContext context) {
    forgetPassword = widget.val;
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
                  Align(alignment: Alignment.center,child: Image.asset('assets/paakhealth.png')),
                  SizedBox(height: 20),
                  Text(
                    forgetPassword ? 'Password Recovery' : 'Username Recovery',
                    style: TextStyle(
                      fontSize: 20.0,
                      fontFamily: AppFont.Gotham,
                      fontWeight: FontWeight.w700,
                      color: AppColors.primaryColor,
                    ),
                  ),
                  SizedBox(height: 30),
                  Text(
                    'Please enter your registered contact number for recovery',
                    style: TextStyle(
                      fontSize: 12,
                      fontFamily: AppFont.Gotham,
                      fontWeight: FontWeight.w400,
                      color: AppColors.textColor,
                    ),
                  ),
                  // SizedBox(height: 15),
                  // buildEmailTextField(),
                  // SizedBox(height: 15),
                  // Text('OR', style: TextStyle(color: Colors.grey, fontSize: 12),),
                  SizedBox(height: 5),
                  buildPhoneTextField(),
                  username.isNotEmpty
                      ? Text('Your username is: ' + username)
                      : Container(),
                  SizedBox(height: 90),

                  isProcessing
                      ? Center(
                          child: CircularProgressIndicator(),
                        )
                      : _primaryBtn(btnText: 'Proceed'),
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
        setState(() {
          isProcessing = true;
        });
        var accountServices = AccountServices();
        // todo change device token
        APIResponse response = await accountServices.checkPhoneVerification(
            phone: _phoneController.text);
        if (response != null) {
          if (response.status == '1') {
            if (forgetPassword) {
              // Get.to(() => ResetPasswordScreen(phone: _phoneController.text));
              Get.to(() => EnterCodeScreen(phone: _phoneController.text, forgetPassword: true,));
            } else {
              APIResponse responsee = await accountServices.getUsername(
                  phone: _phoneController.text);
              if (responsee != null) {
                if (responsee.status == '1') {
                  username = responsee.name;
                  setState(() {});
                } else {
                  ShowMessage.message(message: responsee.message);
                }
              } else {
                print('API response is null');
                ShowMessage.message(message: 'Oops! Server is Down');
              }
            }
          }else {
            ShowMessage.message(message: response.message);
          }
        } else {
          print('API response is null');
          ShowMessage.message(message: 'Oops! Server is Down');
        }

        setState(() {
          isProcessing = false;
        });
      },
      child: AppPrimaryButton(text: btnText,),
    );
  }
}
