import 'package:get/get.dart';

class WelcomeScreenController extends GetxController{
  RxBool isProcessing = false.obs;

  processing(bool value){
    isProcessing.value = value;
  }



}