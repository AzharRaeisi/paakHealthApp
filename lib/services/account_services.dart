import 'dart:convert';
import 'dart:io';

import 'package:http/io_client.dart';

import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import 'package:paakhealth/models/api_response.dart';
import 'package:paakhealth/services/api.dart';

class AccountServices {

  static const headers = <String, String>{
    'Content-Type': 'application/json',
  };

  var logger = Logger();
  // var http;
  var deviceType;
  //
  AccountServices() {
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

  Future login({String name, String password, String device_token}) {

    return http
        .post(
      Uri.parse(NetUtils.BASE_URL + '/login'),
      headers: headers,
      body: jsonEncode(<String, dynamic>{
        'name': name,
        'password': password,
        'device_type': deviceType,
        'device_token': device_token
      }),
    )
        .then((data) {
      final jsonData = json.decode(data.body);
      // logger.i(jsonData);

      // logger.i(jsonData['result']);
      // logger.i(jsonData['status']);
      // logger.i(jsonData['msg']);
      var api = APIResponse(
          data: jsonData['result'],
          status: jsonData['status'],
          message: jsonData['msg']);

      // logger.i(api.status);
      // logger.i(api.message);
      // logger.i(api.data);
      // logger.i(api.data['token']);

      return APIResponse(
          data: jsonData['result'],
          status: jsonData['status'],
          message: jsonData['msg']);
    }).catchError((onError) {
      logger.e(onError);
      // return APIResponse(data: '', status: '', message: '');
    });
  }

  Future signUp({String name, String phone, String password, String gender, String device_token}) {

    return http
        .post(
      Uri.parse(NetUtils.BASE_URL + '/signup'),
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: jsonEncode(<String, dynamic>{
        'name': name,
        'phone': '+92' + phone,
        'password': password,
        'gender': gender,
        'device_token': device_token,
        'device_type': deviceType
      }),
    )
        .then((data) {
      final jsonData = json.decode(data.body);
      // logger.i(jsonData);

      // logger.i(jsonData['result']);
      // logger.i(jsonData['status']);
      // logger.i(jsonData['msg']);
      var api = APIResponse(
          data: jsonData['result'],
          status: jsonData['status'],
          message: jsonData['msg']);

      // logger.i(api.status);
      // logger.i(api.message);
      // logger.i(api.data);
      // logger.i(api.data['token']);

      return APIResponse(
          data: jsonData['result'],
          status: jsonData['status'],
          message: jsonData['msg']);
    }).catchError((onError) {
      logger.e(onError);
      // return APIResponse(data: '', status: '', message: '');
    });
  }

  Future checkPhoneVerification({String phone}) {

    return http
        .post(
      Uri.parse(NetUtils.BASE_URL + '/check-phone-verification'),
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: jsonEncode(<String, dynamic>{
        'phone': '+92' + phone,
      }),
    )
        .then((data) {
      final jsonData = json.decode(data.body);

      var api = APIResponse(
          data: jsonData['result'],
          status: jsonData['status'],
          message: jsonData['msg']);

      // logger.i(api.status);
      // logger.i(api.message);
      // logger.i(api.data);
      // logger.i(api.data['token']);

      return APIResponse(
          data: jsonData['result'],
          status: jsonData['status'],
          message: jsonData['msg']);

    }).catchError((onError) {
      logger.e(onError);
      // return APIResponse(data: '', status: '', message: '');
    });
  }

  // this api end point just
  Future checkVerificationCode({String phone}) {

    return http
        .post(
      Uri.parse(NetUtils.BASE_URL + '/check-phone-verification'),
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: jsonEncode(<String, dynamic>{
        'phone': '+92' + phone,
        'is_verified': 1
      }),
    )
        .then((data) {
      final jsonData = json.decode(data.body);

      var api = APIResponse(
          data: jsonData['result'],
          status: jsonData['status'],
          message: jsonData['msg']);

      // logger.i(api.status);
      // logger.i(api.message);
      // logger.i(api.data);
      // logger.i(api.data['token']);

      return APIResponse(
          data: jsonData['result'],
          status: jsonData['status'],
          message: jsonData['msg']);

    }).catchError((onError) {
      logger.e(onError);
      // return APIResponse(data: '', status: '', message: '');
    });
  }

  Future getUsername({String phone}) {

    return http
        .post(
      Uri.parse(NetUtils.BASE_URL + '/get-username'),
      headers: headers,
      body: jsonEncode(<String, dynamic>{
        'phone': '+92' + phone
      }),
    )
        .then((data) {
      final jsonData = json.decode(data.body);
      return APIResponse(
          name: jsonData['name'],
          status: jsonData['status'],
          message: jsonData['msg']);
    }).catchError((onError) {
      logger.e(onError);
    });
  }

  Future resetPassword({String phone, String password}) {

    return http
        .post(
      Uri.parse(NetUtils.BASE_URL + '/reset-password'),
      headers: headers,
      body: jsonEncode(<String, dynamic>{
        'phone':'+92' + phone,
        'password': password
      }),
    )
        .then((data) {
      final jsonData = json.decode(data.body);
      return APIResponse(
          name: jsonData['name'],
          status: jsonData['status'],
          message: jsonData['msg']);
    }).catchError((onError) {
      logger.e(onError);
    });
  }

  Future getAddresses({String token}) {
    return http.get(
      Uri.parse(NetUtils.BASE_URL + '/address-list'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'x-api-key': token
      },
    ).then((data) {
      final jsonData = json.decode(data.body);

      return APIResponse(
          list: jsonData['address'],
          status: jsonData['status'],
          message: jsonData['msg']);
    }).catchError((onError) {
      logger.e(onError);
      // return APIResponse(data: '', status: '', message: '');
    });
  }

  Future addAddress({String token, String name, String type_name, String address, String  latitude, String  longitude, String  phone, int city}) {

    return http.post(
      Uri.parse(NetUtils.BASE_URL + '/add-address'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'x-api-key': token
      },
      body: jsonEncode(<String, dynamic>{
        'name': name,
        'type_name': type_name,
        'address': address,
        'latitude': latitude,
        'longitude': longitude,
        'phone': phone,
        'city': city,
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

  Future saveAddressChanges({String token, int address_id, String name, String type_name, String address, String  latitude, String  longitude, String  phone, int city}) {

    return http.post(
      Uri.parse(NetUtils.BASE_URL + '/edit-address'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'x-api-key': token
      },
      body: jsonEncode(<String, dynamic>{
        'address_id': address_id,
        'name': name,
        'type_name': type_name,
        'address': address,
        'latitude': latitude,
        'longitude': longitude,
        'phone': phone,
        'city': city,
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

  Future deleteAddress({String token, int address_id}) {

    return http.post(
      Uri.parse(NetUtils.BASE_URL + '/delete-address'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'x-api-key': token
      },
      body: jsonEncode(<String, dynamic>{
        'address_id': address_id
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

  Future getWallet({String token, String from_date, String to_date}) {

    return http.post(
      Uri.parse(NetUtils.BASE_URL + '/get-wallet'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'x-api-key': token
      },
      body: jsonEncode(<String, dynamic>{
        'from_date': from_date,
        'to_date':to_date
      }),
    ).then((data) {
      final jsonData = json.decode(data.body);

      return APIResponse(
          list: jsonData['history'],
          wallet_amount: jsonData['wallet_amount'],
          status: jsonData['status'],
          message: jsonData['msg']);
    }).catchError((onError) {
      logger.e(onError);
      // return APIResponse(data: '', status: '', message: '');
    });
  }



  Future getProfile(String token,) {
    return http.get(
      Uri.parse(NetUtils.BASE_URL + '/get-profile'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'x-api-key': token
      },
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


  Future saveProfile({String token, String name, String email, String gender, String  profile_image}) {

    print('save  profile   ');
    return http.post(
      Uri.parse(NetUtils.BASE_URL + '/save-profile'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'x-api-key': token
      },
      body: jsonEncode(<String, dynamic>{
        'name': name,
        'email': email,
        'gender': gender,
        'profile_image': profile_image,
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

  Future socialLogin({String social_type, String email, String profile_image, String social_id, String  device_token}) {

    print('socail login');
    return http.post(
      Uri.parse(NetUtils.BASE_URL + '/social-login'),
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: jsonEncode(<String, dynamic>{
        'social_type': social_type,
        'email': email,
        'profile_image': profile_image,
        'social_id': social_id,
        'device_type': deviceType,
        'device_token': device_token,
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

}
