import 'dart:convert';
import 'dart:io';

import 'package:http/io_client.dart';

import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import 'package:paakhealth/models/api_response.dart';
import 'package:paakhealth/services/api.dart';

class BloodBankServices {
  static const headers = <String, String>{
    'Content-Type': 'application/json',
  };

  var logger = Logger();
  var deviceType;

  BloodBankServices() {
    // HomeServices({this.http}) {
    // final ioc = new HttpClient();
    // ioc.badCertificateCallback =
    //     (X509Certificate cert, String host, int port) => true;
    // http = new IOClient(ioc);

    if (Platform.isAndroid) {
      deviceType = '1';
    } else if (Platform.isIOS) {
      deviceType = '2';
    }
  }

  Future nearbyBloodStation(
      {String token,
      String lat,
      String long,
      String blood_group = '',
      int city = 0,
      String search_text = ''}) {
    print('blood_group');
    print(blood_group);
    print(city);

    return http
        .post(
      Uri.parse(NetUtils.BASE_URL + '/nearby-blood-donation'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'x-api-key': token
      },
      body: jsonEncode(<String, dynamic>{
        'latitude': lat,
        'longitude': long,
        'blood_group': blood_group,
        'city': city,
        'search_text': search_text
      }),
    )
        .then((data) {
      final jsonData = json.decode(data.body);

      return APIResponse(
          data: jsonData['result'],
          status: jsonData['status'],
          message: jsonData['msg']);
    }).catchError((onError) {
      logger.e(onError);
      // return APIResponse(data: '', status: '', message: '');
    });
  }

  Future requestForBlodd({String token, int blood_bank_id}) {
    return http
        .post(
      Uri.parse(NetUtils.BASE_URL + '/request-for-blood'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'x-api-key': token
      },
      body: jsonEncode(<String, dynamic>{
        'blood_bank_id': blood_bank_id,
      }),
    )
        .then((data) {
      final jsonData = json.decode(data.body);

      return APIResponse(
          data: jsonData['result'],
          status: jsonData['status'],
          message: jsonData['msg']);
    }).catchError((onError) {
      logger.e(onError);
      // return APIResponse(data: '', status: '', message: '');
    });
  }
}
