import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:paakhealth/drawer/drawer.dart';
import 'package:paakhealth/models/api_response.dart';
import 'package:paakhealth/models/order_item_model.dart';
import 'package:paakhealth/models/order_model.dart';
import 'package:paakhealth/screens/order/order_details.dart';
import 'package:paakhealth/services/order_sevices.dart';
import 'package:paakhealth/util/colors.dart';
import 'package:paakhealth/util/font.dart';
import 'package:paakhealth/util/order_status.dart';
import 'package:paakhealth/util/prefernces.dart';
import 'package:paakhealth/util/text_style.dart';
import 'package:paakhealth/widgets/toast/toast.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyOrdersScreen extends StatefulWidget {
  @override
  _MyOrdersScreenState createState() => _MyOrdersScreenState();
}

class _MyOrdersScreenState extends State<MyOrdersScreen> {

  var logger = Logger();

  bool isLoading = true;
  List<OrderModel> orders = [];

  @override
  void initState() {
    getOrders();
    super.initState();
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
          'My Orders',
          style: AppTextStyle.appbarTextStyle,
        ),
        centerTitle: true,
        elevation: 2,
        backgroundColor: Colors.white,
      ),
      body: ListView.builder(
        itemCount: orders.length,
          itemBuilder: (context, index){
        return _orderItem(orders[index]);
      })
      // Column(
      //   children: [
      //     _orderItem(OrderListItemModel(
      //         id: '1234',
      //         order_id: '4321',
      //         time: '20121-03-03 01:10',
      //         status: 'Pending')),
      //     _orderItem(OrderListItemModel(
      //         id: '1234',
      //         order_id: '4321',
      //         time: '20121-03-03 01:10',
      //         status: 'Delivered')),
      //     _orderItem(OrderListItemModel(
      //         id: '1234',
      //         order_id: '4321',
      //         time: '20121-03-03 01:10',
      //         status: 'Delivered')),
      //     _orderItem(OrderListItemModel(
      //         id: '1234',
      //         order_id: '4321',
      //         time: '20121-03-03 01:10',
      //         status: 'Delivered')),
      //   ],
      // ),
    );
  }

  Widget _orderItem(OrderModel model) {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.all(10),
      margin:  EdgeInsets.only(top: 10, left: 10, right: 10),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                  width: 60,
                  height: 60,
                  child: FadeInImage(
                    image: NetworkImage(
                        model.order_image),
                    placeholder: AssetImage('assets/app_logo.png'),
                    fit: BoxFit.cover,
                  )),
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
                            'Order ID: ',
                            style: TextStyle(
                              fontSize: 12.0,
                              fontFamily: AppFont.Gotham,
                              fontWeight: FontWeight.w400,
                              color: AppColors.textColor,
                            ),
                          ),
                          Text(
                            model.order_number,
                            style: TextStyle(
                              fontSize: 12.0,
                              fontFamily: AppFont.Gotham,
                              fontWeight: FontWeight.w500,
                              color: AppColors.textColor,
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: 3,),
                      Text(
                        'Placed on ' + model.order_time,
                        style: TextStyle(
                          fontSize: 12.0,
                          fontFamily: AppFont.Gotham,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textColor,
                        ),
                      ),
                      SizedBox(height: 10),
                      GestureDetector(
                        onTap: () {
                          // Navigator.push(
                          //     context,
                          //     MaterialPageRoute(
                          //         builder: (context) => OrderDetailScreen(model: model )));
                          pushNewScreen(
                            context,
                            screen: OrderDetailScreen(model: model ),
                            withNavBar: true, // OPTIONAL VALUE. True by default.
                            pageTransitionAnimation: PageTransitionAnimation.cupertino,
                          );
                        },
                        child: Text(
                          'View Details',
                          style: TextStyle(
                            fontSize: 12.0,
                            fontFamily: AppFont.Gotham,
                            fontWeight: FontWeight.w400,
                            color: AppColors.primaryColor,
                          ),
                        ),
                      ),

                    ],
                  ),
                ),
              )
            ],
          ),

          SizedBox(height: 3,),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                model.order_details.length.toString() + ' item(s), total: ',
                style: TextStyle(
                  fontSize: 12.0,
                  fontFamily: AppFont.Gotham,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textColor,
                ),
              ),
              Text(
                'Rs. ' + model.total_paid_amount.toString(),
                style: TextStyle(
                  fontSize: 12.0,
                  fontFamily: AppFont.Gotham,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primaryColor,
                ),
              ),
            ],
          ),
          Row(
            children: [
              Text(
                'Order Status: ',
                style: TextStyle(
                  fontSize: 12.0,
                  fontFamily: AppFont.Gotham,
                  fontWeight: FontWeight.w400,
                  color: AppColors.textColor,
                ),
              ),
              Text(
                OrderStatus.status(model.order_status),
                style: TextStyle(
                  fontSize: 12.0,
                  fontFamily: AppFont.Gotham,
                  fontWeight: FontWeight.w500,
                  color: AppColors.primaryColor,
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  Future<void> getOrders() async {
    orders = [];
    var orderServices = OrderServices();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString(SharedPreVariables.TOKEN);

    APIResponse response = await orderServices.getOrder(token: token);
    if (response != null) {
      if (response.status == '1') {
        logger.i(response.message);
        // print('response.data');

        Iterable iterable = response.list;
        orders =
            iterable.map((list) => OrderModel.fromMap(list)).toList();
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
}
