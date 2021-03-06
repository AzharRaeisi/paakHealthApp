import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:paakhealth/models/address_model.dart';
import 'package:paakhealth/models/api_response.dart';
import 'package:paakhealth/screens/address/address_screen.dart';
import 'package:paakhealth/services/account_services.dart';
import 'package:paakhealth/util/colors.dart';
import 'package:paakhealth/util/font.dart';
import 'package:paakhealth/util/prefernces.dart';
import 'package:paakhealth/util/text_style.dart';
import 'package:paakhealth/widgets/toast/toast.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CustomerAddressesScreen extends StatefulWidget {
  const CustomerAddressesScreen({Key key}) : super(key: key);

  @override
  _CustomerAddressesScreenState createState() => _CustomerAddressesScreenState();
}

class _CustomerAddressesScreenState extends State<CustomerAddressesScreen> {



  var logger = Logger();

  bool isLoading = true;
  List<AddressModel> addresses = [];

  @override
  void initState() {
    getAddress();
    super.initState();
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
            'Address Book',
            style: AppTextStyle.appbarTextStyle,
          ),

          actions: [
            IconButton(
                onPressed: () {
                  // Get.to(() => AddressScreen(addressModel: null, edit: true, add: true,));
                  pushNewScreen(
                    context,
                    screen: AddressScreen(addressModel: null, edit: true, add: true,),
                    withNavBar: true, // OPTIONAL VALUE. True by default.
                    pageTransitionAnimation: PageTransitionAnimation.cupertino,
                  );

                },
                icon: Icon(
                  Icons.add_location_alt,
                  color: AppColors.primaryColor,
                ))
          ],
          centerTitle: true,
          elevation: 2,
          backgroundColor: Colors.white,
        ),
      body: Container(
        color: AppColors.bgColor,
        child: RefreshIndicator(
          onRefresh: () async{
            getAddress();
          },
          child: ListView.builder(
              itemCount: addresses.length,
              itemBuilder: (context, index){
                return addressItem(addresses[index]);
              }),
        ),
      ),
    );
  }

  Future<void> getAddress() async {
    addresses = [];
    var accountServices = AccountServices();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString(SharedPreVariables.TOKEN);

    APIResponse response = await accountServices.getAddresses(token: token);
    if (response != null) {
      if (response.status == '1') {
        logger.i(response.message);
        // print('response.data');

        Iterable iterable = response.list;
        addresses =
            iterable.map((list) => AddressModel.fromMap(list)).toList();
        // print('cartItemList.length');
        // print(orders.length);
        setState(() {

        });

      } else {
        ShowMessage.message(message: response.message);
      }
    } else {
      print('API response is null');
      ShowMessage.message(message: 'Oops! Server is Down');
    }
  }

  Widget addressItem(AddressModel model) {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.all(10),
      margin:  EdgeInsets.only(top: 10, left: 10, right: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
              width: 60,
              height: 60,
              child: FadeInImage(
                image: AssetImage(
                    'assets/address-book.png'),
                placeholder: AssetImage('assets/address-book.png'),
                fit: BoxFit.contain,
              )
          ),
          Flexible(
            flex: 1,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        'Name: ',
                        style: TextStyle(
                          fontSize: 12.0,
                          fontFamily: AppFont.Gotham,
                          fontWeight: FontWeight.w400,
                          color: AppColors.textColor,
                        ),
                      ),
                      Text(
                        model.name,
                        style: TextStyle(
                          fontSize: 12.0,
                          fontFamily: AppFont.Gotham,
                          fontWeight: FontWeight.w500,
                          color: AppColors.textColor,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Text(
                        'Address Type: ',
                        style: TextStyle(
                          fontSize: 12.0,
                          fontFamily: AppFont.Gotham,
                          fontWeight: FontWeight.w400,
                          color: AppColors.textColor,
                        ),
                      ),
                      Text(
                        model.type_name,
                        style: TextStyle(
                          fontSize: 12.0,
                          fontFamily: AppFont.Gotham,
                          fontWeight: FontWeight.w500,
                          color: AppColors.textColor,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  Row(
                    children: [
                      Text(
                        'Phone: ',
                        style: TextStyle(
                          fontSize: 12.0,
                          fontFamily: AppFont.Gotham,
                          fontWeight: FontWeight.w400,
                          color: AppColors.textColor,
                        ),
                      ),
                      Text(
                        model.phone,
                        style: TextStyle(
                          fontSize: 12.0,
                          fontFamily: AppFont.Gotham,
                          fontWeight: FontWeight.w500,
                          color: AppColors.textColor,
                        ),
                      ),
                      Expanded(child: Container()),
                      GestureDetector(
                        onTap: () {
                          // Get.to(() => AddressScreen(addressModel: model, edit: false, add: false,));
                          pushNewScreen(
                            context,
                            screen: AddressScreen(addressModel: model, edit: false, add: false,),
                            withNavBar: true, // OPTIONAL VALUE. True by default.
                            pageTransitionAnimation: PageTransitionAnimation.cupertino,
                          );
                        },
                        child: Text(
                          'View',
                          style: TextStyle(
                            fontSize: 12.0,
                            fontFamily: AppFont.Gotham,
                            fontWeight: FontWeight.w400,
                            color: AppColors.primaryColor,
                          ),
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }


}
