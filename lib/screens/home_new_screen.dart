import 'dart:io';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:paakhealth/models/api_response.dart';
import 'package:paakhealth/models/banner_model.dart';
import 'package:paakhealth/models/doctor_model.dart';
import 'package:paakhealth/models/medicine_model.dart';
import 'package:paakhealth/models/store_model.dart';
import 'package:paakhealth/screens/blood_bank_screen.dart';
import 'package:paakhealth/screens/doctor_detail_screen.dart';
import 'package:paakhealth/screens/doctors_screen.dart';
import 'package:paakhealth/screens/delivery_info_screen.dart';
import 'package:paakhealth/screens/medicine_screen.dart';
import 'package:paakhealth/screens/pharmacy_detail_screen.dart';
import 'package:paakhealth/screens/pharmacy_screen.dart';
import 'package:paakhealth/screens/product_detial_screen.dart';
import 'package:paakhealth/services/home_services.dart';
import 'package:paakhealth/util/colors.dart';
import 'package:paakhealth/util/prefernces.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MainHomeScreen extends StatefulWidget {
  const MainHomeScreen({Key key}) : super(key: key);

  @override
  _MainHomeScreenState createState() => _MainHomeScreenState();
}

class _MainHomeScreenState extends State<MainHomeScreen> {
  // File _image;
  // List<BannerModel> mainBanners = [];
  List<StoreModel> stores = [];
  List<MedicineModel> medicines = [];
  List<DoctorModel> doctors = [];

  List<String> imgList = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        // iconTheme: IconThemeData(color: AppColors.primaryColor),
        leading: Container(),
        title: Image.asset('assets/paakhealth.png'),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Container(
              //     height: 170,
              //     child: CarouselSlider(
              //       options: CarouselOptions(
              //         height: 170,
              //         viewportFraction: 1.0,
              //         enlargeCenterPage: false,
              //         autoPlay: true,
              //         ),
              //       items: imgList.map((item) => Container(
              //         child: Center(
              //             child: Image.network(item, fit: BoxFit.cover, height: 170)
              //         ),
              //       )).toList(),
              //     )
              // ),
              Container(
                height: 250,
                padding: EdgeInsets.all(10),
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5.0)),
                              color: Color(0xFFC3E8E3)),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              textWidget(
                                  'ONLINE DOCTOR', Color(0xFF509EC8)),
                              SizedBox(
                                height: 5,
                              ),
                              button('CONSULT NOW', Color(0xFF509EC8)),
                              // Spacer(),
                              Expanded(child: Align(
                                alignment: Alignment.center,
                                  child: Image.asset('assets/doctor.png', fit: BoxFit.cover,)))
                            ],
                          )),
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Expanded(
                            child: Container(
                                padding: EdgeInsets.all(5),
                                decoration: BoxDecoration(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(5.0)),
                                    color: Color(0xFFC6EAF1)),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    textWidget('MEDICINES', Color(0xFF1B2780)),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    button('ORDER NOW', Color(0xFF1B2780)),
                                    Expanded(
                                        child: Align(
                                          alignment: Alignment.centerRight,
                                          child: Image.asset(
                                              'assets/medicine.png'),
                                        ))
                                  ],
                                )),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Expanded(
                            child: Container(
                                padding: EdgeInsets.all(5),
                                decoration: BoxDecoration(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(5.0)),
                                    color: Color(0xFFFDDFE0)),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    textWidget(
                                        'BLOOD BANK', Color(0xFFFA5A60)),
                                    SizedBox(width: 5,),
                                    Row(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                      children: [
                                        button('DONATE NOW', Color(0xFFFA5A60)),
                                        SizedBox(width: 5,),
                                        Expanded(
                                            child: Image.asset(
                                                'assets/blood.png'))
                                      ],
                                    )
                                  ],
                                )),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    margin: EdgeInsets.only(left: 10, top: 10, bottom: 10),
                    child: Text('Online Pharmacy',
                        style: TextStyle(
                          color: AppColors.primaryColor,
                          fontSize: 14,
                        )),
                  ),
                  Container(
                    margin: EdgeInsets.only(right: 10),
                    child: GestureDetector(
                      onTap: () {
                        Get.to(() => OnlinePharmacyScreen(
                              stores: stores,
                            ));
                      },
                      child: Text('See More...',
                          style: TextStyle(
                            fontSize: 12,
                          )),
                    ),
                  ),
                ],
              ),
              onlinepharmacy(),

              SizedBox(
                height: 25,
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    margin: EdgeInsets.only(left: 10),
                    child: Text('Medicines',
                        style: TextStyle(
                          color: AppColors.primaryColor,
                          fontSize: 14,
                        )),
                  ),
                  Container(
                      padding: EdgeInsets.only(right: 10),
                      child: GestureDetector(
                        onTap: () {
                          Get.to(() => MedicinesScreen(
                                medicines: medicines,
                                storeId: 0,
                              ));
                        },
                        child: Text('See More...',
                            style: TextStyle(
                              fontSize: 12,
                            )),
                      ))
                ],
              ),

              SizedBox(
                height: 10,
              ),
              medicinesRow(),
              SizedBox(
                height: 25,
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    margin: EdgeInsets.only(left: 10),
                    child: Text('Doctors',
                        style: TextStyle(
                          color: AppColors.primaryColor,
                          fontSize: 14,
                        )),
                  ),
                  Container(
                      padding: EdgeInsets.only(right: 10),
                      child: GestureDetector(
                        onTap: () {
                          Get.to(
                              () => DoctorAppointmentScreen(doctors: doctors));
                        },
                        child: Text('See More...',
                            style: TextStyle(
                              fontSize: 12,
                            )),
                      ))
                ],
              ),
              SizedBox(
                height: 10,
              ),
              doctorItem(),
              // SizedBox(height: 20),
              // Icon(
              //   Icons.local_hospital_outlined,
              //   color: AppColors.primaryColor,
              // ),
              // Text(
              //   'Order with prescription',
              //   textAlign: TextAlign.center,
              //   style: TextStyle(fontSize: 12),
              // ),
              // SizedBox(height: 5),
              // _primaryBtn(btnText: 'Upload')
            ],
          ),
        ),
      ),
    );
  }

  // Widget _primaryBtn({String btnText}) {
  //   return Container(
  //     height: 170,
  //     decoration: const BoxDecoration(
  //       gradient: LinearGradient(
  //         colors: <Color>[
  //           Color(0xFF69C4F0),
  //           Color(0xFF00B2EE),
  //         ],
  //       ),
  //       // borderRadius: BorderRadius.all(Radius.circular(5.0)),
  //     ),
  //     alignment: Alignment.center,
  //     padding: EdgeInsets.symmetric(vertical: 5),
  //     child: TextButton.icon(
  //       onPressed: () {
  //         showModalBottomSheet(
  //           context: context,
  //           builder: ((builder) => bottomSheet()),
  //         );
  //       },
  //       icon: Icon(
  //         Icons.camera_alt_outlined,
  //         color: Colors.white,
  //       ),
  //       label: Text(
  //         btnText,
  //         style: TextStyle(color: Colors.white, fontSize: 18),
  //         textAlign: TextAlign.center,
  //       ),
  //     ),
  //   );
  // }

  // Widget bottomSheet() {
  //   return Container(
  //     height: 100,
  //     width: MediaQuery.of(context).size.width,
  //     margin: EdgeInsets.all(20),
  //     child: Column(
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: [
  //         Text('Choose Profile Photo'),
  //         SizedBox(height: 20),
  //         Row(
  //           mainAxisAlignment: MainAxisAlignment.center,
  //           children: [
  //             TextButton.icon(
  //                 onPressed: () {
  //                   Navigator.pop(context);
  //                   getImage(ImageSource.camera);
  //                 },
  //                 icon: Icon(Icons.camera),
  //                 label: Text('Camera')),
  //             TextButton.icon(
  //                 onPressed: () {
  //                   Navigator.pop(context);
  //                   getImage(ImageSource.gallery);
  //                 },
  //                 icon: Icon(Icons.image),
  //                 label: Text('Gallery')),
  //           ],
  //         ),
  //       ],
  //     ),
  //   );
  // }

  // void getImage(ImageSource source) async {
  //   final pickedFile = await ImagePicker().getImage(source: source);
  //
  //   setState(() {
  //     if (pickedFile != null) {
  //       _image = File(pickedFile.path);
  //       Navigator.push(
  //           context,
  //           MaterialPageRoute(
  //               builder: (context) => DeliveryInfoScreen(
  //                     image: _image,
  //                     storeId: 0,
  //                   )));
  //     } else {
  //       print('No image selected.');
  //     }
  //   });
  // }

  @override
  void initState() {
    // TODO: implement initState

    if (stores.length == 0) {
      print('=====================');
      print('store length is zer0');
      callHomeAPI();
      print('=====================');
    }
    super.initState();
  }

  void callHomeAPI() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    var homeServices = HomeServices();
    // todo change device token
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString(SharedPreVariables.TOKEN);
    print(token);
    print(position.latitude.toString());
    print(position.longitude.toString());
    APIResponse response = await homeServices.home(
        token: token,
        lat: position.latitude.toString(),
        long: position.longitude.toString());
    if (response != null) {
      if (response.status == '1') {
        // Get.snackbar('', response.message);
        // print("response.data['result']");
        // print(response.data['store']);
        // print(response.data['medicine']);
        // print(response.data['doctors']);

        // Iterable bannersIterable = response.data['banners'];
        // mainBanners =
        //     bannersIterable.map((list) => BannerModel.fromMap(list)).toList();
        //
        // mainBanners.forEach((element) {
        //   imgList.add(element.image);
        // });

        Iterable storeIterable = response.data['store'];
        stores = storeIterable.map((list) => StoreModel.fromMap(list)).toList();

        Iterable medicineIterable = response.data['medicine'];
        medicines = medicineIterable
            .map((list) => MedicineModel.fromMap(list))
            .toList();

        Iterable doctorIterable = response.data['doctors'];
        doctors =
            doctorIterable.map((list) => DoctorModel.fromMap(list)).toList();

        setState(() {});
      } else {
        Get.snackbar('', response.message);
      }
    } else {
      print('API response is null');
      Get.snackbar('', 'Oops! Server is Down');
    }
  }

  //  ////////////////////////////////////////////////
  //  ////////////////////////////////////////////////
  //  ////////////////////////////////////////////////
  //  ////////////////////////////////////////////////

  Widget doctorItem() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        children: [
          Expanded(
            child: SizedBox(
              height: 140,
              child: ListView.builder(
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  itemCount: doctors.length,
                  physics: BouncingScrollPhysics(),
                  itemBuilder: (BuildContext context, int index) =>
                      GestureDetector(
                        onTap: () {
                          Get.to(
                              () => DoctorDetailScreen(id: doctors[index].id));
                        },
                        child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 5),
                            child: Column(children: [
                              CircleAvatar(
                                  radius: 42.0,
                                  backgroundColor: AppColors.primaryColor,
                                  child: CircleAvatar(
                                    radius: 40,
                                    backgroundImage:
                                        NetworkImage(doctors[index].image),
                                  )),
                              SizedBox(
                                height: 7,
                              ),
                              Text(
                                doctors[index].name,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                              ),
                              Container(
                                width: 80,
                                child: Text(
                                  doctors[index].expertise.length > 15
                                      ? doctors[index]
                                              .expertise
                                              .substring(0, 12) +
                                          '...'
                                      : doctors[index].expertise,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 10,
                                  ),
                                ),
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Icon(
                                    Icons.location_on,
                                    color: AppColors.primaryColor,
                                    size: 16,
                                  ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Text(
                                    doctors[index].address,
                                    style: TextStyle(
                                        color: AppColors.primaryColor,
                                        fontSize: 10),
                                  ),
                                ],
                              )
                            ])),
                      )),
            ),
          ),
          // SizedBox(
          //   width: 5,
          // ),
          // GestureDetector(
          //   onTap: () {
          //     Get.to(() => DoctorAppointmentScreen(doctors: doctors));
          //   },
          //   child: Icon(Icons.arrow_forward_ios),
          // ),
          // SizedBox(
          //   width: 5,
          // ),
        ],
      ),
    );
  }

  Widget medicinesRow() {
    return Container(
      child: Row(
        children: [
          Expanded(
            child: SizedBox(
              height: 140,
              child: ListView.builder(
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  itemCount: medicines.length,
                  physics: BouncingScrollPhysics(),
                  itemBuilder: (BuildContext context, int index) =>
                      GestureDetector(
                        onTap: () {
                          Get.to(() =>
                              ProductDetialScreen(id: medicines[index].id));
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
                                    image: NetworkImage(medicines[index].image),
                                    placeholder: AssetImage('assets/m_ph.png'),
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  medicines[index].name,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12,
                                  ),
                                ),
                                Text(
                                  medicines[index].weight_quantity,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 10,
                                  ),
                                ),
                                Text(
                                  'Rs ' +
                                      medicines[index].price.toString() +
                                      '.00',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 10,
                                      color: AppColors.primaryColor),
                                ),
                              ],
                            )),
                      )),
            ),
          ),
          // SizedBox(
          //   width: 5,
          // ),
          // GestureDetector(
          //   onTap: () {
          //     Get.to(() => MedicinesScreen(
          //           medicines: medicines,
          //           storeId: 0,
          //         ));
          //   },
          //   child: Icon(Icons.arrow_forward_ios),
          // ),
          // SizedBox(
          //   width: 5,
          // ),
        ],
      ),
    );
  }

  Widget onlinepharmacy() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 5),
      child: Row(
        children: [
          Expanded(
            child: SizedBox(
              height: 80,
              child: ListView.builder(
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  physics: BouncingScrollPhysics(),
                  itemCount: stores.length,
                  itemBuilder: (BuildContext context, int index) =>
                      GestureDetector(
                        onTap: () {
                          Get.to(
                              () => PharcmayDetailScreen(id: stores[index].id));
                        },
                        child: Container(
                          margin: EdgeInsets.symmetric(horizontal: 5),
                          padding:
                              EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                          width: 80.0,
                          height: 80.0,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                  color: AppColors.primaryColor, width: 2)),
                          child: FadeInImage(
                            image: NetworkImage(stores[index].profile_image),
                            placeholder: AssetImage('assets/p_ph.png'),
                          ),
                        ),
                      )),
            ),
          ),
          // SizedBox(
          //   width: 5,
          // ),
          // GestureDetector(
          //   onTap: () {
          //     Get.to(() => OnlinePharmacyScreen(
          //           stores: stores,
          //         ));
          //   },
          //   child: Icon(Icons.arrow_forward_ios),
          // ),
          // SizedBox(
          //   width: 5,
          // ),
        ],
      ),
    );
  }

  textWidget(String s, Color color) {
    return Text(s, style: TextStyle(color: color, fontSize: 16));
  }

  button(String s, Color color) {
    return GestureDetector(
      onTap: () {
        print(s + 'clicked');
        if(s.contains("CONSULT NOW")) {
          Get.to(
                  () => DoctorAppointmentScreen(doctors: doctors));
        }else if(s.contains("ORDER NOW")){
          Get.to(() => MedicinesScreen(
            medicines: medicines,
            storeId: 0,
          ));
        }else if(s.contains("DONATE NOW")){
          Get.to(
                  () => BloodBankScreen());
        }
      },
      child: Row(
        children: [
          Container(
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.all(Radius.circular(12.0)),
            ),
            alignment: Alignment.center,
            padding: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
            child: Text(
              s,
              style: TextStyle(color: Colors.white, fontSize: 10),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}
