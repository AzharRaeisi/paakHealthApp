import 'dart:convert';
import 'dart:io';

import 'package:http/io_client.dart';

import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import 'package:paakhealth/models/api_response.dart';
import 'package:paakhealth/services/api.dart';

class OrderServices {
  static const headers = <String, String>{
    'Content-Type': 'application/json',
  };

  var logger = Logger();
  var deviceType;

  OrderServices() {
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

  Future placeOrder({String token, int address_id, String comments, int payment_method}) {
    return http.post(
      Uri.parse(NetUtils.BASE_URL + '/place-order'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'x-api-key': token
      },
      body: jsonEncode(<String, dynamic>{
        'address_id': address_id,
        'comments': comments,
        'payment_method': payment_method,
      }),
    ).then((data) {
      final jsonData = json.decode(data.body);

      return APIResponse(
          status: jsonData['status'],
          message: jsonData['msg']);
    }).catchError((onError) {
      logger.e(onError);
      // return APIResponse(data: '', status: '', message: '');
    });
  }

  Future placeOrderPrescription({String token, int store_id, int address_id, String comments, int payment_method, String prescription_images}) {
    return http.post(
      Uri.parse(NetUtils.BASE_URL + '/place-order-prescription'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'x-api-key': token
      },
      body: jsonEncode(<String, dynamic>{
        'store_id': store_id,
        'address_id': address_id,
        'comments': comments,
        'payment_method': payment_method,
        'prescription_images': prescription_images
      }),
    ).then((data) {
      final jsonData = json.decode(data.body);

      logger.d(jsonData['status']);
      logger.d(jsonData['msg']);

      return APIResponse(
          status: jsonData['status'],
          message: jsonData['msg']);
    }).catchError((onError) {
      logger.e(onError);
      // return APIResponse(data: '', status: '', message: '');
    });
  }

  Future getOrder({String token}) {
    return http.get(
      Uri.parse(NetUtils.BASE_URL + '/get-order'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'x-api-key': token
      },
    ).then((data) {
      final jsonData = json.decode(data.body);

      return APIResponse(
          list: jsonData['orders'],
          status: jsonData['status'],
          message: jsonData['msg']);
    }).catchError((onError) {
      logger.e(onError);
      // return APIResponse(data: '', status: '', message: '');
    });
  }

}
