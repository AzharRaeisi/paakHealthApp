// import 'dart:io';
//
// import 'package:flutter/material.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:get/get.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:paakhealth/models/api_response.dart';
// import 'package:paakhealth/models/doctor_model.dart';
// import 'package:paakhealth/models/medicine_model.dart';
// import 'package:paakhealth/models/store_model.dart';
// import 'package:paakhealth/screens/doctors_screen.dart';
// import 'package:paakhealth/screens/delivery_info_screen.dart';
// import 'package:paakhealth/screens/emergency_screen.dart';
// import 'package:paakhealth/screens/medicine_screen.dart';
// import 'package:paakhealth/screens/pharmacy_screen.dart';
// import 'package:paakhealth/services/home_services.dart';
// import 'package:paakhealth/util/colors.dart';
// import 'package:paakhealth/util/prefernces.dart';
// import 'package:shared_preferences/shared_preferences.dart';
//
// class MainScreen extends StatefulWidget {
//   @override
//   _MainScreenState createState() => _MainScreenState();
// }
//
// class _MainScreenState extends State<MainScreen> {
//
//   File _image;
//   List<StoreModel> stores = [];
//   List<MedicineModel> medicines = [];
//   List<DoctorModel> doctors = [];
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         iconTheme: IconThemeData(
//             color: AppColors.primaryColor
//         ),
//         title: Image.asset('assets/paakhealth.png'),
//         centerTitle: true,
//         elevation: 0,
//         backgroundColor: Colors.white,
//       ),
//       body: Container(
//         color: Colors.white,
//         child: SingleChildScrollView(
//           child: Column(
//             children: [
//               SizedBox(height: 10),
//               Image.asset(
//                 'assets/paakhealth.png',
//                 width: MediaQuery.of(context).size.width,
//                 height: MediaQuery.of(context).size.width / 2.5,
//                 fit: BoxFit.cover,
//               ),
//               Container(
//                 padding: EdgeInsets.all(30),
//                 child: Column(
//                   children: [
//                     _mainItem(
//                         icon: Icons.camera_alt_outlined, text: 'Online Pharmacy'),
//                     SizedBox(height: 5),
//                     _mainItem(
//                         icon: Icons.camera_alt_outlined,
//                         text: "Doctor's Appointment"),
//                     SizedBox(height: 5),
//                     _mainItem(icon: Icons.camera_alt_outlined, text: 'Medicines'),
//                     SizedBox(height: 40),
//                     Icon(
//                       Icons.local_hospital_outlined,
//                       color: AppColors.primaryColor,
//                     ),
//                     Text('Order with prescription', style: TextStyle(fontSize: 12),),
//                     SizedBox(height: 5),
//                     _primaryBtn(btnText: 'Upload')
//                   ],
//                 ),
//               )
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _mainItem({IconData icon, String text}) {
//     return GestureDetector(
//       onTap: (){
//         switch(text){
//           case 'Online Pharmacy':
//             Get.to(() => OnlinePharmacyScreen(stores: stores,));
//             break;
//           case "Doctor's Appointment":
//             Get.to(() => DoctorAppointmentScreen());
//             break;
//           case "Medicines":
//             Get.to(() => MedicinesScreen(medicines: medicines,));
//             break;
//
//         }
//       },
//       child: Container(
//         alignment: Alignment.center,
//         decoration: BoxDecoration(
//           border: Border.all(color: AppColors.primaryColor, width: 3),
//           color: Colors.white,
//           borderRadius: BorderRadius.all(Radius.circular(14.0)),
//         ),
//         padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceAround,
//         children: [
//           Expanded(
//               child: Icon(icon, color: AppColors.primaryColor, size: 48,)),
//           Expanded(child: Align(
//             alignment: Alignment.center,
//             child: Text(text, style: TextStyle(
//               fontSize: 14,
//               fontWeight: FontWeight.bold
//             ),
//             textAlign: TextAlign.center,),
//           ),
//           )
//         ],
//         ),
//       ),
//     );
//   }
//
//   Widget _primaryBtn({String btnText}) {
//     return Container(
//       decoration: const BoxDecoration(
//         gradient: LinearGradient(
//           colors: <Color>[
//             Color(0xFF69C4F0),
//             Color(0xFF00B2EE),
//           ],
//         ),
//         borderRadius: BorderRadius.all(Radius.circular(5.0)),
//       ),
//       alignment: Alignment.center,
//       padding: EdgeInsets.symmetric(vertical: 5),
//       child: TextButton.icon(
//         onPressed: () {
//           showModalBottomSheet(
//             context: context,
//             builder: ((builder) => bottomSheet()),
//           );
//         },
//         icon: Icon(
//           Icons.camera_alt_outlined,
//           color: Colors.white,
//         ),
//         label: Text(
//           btnText,
//           style: TextStyle(color: Colors.white, fontSize: 18),
//           textAlign: TextAlign.center,
//         ),
//       ),
//     );
//   }
//
//
//
//   Widget bottomSheet() {
//     return Container(
//       height: 100,
//       width: MediaQuery.of(context).size.width,
//       margin: EdgeInsets.all(20),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text('Choose Profile Photo'),
//           SizedBox(height: 20),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               TextButton.icon(
//                   onPressed: () {
//                     Navigator.pop(context);
//                     getImage(ImageSource.camera);
//                   },
//                   icon: Icon(Icons.camera),
//                   label: Text('Camera')),
//               TextButton.icon(
//                   onPressed: () {
//                     Navigator.pop(context);
//                     getImage(ImageSource.gallery);
//                   },
//                   icon: Icon(Icons.image),
//                   label: Text('Gallery')),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
//
//
//   void getImage(ImageSource source) async {
//     final pickedFile = await ImagePicker().getImage(source: source);
//
//     setState(() {
//       if (pickedFile != null) {
//         _image = File(pickedFile.path);
//         Navigator.push(context,
//             MaterialPageRoute(builder: (context) => DeliveryInfoScreen(image: _image)));
//       } else {
//         print('No image selected.');
//       }
//     });
//   }
//
//   @override
//   void initState() {
//     // TODO: implement initState
//
//     if(stores.length == 0){
//       print('=====================');
//       print('store length is zer0');
//       callHomeAPI();
//       print('=====================');
//
//     }
//     super.initState();
//   }
//
//
//   void callHomeAPI() async {
//     Position position = await Geolocator.getCurrentPosition(
//         desiredAccuracy: LocationAccuracy.high);
//
//     var homeServices = HomeServices();
//     // todo change device token
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     String token = prefs.getString(SharedPreVariables.TOKEN);
//     print(token);
//     print(position.latitude.toString());
//     print(position.longitude.toString());
//     APIResponse response = await homeServices.home(token: token, lat: position.latitude.toString(), long: position.longitude.toString());
//     if (response != null){
//       if (response.status == '1'){
//         // Get.snackbar('', response.message);
//         // print("response.data['result']");
//         // print(response.data['store']);
//         // print(response.data['medicine']);
//         // print(response.data['doctors']);
//         Iterable storeIterable = response.data['store'];
//         stores = storeIterable.map((list) => StoreModel.fromMap(list)).toList();
//
//         Iterable medicineIterable = response.data['medicine'];
//         medicines = medicineIterable.map((list) => MedicineModel.fromMap(list)).toList();
//
//         Iterable doctorIterable = response.data['doctors'];
//         doctors = doctorIterable.map((list) => DoctorModel.fromMap(list)).toList();
//
//       }else{
//         Get.snackbar('', response.message);
//       }
//     }else{
//       print('API response is null');
//       Get.snackbar('','Oops! Server is Down');
//     }
//   }
// }
