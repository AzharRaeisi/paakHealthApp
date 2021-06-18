class CartItemListItemModel{

  int id;
  int cart_id;
  int store_id;
  int store_medicine_id;
  String medicine_name;
  int medicine_price;
  int medicine_quantity;
  int medicine_subtotal;
  String medicine_image;

  CartItemListItemModel(
      {this.id,
      this.cart_id,
      this.store_id,
      this.store_medicine_id,
      this.medicine_name,
      this.medicine_price,
      this.medicine_quantity,
      this.medicine_subtotal,
      this.medicine_image});

  CartItemListItemModel.fromMap(Map<String, dynamic> map)
      : id = map['id'],
        cart_id = map['cart_id'],
        store_id = map['store_id'],
        store_medicine_id = map['store_medicine_id'],
        medicine_name = map['medicine_name'],
        medicine_price = map['medicine_price'],
        medicine_quantity = map['medicine_quantity'],
        medicine_subtotal = map['medicine_subtotal'],
        medicine_image = map['medicine_image'];

  Map<String, dynamic> toMap(){
    return {
      'id' : id,
      'cart_id' : cart_id,
      'store_id' : store_id,
      'store_medicine_id' : store_medicine_id,
      'medicine_name' : medicine_name,
      'medicine_price' : medicine_price,
      'medicine_quantity' : medicine_quantity,
      'medicine_subtotal' : medicine_subtotal,
      'medicine_image' : medicine_image
    };
  }



}