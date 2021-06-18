class DonarModel{

  int id;
  String name;
  String address;
  String phone;
  String latitude;
  String longitude;
  String blood_group;
  String comments;
  String rating;
  double distance;
  String profile_image;
  String city;

  DonarModel(
      {this.id,
      this.name,
      this.address,
      this.phone,
      this.latitude,
      this.longitude,
      this.blood_group,
      this.comments,
      this.rating,
      this.distance,
      this.profile_image,
      this.city});

  DonarModel.fromMap(Map<String, dynamic> map)
  :
      id = map['id'],
        name = map['name'],
        address = map['address'],
        phone = map['phone'],
        latitude = map['latitude'],
        longitude = map['longitude'],
        blood_group = map['blood_group'],
        comments = map['comments'],
        rating = map['rating'],
        distance = map['distance'],
        profile_image = map['profile_image'],
        city = map['city'];
}