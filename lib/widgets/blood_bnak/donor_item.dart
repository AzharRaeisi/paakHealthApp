
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:paakhealth/models/api_response.dart';
import 'package:paakhealth/models/donar_model.dart';
import 'package:paakhealth/screens/blood_bank/blood_bank_detail_screen.dart';
import 'package:paakhealth/services/bloodbank_services.dart';
import 'package:paakhealth/util/colors.dart';
import 'package:paakhealth/util/font.dart';
import 'package:paakhealth/util/prefernces.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DonorItem extends StatelessWidget {
  const DonorItem({
    Key key,
    @required this.model
  }) : super(key: key);

  final DonarModel model;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Get.to(() => BloodBankDetailScreen(model: donarList[index],));
        pushNewScreen(
          context,
          screen: BloodBankDetailScreen(
            model: model,
          ),
          withNavBar: true, // OPTIONAL VALUE. True by default.
          pageTransitionAnimation: PageTransitionAnimation.cupertino,
        );
      },
      child: Container(
        height: 100,
        color: Colors.white,
        margin: EdgeInsets.only(bottom: 10.0),
        padding: EdgeInsets.all(10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
                radius: 38.0,
                backgroundColor: AppColors.primaryColor,
                child: CircleAvatar(
                  radius: 36,
                  backgroundImage: NetworkImage(model.profile_image),
                )),
            SizedBox(
              width: 15,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  model.name,
                  style: TextStyle(
                    fontSize: 14.0,
                    color: Color(0xFF4D4D4D),
                    fontFamily: AppFont.Gotham,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(
                  height: 10.0,
                ),
                Text(
                  model.city,
                  style: TextStyle(
                    color: Color(0xFF808080),
                      fontFamily: AppFont.Gotham,
                      fontWeight: FontWeight.w400,
                      fontSize: 12),
                ),
                Spacer(),
                Text(
                  'Blood group: ' + model.blood_group,
                  style: TextStyle(
                      color: Color(0xFF808080),
                      fontFamily: AppFont.Gotham,
                      fontWeight: FontWeight.w400,
                      fontSize: 12),
                ),
              ],
            ),
            Spacer(),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                GestureDetector(
                  child: Icon(
                    Icons.favorite_border,
                    color: AppColors.primaryColor,
                    size: 18,
                  ),
                ),
                GestureDetector(
                  onTap: () async {
                    var bloodBankServices = BloodBankServices();
                    // todo change device token
                    SharedPreferences prefs = await SharedPreferences.getInstance();
                    String token = prefs.getString(SharedPreVariables.TOKEN);
                    // print(token);
                    APIResponse response = await bloodBankServices.requestForBlodd(
                        token: token, blood_bank_id: model.id);
                    if (response != null) {
                      if (response.status == '1') {
                        Get.snackbar('', response.message);
                      } else {
                        Get.snackbar('', response.message);
                      }
                    } else {
                      print('API response is null');
                      Get.snackbar('', 'Oops! Server is Down');
                    }
                  },
                  child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                      decoration: BoxDecoration(
                          color: AppColors.primaryColor,
                          borderRadius: BorderRadius.circular(5)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.send,
                            color: Colors.white,
                            size: 14,
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Text(
                            'REQUEST',
                            style: TextStyle(
                                fontFamily: AppFont.Gotham,
                                fontWeight: FontWeight.w500,
                                fontSize: 12,
                                color: Colors.white),
                          ),
                        ],
                      )),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
