import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:paakhealth/models/api_response.dart';
import 'package:paakhealth/models/my_appointments_model.dart';
import 'package:paakhealth/screens/appointment/my_appointment_detail.dart';
import 'package:paakhealth/services/doctor_services.dart';
import 'package:paakhealth/util/colors.dart';
import 'package:paakhealth/util/font.dart';
import 'package:paakhealth/util/order_status.dart';
import 'package:paakhealth/util/prefernces.dart';
import 'package:paakhealth/util/text_style.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyAppointmentScreen extends StatefulWidget {
  const MyAppointmentScreen({Key key}) : super(key: key);

  @override
  _MyAppointmentScreenState createState() => _MyAppointmentScreenState();
}

class _MyAppointmentScreenState extends State<MyAppointmentScreen> {
  var logger = Logger();

  bool isLoading = true;
  List<AppointmentModel> appointments = [];


  @override
  void initState() {
    getAppointments();
    super.initState();
  }

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
            'My Appointments',
            style: AppTextStyle.appbarTextStyle,
          ),
          centerTitle: true,
          elevation: 2,
          backgroundColor: Colors.white,
        ),
        // drawer: MainDrawer(title: 'My Orders'),
        body: ListView.builder(
            itemCount: appointments.length,
            itemBuilder: (context, index){
              return _appointmentItem(appointments[index]);
            })
      // Column(
      //   children: [
      //     _orderItem(OrderListItemModel(
      //         id: '1234',
      //         order_id: '4321',
      //         time: '20121-03-03 01:10',
      //         status: 'Pending')),
      //     _orderItem(OrderListItemModel(
      //         id: '1234',
      //         order_id: '4321',
      //         time: '20121-03-03 01:10',
      //         status: 'Delivered')),
      //     _orderItem(OrderListItemModel(
      //         id: '1234',
      //         order_id: '4321',
      //         time: '20121-03-03 01:10',
      //         status: 'Delivered')),
      //     _orderItem(OrderListItemModel(
      //         id: '1234',
      //         order_id: '4321',
      //         time: '20121-03-03 01:10',
      //         status: 'Delivered')),
      //   ],
      // ),
    );
  }

  Widget _appointmentItem(AppointmentModel model) {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.all(10),
      margin:  EdgeInsets.only(top: 10, left: 10, right: 10),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                  width: 60,
                  height: 60,
                  child: FadeInImage(
                    image: NetworkImage(
                        model.doctor_info['image']),
                    placeholder: AssetImage('assets/avatar.png'),
                    fit: BoxFit.cover,
                  )),
              Flexible(
                flex: 1,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                            model.booking_number,
                            style: TextStyle(
                              fontSize: 12.0,
                              fontFamily: AppFont.Gotham,
                              fontWeight: FontWeight.w500,
                              color: AppColors.textColor,
                            ),
                          ),
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
                            model.appointment_type,
                            style: TextStyle(
                              fontSize: 12.0,
                              fontFamily: AppFont.Gotham,
                              fontWeight: FontWeight.w500,
                              color: AppColors.textColor,
                            ),
                          ),
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
                            model.booking_date,
                            style: TextStyle(
                              fontSize: 12.0,
                              fontFamily: AppFont.Gotham,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textColor,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                      GestureDetector(
                        onTap: () {
                          // Get.to(() => MyAppointmentDetail(model: model));
                          pushNewScreen(
                            context,
                            screen: MyAppointmentDetail(model: model),
                            withNavBar: true, // OPTIONAL VALUE. True by default.
                            pageTransitionAnimation: PageTransitionAnimation.cupertino,
                          );
                        },
                        child: Text(
                          'View Details',
                          style: TextStyle(
                            fontSize: 12.0,
                            fontFamily: AppFont.Gotham,
                            fontWeight: FontWeight.w400,
                            color: AppColors.primaryColor,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              )
            ],
          ),

          SizedBox(height: 3,),
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
                OrderStatus.status(model.booking_status),
                style: TextStyle(
                  fontSize: 12.0,
                  fontFamily: AppFont.Gotham,
                  fontWeight: FontWeight.w500,
                  color: AppColors.primaryColor,
                ),
              ),
              Expanded(child: Container()),
              Row(
                children: [
                  Text(
                    'Total: ',
                    style: TextStyle(
                      fontSize: 12.0,
                      fontFamily: AppFont.Gotham,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textColor,
                    ),
                  ),
                  Text(
                    'Rs. ' + model.fees.toString(),
                    style: TextStyle(
                      fontSize: 12.0,
                      fontFamily: AppFont.Gotham,
                      fontWeight: FontWeight.w700,
                      color: AppColors.primaryColor,
                    ),
                  ),
                ],
              ),
            ],
          )
        ],
      ),
    );
  }

  Future<void> getAppointments() async {
    appointments = [];
    var doctorServices = DoctorServices();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString(SharedPreVariables.TOKEN);

    APIResponse response = await doctorServices.getAppoitments(token: token);
    if (response != null) {
      if (response.status == '1') {
        logger.i(response.message);
        // print('response.data');

        Iterable iterable = response.list;
        appointments =
            iterable.map((list) => AppointmentModel.fromMap(list)).toList();
        // print('cartItemList.length');
        // print(orders.length);
        setState(() {

        });

      } else {
        Get.snackbar('', response.message);
      }
    } else {
      print('API response is null');
      Get.snackbar('', 'Oops! Server is Down');
    }
  }
}
