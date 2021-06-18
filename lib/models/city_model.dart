class CityModel {
  int id;
  String name;

  CityModel({this.id, this.name});

  CityModel.fromMap(Map<String, dynamic> map)
      : id = map['id'],
        name = map['name'];
}
