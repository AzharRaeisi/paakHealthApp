import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:paakhealth/models/api_response.dart';
import 'package:paakhealth/models/donar_model.dart';
import 'package:paakhealth/services/bloodbank_services.dart';
import 'package:paakhealth/util/colors.dart';
import 'package:paakhealth/util/prefernces.dart';
import 'package:paakhealth/util/text_style.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class BloodBankDetailScreen extends StatefulWidget {

  final DonarModel model;
  const BloodBankDetailScreen({Key key, @required this.model}) : super(key: key);

  @override
  _BloodBankDetailScreenState createState() => _BloodBankDetailScreenState();
}

class _BloodBankDetailScreenState extends State<BloodBankDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_rounded),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        iconTheme: IconThemeData(color: AppColors.primaryColor),
        title: Text(
          'Details',
          style: AppTextStyle.appTextStyle,
        ),
        centerTitle: true,
        elevation: 2,
        backgroundColor: Colors.white,
      ),
      body: SafeArea(
          child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              children: [
                Stack(
                  children: [
                    Container(
                      color: AppColors.primaryColor,
                      height: 300,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          CircleAvatar(
                            radius: 42.0,
                            backgroundColor: AppColors.primaryColor,
                            child: CircleAvatar(
                              radius: 40,
                              backgroundImage: NetworkImage(widget.model.profile_image),
                              backgroundColor: Colors.white,
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            widget.model.name,
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.location_pin,
                                color: Colors.white60,
                                size: 20,
                              ),
                              Text(widget.model.city,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12,
                                    color: Colors.white60,
                                  ))
                            ],
                          )
                        ],
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 260),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Column(
                            children: [
                              GestureDetector(
                                onTap: () async {
                                  // print(widget.model.phone);
                                  await canLaunch('tel://' + widget.model.phone) ? await launch('tel://' + widget.model.phone) : throw 'Could not launch tel:' + widget.model.phone;
                                },
                                child: Card(
                                  child: CircleAvatar(
                                    radius: 30,
                                    backgroundColor: Colors.white,
                                    child: Icon(
                                      Icons.call,
                                      color: Colors.blue,
                                    ),
                                  ),
                                  elevation: 5,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(50.0),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Text('Call',style: TextStyle(
                                fontSize: 12,
                              ))
                            ],
                          ),
                          SizedBox(
                            width: 20,
                          ),
                          Column(
                            children: [
                              GestureDetector(
                                onTap: () async {
                                  await canLaunch('sms:' + widget.model.phone) ? await launch('sms:' + widget.model.phone) : throw 'Could not launch sms:' + widget.model.phone;
                                },
                                child: Card(
                                  child: CircleAvatar(
                                    radius: 30,
                                    backgroundColor: Colors.white,
                                    child: Icon(
                                      Icons.chat,
                                      color: Colors.blue,
                                    ),
                                  ),
                                  elevation: 5,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(50.0),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Text('Chat',style: TextStyle(
                                fontSize: 12,
                              ))
                            ],
                          ),
                          SizedBox(
                            width: 20,
                          ),
                          Column(
                            children: [
                              GestureDetector(
                                onTap: () async {

                                  var bloodBankServices = BloodBankServices();
                                  // todo change device token
                                  SharedPreferences prefs = await SharedPreferences.getInstance();
                                  String token = prefs.getString(SharedPreVariables.TOKEN);
                                  // print(token);
                                  APIResponse response = await bloodBankServices.requestForBlodd(
                                      token: token,
                                      blood_bank_id: widget.model.id );
                                  if (response != null) {
                                    if (response.status == '1') {
                                      Get.snackbar('', response.message);

                                    } else {
                                      Get.snackbar('', response.message);
                                    }
                                  } else {
                                    print('API response is null');
                                    Get.snackbar('', 'Oops! Server is Down');
                                  }
                                },
                                child: Card(
                                  child: CircleAvatar(
                                    radius: 30,
                                    backgroundColor: Colors.white,
                                    child: Icon(
                                      Icons.send,
                                      color: Colors.blue,
                                    ),
                                  ),
                                  elevation: 5,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(50.0),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Text('Request',style: TextStyle(
                                fontSize: 12,
                              ))
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
            IntrinsicHeight(
              child: Container(
                margin: EdgeInsets.symmetric(vertical: 30, horizontal: 20),
                child:Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      widget.model.blood_group,
                      style: TextStyle(
                          color: AppColors.primaryColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 16),
                    ),
                    VerticalDivider(
                      width: 30,
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.model.distance.toString().substring(0, 5) + ' KM',
                            style: TextStyle(
                                color: AppColors.primaryColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 16),
                          ),
                          Text('away',style: TextStyle(
                            fontSize: 12,
                          ))
                        ],
                      ),
                    ),

                    Icon(
                      Icons.star_border,
                      color: Colors.teal,
                      size: 20,
                    ),
                    Text(
                      widget.model.rating,
                     style: TextStyle(
                      fontSize: 12,
                    ),
                    ),
                  ],
                ),
              ),
            ),
            Divider(
              indent: 14,
              endIndent: 14,
            ),

            Container(
              margin: EdgeInsets.only(left: 20, top: 20),
              child: Row(
                children: [
                  Text(
                  'Address: ',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                    fontSize: 12
                  )),
                  Expanded(
                    child: Text(
                        widget.model.address,
                        style: TextStyle(
                          color: Colors.black54,
                            fontSize: 12
                        )),
                  ),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.only(left: 20, top: 10),
              child: Row(
                children: [
                  Text(
                  'Comments: ',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                    fontSize: 12
                  )),
                  Expanded(
                    child: Text(
                        widget.model.comments,
                        style: TextStyle(
                          color: Colors.black54,
                            fontSize: 12
                        )),
                  ),
                ],
              ),
            ),

          ],
        ),
      )),
    );
  }
}
