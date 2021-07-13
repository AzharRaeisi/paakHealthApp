import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:paakhealth/models/doctor_model.dart';
import 'package:paakhealth/screens/doctor/doctor_detail_screen.dart';
import 'package:paakhealth/util/colors.dart';
import 'package:paakhealth/util/font.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';

class DoctorCard extends StatelessWidget {
  DoctorCard({this.doctor, Key key}) : super(key: key);

  final DoctorModel doctor;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.to(() => DoctorDetailScreen(id: doctor.id));
      },
      child: Container(
        height: 225,
        margin: EdgeInsets.all(5),
        decoration: BoxDecoration(
          color: Colors.white,
            border: Border.all(color: Colors.lightBlueAccent[100])),
        child: Stack(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 20,
                    ),
                    CircleAvatar(
                      backgroundImage: NetworkImage(doctor.image),
                      radius: 50,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      doctor.name,
                      style: TextStyle(
                          fontFamily: AppFont.Gotham,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF393132),
                          fontSize: 18),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(
                      height: 7,
                    ),
                    Text(
                      doctor.expertise.length > 20
                          ? doctor.expertise.substring(0, 17) + '...'
                          : doctor.expertise,
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 14,
                        fontFamily: AppFont.Gotham,
                        fontWeight: FontWeight.w400,
                        color: Color(0xFF726966),
                      ),
                    ),
                    Spacer(),
                    GestureDetector(
                      onTap: () {
                        pushNewScreen(
                          context,
                          screen: DoctorDetailScreen(
                            id: doctor.id,
                            bookNow: true,
                          ),
                          withNavBar: true,
                          // OPTIONAL VALUE. True by default.
                          pageTransitionAnimation:
                              PageTransitionAnimation.cupertino,
                        );
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: <Color>[
                              Color(0xFF69C4F0),
                              Color(0xFF00B2EE),
                            ],
                          ),
                          borderRadius: BorderRadius.all(Radius.circular(5.0)),
                        ),
                        child: Text(
                          'BOOK NOW',
                          style: TextStyle(
                              fontSize: 12,
                              color: Colors.white,
                              fontFamily: AppFont.Gotham,
                              fontWeight: FontWeight.w500),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),

                  ],
                ),
              ],
            ),
            Positioned(
                left: 7,
                top: 7,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.circle,
                      size: 10,
                      color: Colors.greenAccent,
                    ),
                    Text(
                      ' Rs ' + doctor.fees.toString(),
                      style: TextStyle(
                          fontFamily: AppFont.Gotham,
                          fontWeight: FontWeight.w500),
                    )
                  ],
                )),
            Positioned(
                right: 7,
                top: 7,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.star_border,
                      color: AppColors.primaryColor,
                      size: 16,
                    ),
                    SizedBox(
                      width: 3,
                    ),
                    Text(
                      doctor.rating,
                      style: TextStyle(
                          fontFamily: AppFont.Gotham,
                          fontWeight: FontWeight.w700),
                    )
                  ],
                ))
          ],
        ),
      ),
    );
  }
}
