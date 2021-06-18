import 'dart:convert';
import 'dart:io';

import 'package:http/io_client.dart';

import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import 'package:paakhealth/models/api_response.dart';
import 'package:paakhealth/services/api.dart';

class HomeServices {
  static const headers = <String, String>{
    'Content-Type': 'application/json',
  };

  var logger = Logger();
  var deviceType;

  HomeServices() {
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

  Future home({String token, String lat, String long}) {
    return http.post(
      Uri.parse(NetUtils.BASE_URL + '/home'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'x-api-key': token
      },
      body: jsonEncode(<String, dynamic>{
        'latitude': lat,
        'longitude': long,
      }),
    ).then((data) {
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

  Future searchPharmacy({String token,String search_text, String lat, String long}) {
    return http.post(
      Uri.parse(NetUtils.BASE_URL + '/search-pharmacy'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'x-api-key': token
      },
      body: jsonEncode(<String, dynamic>{
        'search_text': search_text,
        'latitude': lat,
        'longitude': long,
      }),
    ).then((data) {
      final jsonData = json.decode(data.body);

      return APIResponse(
          list: jsonData['store_list'],
          status: jsonData['status'],
          message: jsonData['msg']);
    }).catchError((onError) {
      logger.e(onError);
      // return APIResponse(data: '', status: '', message: '');
    });
  }

  Future searchMedicine({String token,String search_text, String lat, String long}) {
    return http.post(
      Uri.parse(NetUtils.BASE_URL + '/search-medicine'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'x-api-key': token
      },
      body: jsonEncode(<String, dynamic>{
        'search_text': search_text,
        'latitude': lat,
        'longitude': long,
      }),
    ).then((data) {
      final jsonData = json.decode(data.body);

      return APIResponse(
          list: jsonData['medicine_list'],
          status: jsonData['status'],
          message: jsonData['msg']);
    }).catchError((onError) {
      logger.e(onError);
      // return APIResponse(data: '', status: '', message: '');
    });
  }


  Future markMedicineFavorite({String token, int medicine_id}) {

    return http.post(
      Uri.parse(NetUtils.BASE_URL + '/mark-medicine-favorite'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'x-api-key': token
      },
      body: jsonEncode(<String, dynamic>{
        'medicine_id': medicine_id,
      }),
    ).then((data) {
      final jsonData = json.decode(data.body);

      return APIResponse(
          favoriteStatus: jsonData['result'],
          status: jsonData['status'],
          message: jsonData['msg']);
    }).catchError((onError) {
      logger.e(onError);
      // return APIResponse(data: '', status: '', message: '');
    });
  }

Future markStoreFavorite({String token, int store_id}) {

    return http.post(
      Uri.parse(NetUtils.BASE_URL + '/mark-store-favorite'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'x-api-key': token
      },
      body: jsonEncode(<String, dynamic>{
        'store_id': store_id,
      }),
    ).then((data) {
      final jsonData = json.decode(data.body);

      return APIResponse(
          favoriteStatus: jsonData['result'],
          status: jsonData['status'],
          message: jsonData['msg']);
    }).catchError((onError) {
      logger.e(onError);
      // return APIResponse(data: '', status: '', message: '');
    });
  }

  Future medicineDetail({String token, int medicine_id}) {

    return http.post(
      Uri.parse(NetUtils.BASE_URL + '/medicine-details'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'x-api-key': token
      },
      body: jsonEncode(<String, dynamic>{
        'medicine_id': medicine_id,
      }),
    ).then((data) {
      final jsonData = json.decode(data.body);

      return APIResponse(
          data: jsonData['medicine'],
          status: jsonData['status'],
          message: jsonData['msg']);
    }).catchError((onError) {
      logger.e(onError);
      // return APIResponse(data: '', status: '', message: '');
    });
  }

  Future pharmacyDetail({String token, int store_id}) {

    return http.post(
      Uri.parse(NetUtils.BASE_URL + '/pharmacy-details'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'x-api-key': token
      },
      body: jsonEncode(<String, dynamic>{
        'store_id': store_id,
      }),
    ).then((data) {
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

  Future doctorDetail({String token, int doctor_id}) {

    return http.post(
      Uri.parse(NetUtils.BASE_URL + '/doctor-details'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'x-api-key': token
      },
      body: jsonEncode(<String, dynamic>{
        'doctor_id': doctor_id,
      }),
    ).then((data) {
      final jsonData = json.decode(data.body);

      return APIResponse(
          data: jsonData['doctor'],
          status: jsonData['status'],
          message: jsonData['msg']);
    }).catchError((onError) {
      logger.e(onError);
      // return APIResponse(data: '', status: '', message: '');
    });
  }

  Future doctorSearch({String token,int type, String name,  List<int> speciality,  int city, String gender, String latitude,  String longitude }) {

    return http.post(
      Uri.parse(NetUtils.BASE_URL + '/search-doctor'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'x-api-key': token
      },
      body: jsonEncode(<String, dynamic>{
        'type': type,
        'name': name,
        'speciality': speciality,
        'city': city,
        'gender': gender,
        'latitude': latitude,
        'longitude': longitude,
      }),
    ).then((data) {
      final jsonData = json.decode(data.body);
      return APIResponse(
          list: jsonData['doctor_list'],
          status: jsonData['status'],
          message: jsonData['msg']);
    }).catchError((onError) {
      logger.e(onError);
      // return APIResponse(data: '', status: '', message: '');
    });
  }


  Future searchPharmacyMedicine({String token,int store_id, String search_text}) {
    return http.post(
      Uri.parse(NetUtils.BASE_URL + '/pharmacy-medicine-list'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'x-api-key': token
      },
      body: jsonEncode(<String, dynamic>{
        'store_id': store_id,
        'search_text': search_text,
      }),
    ).then((data) {
      final jsonData = json.decode(data.body);

      return APIResponse(
          list: jsonData['medicine_list'],
          status: jsonData['status'],
          message: jsonData['msg']);
    }).catchError((onError) {
      logger.e(onError);
      // return APIResponse(data: '', status: '', message: '');
    });
  }


}
