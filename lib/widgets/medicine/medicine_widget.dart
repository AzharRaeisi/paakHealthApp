import 'package:flutter/material.dart';
import 'package:paakhealth/models/medicine_model.dart';
import 'package:paakhealth/screens/medicine/product_detial_screen.dart';
import 'package:paakhealth/util/colors.dart';
import 'package:paakhealth/util/font.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';

class MedicineWidget extends StatelessWidget {
  const MedicineWidget({
    Key key,
    @required this.medicine,
    @required this.favorite
  }) : super(key: key);

  final MedicineModel medicine;

  final VoidCallback favorite;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Get.to(() =>
        //     ProductDetialScreen(id: medicines[index].id));
        pushNewScreen(
          context,
          screen: ProductDetialScreen(id: medicine.id),
          withNavBar: true,
          // OPTIONAL VALUE. True by default.
          pageTransitionAnimation: PageTransitionAnimation.cupertino,
        );
      },
      child: Container(
          color: Colors.white,
          height: 170,
          margin: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
          padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.maxFinite,
                height: 100.0,
                color: AppColors.primaryColor,
                child: Stack(
                  children: [
                    FadeInImage(
                      fit: BoxFit.cover,
                      image: NetworkImage(medicine.image),
                      placeholder: AssetImage('assets/m_ph.png'),
                    ),
                    Positioned(
                        right: 7,
                        top: 7,
                        child: GestureDetector(
                          onTap: favorite,
                          child: Icon(
                            medicine.is_favorite == 0
                                ? Icons.favorite_border
                                : Icons.favorite,
                            color: Colors.white,
                            size: 18,
                          ),
                        ))
                  ],
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                medicine.name,
                style: TextStyle(
                    fontSize: 12,
                    color: Color(0xFF726966),
                    fontFamily: AppFont.Gotham,
                    fontWeight: FontWeight.w400),
              ),
              SizedBox(
                height: 3,
              ),
              Text(
                medicine.weight_quantity,
                style: TextStyle(
                    fontSize: 10,
                    fontFamily: AppFont.Gotham,
                    fontWeight: FontWeight.w400),
              ),
              Spacer(),
              Text(
                'Rs ' + medicine.price.toString() + '.00',
                style: TextStyle(
                    fontFamily: AppFont.Gotham,
                    fontWeight: FontWeight.w700,
                    fontSize: 10,
                    color: AppColors.primaryColor),
              ),
            ],
          )),
    );
  }
}
