import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:paakhealth/util/colors.dart';

class ShowMessage{

  static void message({String title = 'PaakHealth', String message = ''}){
    Get.snackbar(title, message,
      icon: Image.asset('assets/app_logo.png'),
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.white,
      borderRadius: 5,
      margin: EdgeInsets.all(14),
      colorText: AppColors.primaryColor,
      duration: Duration(seconds: 4),
      isDismissible: true,
      dismissDirection: SnackDismissDirection.HORIZONTAL,
      borderWidth: 1,
      borderColor: AppColors.primaryColor,
      forwardAnimationCurve: Curves.easeOutBack,);

  }

}