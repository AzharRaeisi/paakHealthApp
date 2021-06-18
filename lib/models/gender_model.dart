class GenderModel{

  int id;
  String name;

  GenderModel({this.id, this.name});
  GenderModel.fromMap(Map<String, dynamic> map)
      :
        id = map['id'],
        name = map['name'];

}