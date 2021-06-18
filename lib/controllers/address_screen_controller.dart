
import 'package:get/get.dart';

class AddressScreenController extends GetxController{

  RxBool editable = false.obs;
  RxBool isProcessing = false.obs;

  updateEditable(bool val){
    editable.value = val;
  }

  updateIsProcessing(bool val){
    isProcessing.value = val;
  }
}