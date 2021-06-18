class DoctorSlotModel {
  int id;
  String day;
  String start_time;

  DoctorSlotModel({this.id, this.day, this.start_time});

  DoctorSlotModel.fromMap(Map<String, dynamic> map)
      : id = map['id'],
        day = map['day'],
        start_time = map['start_time'];
}
