import 'package:paakhealth/models/my_appointment_doctor_info_model.dart';

class AppointmentModel{

  int id;
  String booking_number;
  int doctor_id;
  String booking_date;
  String booking_time;
  int booking_status;
  String phone;
  int fees;
  int payment_type;
  String appointment_type;
  // DoctorInfo doctor_info;
  Map<String, dynamic> doctor_info;

  AppointmentModel(
      {this.id,
      this.booking_number,
      this.doctor_id,
      this.booking_date,
      this.booking_time,
      this.booking_status,
      this.phone,
      this.fees,
      this.payment_type,
        this.appointment_type,
      this.doctor_info});


  AppointmentModel.fromMap(Map<String, dynamic> map)
  :
      id = map['id'],
        booking_number = map['booking_number'],
        doctor_id = map['doctor_id'],
        booking_date = map['booking_date'],
        booking_time = map['booking_time'],
        booking_status = map['booking_status'],
        phone = map['phone'],
        fees = map['fees'],
        payment_type = map['payment_type'],
        appointment_type = map['appointment_type'],
        doctor_info = map['doctor_info'];
}