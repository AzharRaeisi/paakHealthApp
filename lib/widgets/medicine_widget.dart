import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:paakhealth/models/medicine_model.dart';
import 'package:paakhealth/screens/product_detial_screen.dart';
import 'package:paakhealth/util/colors.dart';

class MedicineWidget extends StatelessWidget {
  const MedicineWidget({
    Key key,
    @required this.medicine,
  }) : super(key: key);

  final MedicineModel medicine;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.to(() =>
            ProductDetialScreen(id: medicine.id));
      },
      child: Container(
          padding: EdgeInsets.symmetric(horizontal: 5),
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.symmetric(horizontal: 5),
                padding: EdgeInsets.symmetric(
                    horizontal: 5, vertical: 5),
                width: 80.0,
                height: 80.0,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                        color: AppColors.primaryColor,
                        width: 2)),
                child: FadeInImage(
                  image: NetworkImage(medicine.image),
                  placeholder:
                  AssetImage('assets/avatar.png'),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                medicine.name,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
              Text(
                medicine.weight_quantity,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 10,
                ),
              ),
              Text(
                'Rs ' +
                    medicine.price.toString() +
                    '.00',
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 10,
                    color: AppColors.primaryColor),
              ),
            ],
          )),
    );
  }
}