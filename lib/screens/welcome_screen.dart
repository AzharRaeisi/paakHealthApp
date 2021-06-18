import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:paakhealth/controllers/welcome_controller.dart';
import 'package:paakhealth/models/api_response.dart';
import 'package:paakhealth/screens/enter_code_screen.dart';
import 'package:paakhealth/screens/setup_profile_screen.dart';
import 'package:paakhealth/screens/welcome_back_screen.dart';
import 'package:paakhealth/services/account_services.dart';
import 'package:paakhealth/util/colors.dart';
import 'package:paakhealth/util/prefernces.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WelcomeScreen extends StatefulWidget {
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  GlobalKey<FormState> _key = GlobalKey<FormState>();
  TextEditingController _phoneController = new TextEditingController();
  TextEditingController _passwordController = new TextEditingController();
  TextEditingController _confirmPasswordController =
  new TextEditingController();
  bool isProcessing = false;

  WelcomeScreenController controller = Get.put(WelcomeScreenController());

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
                'Welcome',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryColor,
                    fontSize: 20),
              ),
              SizedBox(height: 30),
              Text('Enter your mobile number'),
              SizedBox(height: 15),
              Form(
                key: _key,
                  child: Column(
                    children: [
                      buildPhoneTextField(),
                      SizedBox(height: 14),
                      buildPasswordTextField(),
                      SizedBox(height: 14),
                      buildConfirmPasswordTextField(),
                    ],
                  )),
              Expanded(child: Container()),
              // GetX<WelcomeScreenController>(
              //   init: WelcomeScreenController(),
              //     builder: (_) {
              //   return _.isProcessing.value
              //       ? Center(
              //           child: CircularProgressIndicator(),
              //         )
              //       : _primaryBtn(btnText: 'Next');
              // }),
              Obx(() => controller.isProcessing.value
                    ? Center(
                        child: CircularProgressIndicator(),
                      )
                    : _primaryBtn(btnText: 'Next')
              ),
              SizedBox(height: 20),
              _row(firstStr: 'Already have an account?', secondStr: 'Sign In')
            ],
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
          prefixText: '+92'),
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
            if (controller.isProcessing.value)
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

  Widget _primaryBtn({String btnText}) {
    return GestureDetector(
      onTap: () async {
        if (_key.currentState.validate()) {

          controller.processing(true);
          
          var accountServices = AccountServices();
          // todo change device token
          APIResponse response = await accountServices.signUp(phone: _phoneController.text,
              password: _passwordController.text, device_token: '1234');
          if (response != null){
            if (response.status == '1'){
              Get.snackbar('', response.message);
              _setData(response.data);
              Get.to(SetupProfileScreen());
            }else{
              Get.snackbar('', response.message);
            }
          }else{
            print('API response is null');
            Get.snackbar('','Oops! Server is Down');
          }


          controller.processing(false);

          
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

  void _setData(Map<String, dynamic> data) async{

    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(SharedPreVariables.TOKEN, data[SharedPreVariables.TOKEN]);
    await prefs.setString(SharedPreVariables.REFRESH_TOKEN, data[SharedPreVariables.REFRESH_TOKEN]);
    await prefs.setInt(SharedPreVariables.EXPRIRY_TIME, data[SharedPreVariables.EXPRIRY_TIME]);
    DateTime expiryDateTime =  DateTime.now().add(Duration(days: 30));
    await prefs.setString(SharedPreVariables.EXPRIRY_DATE, expiryDateTime.toString());

    // logger.i(prefs.getString('customer_name'));
    // logger.i(prefs.getString('customer_image'));
    // logger.i(prefs.getInt('cart_id'));
    // logger.i(prefs.getString('token'));
    // logger.i(prefs.getString('refresh_token'));
    // logger.i(prefs.getInt('expiry_time'));
  }

}
