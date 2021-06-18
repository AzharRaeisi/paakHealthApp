import 'dart:convert';
import 'dart:io';

import 'package:http/io_client.dart';

import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import 'package:paakhealth/models/api_response.dart';
import 'package:paakhealth/services/api.dart';

class DoctorServices {
  static const headers = <String, String>{
    'Content-Type': 'application/json',
  };

  var logger = Logger();
  var deviceType;

  DoctorServices() {
    if (Platform.isAndroid) {
      deviceType = '1';
    } else if (Platform.isIOS) {
      deviceType = '2';
    }
  }


  Future getAppoitments({String token}) {
    return http.get(
      Uri.parse(NetUtils.BASE_URL + '/get-appointments'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'x-api-key': token
      },
    ).then((data) {
      final jsonData = json.decode(data.body);

      return APIResponse(
          list: jsonData['appointment'],
          status: jsonData['status'],
          message: jsonData['msg']);
    }).catchError((onError) {
      logger.e(onError);
      // return APIResponse(data: '', status: '', message: '');
    });
  }


  Future getDoctorItemSlot({
    String token,
    int visit_type,
    int consultation_type,
    String booking_date,
    int doctor_id}) {

    return http.post(
      Uri.parse(NetUtils.BASE_URL + '/get-doctor-time-slots'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'x-api-key': token
      },
      body: jsonEncode(<String, dynamic>{
        'visit_type': visit_type,
        'consultation_type': consultation_type,
        'booking_date': booking_date,
        'doctor_id': doctor_id,
      }),
    ).then((data) {
      final jsonData = json.decode(data.body);
      return APIResponse(
          data: jsonData['time_slots'],
          status: jsonData['status'],
          message: jsonData['msg']);
    }).catchError((onError) {
      logger.e(onError);
      // return APIResponse(data: '', status: '', message: '');
    });
  }

  Future bookAppointment({
    String token,
    int visit_type,
    int consultation_type,
    String booking_date,
    int doctor_id,
    String booking_time,
    String phone,
    int payment_method
  }) {

    return http.post(
      Uri.parse(NetUtils.BASE_URL + '/book-appointment'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'x-api-key': token
      },
      body: jsonEncode(<String, dynamic>{
        'visit_type': visit_type,
        'consultation_type': consultation_type,
        'booking_date': booking_date,
        'doctor_id': doctor_id,
        'booking_time': booking_time,
        'phone': phone,
        'payment_method': payment_method,
      }),
    ).then((data) {
      final jsonData = json.decode(data.body);
      return APIResponse(
          data: jsonData['time_slots'],
          status: jsonData['status'],
          message: jsonData['msg']);
    }).catchError((onError) {
      logger.e(onError);
      // return APIResponse(data: '', status: '', message: '');
    });
  }

}
