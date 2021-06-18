class ConsultationTypeModel{

  int id;
  String type;

  ConsultationTypeModel({this.id, this.type});

  ConsultationTypeModel.fromMap(Map<String, dynamic> map)
  :
      id = map['id'],
  type = map['type'];
}