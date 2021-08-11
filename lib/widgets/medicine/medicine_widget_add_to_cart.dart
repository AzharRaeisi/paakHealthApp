import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:paakhealth/models/api_response.dart';
import 'package:paakhealth/models/medicine_model.dart';
import 'package:paakhealth/screens/purchase/delivery_info_screen.dart';
import 'package:paakhealth/screens/medicine/medicine_detial_screen.dart';
import 'package:paakhealth/services/cart_services.dart';
import 'package:paakhealth/util/colors.dart';
import 'package:paakhealth/util/prefernces.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MedicineAddToCartWidget extends StatelessWidget {
  const MedicineAddToCartWidget({
    Key key,
    @required this.medicine,
  }) : super(key: key);

  final MedicineModel medicine;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.to(() => ProductDetialScreen(id: medicine.id));
      },
      child: Container(
          height: 171,
          padding: EdgeInsets.symmetric(horizontal: 5),
          margin: EdgeInsets.only(bottom: 25),
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.symmetric(horizontal: 5),
                padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                width: 80.0,
                height: 80.0,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border:
                        Border.all(color: AppColors.primaryColor, width: 2)),
                child: FadeInImage(
                  image: NetworkImage(medicine.image),
                  placeholder: AssetImage('assets/avatar.png'),
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
              Spacer(),
              Text(
                'Rs ' + medicine.price.toString() + '.00',
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 10,
                    color: AppColors.primaryColor),
              ),
              SizedBox(
                height: 10,
              ),
              medicine.is_prescribed == 0
                  ? GestureDetector(
                      onTap: () {
                        addtoCart(medicine);
                      },
                      child: Container(
                        padding: EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: <Color>[
                              Color(0xFF69C4F0),
                              Color(0xFF00B2EE),
                            ],
                          ),
                          // borderRadius: BorderRadius.all(Radius.circular(5.0)),
                        ),
                        child: Text(
                          'Add to Cart',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white
                          ),
                        ),
                      ),
                    )
                  : GestureDetector(
                      onTap: () {
                        // todo handle upload prescribtion
                        showModalBottomSheet(
                          context: context,
                          builder: ((builder) => bottomSheet(context)),
                        );
                      },
                      child: Text(
                        'Upload Prescription',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
              SizedBox(
                height: 10,
              ),
              Divider(thickness: 1, height: 1,)
            ],
          )),
    );
  }

  Future<void> addtoCart(MedicineModel model) async {
    var cartServices = CartServices();
    // todo change device token
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString(SharedPreVariables.TOKEN);

    print(token);
    APIResponse response = await cartServices.addToCart(
        token: token,
        store_id: model.store_id,
        medicine_id: model.id,
        quantity: 1);
    if (response != null) {
      if (response.status == '1') {
        // Get.snackbar('', response.message);
        print('response.data');
        Get.snackbar('', response.message);
      } else {
        Get.snackbar('', response.message);
      }
    } else {
      print('API response is null');
      Get.snackbar('', 'Oops! Server is Down');
    }
  }

  Widget bottomSheet(BuildContext context) {
    return Container(
      height: 100,
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Choose Profile Photo'),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextButton.icon(
                  onPressed: () {
                    Navigator.pop(context);
                    getImage(ImageSource.camera, context);
                  },
                  icon: Icon(Icons.camera),
                  label: Text('Camera')),
              TextButton.icon(
                  onPressed: () {
                    Navigator.pop(context);
                    getImage(ImageSource.gallery, context);
                  },
                  icon: Icon(Icons.image),
                  label: Text('Gallery')),
            ],
          ),
        ],
      ),
    );
  }

  void getImage(ImageSource source, BuildContext context) async {
    final pickedFile = await ImagePicker().getImage(source: source);

    if (pickedFile != null) {
      File image = File(pickedFile.path);
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => DeliveryInfoScreen(image: image, storeId: 0,)));
    } else {
      print('No image selected.');
    }
  }

}
