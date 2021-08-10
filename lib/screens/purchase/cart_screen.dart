import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:paakhealth/models/api_response.dart';
import 'package:paakhealth/models/cart_item_list_model.dart';
import 'package:paakhealth/models/cart_item_model.dart';
import 'package:paakhealth/screens/purchase/checkout_screen.dart';
import 'package:paakhealth/services/cart_services.dart';
import 'package:paakhealth/util/colors.dart';
import 'package:paakhealth/util/font.dart';
import 'package:paakhealth/util/prefernces.dart';
import 'package:paakhealth/util/text_style.dart';
import 'package:paakhealth/widgets/primaryButton.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
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
        backgroundColor: AppColors.bgColor,
        appBar: AppBar(
          iconTheme: IconThemeData(color: AppColors.primaryColor),
          title: Text(
            'Cart',
            style: AppTextStyle.appbarTextStyle,
          ),
          centerTitle: true,
          elevation: 2,
          backgroundColor: Colors.white,
        ),
        body: isLoading
            ? Container(
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              )
            : Builder(builder: (context) {
                if (cartItemList.length == 0)
                  return Container(
                    padding: EdgeInsets.all(10),
                    child: Center(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            alignment: Alignment.centerRight,
                            margin: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                            child: GestureDetector(
                              onTap: (){
                                if(!isLoading){
                                  setState(() {
                                    isLoading = true;
                                  });
                                  getCartList();
                                }

                              },
                              child: Text('Update',
                                style: TextStyle(
                                  fontFamily: AppFont.Gotham,
                                  fontWeight: FontWeight.w400,

                                ),),
                            ),
                          ),
                          Text(
                            'Shopping cart is Empty!',
                            style:
                            TextStyle(
                              fontSize: 20.0,
                              fontFamily: AppFont.Gotham,
                              fontWeight: FontWeight.w400,
                              color: AppColors.buttonColor,
                            ),
                          ),
                          Text(
                            'You have no items in your shopping cart.',
                            style: TextStyle(
                              fontSize: 12.0,
                              fontFamily: AppFont.Gotham,
                              fontWeight: FontWeight.w400,
                              color: AppColors.textColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );

                return Container(
                  child: Column(
                    children: [
                      Container(
                        alignment: Alignment.centerRight,
                        margin: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                        child: GestureDetector(
                          onTap: (){
                            if(!isLoading){
                              setState(() {
                                isLoading = true;
                              });
                              getCartList();
                            }

                          },
                          child: Text('Update',
                          style: TextStyle(
                            fontFamily: AppFont.Gotham,
                            fontWeight: FontWeight.w400,

                          ),),
                        ),
                      ),
                      Expanded(
                          child: ListView.builder(
                        itemCount: cartItemListItems.length,
                        physics: BouncingScrollPhysics(),
                        itemBuilder: (context, index) {
                          CartItemListItemModel model =
                              cartItemListItems[index];

                          return _cartItem(model);
                          // return Container();
                        },
                      )),
                      Container(
                        padding: EdgeInsets.all(10),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Subtotal',
                                  style: TextStyle(
                                    fontFamily: AppFont.Gotham,
                                    fontWeight: FontWeight.w700,),
                                ),
                                Text(
                                  'Rs. ' + total,
                                  style: TextStyle(
                                      fontFamily: AppFont.Gotham,
                                      fontWeight: FontWeight.w700, color: Colors.grey[700]),
                                ),
                              ],
                            ),
                            SizedBox(height: 5,),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Delivery Fee',
                                  style: TextStyle(color: Colors.grey[700],
                                      fontFamily: AppFont.Gotham,
                                      fontWeight: FontWeight.w400, fontSize: 13),
                                ),
                                Text(
                                  'Rs. ',
                                  style: TextStyle(color: Colors.grey[700],
                                      fontFamily: AppFont.Gotham,
                                      fontWeight: FontWeight.w400, fontSize: 13),
                                ),
                              ],
                            ),
                            SizedBox(height: 15),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Total',
                                  style: TextStyle(
                                      fontFamily: AppFont.Gotham,
                                      fontWeight: FontWeight.w700,
                                      color: AppColors.primaryColor,
                                      fontSize: 20),
                                ),
                                Text(
                                  'Rs. ' + total,
                                  style: TextStyle(
                                      fontFamily: AppFont.Gotham,
                                      fontWeight: FontWeight.w700,
                                      color: AppColors.primaryColor,
                                      fontSize: 20),
                                ),
                              ],
                            ),
                            SizedBox(height: 10),
                            Container(
                              margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                                child: _primaryBtn(btnText: 'Checkout'))
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
            // final result = await Get.to(() => CheckOutScreen(total: total));
            final result = await pushNewScreen(
              context,
              screen: CheckOutScreen(total: total),
              withNavBar: true, // OPTIONAL VALUE. True by default.
              pageTransitionAnimation: PageTransitionAnimation.cupertino,
            );
            if (result) {
              setState(() {
                isLoading = true;
                getCartList();
              });
            }
          }
        }
      },
      child: AppPrimaryButton(text: btnText,),
    );
  }

  Widget _cartItem(CartItemListItemModel model) {
    return Container(
      height: 100,
      color: Colors.white,
      padding: EdgeInsets.all(10),
      margin: EdgeInsets.fromLTRB(10, 0, 10, 10),
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
                image: NetworkImage(model.medicine_image),
                placeholder: AssetImage('assets/p_ph.png'),
                fit: BoxFit.cover,
              )),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [

                    Expanded(
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 15,),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              model.medicine_name,
                              style: TextStyle(
                                  fontFamily: AppFont.Gotham,
                                  fontWeight: FontWeight.w400, fontSize: 16),
                            ),
                            SizedBox(height: 3,),
                            Text(
                              'Qty: ' + model.medicine_quantity.toString(),
                              style: TextStyle(
                                  fontFamily: AppFont.Gotham,
                                  fontWeight: FontWeight.w400,
                                  fontSize: 14,
                                  color: Colors.grey),
                            ),

                          ],
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: (){
                        deleteCartItem(
                            store_id: model.store_id,
                            medicine_id: model.store_medicine_id,
                            model: model);
                      },
                      child: Icon(
                        CupertinoIcons.delete,
                        size: 24,
                        color: AppColors.outlineColor,
                      ),
                    )
                  ],
                ),


                Container(
                  padding: EdgeInsets.only(left: 15,),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Rs. ' + model.medicine_subtotal.toString(),
                        style: TextStyle(
                            fontFamily: AppFont.Gotham,
                            fontWeight: FontWeight.w700,
                            fontSize: 14,
                            color: AppColors.primaryColor),
                      ),
                      incDecBtn()
                    ],
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  // todo make this button funcitonal
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
                  color: AppColors.outlineColor,
                  style: BorderStyle.solid)),
          child: IconButton(
            padding: EdgeInsets.zero,
            // splashColor: AppColors.primaryColor,
            icon: Icon(
              Icons.remove,
              size: 10,
              color: AppColors.outlineColor,
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
                color: AppColors.outlineColor,
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
                  color: AppColors.outlineColor,
                  style: BorderStyle.solid)),
          child: IconButton(
            padding: EdgeInsets.zero,
            // splashColor: AppColors.primaryColor,
            icon: Icon(
              Icons.add,
              size: 12,
              color: AppColors.outlineColor,
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
        int totall = int.parse(total) - model.medicine_subtotal;
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
