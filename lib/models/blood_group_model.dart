class BloodGroupModel{
  String name;

  BloodGroupModel({this.name});

  BloodGroupModel.fromMap(Map<String, dynamic> map)
  : name = map['name'];
}