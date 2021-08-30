import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:paakhealth/models/api_response.dart';
import 'package:paakhealth/models/medicine_model.dart';
import 'package:paakhealth/models/store_model.dart';
import 'package:paakhealth/screens/medicine/medicine_screen.dart';
import 'package:paakhealth/screens/purchase/delivery_info_screen.dart';
import 'package:paakhealth/services/home_services.dart';
import 'package:paakhealth/util/colors.dart';
import 'package:paakhealth/util/font.dart';
import 'package:paakhealth/util/prefernces.dart';
import 'package:paakhealth/util/text_style.dart';
import 'package:paakhealth/widgets/medicine/medicine_widget.dart';
import 'package:paakhealth/widgets/medicine/medicine_widget_add_to_cart.dart';
import 'package:paakhealth/widgets/primaryButton.dart';
import 'package:paakhealth/widgets/toast/toast.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
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
  List<MedicineModel> completeMedicineList = [];
  List<MedicineModel> sampleMedicineList = [];

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
          style: AppTextStyle.appbarTextStyle,
        ),
        centerTitle: true,
        elevation: 2,
        backgroundColor: Colors.white,
      ),
      body: loading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Column(
              children: [
                Container(
                    height: 200,
                    padding: EdgeInsets.all(30),
                    child: FadeInImage(
                      image: NetworkImage(storeModel.profile_image),
                      placeholder: AssetImage('assets/p_ph.png'),
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
                        fontFamily: AppFont.Gotham,
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                      )),
                ),
                SizedBox(
                  height: 10,
                ),
                Expanded(
                  child: SingleChildScrollView(
                    physics: BouncingScrollPhysics(),
                    child: ResponsiveGridList(
                        desiredItemWidth:
                            MediaQuery.of(context).size.width * .30,
                        scroll: false,
                        children: sampleMedicineList.map((e) {
                          int i = sampleMedicineList.indexOf(e);
                          return MedicineWidget(
                            medicine: e,
                            favorite: (){
                              changeFavorite(e.id, i);
                            },
                          );
                        }).toList()),
                  ),
                ),
                Align(
                    alignment: Alignment.centerRight,
                    child: Container(
                        padding:
                            EdgeInsets.only(right: 10, top: 10, bottom: 10),
                        child: GestureDetector(
                          onTap: () {
                            // Get.to(() => MedicinesScreen(
                            //   medicines: completeMedicineList,
                            //   storeId: storeModel.id,
                            // ));
                            pushNewScreen(
                              context,
                              screen: MedicinesScreen(
                                medicines: completeMedicineList,
                                storeId: storeModel.id,
                              ),
                              withNavBar:
                                  true, // OPTIONAL VALUE. True by default.
                              pageTransitionAnimation:
                                  PageTransitionAnimation.cupertino,
                            );
                          },
                          child: Text('See More...',
                              style: TextStyle(
                                fontSize: 12,
                                fontFamily: AppFont.Avenirl,
                                fontWeight: FontWeight.w400,
                              )),
                        ))),
                _primaryBtn(
                    btnText: 'Upload Prescribtion')
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
          style: TextStyle(
              fontFamily: AppFont.Avenirl,
              fontWeight: FontWeight.w400,
              color: Colors.white,
              fontSize: 12),
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
        completeMedicineList =
            medicineListItr.map((list) => MedicineModel.fromMap(list)).toList();

        if (completeMedicineList.length > 12) {
          sampleMedicineList = completeMedicineList.sublist(0, 11);
        } else {
          sampleMedicineList = completeMedicineList;
        }

        // print(response.data['medicine_list']);
        //
        // print (medicines.length);
        loading = false;
        setState(() {});
      } else {
        ShowMessage.message(message: response.message);
      }
    } else {
      print('API response is null');
      ShowMessage.message(message: 'Oops! Server is Down');
    }
  }

// Widget medicinesRow() {
// return MedicineWidget(medicines: medicines);
// }

  Widget _primaryBtn({String btnText}) {
    return GestureDetector(
      onTap: () {
        showModalBottomSheet(
          context: context,
          builder: ((builder) => bottomSheet()),
        );
      },
      child: AppPrimaryButton(text: btnText, ),
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
                builder: (context) => DeliveryInfoScreen(
                      image: _image,
                      storeId: storeModel.id,
                    )));
      } else {
        print('No image selected.');
      }
    });
  }


  Future<void> changeFavorite(int id, int index) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString(SharedPreVariables.TOKEN);

    var homeService = HomeServices();
    APIResponse response =
    await homeService.markMedicineFavorite(token: token, medicine_id: id);
    if (response != null) {
      if (response.status == '1') {
        // ShowMessage.message(message: response.message);
        print('response.data');

        sampleMedicineList[index].is_favorite = response.favoriteStatus;
        setState(() {

        });
        // ShowMessage.message(message: response.message);
      } else {
        ShowMessage.message(message: response.message);
      }
    } else {
      print('API response is null');
      ShowMessage.message(message: 'Oops! Server is Down');
    }
  }
}
