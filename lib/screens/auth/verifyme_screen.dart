import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:paakhealth/controllers/verifyme_screen_controller.dart';
import 'package:paakhealth/models/api_response.dart';
import 'package:paakhealth/screens/auth/enter_code_screen.dart';
import 'package:paakhealth/services/account_services.dart';
import 'package:paakhealth/util/colors.dart';
import 'package:paakhealth/widgets/primaryButton.dart';

class VerifyMeScreen extends StatelessWidget {
  GlobalKey<FormState> _key = GlobalKey<FormState>();
  TextEditingController _phoneController = new TextEditingController();
  bool isProcessing = false;


  VerifyMeScreenController controller = Get.put(VerifyMeScreenController());

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
                'Verify your mobile number',
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
                  child: buildPhoneTextField()),
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


  // Widget _row({String firstStr, String secondStr}) {
  //   return Row(
  //     mainAxisAlignment: MainAxisAlignment.center,
  //     children: [
  //       Text(
  //         firstStr,
  //         style: TextStyle(color: Colors.grey[500]),
  //       ),
  //       SizedBox(width: 5),
  //       GestureDetector(
  //         onTap: () {
  //           if (controller.isProcessing.value)
  //             Get.snackbar('Processing', 'Please wait.');
  //           else
  //             Get.to(WelcomeBackScreen());
  //         },
  //         child: Text(
  //           secondStr,
  //           style: TextStyle(color: AppColors.primaryColor),
  //         ),
  //       )
  //     ],
  //   );
  // }

  Widget _primaryBtn({String btnText}) {
    return GestureDetector(
      onTap: () async {
        if (_key.currentState.validate()) {

          controller.processing(true);

          var accountServices = AccountServices();
          // todo change device token
          APIResponse response = await accountServices.checkPhoneVerification(phone: _phoneController.text);
          if (response != null){
            if (response.status == '1'){
              Get.snackbar('', response.message);
            }else if(response.status == '2'){
              Get.to(() => EnterCodeScreen(phone: _phoneController.text, forgetPassword: false,));
            }
            else{
              Get.snackbar('', response.message);
            }
          }else{
            print('API response is null');
            Get.snackbar('','Oops! Server is Down');
          }

          controller.processing(false);


        }
      },
      child: AppPrimaryButton(text: btnText,),
    );
  }




}
