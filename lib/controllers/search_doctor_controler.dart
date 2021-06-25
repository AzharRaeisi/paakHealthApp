
import 'package:get/get.dart';
import 'package:paakhealth/models/doctor_expertise_model.dart';
// import 'package:paakhealth/models/doctor_model.dart';

class SearchDoctorController extends GetxController{

  RxList<DoctorExpertiseModel> selectedExpertise = <DoctorExpertiseModel>[].obs;

  addToExpertList(DoctorExpertiseModel expertiseModel){
    selectedExpertise.add(expertiseModel);

  }

  removeFromExpertList(DoctorExpertiseModel expertiseModel){
    selectedExpertise.remove(expertiseModel);
  }

  removeAllExpertise(){
    selectedExpertise.value.clear();
  }

}