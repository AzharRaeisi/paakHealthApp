import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:paakhealth/models/api_response.dart';
import 'package:paakhealth/models/my_appointments_model.dart';
import 'package:paakhealth/screens/my_appointment_detail.dart';
import 'package:paakhealth/services/doctor_services.dart';
import 'package:paakhealth/util/colors.dart';
import 'package:paakhealth/util/order_status.dart';
import 'package:paakhealth/util/prefernces.dart';
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
            'My Appointments',
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
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
      child: Row(
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
                        style: TextStyle(color: Colors.grey[600], fontSize: 12),
                      ),
                      Text(
                        model.booking_number,
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                            color: Colors.grey[700]),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Text(
                        'Appointment Date: ',
                        style: TextStyle(color: Colors.grey[600], fontSize: 12),
                      ),
                      Text(
                        model.booking_date,
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                            color: Colors.grey[700]),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  Row(
                    children: [
                      Text(
                        'Order Status: ',
                        style: TextStyle(color: Colors.grey[600], fontSize: 12),
                      ),
                      Text(
                        OrderStatus.status(model.booking_status),
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                            color: Colors.grey[700]),
                      ),
                      Expanded(child: Container()),
                      GestureDetector(
                        onTap: () {
                          Get.to(() => MyAppointmentDetail(model: model));
                        },
                        child: Text(
                          'View Details',
                          style: TextStyle(
                              color: AppColors.primaryColor, fontSize: 12),
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
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
