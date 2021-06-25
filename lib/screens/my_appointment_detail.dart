import 'package:flutter/material.dart';
import 'package:paakhealth/models/my_appointment_doctor_info_model.dart';
import 'package:paakhealth/models/my_appointments_model.dart';
import 'package:paakhealth/util/appointment_status.dart';
import 'package:paakhealth/util/colors.dart';

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
      backgroundColor: Colors.white,
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
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 2,
        backgroundColor: Colors.white,
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraint) {
            return Container(
              padding: EdgeInsets.all(20.0),
              child: SingleChildScrollView(
                child: ConstrainedBox(
                  constraints:
                      BoxConstraints(minHeight: constraint.maxHeight - 40),
                  child: IntrinsicHeight(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              'Appointment ID: ',
                              style: TextStyle(
                                fontSize: 12.0,
                                color: Colors.black,
                              ),
                            ),
                            Text(
                              appointmentModel.booking_number,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 12.0,
                                color: Colors.black,
                              ),
                            )
                          ],
                        ),
                        Row(
                          children: [
                            Text(
                              'Appointment Type: ',
                              style: TextStyle(
                                fontSize: 12.0,
                                color: Colors.black,
                              ),
                            ),
                            Text(
                              appointmentModel.appointment_type,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 12.0,
                                color: Colors.black,
                              ),
                            )
                          ],
                        ),
                        Row(
                          children: [
                            Text(
                              'Appointment Status: ',
                              style: TextStyle(
                                fontSize: 12.0,
                                color: Colors.black,
                              ),
                            ),
                            Text(
                              AppointmentStatus.status(
                                  appointmentModel.booking_status),
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 12.0,
                                color: AppColors.primaryColor,
                              ),
                            )
                          ],
                        ),
                        Divider(
                          height: 20.0,
                        ),
                        Expanded(
                            child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Appointment Details:',
                              style: TextStyle(
                                // fontSize: 12.0,
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
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
                            Row(
                              children: [
                                Text(
                                  'Date: ',
                                  style: TextStyle(
                                    fontSize: 12.0,
                                    color: Colors.black,
                                  ),
                                ),
                                Text(
                                  appointmentModel.booking_date,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12.0,
                                    color: AppColors.primaryColor,
                                  ),
                                )
                              ],
                            ),
                            Row(
                              children: [
                                Text(
                                  'Time Slot Selected: ',
                                  style: TextStyle(
                                    fontSize: 12.0,
                                    color: Colors.black,
                                  ),
                                ),
                                Text(
                                  appointmentModel.booking_time,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12.0,
                                    color: AppColors.primaryColor,
                                  ),
                                )
                              ],
                            ),
                          ],
                        )),
                        Divider(
                          height: 20.0,
                        ),
                        Text(
                          'Doctor Details:',
                          style: TextStyle(
                            // fontSize: 12.0,
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
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
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      doctorInfo.expertise,
                                      style: TextStyle(
                                        fontSize: 12.0,
                                        color: Colors.black38,
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
                                            fontWeight: FontWeight.bold,
                                            fontSize: 12,
                                            color: AppColors.primaryColor,
                                          )),
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
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12),
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
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12,
                                    )),
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
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12,
                                    )),
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
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12,
                                    )),
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
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12,
                                    )),
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
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: 5.0,
                        ),
                        Text(
                          'Executive Complex, Lower Ground Floor, Behind PSO PUMP, G-8 Markaz, Islamabad',
                          style: TextStyle(
                            fontSize: 12.0,
                            color: Colors.black38,
                          ),
                        )
                      ],
                    ),
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
