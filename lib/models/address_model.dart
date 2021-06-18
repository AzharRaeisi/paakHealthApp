class AddressModel{
  int id;
  String type_name;
  String name;
  String address;
  String phone;
  int city_id;
  String latitude;
  String longitude;
  String city;


  AddressModel({this.id, this.type_name, this.name, this.address, this.phone,
    this.latitude, this.longitude, this.city_id, this.city});

  AddressModel.fromMap(Map map)
      : id = map['id'],
        type_name = map['type_name'],
        name = map['name'],
        address = map['address'],
        phone = map['phone'],
        city_id = map['city_id'],
        latitude = map['latitude'],
        longitude = map['longitude'],
        city = map['city'];


}