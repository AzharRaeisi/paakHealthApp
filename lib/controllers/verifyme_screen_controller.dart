import 'package:get/get.dart';

class VerifyMeScreenController extends GetxController{
  RxBool isProcessing = false.obs;

  processing(bool value){
    isProcessing.value = value;
  }



}