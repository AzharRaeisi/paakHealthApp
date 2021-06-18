import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:paakhealth/models/api_response.dart';
import 'package:paakhealth/models/medicine_model.dart';
import 'package:paakhealth/models/store_model.dart';
import 'package:paakhealth/screens/delivery_info_screen.dart';
import 'package:paakhealth/screens/medicine_screen.dart';
import 'package:paakhealth/screens/product_detial_screen.dart';
import 'package:paakhealth/services/home_services.dart';
import 'package:paakhealth/util/colors.dart';
import 'package:paakhealth/util/prefernces.dart';
import 'package:paakhealth/widgets/medicine_widget.dart';
import 'package:responsive_grid/responsive_grid.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PharcmayDetailScreen extends StatefulWidget {
  final int id;

  const PharcmayDetailScreen({Key key, @required this.id}) : super(key: key);

  @override
  _PharcmayDetailScreenState createState() => _PharcmayDetailScreenState();
}

class _PharcmayDetailScreenState extends State<PharcmayDetailScreen> {
  StoreModel storeModel;
  bool loading = true;
  List<MedicineModel> medicines = [];

  File _image;

  @override
  void initState() {
    // TODO: implement initState
    getPharmacy(id: widget.id);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // storeModel = widget.model;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_rounded),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        iconTheme: IconThemeData(color: AppColors.primaryColor),
        title: Text(
          loading ? 'Loading' : storeModel.name,
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 2,
        backgroundColor: Colors.white,
      ),
      body: loading
          ? Center(
              child: CircularProgressIndicator(),
            )
          :
      Column(
        children: [
          Container(
              height: 200,
              padding: EdgeInsets.all(30),
              child: FadeInImage(
                image: NetworkImage(storeModel.profile_image),
                placeholder: AssetImage('assets/avatar.png'),
                fit: BoxFit.cover,
              )),
          Container(
            color: AppColors.primaryColor,
            padding: EdgeInsets.all(10),
            child: IntrinsicHeight(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  rowItem(Icons.add_location, storeModel.city),
                  VerticalDivider(
                    color: Colors.white,
                    width: 26,
                  ),
                  rowItem(Icons.phone, storeModel.phone),
                  VerticalDivider(
                    color: Colors.white,
                    width: 26,
                  ),
                  rowItem(Icons.access_time_rounded,
                      storeModel.working_hours),
                ],
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Container(
            alignment: Alignment.centerLeft,
            margin: EdgeInsets.only(left: 10),
            child: Text('Medicines',
                style: TextStyle(
                  color: AppColors.primaryColor,
                  fontSize: 14,
                )),
          ),
          SizedBox(
            height: 10,
          ),
          Expanded(
            child: ResponsiveGridList(
                desiredItemWidth: MediaQuery.of(context).size.width * .20,
                children: medicines.map((e) {
                  return MedicineWidget(
                    medicine: e,
                  );
                }).toList()),
          ),
          Align(
              alignment: Alignment.centerRight,
              child: Container(
                  padding: EdgeInsets.only(right: 10, top: 10, bottom: 10),
                  child: GestureDetector(
                    onTap: () {
                      Get.to(() => MedicinesScreen(
                        medicines: medicines,
                        storeId: storeModel.id,
                      ));
                    },
                    child: Text('See More...',
                        style: TextStyle(
                          fontSize: 12,
                        )),
                  ))),

          _primaryBtn(btnText: 'Upload Prescribtion to ' + storeModel.name)
        ],
      ),
    );
  }

  rowItem(IconData icon, String text) {
    return Column(
      children: [
        Icon(
          icon,
          color: Colors.white,
          size: 20,
        ),
        Text(
          text,
          style: TextStyle(color: Colors.white, fontSize: 12),
        )
      ],
    );
  }

  getPharmacy({int id}) async {
    var homeServices = HomeServices();
    // todo change device token
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString(SharedPreVariables.TOKEN);

    APIResponse response =
        await homeServices.pharmacyDetail(token: token, store_id: id);
    if (response != null) {
      if (response.status == '1') {
        storeModel = StoreModel.fromMap(response.data['details']);
        // print(storeModel.id);

        Iterable medicineListItr = response.data['medicine_list'];
        medicines =
            medicineListItr.map((list) => MedicineModel.fromMap(list)).toList();

        // print(response.data['medicine_list']);
        //
        // print (medicines.length);
        loading = false;
        setState(() {});
      } else {
        Get.snackbar('', response.message);
      }
    } else {
      print('API response is null');
      Get.snackbar('', 'Oops! Server is Down');
    }
  }

// Widget medicinesRow() {
// return MedicineWidget(medicines: medicines);
// }

  Widget _primaryBtn({String btnText}) {
    return GestureDetector(
      onTap: (){
        showModalBottomSheet(
          context: context,
          builder: ((builder) => bottomSheet()),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: <Color>[
              Color(0xFF69C4F0),
              Color(0xFF00B2EE),
            ],
          ),
          // borderRadius: BorderRadius.all(Radius.circular(5.0)),
        ),
        alignment: Alignment.center,
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              Icons.camera_alt_outlined,
              color: Colors.white,
            ),
            SizedBox(width: 10,),
            Expanded(
              child: Text(
                btnText,
                style: TextStyle(color: Colors.white, fontSize: 18),
                textAlign: TextAlign.center,
              )
            ),
          ],
        ),
      ),
    );
  }

  Widget bottomSheet() {
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
                    getImage(ImageSource.camera);
                  },
                  icon: Icon(Icons.camera),
                  label: Text('Camera')),
              TextButton.icon(
                  onPressed: () {
                    Navigator.pop(context);
                    getImage(ImageSource.gallery);
                  },
                  icon: Icon(Icons.image),
                  label: Text('Gallery')),
            ],
          ),
        ],
      ),
    );
  }

  void getImage(ImageSource source) async {
    final pickedFile = await ImagePicker().getImage(source: source);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => DeliveryInfoScreen(image: _image, storeId: storeModel.id,)));
      } else {
        print('No image selected.');
      }
    });
  }

}
