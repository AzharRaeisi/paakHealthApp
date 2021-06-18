import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:paakhealth/models/api_response.dart';
import 'package:paakhealth/models/cart_item_list_model.dart';
import 'package:paakhealth/models/cart_item_model.dart';
import 'package:paakhealth/models/medicine_model.dart';
import 'package:paakhealth/screens/checkout_screen.dart';
import 'package:paakhealth/services/cart_services.dart';
import 'package:paakhealth/util/colors.dart';
import 'package:paakhealth/util/prefernces.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CartScreen extends StatefulWidget {
  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  int _productQty = 0;
  bool isLoading = true;

  // AnimationController _controller;

  List<CartItemModel> cartItemList = [];
  List<CartItemListItemModel> cartItemListItems = [];

  // String shipping;
  // String subtotal;
  String total = '';

  getCartList() async {
    cartItemList = [];
    cartItemListItems = [];
    var cartServices = CartServices();
    // todo change device token
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString(SharedPreVariables.TOKEN);

    print(token);
    APIResponse response = await cartServices.getCart(token: token);
    if (response != null) {
      if (response.status == '1') {
        // Get.snackbar('', response.message);
        print('response.data');

        Iterable iterable = response.list;
        cartItemList =
            iterable.map((list) => CartItemModel.fromMap(list)).toList();
        print('cartItemList.length');
        print(cartItemList.length);
        cartItemList.forEach((element) {
          element.item_list.forEach((map) {
            CartItemListItemModel model = CartItemListItemModel.fromMap(map);
            print(model.toString());
            cartItemListItems.add(model);
            print(cartItemListItems.length);
          });
        });
        print(response.total_amount);
        total = response.total_amount;
        // Get.snackbar('', response.message);
      } else {
        Get.snackbar('', response.message);
      }
    } else {
      print('API response is null');
      Get.snackbar('', 'Oops! Server is Down');
    }

    print(cartItemListItems.length);
    isLoading = false;
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    getCartList();
    // _controller = AnimationController(vsync: this, duration: Duration(seconds: 2))..repeat();
    //
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[300],
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios_rounded),
            onPressed: () {
              Navigator.canPop(context);
            },
          ),
          iconTheme: IconThemeData(color: AppColors.primaryColor),
          title: Text(
            'Cart',
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
          elevation: 2,
          backgroundColor: Colors.white,
        ),
        body: isLoading
            ? Container(
          color: Colors.white,
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              )
            : Builder(builder: (context) {
                if (cartItemList.length == 0)
                  return Container(
                    color: Colors.white,
                    padding: EdgeInsets.all(30),
                    child: Center(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Shopping cart is Empty!',
                            style: TextStyle(
                                fontSize: 20,
                                color: Color(0xFF939598),
                                fontWeight: FontWeight.w700),
                          ),
                          Text(
                            'You have no items in your shopping cart.',
                          ),
                        ],
                      ),
                    ),
                  );

                return Container(
                  color: Colors.white,
                  child: Column(
                    children: [
                      Expanded(
                          child: ListView.builder(
                        itemCount: cartItemListItems.length,
                        itemBuilder: (context, index) {
                          CartItemListItemModel model =
                              cartItemListItems[index];

                          return _cartItem(model);
                          // return Container();
                        },
                      )),
                      Container(
                        padding: EdgeInsets.all(30),
                        child: Column(
                          children: [
                            // Row(
                            //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            //   children: [
                            //     Text(
                            //       'Subtotal',
                            //       style: TextStyle(fontWeight: FontWeight.bold),
                            //     ),
                            //     Text(
                            //       'Rs. 600.0',
                            //       style: TextStyle(
                            //           fontWeight: FontWeight.bold, color: Colors.grey[700]),
                            //     ),
                            //   ],
                            // ),
                            // Row(
                            //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            //   children: [
                            //     Text(
                            //       'Delivery Fee',
                            //       style: TextStyle(color: Colors.grey[700], fontSize: 13),
                            //     ),
                            //     Text(
                            //       'Rs. 50.0',
                            //       style: TextStyle(color: Colors.grey[700], fontSize: 13),
                            //     ),
                            //   ],
                            // ),
                            SizedBox(height: 15),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Total',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.primaryColor,
                                      fontSize: 20),
                                ),
                                Text(
                                  'Rs. ' + total,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.primaryColor,
                                      fontSize: 20),
                                ),
                              ],
                            ),
                            SizedBox(height: 10),
                            _primaryBtn(btnText: 'Checkout')
                          ],
                        ),
                      )
                    ],
                  ),
                );
              }));
  }

  Widget _primaryBtn({String btnText}) {
    return GestureDetector(
      onTap: () async {
        if (total.isNotEmpty) {
          if (double.parse(total) >= 0) {
            final result = await Get.to(() => CheckOutScreen(total: total));
            if (result) {
              setState(() {
                isLoading = true;
                getCartList();
              });
            }
          }
        }
      },
      child: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: <Color>[
              Color(0xFF69C4F0),
              Color(0xFF00B2EE),
            ],
          ),
          borderRadius: BorderRadius.all(Radius.circular(5.0)),
        ),
        alignment: Alignment.center,
        padding: EdgeInsets.symmetric(vertical: 15),
        child: Text(
          btnText,
          style: TextStyle(color: Colors.white, fontSize: 18),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  Widget _cartItem(CartItemListItemModel model) {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.all(10),
      // margin: EdgeInsets.fromLTRB(0, 0, 0, 5),
      child: Column(
        children: [
          Container(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                    width: 60,
                    height: 70,
                    child: FadeInImage(
                      image: NetworkImage(model.medicine_image),
                      placeholder: AssetImage('assets/avatar.png'),
                      fit: BoxFit.cover,
                    )),
                Flexible(
                  flex: 2,
                  child: Container(
                    // height: 70,
                    padding: EdgeInsets.all(10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          model.medicine_name,
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                        Text(
                          'Qty: ' + model.medicine_quantity.toString(),
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                              color: Colors.grey),
                        ),
                        SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            // incDecBtn(),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
                Flexible(
                  flex: 1,
                  child: Container(
                    width: double.maxFinite,
                    // height: 70,
                    padding: EdgeInsets.fromLTRB(10, 0, 10, 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          icon: Icon(
                            Icons.delete,
                            size: 20,
                            color: Colors.grey[400],
                          ),
                          onPressed: () {
                            deleteCartItem(
                                store_id: model.store_id,
                                medicine_id: model.store_medicine_id,
                                model: model);
                          },
                        ),
                        Text(
                          'Rs. ' + model.medicine_subtotal.toString(),
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                              color: AppColors.primaryColor),
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
          Divider(
            thickness: 3,
            height: 30,
          )
        ],
      ),
    );
  }

  Row incDecBtn() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(40),
                  bottomLeft: Radius.circular(40)),
              border: Border.all(
                  width: 1,
                  color: AppColors.primaryColor,
                  style: BorderStyle.solid)),
          child: IconButton(
            padding: EdgeInsets.zero,
            splashColor: AppColors.primaryColor,
            icon: Icon(
              Icons.remove,
              size: 10,
              color: AppColors.primaryColor,
            ),
            onPressed: () {
              _decrementQty();
            },
          ),
          width: 24,
          height: 24,
        ),
        Container(
          // padding: EdgeInsets.all(15),
          decoration: BoxDecoration(
              border: Border.symmetric(
            horizontal: BorderSide(
                width: 1,
                color: AppColors.primaryColor,
                style: BorderStyle.solid),
          )),
          child: Center(
              child: Text(
            _productQty.toString(),
            style: TextStyle(fontSize: 12),
          )),

          width: 24,
          height: 24,
        ),
        Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                  topRight: Radius.circular(40),
                  bottomRight: Radius.circular(40)),
              border: Border.all(
                  width: 1,
                  color: AppColors.primaryColor,
                  style: BorderStyle.solid)),
          child: IconButton(
            padding: EdgeInsets.zero,
            splashColor: AppColors.primaryColor,
            icon: Icon(
              Icons.add,
              size: 12,
              color: AppColors.primaryColor,
            ),
            onPressed: () {
              _incrementQty();
            },
          ),
          width: 24,
          height: 24,
        ),
      ],
    );
  }

  void _decrementQty() {
    if (_productQty > 0) {
      _productQty = _productQty - 1;
      setState(() {});
    }
  }

  //
  void _incrementQty() {
    _productQty = _productQty + 1;
    setState(() {});
  }

  Future<void> deleteCartItem(
      {int store_id, int medicine_id, CartItemListItemModel model}) async {
    var cartServices = CartServices();
    // todo change device token
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString(SharedPreVariables.TOKEN);

    print(token);
    APIResponse response = await cartServices.deleteCardItem(
        token: token, store_id: store_id, medicine_id: medicine_id);
    if (response != null) {
      if (response.status == '1') {
        cartItemListItems.remove(model);
        Get.snackbar('', response.message);
        int totall =
            int.parse(total) - model.medicine_subtotal;
        total = totall.toString();
        if (cartItemListItems.length != 0) {
          getCartList();
        }

        setState(() {});
      } else {
        Get.snackbar('', response.message);
      }
    } else {
      print('API response is null');
      Get.snackbar('', 'Oops! Server is Down');
    }
  }
}
