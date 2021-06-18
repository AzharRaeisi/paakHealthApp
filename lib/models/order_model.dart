class OrderListItemModel {
  String id;
  String order_id;
  String time;
  String status;

  OrderListItemModel({this.id, this.order_id, this.time, this.status});

  OrderListItemModel.fromMap(Map map)
      : id = map['id'],
        order_id = map['order_id'],
        time = map['time'],
        status = map['status'];

}
