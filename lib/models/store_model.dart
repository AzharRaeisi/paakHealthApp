class StoreModel{

  int id;
  String name;
  int is_blocked;
  String address;
  String latitude;
  String longitude;
  String rating;
  int delivery_fee;
  String profile_image;
  String phone;
  String working_hours;
  String city;
  double distance;
  int is_favorite;

  StoreModel(
      {this.id,
      this.name,
      this.is_blocked,
      this.address,
      this.latitude,
      this.longitude,
      this.rating,
      this.delivery_fee,
      this.profile_image,
        this.phone,
        this.city,
        this.working_hours,
      this.is_favorite,
      this.distance});

  StoreModel.fromMap(Map map)
      : id = map['id'],
        name = map['name'],
        is_blocked = map['is_blocked'],
        address = map['address'],
        latitude = map['latitude'],
        longitude = map['longitude'],
        rating = map['rating'],
        delivery_fee = map['delivery_fee'],
        profile_image = map['profile_image'],
        phone = map['phone'],
        city = map['city'],
        working_hours = map['working_hours'],
        distance = map['distance'],
        is_favorite = map['is_favorite'];

}