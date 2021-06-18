import 'package:flutter/material.dart';
import 'package:paakhealth/models/order_detail_model.dart';
import 'package:paakhealth/models/order_item_model.dart';
import 'package:paakhealth/models/order_model.dart';
import 'package:paakhealth/util/colors.dart';
import 'package:paakhealth/util/order_status.dart';
import 'package:paakhealth/widgets/hero_photo_view_route_wrapper.dart';

class OrderDetailScreen extends StatefulWidget {
  final OrderModel model;

  const OrderDetailScreen({Key key, @required this.model}) : super(key: key);

  @override
  _OrderDetailScreenState createState() => _OrderDetailScreenState();
}

class _OrderDetailScreenState extends State<OrderDetailScreen> {
  OrderModel orderModel;
  List<String> prescriptionImages = [];

  @override
  Widget build(BuildContext context) {
    orderModel = widget.model;
    if (orderModel.prescription_images.isNotEmpty) {
      prescriptionImages = [];
      orderModel.prescription_images.split(',').forEach((element) {
        prescriptionImages.add(element);
      });
    }
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        iconTheme: IconThemeData(color: AppColors.primaryColor),
        title: Text(
          'Order Details',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 2,
        backgroundColor: Colors.white,
      ),
      body: Container(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _orderItem(orderModel),
            ListTile(
              leading: Icon(
                Icons.location_on,
                size: 20,
                color: Colors.black,
              ),
              title: Text(
                orderModel.delivery_address,
                style: TextStyle(color: Colors.grey[600], fontSize: 12),
              ),
              horizontalTitleGap: 0,
              contentPadding: EdgeInsets.zero,
              visualDensity: VisualDensity(horizontal: 0, vertical: -4),
            ),
            ListTile(
              leading: Icon(
                Icons.phone_outlined,
                size: 20,
                color: Colors.black,
              ),
              title: Text(
                orderModel.customer_phone,
                style: TextStyle(color: Colors.grey[600], fontSize: 12),
              ),
              horizontalTitleGap: 0,
              contentPadding: EdgeInsets.zero,
              visualDensity: VisualDensity(horizontal: 0, vertical: -4),
            ),
            Divider(
              height: 30,
            ),
            Text(
              'Details:',
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                  color: Colors.grey[700]),
            ),
            ListTile(
              leading: Icon(
                Icons.circle,
                size: 10,
                color: AppColors.primaryColor,
              ),
              title: Text(
                'Waiting for store approval',
                style: TextStyle(color: Colors.grey[600], fontSize: 12),
              ),
              horizontalTitleGap: 0,
              contentPadding: EdgeInsets.zero,
              visualDensity: VisualDensity(horizontal: 0, vertical: -4),
            ),
            Divider(
              height: 30,
            ),
            Text(
              'Order Summary:',
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                  color: Colors.grey[700]),
            ),
            SizedBox(height: 15),
            Row(
              children: [
                Text(
                  'Payment Method: ',
                  style: TextStyle(color: Colors.grey[600], fontSize: 12),
                ),
                Text(
                  orderModel.payment_type,
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                      color: Colors.grey[700]),
                ),
              ],
            ),
            SizedBox(height: 5),
            orderModel.prescription_images.isNotEmpty
                ? Text(
                    'Prescription Uploaded: ',
                    style: TextStyle(color: Colors.grey[600], fontSize: 12),
                  )
                : Container(),
            SizedBox(height: 7),
            orderModel.prescription_images.isNotEmpty
                ? SizedBox(
                    height: 70,
                    child: ListView.builder(
                        itemCount: prescriptionImages.length,
                        scrollDirection: Axis.horizontal,
                        shrinkWrap: true,
                        physics: BouncingScrollPhysics(
                            parent: AlwaysScrollableScrollPhysics()),
                        itemBuilder: (context, index) {
                          //File i = images[index];
                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      HeroPhotoViewRouteWrapper(
                                    imageProvider:
                                        NetworkImage(prescriptionImages[index]),
                                    tag: index,
                                  ),
                                ),
                              );
                            },
                            child: Hero(
                              tag: index,
                              child: Container(
                                  width: 70,
                                  height: 70,
                                  margin: EdgeInsets.only(right: 7),
                                  child: FadeInImage(
                                    image:
                                        NetworkImage(prescriptionImages[index]),
                                    placeholder:
                                        AssetImage('assets/avatar.png'),
                                    fit: BoxFit.contain,
                                  )),
                            ),
                          );
                        }),
                  )
                : Container(),
            SizedBox(height: 7),
            Expanded(
              child: orderModel.order_details.length == 0
                  ? Text(
                      'Not Available',
                      style: TextStyle(color: Colors.grey[600], fontSize: 12),
                    )
                  : ListView.builder(
                      itemCount: orderModel.order_details.length,
                      itemBuilder: (context, index) {
                        Map<String, dynamic> map =
                            orderModel.order_details[index];
                        OrderDetailModel details =
                            OrderDetailModel.fromMap(map);
                        return _orderSummaryItem(details);
                      },
                      shrinkWrap: true,
                      physics: BouncingScrollPhysics(
                          parent: AlwaysScrollableScrollPhysics()),
                    ),
            ),
            Divider(
              height: 30,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Total',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                      color: Colors.grey[700]),
                ),
                Text(
                  'Rs. ' + orderModel.order_amount.toString(),
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                      color: Colors.grey[700]),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Delivery Fee',
                  style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                ),
                Text(
                  'Rs. ' + orderModel.delivery_fee.toString(),
                  style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                ),
              ],
            ),
            SizedBox(
              height: 12,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Sub Total',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: AppColors.primaryColor),
                ),
                Text(
                  'Rs. ' + orderModel.total_paid_amount.toString(),
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: AppColors.primaryColor),
                ),
              ],
            ),
            Text(orderModel.payment_type)
          ],
        ),
      ),
    );
  }

  Widget _orderItem(OrderModel model) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
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
                      style: TextStyle(color: Colors.grey[600], fontSize: 12),
                    ),
                    Text(
                      model.order_number,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                          color: Colors.grey[700]),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Text(
                      'Order time: ',
                      style: TextStyle(color: Colors.grey[600], fontSize: 12),
                    ),
                    Text(
                      model.order_time,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                          color: Colors.grey[700]),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                Row(
                  children: [
                    Text(
                      'Order Status: ',
                      style: TextStyle(color: Colors.grey[600], fontSize: 12),
                    ),
                    Text(
                      OrderStatus.status(model.order_status),
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                          color: Colors.grey[700]),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
        Container(
            width: 60,
            height: 60,
            child: FadeInImage(
              image: NetworkImage(model.order_image),
              placeholder: AssetImage('assets/avatar.png'),
              fit: BoxFit.cover,
            )),
      ],
    );
  }

  Widget _orderSummaryItem(OrderDetailModel details) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              details.medicine_name,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                  color: Colors.grey[700]),
            ),
            SizedBox(width: 5),
            Text(
              'Unit price: ' + details.medicine_price.toString(),
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                  color: Colors.grey[500]),
            ),
            Expanded(
                child: Text(
              'Rs ' + details.subtotal.toString(),
              textAlign: TextAlign.end,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                  color: Colors.grey[700]),
            ))
          ],
        ),
        Text(
          'Qty: ' + details.quantity.toString(),
          style: TextStyle(color: Colors.grey[600], fontSize: 12),
        ),
        SizedBox(height: 10)
      ],
    );
  }
}
