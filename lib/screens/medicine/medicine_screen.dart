import 'dart:io';

import 'package:flutter/material.dart';

import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:paakhealth/models/api_response.dart';
import 'package:paakhealth/models/medicine_model.dart';
import 'package:paakhealth/models/store_model.dart';
import 'package:paakhealth/screens/purchase/delivery_info_screen.dart';
import 'package:paakhealth/screens/medicine/medicine_detial_screen.dart';
import 'package:paakhealth/services/cart_services.dart';
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
      backgroundColor: AppColors.bgColor,
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
          style: AppTextStyle.appbarTextStyle,
        ),
        centerTitle: true,
        elevation: 2,
        backgroundColor: Colors.white,
      ),
      body: Column(
        children: [
          Container(
            height: 45,
            margin: EdgeInsets.only(left: 12, top: 10, right: 12),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(50.0)),
                border: Border.all(color: Color(0xFFE8E8E2))),
            child: TextField(
              controller: searchBoxController,
              onChanged: (val) {
                if (val.isEmpty) {
                  searchList = [];
                  setState(() {
                    searching = false;
                    searchingCompleted = false;
                  });
                }
              },
              style: TextStyle(
                  color: AppColors.textColor, fontFamily: AppFont.Avenirl),
              decoration: InputDecoration(
                contentPadding: EdgeInsets.all(10),
                hintText: 'Find a medicine...',
                hintStyle: TextStyle(
                    color: AppColors.textColor, fontFamily: AppFont.Avenirl),
                suffixIcon: Container(
                  margin: EdgeInsets.fromLTRB(0, 5, 5, 5),
                  padding: EdgeInsets.symmetric(horizontal: 3),
                  decoration: BoxDecoration(
                    color: AppColors.primaryColor,
                    borderRadius: BorderRadius.all(Radius.circular(50.0)),
                  ),
                  child: IconButton(
                    padding: EdgeInsets.zero,
                    onPressed: _searchMedicine,
                    icon: Icon(Icons.search,
                      color: Colors.white,),
                  ),
                ),
                border: InputBorder.none,
              ),
            ),
          ),
          SizedBox(height: 10,),
          if (medicines.length == 0)
            Expanded(
              child: Text('No medicine available...'),
            )
          else
            Builder(builder: (context) {
              if (searching) {
                if (searchingCompleted) {
                  // return Expanded(
                  //   child: ListView.builder(
                  //     itemBuilder: (context, index) {
                  //       MedicineModel model = searchList[index];
                  //       return _medicineItem(model, index);
                  //     },
                  //     itemCount: searchList.length,
                  //     scrollDirection: Axis.vertical,
                  //     shrinkWrap: true,
                  //   ),
                  // );

                  return Expanded(
                    child: ResponsiveGridList(
                        desiredItemWidth: MediaQuery.of(context).size.width * .30,
                        children: searchList.map((e) {
                          return MedicineWidget(
                            medicine: e,
                          );
                        }).toList()),
                  );
                } else {
                  return Expanded(child: Center(child: CircularProgressIndicator()));
                }
              } else {
                // return Expanded(
                //   child: ListView.builder(
                //     itemBuilder: (context, index) {
                //       MedicineModel model = medicines[index];
                //       return _medicineItem(model, index);
                //     },
                //     itemCount: medicines.length,
                //     scrollDirection: Axis.vertical,
                //     shrinkWrap: true,
                //   ),
                // );


                return Expanded(
                  child: SingleChildScrollView(
                    physics: BouncingScrollPhysics(),
                    child: ResponsiveGridList(
                        desiredItemWidth: MediaQuery.of(context).size.width * .30,
                        scroll: false,
                        children: medicines.map((e) {
                          int i = medicines.indexOf(e);
                          return MedicineWidget(
                            medicine: e, favorite: (){
                            changeFavorite(e.id, i);
                          },
                          );
                        }).toList()),
                  ),
                );
              }
              return Container();
            })
        ],
      ),
    );
  }

  Widget _primaryBtn({String btnText}) {
    return GestureDetector(
      onTap: (){
        showModalBottomSheet(
          context: context,
          builder: ((builder) => bottomSheet()),
        );
      },
      child: AppPrimaryButton(text: btnText,),
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
        // ShowMessage.message(message: response.message);
        print('response.data');
        print(response.list);
        Iterable seachListItr = response.list;

        searchList =
            seachListItr.map((list) => MedicineModel.fromMap(list)).toList();

        print(searchList.length);
      } else {
        ShowMessage.message(message: response.message);
      }
    } else {
      print('API response is null');
      ShowMessage.message(message: 'Oops! Server is Down');
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
        // ShowMessage.message(message: response.message);
        print('response.data');
        ShowMessage.message(message: response.message);
      } else {
        ShowMessage.message(message: response.message);
      }
    } else {
      print('API response is null');
      ShowMessage.message(message: 'Oops! Server is Down');
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
                builder: (context) => DeliveryInfoScreen(image: _image, storeId: widget.storeId,)));
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

        medicines[index].is_favorite = response.favoriteStatus;
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
