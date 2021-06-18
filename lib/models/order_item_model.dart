import 'package:paakhealth/models/order_detail_model.dart';

class OrderModel{

  int id;
  String order_number;
  int order_status;
  int order_type;
  String prescription_images;
  String delivery_address;
  String customer_phone;
  int order_amount;
  int delivery_fee;
  int total_paid_amount;
  String payment_type;
  String order_time;
  String order_image;
  // todo here is the OrderDetailModel list, better solution is to use json serializer.
  List<dynamic> order_details;

  OrderModel.fromMap(Map<String, dynamic> map)
      : id = map['id'],
        order_number = map['order_number'],
        order_status = map['order_status'],
        order_type = map['order_type'],
        prescription_images = map['prescription_images'],
        customer_phone = map['customer_phone'],
        delivery_address = map['delivery_address'],
        order_amount = map['order_amount'],
        delivery_fee = map['delivery_fee'],
        total_paid_amount = map['total_paid_amount'],
        payment_type = map['payment_type'],
        order_time = map['order_time'],
        order_image = map['order_image'],
        order_details = map['order_details'];

  Map<String, dynamic> toMap(){
    return {
      'id' : id,
      'order_number' : order_number,
      'order_status' : order_status,
      'order_type' : order_type,
      'prescription_images' : prescription_images,
      'delivery_address' : delivery_address,
      'customer_phone' : customer_phone,
      'order_amount' : order_amount,
      'delivery_fee' : delivery_fee,
      'total_paid_amount' : total_paid_amount,
      'payment_type' : payment_type,
      'order_time' : order_time,
      'order_type' : order_type,
      'order_image' : order_image,
      'order_details' : order_details
    };
  }

}