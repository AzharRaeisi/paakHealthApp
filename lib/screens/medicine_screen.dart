import 'dart:io';

import 'package:flutter/material.dart';

import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:paakhealth/models/api_response.dart';
import 'package:paakhealth/models/medicine_model.dart';
import 'package:paakhealth/models/store_model.dart';
import 'package:paakhealth/screens/delivery_info_screen.dart';
import 'package:paakhealth/screens/product_detial_screen.dart';
import 'package:paakhealth/services/cart_services.dart';
import 'package:paakhealth/services/home_services.dart';
import 'package:paakhealth/util/colors.dart';
import 'package:paakhealth/util/prefernces.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:get/get.dart';

class MedicinesScreen extends StatefulWidget {
  final List<MedicineModel> medicines;
  final int storeId;

  const MedicinesScreen({Key key, @required this.medicines, @required this.storeId}) : super(key: key);

  @override
  _MedicinesScreenState createState() => _MedicinesScreenState();
}

class _MedicinesScreenState extends State<MedicinesScreen> {
  List<MedicineModel> medicines = [];

  initializeMedicineList() {
    medicines = widget.medicines;
  }

  File _image;

  // getProductList() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   logger.i(prefs.getString(SharedPreVariables.TOKEN));
  //   logger.i(prefs.getInt(SharedPreVariables.CARD_ID));
  //   var productServies = ProductServices();
  //   APIResponse respone = await productServies.getProducts(token: prefs.getString(SharedPreVariables.TOKEN));
  //   if (respone != null){
  //     if (respone.status == '1'){
  //       Iterable iterable1 = respone.data['featured_product'];
  //       featuredProductList = iterable1.map((list) => ProductModel.fromJSON(list)).toList();
  //       Iterable iterable2 = respone.data['best_seller'];
  //       bestSellerList = iterable2.map((list) => ProductModel.fromJSON(list)).toList();
  //       Iterable iterable3 = respone.data['more_to_love'];
  //       moreToLoveList = iterable3.map((list) => ProductModel.fromJSON(list)).toList();
  //     }
  //   }
  //
  //   if(mounted){
  //     setState(() {});
  //   }
  // }

  bool searching = false;
  bool searchingCompleted = false;
  TextEditingController searchBoxController = new TextEditingController();

  List<MedicineModel> searchList = [];

  @override
  void initState() {
    super.initState();
    initializeMedicineList();
  }

  @override
  Widget build(BuildContext context) {
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
          'Medicines',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 2,
        backgroundColor: Colors.white,
      ),
      body: Container(
        color: Colors.white,
        child: Column(
          children: [
            Container(
              color: Colors.white,
              height: 60,
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              child: TextField(
                controller: searchBoxController,
                onChanged: (val) {
                  if (val.isEmpty) {
                    searchList = [];
                  }
                },
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.all(10),
                  hintText: 'Type to search ...',
                  hintStyle: TextStyle(color: Colors.grey),
                  suffixIcon: Container(
                    margin: EdgeInsets.fromLTRB(0, 5, 5, 5),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: <Color>[
                          Color(0xFF69C4F0),
                          Color(0xFF00B2EE),
                        ],
                      ),
                      borderRadius: BorderRadius.all(Radius.circular(50.0)),
                    ),
                    child: IconButton(
                      padding: EdgeInsets.zero,
                      onPressed: _searchMedicine,
                      icon: Icon(Icons.search),
                      color: Colors.white,
                    ),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(
                      50,
                    ),
                    borderSide:
                        BorderSide(color: Colors.greenAccent, width: 0.0),
                  ),
                ),
              ),
            ),
            if (medicines.length == 0)
              Expanded(
                child: Text('No medicine available...'),
              )
            else
              Builder(builder: (context) {
                if (searching) {
                  if (searchingCompleted) {
                    return Expanded(
                      child: ListView.builder(
                        itemBuilder: (context, index) {
                          MedicineModel model = searchList[index];
                          return _medicineItem(model, index);
                        },
                        itemCount: searchList.length,
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                      ),
                    );
                  } else {
                    return Expanded(child: Center(child: CircularProgressIndicator()));
                  }
                } else {
                  return Expanded(
                    child: ListView.builder(
                      itemBuilder: (context, index) {
                        MedicineModel model = medicines[index];
                        return _medicineItem(model, index);
                      },
                      itemCount: medicines.length,
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                    ),
                  );
                }
                return Container();
              })
          ],
        ),
      ),
    );
  }

  Future<void> _searchMedicine() async {
    if (searchBoxController.text.isEmpty) {
      setState(() {
        searching = false;
        searchingCompleted = false;
      });
    } else {
      // if (searchingCompleted){
      setState(() {
        searching = true;
        searchingCompleted = false;
      });
      // }

      getSearchProductList();
    }
  }

  Widget _medicineItem(MedicineModel model, int index) {
    return GestureDetector(
      onTap: () {
        Get.to(() => ProductDetialScreen(id: model.id));
      },
      child: Container(
        color: Colors.white,
        padding: EdgeInsets.all(10),
        margin: EdgeInsets.fromLTRB(0, 0, 0, 3),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                    width: 100,
                    height: 140,
                    child: FadeInImage(
                      image: NetworkImage(model.image),
                      placeholder: AssetImage('assets/paakhealth.png'),
                      fit: BoxFit.cover,
                    )),
                Flexible(
                  flex: 1,
                  child: Stack(
                    children: [
                      Container(
                        padding: EdgeInsets.all(10),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              model.name,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                            Text(
                              model.weight_quantity,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                  color: Colors.grey),
                            ),
                            Text(
                              model.medicine_type,
                              style: TextStyle(fontSize: 12, color: Colors.grey),
                            ),
                            SizedBox(height: 50),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Rs. ' + model.sale_price.toString() + '.00',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                      color: AppColors.primaryColor),
                                ),
                                model.is_prescribed == 0
                                    ? GestureDetector(
                                        onTap: () {
                                          addtoCart(model);
                                        },
                                        child: Text(
                                          'Add to Cart',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      )
                                    : GestureDetector(
                                        onTap: () {
                                          // todo handle upload prescribtion
                                          showModalBottomSheet(
                                            context: context,
                                            builder: ((builder) => bottomSheet()),
                                          );
                                        },
                                        child: Text(
                                          'Upload Prescription',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                              ],
                            )
                          ],
                        ),
                      ),
                      Positioned(
                          right: 10,
                          top: 10,
                          child: GestureDetector(
                            onTap: () {
                              changeFavorite(model.id, index);
                            },
                            child: Icon(
                              model.is_favorite == 0
                                  ? Icons.star_border
                                  : Icons.star,
                              color: AppColors.primaryColor,
                            ),
                          ))
                    ],
                  ),
                )
              ],
            ),
            Divider(thickness: 3,)
          ],
        ),
      ),
    );
  }

  Future<void> getSearchProductList() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    var homeServices = HomeServices();
    // todo change device token
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString(SharedPreVariables.TOKEN);

    print(token);
    print(position.latitude.toString());
    print(position.longitude.toString());
    APIResponse response;
    if (widget.storeId == 0){
      response = await homeServices.searchMedicine(
          token: token,
          search_text: searchBoxController.text,
          lat: position.latitude.toString(),
          long: position.longitude.toString());

    }
    if (widget.storeId > 0){
      response = await homeServices.searchPharmacyMedicine(
          token: token,
          store_id: widget.storeId,
          search_text: searchBoxController.text);
    }


    if (response != null) {
      if (response.status == '1') {
        // Get.snackbar('', response.message);
        print('response.data');
        print(response.list);
        Iterable seachListItr = response.list;

        searchList =
            seachListItr.map((list) => MedicineModel.fromMap(list)).toList();

        print(searchList.length);
      } else {
        Get.snackbar('', response.message);
      }
    } else {
      print('API response is null');
      Get.snackbar('', 'Oops! Server is Down');
    }




    if (mounted) {
      setState(() {
        searchingCompleted = true;
      });
    }




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
                builder: (context) => DeliveryInfoScreen(image: _image, storeId: 0,)));
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
        // Get.snackbar('', response.message);
        print('response.data');

        medicines[index].is_favorite = response.favoriteStatus;
        setState(() {

        });
        // Get.snackbar('', response.message);
      } else {
        Get.snackbar('', response.message);
      }
    } else {
      print('API response is null');
      Get.snackbar('', 'Oops! Server is Down');
    }
  }
}
