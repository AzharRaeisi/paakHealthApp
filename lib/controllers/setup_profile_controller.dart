import 'package:get/get.dart';
import 'package:paakhealth/models/setup_profile_model.dart';

class SetupProfileController extends GetxController{

  Rx<SetupProfileModel> model = SetupProfileModel().obs;

  updateModel(String name, String email, String gender, String profile_image){
    model.update((val) {
      val.name = name;
      val.email = email;
      val.gender = gender;
      val.profile_image = profile_image;
    });
  }

}