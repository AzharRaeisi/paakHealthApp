class MedicineModel {
  int id;
  int store_id;
  int price;
  int sale_price;
  int is_prescribed;
  String rating;
  String name;
  String description;
  String image;
  String weight_quantity;
  String medicine_type;
  String expiry_date;
  int is_favorite;
  int cart_count;

  MedicineModel(
      {this.id,
        this.store_id,
        this.price,
        this.sale_price,
        this.is_prescribed,
        this.rating,
        this.name,
        this.description,
        this.image,
        this.weight_quantity,
        this.medicine_type,
        this.expiry_date,
      this.is_favorite,
      this.cart_count});

  MedicineModel.fromMap(Map map)
      : id = map['id'],
        store_id = map['store_id'],
        price = map['price'],
        sale_price = map['sale_price'],
        is_prescribed = map['is_prescribed'],
        rating = map['rating'],
        name = map['name'],
        description = map['description'],
         image = map['image'],
        weight_quantity = map['weight_quantity'],
        medicine_type = map['medicine_type'],
        expiry_date = map['expiry_date'],
        is_favorite = map['is_favorite'],
        cart_count = map['cart_count'];

  Map toMap(){
    return {
      'id' : id,
      'store_id' : store_id,
      'price' : price,
      'sale_price' : sale_price,
      'is_prescribed' : is_prescribed,
      'rating' : rating,
      'name' : name,
      'description' : description,
      'image' : image,
      'name' : name,
      'weight_quantity' : weight_quantity,
      'medicine_type' : medicine_type,
      'expiry_date' : expiry_date,
      'is_favorite' : is_favorite,
      'cart_count' : cart_count
    };
  }
}
