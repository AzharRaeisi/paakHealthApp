import 'package:flutter/material.dart';
import 'package:paakhealth/models/my_appointment_doctor_info_model.dart';
import 'package:paakhealth/models/my_appointments_model.dart';
import 'package:paakhealth/util/appointment_status.dart';
import 'package:paakhealth/util/colors.dart';
import 'package:paakhealth/util/font.dart';
import 'package:paakhealth/util/text_style.dart';

class MyAppointmentDetail extends StatefulWidget {
  final AppointmentModel model;

  const MyAppointmentDetail({Key key, @required this.model}) : super(key: key);

  @override
  _MyAppointmentDetailState createState() => _MyAppointmentDetailState();
}

class _MyAppointmentDetailState extends State<MyAppointmentDetail> {
  AppointmentModel appointmentModel;
  DoctorInfo doctorInfo;

  @override
  Widget build(BuildContext context) {
    appointmentModel = widget.model;
    doctorInfo = DoctorInfo.fromMap(appointmentModel.doctor_info);

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
          'Appointment Detail',
          style: AppTextStyle.appbarTextStyle,
        ),
        centerTitle: true,
        elevation: 2,
        backgroundColor: Colors.white,
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraint) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints:
                BoxConstraints(minHeight: constraint.maxHeight),
                child: IntrinsicHeight(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: EdgeInsets.all(10),
                        color: AppColors.boxColor,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  'Appointment ID: ',
                                  style: TextStyle(
                                    fontSize: 12.0,
                                    fontFamily: AppFont.Gotham,
                                    fontWeight: FontWeight.w400,
                                    color: AppColors.textColor,
                                  ),
                                ),
                                Text(
                                  appointmentModel.booking_number,
                                  style: TextStyle(
                                    fontSize: 12.0,
                                    fontFamily: AppFont.Gotham,
                                    fontWeight: FontWeight.w500,
                                    color: AppColors.textColor,
                                  ),
                                )
                              ],
                            ),
                            SizedBox(height: 3,),
                            Row(
                              children: [
                                Text(
                                  'Appointment Type: ',
                                  style: TextStyle(
                                    fontSize: 12.0,
                                    fontFamily: AppFont.Gotham,
                                    fontWeight: FontWeight.w400,
                                    color: AppColors.textColor,
                                  ),
                                ),
                                Text(
                                  appointmentModel.appointment_type,
                                  style: TextStyle(
                                    fontSize: 12.0,
                                    fontFamily: AppFont.Gotham,
                                    fontWeight: FontWeight.w500,
                                    color: AppColors.textColor,
                                  ),
                                )
                              ],
                            ),
                            SizedBox(height: 3,),
                            Row(
                              children: [
                                Text(
                                  'Appointment made on ',
                                  style: TextStyle(
                                    fontSize: 12.0,
                                    fontFamily: AppFont.Gotham,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.textColor,
                                  ),
                                ),
                                Text(
                                  appointmentModel.booking_date,
                                  style: TextStyle(
                                    fontSize: 12.0,
                                    fontFamily: AppFont.Gotham,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.textColor,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 10,),
                            Row(
                              children: [
                                Text(
                                  'Appointment Status: ',
                                  style: TextStyle(
                                    fontSize: 12.0,
                                    fontFamily: AppFont.Gotham,
                                    fontWeight: FontWeight.w400,
                                    color: AppColors.textColor,
                                  ),
                                ),
                                Text(
                                  AppointmentStatus.status(
                                      appointmentModel.booking_status),
                                  style: TextStyle(
                                    fontSize: 12.0,
                                    fontFamily: AppFont.Gotham,
                                    fontWeight: FontWeight.w500,
                                    color: AppColors.primaryColor,
                                  ),
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      Expanded(
                          child: Container(
                            padding: EdgeInsets.all(10),
                            color: AppColors.boxColor,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Appointment Details:',
                                  style: TextStyle(
                                    fontSize: 12.0,
                                    fontFamily: AppFont.Gotham,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.textColor,
                                  ),
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                Text(
                                  'Visit booked for',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 10.0,
                                  ),
                                ),
                                SizedBox(height: 3,),
                                Row(
                                  children: [
                                    Text(
                                      'Date: ',
                                      style: TextStyle(
                                        fontSize: 12.0,
                                        fontFamily: AppFont.Gotham,
                                        fontWeight: FontWeight.w400,
                                        color: AppColors.textColor,
                                      ),
                                    ),
                                    Text(
                                      appointmentModel.booking_date,
                                      style: TextStyle(
                                        fontSize: 12.0,
                                        fontFamily: AppFont.Gotham,
                                        fontWeight: FontWeight.w500,
                                        color: AppColors.primaryColor,
                                      ),
                                    )
                                  ],
                                ),
                                SizedBox(height: 3,),
                                Row(
                                  children: [
                                    Text(
                                      'Time Slot Selected: ',
                                      style: TextStyle(
                                        fontSize: 12.0,
                                        fontFamily: AppFont.Gotham,
                                        fontWeight: FontWeight.w400,
                                        color: AppColors.textColor,
                                      ),
                                    ),
                                    Text(
                                      appointmentModel.booking_time,
                                      style: TextStyle(
                                        fontSize: 12.0,
                                        fontFamily: AppFont.Gotham,
                                        fontWeight: FontWeight.w500,
                                        color: AppColors.primaryColor,
                                      ),
                                    )
                                  ],
                                ),
                                SizedBox(height: 10,),
                                Row(
                                  children: [
                                    Text(
                                      'Payment: ',
                                      style: TextStyle(
                                        fontSize: 12.0,
                                        fontFamily: AppFont.Gotham,
                                        fontWeight: FontWeight.w400,
                                        color: AppColors.textColor,
                                      ),
                                    ),
                                    Text(
                                      'Rs. ' + appointmentModel.booking_time,
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12.0,
                                        color: AppColors.primaryColor,
                                      ),
                                    )
                                  ],
                                ),
                              ],
                            ),
                          )),
                      SizedBox(
                        height: 10.0,
                      ),
                      Container(
                        padding: EdgeInsets.all(10),
                        color: AppColors.boxColor,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Doctor Details:',
                              style: TextStyle(
                                // fontSize: 12.0,
                                fontFamily: AppFont.Gotham,
                                fontWeight: FontWeight.w700,
                                color: AppColors.textColor,
                              ),
                            ),

                            SizedBox(
                              height: 20,
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CircleAvatar(
                                  radius: 37.0,
                                  backgroundColor: AppColors.primaryColor,
                                  child: CircleAvatar(
                                    radius: 35,
                                    backgroundImage: NetworkImage(doctorInfo.image),
                                    backgroundColor: Colors.white,
                                  ),
                                ),
                                Expanded(
                                  child: Container(
                                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 7),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          doctorInfo.name,
                                          style: TextStyle(
                                            fontSize: 14.0,
                                            fontFamily: AppFont.Gotham,
                                            fontWeight: FontWeight.w700,
                                            color: AppColors.textColor,
                                          ),
                                        ),
                                        Text(
                                          doctorInfo.expertise,
                                          style: TextStyle(
                                            fontSize: 12.0,
                                            fontFamily: AppFont.Gotham,
                                            fontWeight: FontWeight.w400,
                                            color: AppColors.textColor,
                                          ),
                                        ),
                                        ListTile(
                                          leading: Icon(
                                            Icons.location_pin,
                                            color: AppColors.primaryColor,
                                            size: 20,
                                          ),
                                          title: Text(doctorInfo.address,
                                            style: TextStyle(
                                              fontSize: 12.0,
                                              fontFamily: AppFont.Gotham,
                                              fontWeight: FontWeight.w700,
                                              color: AppColors.primaryColor,
                                            ),),
                                          horizontalTitleGap: 0,
                                          contentPadding: EdgeInsets.zero,
                                          visualDensity: VisualDensity(
                                              horizontal: 0, vertical: -4),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Icon(Icons.star_border,
                                        color: Colors.teal, size: 20),
                                    Text(
                                      doctorInfo.rating,
                                        style: TextStyle(
                                          fontSize: 12.0,
                                          fontFamily: AppFont.Gotham,
                                          fontWeight: FontWeight.w700,
                                          color: AppColors.textColor,
                                        ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Expanded(
                                  child: ListTile(
                                    leading: Icon(
                                      Icons.calendar_today_sharp,
                                      color: AppColors.primaryColor,
                                      size: 20,
                                    ),
                                    title: Text(doctorInfo.available_days,
                                      style: TextStyle(
                                        fontSize: 12.0,
                                        fontFamily: AppFont.Gotham,
                                        fontWeight: FontWeight.w400,
                                        color: AppColors.textColor,
                                      ),),
                                    horizontalTitleGap: 0,
                                    contentPadding: EdgeInsets.zero,
                                    visualDensity:
                                    VisualDensity(horizontal: 0, vertical: -4),
                                  ),
                                ),
                                Expanded(
                                  child: ListTile(
                                    leading: Icon(
                                      Icons.call_outlined,
                                      color: AppColors.primaryColor,
                                      size: 20,
                                    ),
                                    title: Text(doctorInfo.phone,
                                      style: TextStyle(
                                        fontSize: 12.0,
                                        fontFamily: AppFont.Gotham,
                                        fontWeight: FontWeight.w400,
                                        color: AppColors.textColor,
                                      ),),
                                    horizontalTitleGap: 0,
                                    contentPadding: EdgeInsets.zero,
                                    visualDensity:
                                    VisualDensity(horizontal: 0, vertical: -4),
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Expanded(
                                  child: ListTile(
                                    leading: Icon(
                                      Icons.access_time,
                                      color: AppColors.primaryColor,
                                      size: 20,
                                    ),
                                    title: Text(doctorInfo.wait_time,
                                      style: TextStyle(
                                        fontSize: 12.0,
                                        fontFamily: AppFont.Gotham,
                                        fontWeight: FontWeight.w400,
                                        color: AppColors.textColor,
                                      ),),
                                    horizontalTitleGap: 0,
                                    contentPadding: EdgeInsets.zero,
                                    visualDensity:
                                    VisualDensity(horizontal: 0, vertical: -4),
                                  ),
                                ),
                                Expanded(
                                  child: ListTile(
                                    leading: Icon(
                                      Icons.credit_card,
                                      color: AppColors.primaryColor,
                                      size: 20,
                                    ),
                                    title: Text('Rs ' + doctorInfo.fees.toString(),
                                      style: TextStyle(
                                        fontSize: 12.0,
                                        fontFamily: AppFont.Gotham,
                                        fontWeight: FontWeight.w400,
                                        color: AppColors.textColor,
                                      ),),
                                    horizontalTitleGap: 0,
                                    contentPadding: EdgeInsets.zero,
                                    visualDensity:
                                    VisualDensity(horizontal: 0, vertical: -4),
                                  ),
                                ),
                              ],
                            ),
                            Text(
                              'Advanced Medical Centre',
                              style: TextStyle(
                                fontSize: 14.0,
                                fontFamily: AppFont.Gotham,
                                fontWeight: FontWeight.w700,
                                color: AppColors.textColor,
                              ),
                            ),
                            SizedBox(
                              height: 5.0,
                            ),
                            Text(
                              'Executive Complex, Lower Ground Floor, Behind PSO PUMP, G-8 Markaz, Islamabad',
                              style: TextStyle(
                                fontSize: 12.0,
                                fontFamily: AppFont.Gotham,
                                fontWeight: FontWeight.w400,
                                color: AppColors.textColor,
                              ),
                            ),

                            SizedBox(
                              height: 10,
                            ),
                            IntrinsicHeight(
                              child: Row(
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: [
                                      Text(doctorInfo.wait_time,
                                          style: TextStyle(
                                            fontFamily: AppFont.Gotham,
                                            fontWeight: FontWeight.w700,
                                            fontSize: 14,
                                            color: AppColors.primaryColor,
                                          )),
                                      Text(
                                        'Wait Time',
                                        style: TextStyle(
                                          fontFamily: AppFont.Avenirl,
                                          fontWeight: FontWeight.w700,
                                          fontSize: 12.0,
                                          color: Colors.black38,
                                        ),
                                      ),
                                    ],
                                  ),
                                  VerticalDivider(
                                    width: 40,
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: [
                                      Text(doctorInfo.experience,
                                          style: TextStyle(
                                            fontFamily: AppFont.Gotham,
                                            fontWeight: FontWeight.w700,
                                            fontSize: 14,
                                            color: AppColors.primaryColor,
                                          )),
                                      Text(
                                        'Experience',
                                        style: TextStyle(
                                          fontFamily: AppFont.Avenirl,
                                          fontWeight: FontWeight.w700,
                                          fontSize: 12.0,
                                          color: AppColors.textColor,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
