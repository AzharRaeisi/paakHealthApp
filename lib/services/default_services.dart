import 'dart:convert';
import 'dart:io';

import 'package:http/io_client.dart';

import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import 'package:paakhealth/models/api_response.dart';
import 'package:paakhealth/services/api.dart';

class DefaultServices {
  static const headers = <String, String>{
    'Content-Type': 'application/json',
  };

  var logger = Logger();
  var deviceType;

  DefaultServices() {
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

  Future getCityList() {
    return http.get(
      Uri.parse(NetUtils.BASE_URL + '/get-city-list'),
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
    ).then((data) {
      final jsonData = json.decode(data.body);

      return APIResponse(
          list: jsonData['city'],
          status: jsonData['status'],
          message: jsonData['msg']);
    }).catchError((onError) {
      logger.e(onError);
      // return APIResponse(data: '', status: '', message: '');
    });
  }

Future getExpertiseList() {
    return http.get(
      Uri.parse(NetUtils.BASE_URL + '/get-expertise-list'),
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
    ).then((data) {
      final jsonData = json.decode(data.body);

      return APIResponse(
          list: jsonData['expertise'],
          status: jsonData['status'],
          message: jsonData['msg']);
    }).catchError((onError) {
      logger.e(onError);
      // return APIResponse(data: '', status: '', message: '');
    });
  }

  Future getPaymentList() {
    return http.get(
      Uri.parse(NetUtils.BASE_URL + '/get-payment-list'),
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
    ).then((data) {
      final jsonData = json.decode(data.body);

      return APIResponse(
          list: jsonData['payment'],
          status: jsonData['status'],
          message: jsonData['msg']);
    }).catchError((onError) {
      logger.e(onError);
      // return APIResponse(data: '', status: '', message: '');
    });
  }

  Future getBloodGroupList() {
    return http.get(
      Uri.parse(NetUtils.BASE_URL + '/get-blood-groups'),
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
    ).then((data) {
      final jsonData = json.decode(data.body);

      return APIResponse(
          list: jsonData['blood_groups'],
          status: jsonData['status'],
          message: jsonData['msg']);
    }).catchError((onError) {
      logger.e(onError);
      // return APIResponse(data: '', status: '', message: '');
    });
  }



  Future uploadImage({
    String token,
    String filename
  }) async {

    var header = <String, String>{
      'Content-Type': 'application/json',
      'x-api-key': token
    };


    var uri = Uri.parse(NetUtils.BASE_URL + '/upload-image');
    var request = http.MultipartRequest('POST', uri);
    request.headers.addAll(header);
    request.files.add(await http.MultipartFile.fromPath('image', filename));
    var res = await request.send();

    final respStr = await res.stream.bytesToString();
    // logger.i(respStr);

    final jsonData = json.decode(respStr);

    // logger.i(jsonData['status']);
    // logger.i(jsonData['msg']);
    // logger.i(jsonData['url']);

    return APIResponse(
        url: jsonData['url'],
        status: jsonData['status'],
        message: jsonData['msg']);





  }
}
