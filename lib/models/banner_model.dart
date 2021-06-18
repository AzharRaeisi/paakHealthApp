class BannerModel{
  String image;

  BannerModel({this.image});

  BannerModel.fromMap(Map<String, dynamic> map)
  : image = map['image'];
}