import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:paakhealth/models/doctor_model.dart';
import 'package:paakhealth/screens/doctor_detail_screen.dart';
import 'package:paakhealth/util/colors.dart';

class DoctorCard extends StatelessWidget {
  DoctorCard({this.doctor, Key key}) : super(key: key);

  final DoctorModel doctor;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        Get.to(() => DoctorDetailScreen(id: doctor.id));
      },
      child: Container(
        height: 200,
        margin: EdgeInsets.all(5),
        decoration:
            BoxDecoration(border: Border.all(color: Colors.lightBlueAccent[100])),
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [

                SizedBox(
                  height: 5,
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
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 7,),
                Text(
                    doctor.expertise.length > 20
                  ? doctor.expertise.substring(0, 17) + '...'
                  : doctor.expertise,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 14),
                ),
                Spacer(),
                Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.location_on,
                      color: AppColors.primaryColor,
                    ),
                    SizedBox(width: 12,),
                    Text(
                      doctor.address,
                      style: TextStyle(color: AppColors.primaryColor),
                    )
                  ],
                ),

                SizedBox(height: 7,),
              ],
            ),
            Positioned(
                left: 7,
                top: 7,
                child: Icon(
                  Icons.circle,
                  size: 10,
                  color: Colors.greenAccent,
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
                    SizedBox(width: 3,),
                    Text(
                      doctor.rating,
                    )
                  ],
                )
            )
          ],
        ),
      ),
    );
  }
}
