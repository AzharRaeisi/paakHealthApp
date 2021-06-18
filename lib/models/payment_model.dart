class PaymentModel {
  int id;
  String name;

  PaymentModel({this.id, this.name});

  PaymentModel.fromMap(Map<String, dynamic> map)
      : id = map['id'],
        name = map['name'];
}
