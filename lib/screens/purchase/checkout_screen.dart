import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:paakhealth/models/address_model.dart';
import 'package:paakhealth/models/api_response.dart';
import 'package:paakhealth/models/city_model.dart';
import 'package:paakhealth/models/payment_model.dart';
import 'package:paakhealth/screens/address/address_screen.dart';
import 'package:paakhealth/services/account_services.dart';
import 'package:paakhealth/services/default_services.dart';
import 'package:paakhealth/services/order_sevices.dart';
import 'package:paakhealth/util/colors.dart';
import 'package:paakhealth/util/prefernces.dart';
import 'package:paakhealth/util/text_style.dart';
import 'package:paakhealth/widgets/primaryButton.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CheckOutScreen extends StatefulWidget {
  final String total;

  const CheckOutScreen({Key key, @required this.total}) : super(key: key);

  @override
  _CheckOutScreenState createState() => _CheckOutScreenState();
}

class _CheckOutScreenState extends State<CheckOutScreen> {
  var logger = Logger();
  bool shoppingCompleted = false;

  bool isLoading = true;
  //
  // GlobalKey<FormState> _key = GlobalKey<FormState>();
  // TextEditingController _nameController = new TextEditingController();
  TextEditingController _addressController = new TextEditingController();
  TextEditingController _comentController = new TextEditingController();
  // TextEditingController _cityController = new TextEditingController();
  // TextEditingController _phoneController = new TextEditingController();

  // int _cashMethod = 0;
  String total;
  PaymentModel selectedPayment;
  List<PaymentModel> paymentList = [];

  AddressModel selectedAddress;
  List<AddressModel> addressList = [];
  bool isProcessing = false;

  @override
  void initState() {
    // TODO: implement initState
    getCityAndPaymentList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        Navigator.of(context).pop(shoppingCompleted);
        return Future.value(shoppingCompleted);
      },
      child: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            leading: IconButton(
              icon: Icon(Icons.arrow_back_ios_rounded),
              onPressed: () {
                Navigator.of(context).pop(shoppingCompleted);
              },
            ),
            iconTheme: IconThemeData(color: AppColors.primaryColor),
            title: Text(
              shoppingCompleted ? '' : 'Check Out',
              style: AppTextStyle.appbarTextStyle,
            ),
            centerTitle: true,
            elevation: 2,
            backgroundColor: Colors.white,
          ),
          body: isLoading
              ? Container(
              height: MediaQuery.of(context).size.height -
                  AppBar().preferredSize.height -
                  60,
              child: Center(child: CircularProgressIndicator()))
              :
          Builder(builder: (context) {
            if (shoppingCompleted) {
              return Container(
                width: MediaQuery.of(context).size.width,
                padding: EdgeInsets.all(30),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Expanded(child: Container()),

                    Image.asset('assets/paakhealth.png'),
                    Text(
                      'Thankyou For',
                      style: TextStyle(
                          fontSize: 28,
                          color: Color(0xFF939598),
                          fontWeight: FontWeight.w700),
                    ),
                    Text(
                      'Your Orderhas been placed.',
                    ),
                    SizedBox(
                      height: 24,
                    ),
                    // Expanded(child: Container()),
                  ],
                ),
              );
            }
            return Container(
              padding: EdgeInsets.all(10),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // buildNameTextField(),
                    // SizedBox(height: 7),
                    // buildAddressTextField(),
                    // SizedBox(height: 7),
                    // buildCityTextField(),
                    // SizedBox(height: 7),
                    // buildPhoneTextField(),
                    // SizedBox(height: 7),
                    buildComentTextField(),
                    SizedBox(height: 7),
                    DropdownButtonFormField<AddressModel>(
                      hint: Text("Select Address"),
                      isExpanded: true,
                      value: selectedAddress,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                      ),
                      onChanged: (value) {
                        _addressController.text =
                            'Name: ' + value.name + '\n' +
                                'Address Type: ' + value.type_name + '\n' +
                                'Address: ' + value.address + '\n' +
                                'Phone: ' + value.phone + '\n' +
                                'City: ' + value.city ;
                        setState(() {
                          selectedAddress = value;
                        });
                      },
                      items: addressList.map((AddressModel address) {
                        return DropdownMenuItem<AddressModel>(
                          value: address,
                          child: Text(address.type_name),
                        );
                      }).toList(),
                    ),
                    addressList.length == 0
                        ? SizedBox(height: 5)
                        : Container(),
                    addressList.length == 0
                        ? Align(
                      alignment: Alignment.centerRight,
                      child: GestureDetector(
                        onTap: () async {
                          // await Get.to(() => AddressScreen(
                          //   addressModel: null,
                          //   edit: true,
                          //   add: true,
                          // ));
                          await pushNewScreen(
                            context,
                            screen: AddressScreen(
                              addressModel: null,
                              edit: true,
                              add: true,
                            ),
                            withNavBar: true, // OPTIONAL VALUE. True by default.
                            pageTransitionAnimation: PageTransitionAnimation.cupertino,
                          );
                          getCityAndPaymentList();
                        },
                        child: Text(
                          'Add address',
                          style: TextStyle(
                              color: AppColors.primaryColor,
                              fontSize: 12),
                        ),
                      ),
                    )
                        : Container(),
                    SizedBox(height: 7),
                    buildAddressTextField(),
                    SizedBox(height: 7),
                    DropdownButtonFormField<PaymentModel>(
                      hint: Text("Select Payment Method"),
                      isExpanded: true,
                      value: selectedPayment,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                      ),
                      onChanged: (value) {
                        setState(() {
                          selectedPayment = value;
                        });
                      },
                      items: paymentList.map((PaymentModel payment) {
                        return DropdownMenuItem<PaymentModel>(
                          value: payment,
                          child: Text(payment.name),
                        );
                      }).toList(),
                    ),
                    // ListView.builder(
                    //   itemCount: paymentList.length,
                    //   shrinkWrap: true,
                    //   itemBuilder: (context, index) {
                    //     PaymentModel model = paymentList[index];
                    //     return ListTile(
                    //       contentPadding: EdgeInsets.zero,
                    //       leading: Radio(
                    //         value: model.id,
                    //         activeColor: Color(0xFF939598),
                    //         groupValue: _cashMethod,
                    //         onChanged: (value) {
                    //           _cashMethod = value;
                    //           setState(() {});
                    //         },
                    //       ),
                    //       title: Text(model.name),
                    //     );
                    //   },
                    // ),

                    // SizedBox(height: 100,),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Total',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: AppColors.primaryColor,
                              fontSize: 16),
                        ),
                        Text(
                          'Rs. ${widget.total}',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: AppColors.primaryColor,
                              fontSize: 16),
                        ),
                      ],
                    ),

                    SizedBox(height: 3),
                    _primaryBtn(btnText: 'Place Order')
                  ],
                ),
              ),
            );
          }) ),
    );
  }

  // TextFormField buildNameTextField() {
  //   return TextFormField(
  //     controller: _nameController,
  //     autovalidateMode: AutovalidateMode.onUserInteraction,
  //     validator: (value) {
  //       if (value.length > 2)
  //         return null;
  //       else
  //         return 'Username must be at least of 3 characters';
  //     },
  //     decoration: InputDecoration(
  //         border: OutlineInputBorder(
  //             borderSide: BorderSide(color: Colors.grey[100], width: 1.0),
  //             borderRadius: BorderRadius.circular(5)),
  //         hintText: 'Username'),
  //   );
  // }


  TextFormField buildComentTextField() {
    return TextFormField(
      controller: _comentController,
      maxLines: 5,
      decoration: InputDecoration(
          border: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey[100], width: 1.0),
              borderRadius: BorderRadius.circular(5)),
          hintText: 'Your Coments'),
    );
  }

  TextFormField buildAddressTextField() {
    return TextFormField(
      controller: _addressController,
      maxLines: 8,
      enabled: false,
      decoration: InputDecoration(
          border: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey[100], width: 1.0),
              borderRadius: BorderRadius.circular(5)),
          hintText: 'Address'),
    );
  }

  // TextFormField buildCityTextField() {
  //   return TextFormField(
  //     controller: _cityController,
  //     autovalidateMode: AutovalidateMode.onUserInteraction,
  //     validator: (value) {
  //       if (value.length > 2)
  //         return null;
  //       else
  //         return 'City must be at least of 3 characters';
  //     },
  //     decoration: InputDecoration(
  //         border: OutlineInputBorder(
  //             borderSide: BorderSide(color: Colors.grey[100], width: 1.0),
  //             borderRadius: BorderRadius.circular(5)),
  //         hintText: 'Username'),
  //   );
  // }
  //
  // TextFormField buildPhoneTextField() {
  //   return TextFormField(
  //     controller: _phoneController,
  //     maxLength: 10,
  //     keyboardType: TextInputType.number,
  //     autovalidateMode: AutovalidateMode.onUserInteraction,
  //     validator: (value) {
  //       if (value.length == 10)
  //         return null;
  //       else
  //         return 'Enter valid phone number';
  //     },
  //     decoration: InputDecoration(
  //         border: OutlineInputBorder(
  //             borderSide: BorderSide(color: Colors.grey, width: 1.0),
  //             borderRadius: BorderRadius.circular(5)),
  //         prefixText: '+92',
  //       hintText: 'Phone Number',),
  //   );
  // }

  Widget _primaryBtn({String btnText}) {
    return GestureDetector(
      onTap: () {
        if (selectedAddress == null || selectedPayment == null) {
          Get.snackbar('', 'Please Select Address and Payment Method');
        } else {
          setState(() {
            isProcessing = true;
          });
          placeOrder();
        }
      },
      child: AppPrimaryButton(text: btnText,),
    );
  }

  Future<void> getCityAndPaymentList() async {
    var accountServices = AccountServices();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString(SharedPreVariables.TOKEN);

    APIResponse response = await accountServices.getAddresses(token: token);
    if (response != null) {
      if (response.status == '1') {
        Iterable iterable1 = response.list;
        addressList = [];
        addressList = iterable1.map((list) => AddressModel.fromMap(list)).toList();
      } else {
        Get.snackbar('', response.message);
      }
    } else {
      print('API response is null');
      Get.snackbar('', 'Oops! Server is Down');
    }

    var defaultServices = DefaultServices();

    APIResponse responSe = await defaultServices.getPaymentList();
    if (responSe != null) {
      if (responSe.status == '1') {
        Iterable iterable1 = responSe.list;
        paymentList =
            iterable1.map((list) => PaymentModel.fromMap(list)).toList();
      } else {
        Get.snackbar('', responSe.message);
      }
    } else {
      print('API response is null');
      Get.snackbar('', 'Oops! Server is Down');
    }

    isLoading = false;
    setState(() {});
  }

  Future<void> placeOrder() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    logger.i(prefs.getString(SharedPreVariables.TOKEN));

    var orderServices = OrderServices();
    APIResponse response = await orderServices.placeOrder(
        token: prefs.getString(SharedPreVariables.TOKEN),
        address_id: selectedAddress.id,
        comments: _comentController.text,
        payment_method: selectedPayment.id);
    if (response != null) {
      if (response.status == '1') {
        Get.snackbar('', response.message);

        setState(() {
          shoppingCompleted = true;
        });
      } else {
        Get.snackbar('', response.message);
      }
    } else {
      logger.i('API response is null');
      Get.snackbar('', 'Oops! Server is Down');
    }
  }
}
