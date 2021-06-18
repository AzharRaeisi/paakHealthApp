
class DoctorModel{

  int id;
  String name;
  String email;
  String phone;
  String gender;
  String image;
  int is_blocked;
  String address;
  String rating;
  int fees;
  String experience;
  String wait_time;
  String education;
  double distance;
  String expertise;
  String available_days;
  int is_favorite;

  DoctorModel(
      {this.id,
      this.name,
      this.email,
      this.phone,
      this.gender,
      this.image,
      this.is_blocked,
      this.address,
      this.rating,
      this.fees,
      this.experience,
      this.wait_time,
      this.education,
      this.distance,
      this.expertise,
      this.available_days,
      this.is_favorite});

  DoctorModel.fromMap(Map<String, dynamic> map)
  :
        id = map['id'],
        name = map['name'],
        email = map['email'],
        phone = map['phone'],
        gender = map['gender'],
        image = map['image'],
        is_blocked = map['is_blocked'],
        address = map['address'],
        rating = map['rating'],
        fees = map['fees'],
        experience = map['experience'],
        wait_time = map['wait_time'],
        education = map['education'],
        distance = map['distance'],
        expertise = map['expertise'],
        available_days = map['available_days'],
        is_favorite = map['is_favorite'];
}