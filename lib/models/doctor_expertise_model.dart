class DoctorExpertiseModel{

  int id;
  String name;

  DoctorExpertiseModel({this.id, this.name});
  DoctorExpertiseModel.fromMap(Map<String, dynamic> map)
      :
        id = map['id'],
        name = map['name'];

}