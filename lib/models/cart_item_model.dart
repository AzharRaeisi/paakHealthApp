import 'package:paakhealth/models/cart_item_list_model.dart';

class CartItemModel{

  int store_id;
  String store_name;
  List<dynamic> item_list;

  CartItemModel({this.store_id, this.store_name, this.item_list});

  CartItemModel.fromMap(Map map)
      : store_id = map['store_id'],
        store_name = map['store_name'],
        item_list = map['item_list'];

  Map toMap(){
    return {
      'store_id' : store_id,
      'store_name' : store_name,
      'item_list' : item_list
    };
  }


}