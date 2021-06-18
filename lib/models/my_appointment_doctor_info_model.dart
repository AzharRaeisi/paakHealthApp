class DoctorInfo {
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
  String expertise;
  String available_days;

  DoctorInfo(
      {this.name,
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
      this.expertise,
      this.available_days});

  DoctorInfo.fromMap(Map<String, dynamic> map)
      : name = map['name'],
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
        expertise = map['expertise'],
        available_days = map['available_days'];
}
