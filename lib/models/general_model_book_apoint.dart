class GeneralModel{

  int id;
  String name;

  GeneralModel({this.id, this.name});
  GeneralModel.fromMap(Map<String, dynamic> map)
      :
        id = map['id'],
        name = map['name'];
}