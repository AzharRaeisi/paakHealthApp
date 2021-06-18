class OrderDetailModel{
  String medicine_name;
  int medicine_price;
  int quantity;
  int subtotal;

  OrderDetailModel(
      {this.medicine_name, this.medicine_price, this.quantity, this.subtotal});

  OrderDetailModel.fromMap(Map<String, dynamic> map)
      : medicine_name = map['medicine_name'],
        medicine_price = map['medicine_price'],
        quantity = map['quantity'],
        subtotal = map['subtotal'];

  Map<String, dynamic> toMap(){
    return {
      'medicine_name' : medicine_name,
      'medicine_price' : medicine_price,
      'quantity' : quantity,
      'subtotal' : subtotal
    };
  }
}