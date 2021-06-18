import 'package:get/get.dart';
import 'package:paakhealth/models/doctor_slot_model.dart';

class SelectedSlotController extends GetxController{


  RxList<DoctorSlotModel> selectedSlot = <DoctorSlotModel>[].obs;

  addToExpertList(DoctorSlotModel s){
    selectedSlot.add(s);

  }

  removeFromExpertList(DoctorSlotModel s){
    selectedSlot.remove(s);
  }

  removeAllExpertise(){
    selectedSlot.clear();
  }


}