import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:paakhealth/models/api_response.dart';
import 'package:paakhealth/models/medicine_model.dart';
import 'package:paakhealth/models/store_model.dart';
import 'package:paakhealth/screens/pharmacy/pharmacy_detail_screen.dart';
import 'package:paakhealth/screens/medicine/medicine_detial_screen.dart';
import 'package:paakhealth/services/home_services.dart';
import 'package:paakhealth/util/colors.dart';
import 'package:paakhealth/util/font.dart';
import 'package:paakhealth/util/prefernces.dart';
import 'package:paakhealth/util/text_style.dart';
import 'package:paakhealth/widgets/toast/toast.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:get/get.dart';

class OnlinePharmacyScreen extends StatefulWidget {
  final List<StoreModel> stores;

  const OnlinePharmacyScreen({Key key, @required this.stores})
      : super(key: key);

  @override
  _OnlinePharmacyScreenState createState() => _OnlinePharmacyScreenState();
}

class _OnlinePharmacyScreenState extends State<OnlinePharmacyScreen> {
  List<StoreModel> _pharmacyList = [];

  getProductList() {
    _pharmacyList = widget.stores;
  }

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

  List<StoreModel> searchList = [];

  @override
  void initState() {
    super.initState();
    getProductList();
    // _controller = AnimationController(vsync: this, duration: Duration(seconds: 2))..repeat();
    //
    // getProductList();
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
          'Online Pharmacy',
          style: AppTextStyle.appbarTextStyle,
        ),
        centerTitle: true,
        elevation: 2,
        backgroundColor: Colors.white,
      ),
      body: Container(
        // child: SingleChildScrollView(
        child: Column(
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
                  }
                },
                style: TextStyle(
                    color: AppColors.textColor, fontFamily: AppFont.Avenirl),
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.all(10),
                  hintText: 'Find pharmacy...',
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
                      onPressed: _searchPharmacy,
                      icon: Icon(Icons.search),
                      color: Colors.white,
                    ),
                  ),
                  border: InputBorder.none,
                ),
              ),
            ),
            SizedBox(height: 10,),
            if (_pharmacyList.length == 0)
              Expanded(
                child: Text('No pharmacy available...'),
              )
            else
              Builder(
                builder: (context) {
                  if (searching) {
                    if (searchingCompleted) {
                      return Expanded(
                        child: ListView.builder(
                          itemBuilder: (context, index) {
                            StoreModel model = searchList[index];
                            return pharmacyItem(model, index);
                          },
                          itemCount: searchList.length,
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                        ),
                      );
                    } else {
                      return Expanded(
                          child: Center(child: CircularProgressIndicator()));
                    }
                  } else {
                    return Expanded(
                      child:
                          // if you want a
                          ListView.builder(
                        itemBuilder: (context, index) {
                          StoreModel model = _pharmacyList[index];
                          return pharmacyItem(model, index);
                        },
                        itemCount: _pharmacyList.length,
                        scrollDirection: Axis.vertical,
                        physics: BouncingScrollPhysics(),
                        shrinkWrap: true,
                        // primary: false,
                      ),
                    );
                  }
                },
              ),
          ],
        ),
        // ),
      ),
    );
  }

  Future<void> _searchPharmacy() async {
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

      getSearchPharmacyList();
    }
  }

  Future<void> getSearchPharmacyList() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    var homeServices = HomeServices();
    // todo change device token
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString(SharedPreVariables.TOKEN);

    print(token);
    print(position.latitude.toString());
    print(position.longitude.toString());
    APIResponse response = await homeServices.searchPharmacy(
        token: token,
        search_text: searchBoxController.text,
        lat: position.latitude.toString(),
        long: position.longitude.toString());
    if (response != null) {
      if (response.status == '1') {
        // ShowMessage.message(message: response.message);
        print('response.data');
        print(response.list);
        Iterable seachListItr = response.list;

        searchList =
            seachListItr.map((list) => StoreModel.fromMap(list)).toList();

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

  Widget pharmacyItem(StoreModel model, int index) {
    return Container(
      height: 100,
      color: Colors.white,
      padding: EdgeInsets.all(10),
      margin: EdgeInsets.fromLTRB(0, 0, 0, 7),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
              width: 80,
              height: 80,
              padding: EdgeInsets.all(15),
              decoration: BoxDecoration(
                  border: Border.all(color: AppColors.outlineColor, )
              ),
              child: FadeInImage(
                image: NetworkImage(model.profile_image),
                placeholder: AssetImage('assets/p_ph.png'),
                fit: BoxFit.cover,
              )),
          Flexible(
            flex: 1,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 15,),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(

                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            model.name,
                            style: TextStyle(
                                fontFamily: AppFont.Gotham,
                                fontWeight: FontWeight.w700, fontSize: 16),
                          ),

                          SizedBox(height: 5,),
                          Text(model.address,
                            style:
                            TextStyle(
                                fontWeight: FontWeight.w400,
                                fontFamily: AppFont.Gotham,
                                fontSize: 14
                            ),),
                        ],
                      ),
                      GestureDetector(
                        onTap: () {
                          changeFavorite(model.id, index);
                        },
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              model.is_favorite == 0
                                  ? Icons.star_border
                                  : Icons.star,
                              color: AppColors.primaryColor,
                              size: 20,
                            ),
                            Text(model.rating,
                              style: TextStyle(
                                  fontFamily: AppFont.Gotham,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 12
                              ),)
                          ],
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      GestureDetector(
                        onTap: () {
                          // Get.to(
                          //     () => PharcmayDetailScreen(id: model.id));
                          pushNewScreen(
                            context,
                            screen: PharcmayDetailScreen(id: model.id),
                            withNavBar: true, // OPTIONAL VALUE. True by default.
                            pageTransitionAnimation: PageTransitionAnimation.cupertino,
                          );
                        },
                        child: Text(
                          'View Details',
                          style: TextStyle(
                              fontWeight: FontWeight.w400,
                              fontFamily: AppFont.Gotham,
                              color: AppColors.primaryColor,
                              fontSize: 12),
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Future<void> changeFavorite(int id, int index) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString(SharedPreVariables.TOKEN);

    var homeService = HomeServices();
    APIResponse response =
        await homeService.markStoreFavorite(token: token, store_id: id);
    if (response != null) {
      if (response.status == '1') {
        // ShowMessage.message(message: response.message);
        print('response.data');

        _pharmacyList[index].is_favorite = response.favoriteStatus;
        setState(() {});
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
