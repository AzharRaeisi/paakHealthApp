import 'package:flutter/material.dart';
import 'package:paakhealth/models/blood_station_model.dart';
import 'package:paakhealth/util/colors.dart';
import 'package:paakhealth/util/font.dart';
import 'package:paakhealth/util/text_style.dart';
import 'package:url_launcher/url_launcher.dart';

class BloodStationDetailScreen extends StatefulWidget {
  final BloodStationModel model;

  const BloodStationDetailScreen({Key key, this.model}) : super(key: key);

  @override
  _BloodStationDetailScreenState createState() => _BloodStationDetailScreenState();
}

class _BloodStationDetailScreenState extends State<BloodStationDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgColor,
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
          style: AppTextStyle.appbarTextStyle,
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
                                  fontFamily: AppFont.Gotham,
                                  fontWeight: FontWeight.w700,
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
                                        fontFamily: AppFont.Gotham,
                                        fontWeight: FontWeight.w700,
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
                                          color: AppColors.primaryColor,
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
                                    fontFamily: AppFont.Avenirl,
                                    fontWeight: FontWeight.w400,
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
                                      // print(widget.model.phone);
                                      await canLaunch('https://' + widget.model.website_link) ? await launch('https://' + widget.model.website_link) : throw 'Could not launch https:' + widget.model.website_link;
                                    },
                                    child: Card(
                                      child: CircleAvatar(
                                        radius: 30,
                                        backgroundColor: Colors.white,
                                        child: Icon(
                                          Icons.vpn_lock,
                                          color: AppColors.primaryColor,
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
                                  Text('Visit',style: TextStyle(
                                    fontFamily: AppFont.Avenirl,
                                    fontWeight: FontWeight.w400,
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
                SizedBox(
                  height: 20,
                ),
                IntrinsicHeight(
                  child: Container(
                    color: AppColors.boxColor,
                    padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                    child:Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Text(
                        //   widget.model.,
                        //   style: TextStyle(
                        //       color: AppColors.primaryColor,
                        //       fontWeight: FontWeight.bold,
                        //       fontSize: 16),
                        // ),
                        // VerticalDivider(
                        //   width: 30,
                        // ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.model.distance.toString().substring(0, 5) + ' KM',
                                style: TextStyle(
                                    color: AppColors.primaryColor,
                                    fontFamily: AppFont.Gotham,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 16),
                              ),
                              Text('away',style: TextStyle(
                                fontFamily: AppFont.Avenirl,
                                fontWeight: FontWeight.w700,
                                fontSize: 12,
                              ))
                            ],
                          ),
                        ),

                        // Icon(
                        //   Icons.star_border,
                        //   color: Colors.teal,
                        //   size: 20,
                        // ),
                        // Text(
                        //   widget.model.rating,
                        //   style: TextStyle(
                        //     fontSize: 12,
                        //   ),
                        // ),
                      ],
                    ),
                  ),
                ),

                SizedBox(
                  height: 10,
                ),
                Container(
                  color: Colors.white,
                  padding: EdgeInsets.only(left: 20, top: 20, bottom: 10),
                  child: Row(
                    children: [
                      Text('Address: ',
                          style: TextStyle(
                              fontFamily: AppFont.Gotham,
                              fontWeight: FontWeight.w700,
                              color: AppColors.headingColor,
                              fontSize: 12)),
                      Expanded(
                        child: Text(widget.model.address,
                            style:
                            TextStyle(
                                fontFamily: AppFont.Avenirl,
                                fontWeight: FontWeight.w400,
                                color: AppColors.textColor, fontSize: 12)),
                      ),
                    ],
                  ),
                ),
                Container(
                  color: Colors.white,
                  padding: EdgeInsets.only(left: 20, bottom: 20),
                  child: Row(
                    children: [
                      Text('Latitude: ',
                          style: TextStyle(
                              fontFamily: AppFont.Gotham,
                              fontWeight: FontWeight.w700,
                              color: AppColors.headingColor,
                              fontSize: 12)),
                      Expanded(
                        child: Text(widget.model.latitude,
                            style:
                            TextStyle(
                                fontFamily: AppFont.Avenirl,
                                fontWeight: FontWeight.w400,
                                color: AppColors.textColor, fontSize: 12)),
                      ),
                      Text('Longitude: ',
                          style: TextStyle(
                              fontFamily: AppFont.Gotham,
                              fontWeight: FontWeight.w700,
                              color: AppColors.headingColor,
                              fontSize: 12)),
                      Expanded(
                        child: Text(widget.model.longitude,
                            style:
                            TextStyle(
                                fontFamily: AppFont.Avenirl,
                                fontWeight: FontWeight.w400,
                                color: AppColors.textColor, fontSize: 12)),
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
