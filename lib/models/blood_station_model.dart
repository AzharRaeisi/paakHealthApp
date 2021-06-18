class BloodStationModel{

  int id;
  String name;
  String address;
  String phone;
  String latitude;
  String longitude;
  String website_link;
  String city;
  String profile_image;
  String rating;
  double distance;

  BloodStationModel(
      {this.id,
      this.name,
      this.address,
      this.phone,
      this.latitude,
      this.longitude,
      this.website_link,
      this.city,
      this.profile_image,
      this.rating,
      this.distance});

  BloodStationModel.fromMap(Map<String, dynamic> map)
  :
        id = map['id'],
        name = map['name'],
        address = map['address'],
        phone = map['phone'],
        latitude = map['latitude'],
        longitude = map['longitude'],
        website_link = map['website_link'],
        city = map['city'],
        profile_image = map['profile_image'],
        rating = map['rating'],
        distance = map['distance'];
}