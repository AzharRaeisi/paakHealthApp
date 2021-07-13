import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:paakhealth/models/api_response.dart';
import 'package:paakhealth/screens/auth/login_screen.dart';
import 'package:paakhealth/services/account_services.dart';
import 'package:paakhealth/util/colors.dart';

class ResetPasswordScreen extends StatefulWidget {
  final String phone;

  const ResetPasswordScreen({Key key,@required this.phone}) : super(key: key);

  @override
  _ResetPasswordScreenState createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  GlobalKey<FormState> _key = GlobalKey<FormState>();
  TextEditingController _passwordController = new TextEditingController();
  TextEditingController _confirmPasswordController =
  new TextEditingController();
  bool isProcessing = false;


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
                'Reset Password',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryColor,
                    fontSize: 20),
              ),
              SizedBox(height: 30),
              Text('Enter your new password'),
              SizedBox(height: 15),
              Form(
                  key: _key,
                  child: Column(
                    children: [
                      buildPasswordTextField(),
                      SizedBox(height: 14),
                      buildConfirmPasswordTextField(),
                    ],
                  )),
              Expanded(child: Container()),
              _primaryBtn(btnText: 'Next'),
              SizedBox(height: 20),
            ],
          ),
        ),
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



          var accountServices = AccountServices();
          // todo change device token
          APIResponse response = await accountServices.resetPassword(
              phone: widget.phone,
              password: _passwordController.text);
          if (response != null){
            if (response.status == '1'){
              Get.snackbar('', response.message);

              Get.offAll(LoginScreen());
            }else{
              Get.snackbar('', response.message);
            }
          }else{
            print('API response is null');
            Get.snackbar('','Oops! Server is Down');
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

}
