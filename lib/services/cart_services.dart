import 'dart:convert';
import 'dart:io';

import 'package:http/io_client.dart';

import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import 'package:paakhealth/models/api_response.dart';
import 'package:paakhealth/services/api.dart';

class CartServices {
  static const headers = <String, String>{
    'Content-Type': 'application/json',
  };

  var logger = Logger();
  var deviceType;

  CartServices() {
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

  Future getCart({String token}) {
    return http.get(
      Uri.parse(NetUtils.BASE_URL + '/get-cart'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'x-api-key': token
      },
    ).then((data) {
      final jsonData = json.decode(data.body);

      return APIResponse(
          list: jsonData['result'],
          total_amount: jsonData['total_amount'],
          status: jsonData['status'],
          message: jsonData['msg']);
    }).catchError((onError) {
      logger.e(onError);
      // return APIResponse(data: '', status: '', message: '');
    });
  }

  Future addToCart({String token,int store_id, int medicine_id, int quantity}) {
    return http.post(
      Uri.parse(NetUtils.BASE_URL + '/add-to-cart'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'x-api-key': token
      },
      body: jsonEncode(<String, dynamic>{
        'store_id': store_id.toString(),
        'medicine_id': medicine_id.toString(),
        'quantity': quantity.toString(),
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

  Future deleteCardItem({String token,int store_id, int medicine_id}) {
    return http.post(
      Uri.parse(NetUtils.BASE_URL + '/delete-cart-item'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'x-api-key': token
      },
      body: jsonEncode(<String, dynamic>{
        'store_id': store_id.toString(),
        'medicine_id': medicine_id.toString(),
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

}
