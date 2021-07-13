import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:paakhealth/models/api_response.dart';
import 'package:paakhealth/models/medicine_model.dart';
import 'package:paakhealth/models/store_model.dart';
import 'package:paakhealth/screens/pharmacy/pharmacy_detail_screen.dart';
import 'package:paakhealth/screens/medicine/product_detial_screen.dart';
import 'package:paakhealth/services/home_services.dart';
import 'package:paakhealth/util/colors.dart';
import 'package:paakhealth/util/prefernces.dart';
import 'package:paakhealth/util/text_style.dart';
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
          style: AppTextStyle.appTextStyle,
        ),
        centerTitle: true,
        elevation: 2,
        backgroundColor: Colors.white,
      ),
      body: Container(
        color: Colors.white,
        // child: SingleChildScrollView(
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
                      onPressed: _searchPharmacy,
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
        // Get.snackbar('', response.message);
        print('response.data');
        print(response.list);
        Iterable seachListItr = response.list;

        searchList =
            seachListItr.map((list) => StoreModel.fromMap(list)).toList();

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

  Widget pharmacyItem(StoreModel model, int index) {
    return Container(
      color: Colors.white,
      // padding: EdgeInsets.all(10),
      margin: EdgeInsets.fromLTRB(0, 0, 0, 5),
      child: IntrinsicHeight(
        child: Column(
          children: [
            IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  VerticalDivider(
                    thickness: 3,
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Container(
                      width: 60,
                      height: 60,
                      child: FadeInImage(
                        image: NetworkImage(model.profile_image),
                        placeholder: AssetImage('assets/p_ph.png'),
                        fit: BoxFit.cover,
                      )),
                  SizedBox(
                    width: 5,
                  ),
                  VerticalDivider(
                    thickness: 3,
                  ),
                  Flexible(
                    flex: 1,
                    child: Container(
                      padding: EdgeInsets.fromLTRB(5, 0, 15, 0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                model.name,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 16),
                              ),
                              GestureDetector(
                                onTap: () {
                                  changeFavorite(model.id, index);
                                },
                                child: Icon(
                                  model.is_favorite == 0
                                      ? Icons.star_border
                                      : Icons.star,
                                  color: AppColors.primaryColor,
                                  size: 20,
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
            ),
            Divider(
              height: 30,
            )
          ],
        ),
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
        // Get.snackbar('', response.message);
        print('response.data');

        _pharmacyList[index].is_favorite = response.favoriteStatus;
        setState(() {});
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
