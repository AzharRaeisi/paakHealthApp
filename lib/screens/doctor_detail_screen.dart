import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:paakhealth/controllers/selected_slot_controller.dart';
import 'package:paakhealth/models/api_response.dart';
import 'package:paakhealth/models/city_model.dart';
import 'package:paakhealth/models/doctor_model.dart';
import 'package:paakhealth/models/doctor_slot_model.dart';
import 'package:paakhealth/models/general_model_book_apoint.dart';
import 'package:paakhealth/models/my_appointment_doctor_info_model.dart';
import 'package:paakhealth/models/payment_model.dart';
import 'package:paakhealth/services/default_services.dart';
import 'package:paakhealth/services/doctor_services.dart';
import 'package:paakhealth/services/home_services.dart';
import 'package:paakhealth/util/colors.dart';
import 'package:paakhealth/util/prefernces.dart';
import 'package:responsive_grid/responsive_grid.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DoctorDetailScreen extends StatefulWidget {
  final int id;

  const DoctorDetailScreen({Key key, @required this.id}) : super(key: key);

  @override
  _DoctorDetailScreenState createState() => _DoctorDetailScreenState();
}

class _DoctorDetailScreenState extends State<DoctorDetailScreen> {
  DoctorModel doctorInfo;

  bool loading = true;

  GeneralModel selectedAppointment;
  List<GeneralModel> appointmentList = [
    GeneralModel(id: 1, name: 'Regular Visit'),
    GeneralModel(id: 2, name: 'First Time Visit'),
  ];

  GeneralModel selectedConsultation;
  List<GeneralModel> consultationList = [
    GeneralModel(id: 1, name: 'Online Consultation'),
    GeneralModel(id: 2, name: 'Visit Doctor'),
  ];

  DateTime selectedDate = DateTime.now();

  bool processing = false;

  var logger = Logger();

  List<DoctorSlotModel> morningSlots = [];
  List<DoctorSlotModel> eveningSlots = [];

  SelectedSlotController controller = Get.put(SelectedSlotController());

  PaymentModel selectedPayment;
  List<PaymentModel> paymentList = [];

  GlobalKey<FormState> _key = GlobalKey<FormState>();

  TextEditingController _phoneController = new TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    getDoctor(id: widget.id);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: AppColors.primaryColor),
        title: Text(
          'More Details',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 2,
        backgroundColor: Colors.white,
      ),
      body: loading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Container(
              padding: EdgeInsets.all(20.0),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CircleAvatar(
                          radius: 37.0,
                          backgroundColor: AppColors.primaryColor,
                          child: CircleAvatar(
                            radius: 35,
                            backgroundImage: NetworkImage('doctorInfo.image'),
                            backgroundColor: Colors.white,
                          ),
                        ),
                        Expanded(
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 10, vertical: 7),
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
                                  fontWeight: FontWeight.bold, fontSize: 12),
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
                    Expanded(
                        child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Divider(
                          height: 20.0,
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
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        IntrinsicHeight(
                          child: Row(
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(doctorInfo.wait_time,
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                        color: AppColors.primaryColor,
                                      )),
                                  Text(
                                    'Wait Time',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
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
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(doctorInfo.experience,
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                        color: AppColors.primaryColor,
                                      )),
                                  Text(
                                    'Experience',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12.0,
                                      color: Colors.black38,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    )),
                    Expanded(
                        child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Divider(
                          height: 20.0,
                        ),
                        Row(
                          children: [
                            Text(
                              'Education: ',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 12.0,
                                color: Colors.black,
                              ),
                            ),
                            Text(
                              doctorInfo.education,
                              style: TextStyle(
                                fontSize: 12.0,
                                color: Colors.black38,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Specialization: ',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 12.0,
                                color: Colors.black,
                              ),
                            ),
                            Expanded(
                              child: Text(
                                doctorInfo.expertise,
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                  fontSize: 12.0,
                                  color: Colors.black38,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Professional Memberships: ',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 12.0,
                                color: Colors.black,
                              ),
                            ),
                            Expanded(
                              child: Text(
                                '',
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                  fontSize: 12.0,
                                  color: Colors.black38,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'About ' + doctorInfo.name + ': ',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 12.0,
                                color: Colors.black,
                              ),
                            ),
                            Expanded(
                              child: Text(
                                '',
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                  fontSize: 12.0,
                                  color: Colors.black38,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    )),
                    processing
                        ? Container(
                            alignment: Alignment.center,
                            child: Text('Processing, please wait...'),
                          )
                        : _primaryBtn(btnText: 'Book Appointment')
                  ]),
            ),
    );
  }

  Widget _primaryBtn({String btnText}) {
    return GestureDetector(
      onTap: () async {
        showModalBottomSheet(
            context: context,
            isDismissible: false,
            enableDrag: false,
            builder: (context) {
              return basicDetail();
            });
      },
      child: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: <Color>[
              Color(0xFF69C4F0),
              Color(0xFF00B2EE),
            ],
          ),
          borderRadius: BorderRadius.all(Radius.circular(5.0)),
        ),
        alignment: Alignment.center,
        padding: EdgeInsets.symmetric(vertical: 10),
        child: Text(
          btnText,
          style: TextStyle(color: Colors.white, fontSize: 18),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  Future<void> getDoctor({int id}) async {
    var homeServices = HomeServices();
    // todo change device token
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString(SharedPreVariables.TOKEN);

    APIResponse response =
        await homeServices.doctorDetail(token: token, doctor_id: id);
    if (response != null) {
      if (response.status == '1') {
        doctorInfo = DoctorModel.fromMap(response.data);
        loading = false;
        setState(() {});
      } else {
        Get.snackbar('', response.message);
      }
    } else {
      print('API response is null');
      Get.snackbar('', 'Oops! Server is Down');
    }
  }

  Widget basicDetail() {
    double h = 7;
    TextStyle s = TextStyle(fontSize: 12);
    return Container(
      padding: EdgeInsets.all(10),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Book Appointment', style: s),
            DropdownButtonFormField<GeneralModel>(
              // hint: Text("Select City"),
              isExpanded: true,
              value: selectedAppointment,
              onChanged: appointmentList.isNotEmpty
                  ? (value) {
                      // setState(() {
                      selectedAppointment = value;
                      // });
                    }
                  : null,
              items: appointmentList.map((GeneralModel apoint) {
                return DropdownMenuItem<GeneralModel>(
                  value: apoint,
                  child: Text(apoint.name, style: s),
                );
              }).toList(),
            ),
            SizedBox(
              height: h,
            ),
            Text('Type of Consultation', style: s),
            DropdownButtonFormField<GeneralModel>(
              // hint: Text("Select City"),
              isExpanded: true,
              value: selectedConsultation,
              onChanged: consultationList.isNotEmpty
                  ? (value) {
                      // setState(() {
                      selectedConsultation = value;
                      // });
                    }
                  : null,
              items: consultationList.map((GeneralModel consult) {
                return DropdownMenuItem<GeneralModel>(
                  value: consult,
                  child: Text(consult.name, style: s),
                );
              }).toList(),
            ),
            SizedBox(
              height: h,
            ),
            Text('Date', style: s),
            CalendarDatePicker(
              initialCalendarMode: DatePickerMode.day,
              firstDate: DateTime(2000),
              lastDate: DateTime(2050),
              initialDate: DateTime.now(),
              onDateChanged: (date) {
                selectedDate = date;
              },
            ),
            _nextBtn(btnText: 'Next')
          ],
        ),
      ),
    );
  }

  Widget _nextBtn({String btnText}) {
    return GestureDetector(
      onTap: () async {
        if (selectedAppointment == null || selectedConsultation == null) {
          Get.snackbar('', 'Please Select Appointment and Consultation Type');
        } else {
          Get.back();
          setState(() {
            processing = true;
          });

          print(selectedConsultation.id);
          print(selectedAppointment.id);
          print(formatDate(selectedDate, [yyyy, '-', mm, '-', d]));

          morningSlots = [];
          eveningSlots = [];

          var doctorServices = DoctorServices();
          SharedPreferences prefs = await SharedPreferences.getInstance();
          String token = prefs.getString(SharedPreVariables.TOKEN);

          APIResponse response = await doctorServices.getDoctorItemSlot(
              token: token,
              visit_type: selectedAppointment.id,
              consultation_type: selectedConsultation.id,
              booking_date:
                  formatDate(selectedDate, [yyyy, '-', mm, '-', d]).toString(),
              doctor_id: widget.id);
          if (response != null) {
            if (response.status == '1') {
              logger.i(response.message);
              print('response.data');

              Iterable iterable = response.data['morning_slots'];
              morningSlots = iterable
                  .map((list) => DoctorSlotModel.fromMap(list))
                  .toList();

              Iterable iterable2 = response.data['afternoon_slots'];
              eveningSlots = iterable2
                  .map((list) => DoctorSlotModel.fromMap(list))
                  .toList();

              print(morningSlots.length);
              print(eveningSlots.length);

              if (morningSlots.isEmpty && eveningSlots.isEmpty) {
                Get.snackbar('Oops', 'No slot available');
                setState(() {
                  processing = false;
                });
              } else {
                controller.removeAllExpertise();
                showModalBottomSheet(
                    context: context,
                    isDismissible: false,
                    enableDrag: false,
                    builder: (context) {
                      return showSlots();
                    });
              }
            } else {
              Get.snackbar('', response.message);
            }
          } else {
            print('API response is null');
            Get.snackbar('', 'Oops! Server is Down');
          }
        }
      },
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: <Color>[
              Color(0xFF69C4F0),
              Color(0xFF00B2EE),
            ],
          ),
          borderRadius: BorderRadius.all(Radius.circular(5.0)),
        ),
        alignment: Alignment.center,
        padding: EdgeInsets.symmetric(vertical: 10),
        child: Text(
          btnText,
          style: TextStyle(color: Colors.white, fontSize: 18),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  Widget showSlots() {
    double h = 7;
    TextStyle s = TextStyle(fontSize: 12);
    return Container(
      padding: EdgeInsets.all(10),
      color: AppColors.primaryColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Align(
              alignment: Alignment.centerRight,
              child: Container(
                  padding: EdgeInsets.only(right: 10, top: 10),
                  child: GestureDetector(
                    onTap: () {
                      Get.back();
                      setState(() {
                        processing = false;
                      });
                    },
                    child: Text('Cancel',
                        style: TextStyle(fontSize: 12, color: Colors.white)),
                  ))),
          Text('Available SLots', style: TextStyle(color: Colors.white)),
          Text(formatDate(selectedDate, [d, '-', M, '-', yyyy]),
              style: TextStyle(fontSize: 12, color: Colors.white60)),
          Text('Morning',
              style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: Colors.white)),
          SizedBox(
            height: h,
          ),
          Expanded(
              child: ResponsiveGridList(
                  desiredItemWidth: MediaQuery.of(context).size.width / 4,
                  minSpacing: 10,
                  children: morningSlots.map((i) {
                    return Obx(() => GestureDetector(
                          onTap: () {
                            if (controller.selectedSlot.value.isNotEmpty) {
                              if (controller.selectedSlot.value.contains(i)) {
                                print('insideee');
                                controller.removeAllExpertise();
                              } else {
                                controller.removeAllExpertise();

                                controller.addToExpertList(i);
                              }
                            } else {
                              controller.addToExpertList(i);
                            }

                            setState(() {});
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: controller.selectedSlot.value.contains(i)
                                  ? Colors.white60
                                  : Colors.transparent,
                              border: Border.all(color: Colors.white60),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5.0)),
                            ),
                            padding: EdgeInsets.all(3),
                            child: Center(
                              child: Text(
                                i.start_time,
                                style: TextStyle(
                                    color: controller.selectedSlot.value
                                            .contains(i)
                                        ? Colors.black45
                                        : Colors.white60),
                              ),
                            ),
                          ),
                        ));
                  }).toList())),
          Text('Afternoon',
              style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: Colors.white)),
          SizedBox(
            height: h,
          ),
          Expanded(
              child: ResponsiveGridList(
                  desiredItemWidth: MediaQuery.of(context).size.width / 3,
                  minSpacing: 1,
                  children: eveningSlots.map((i) {
                    return Obx(() => GestureDetector(
                          onTap: () {
                            if (controller.selectedSlot.value.isNotEmpty) {
                              if (controller.selectedSlot.value.contains(i)) {
                                print('insideee');
                                controller.removeAllExpertise();
                              } else {
                                controller.removeAllExpertise();

                                controller.addToExpertList(i);
                              }
                            } else {
                              controller.addToExpertList(i);
                            }

                            setState(() {});
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: controller.selectedSlot.value.contains(i)
                                  ? Colors.white60
                                  : Colors.transparent,
                              border: Border.all(color: Colors.white60),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5.0)),
                            ),
                            padding: EdgeInsets.all(3),
                            child: Center(
                              child: Text(
                                i.start_time,
                                style: TextStyle(
                                    color: controller.selectedSlot.value
                                            .contains(i)
                                        ? Colors.black45
                                        : Colors.white60),
                              ),
                            ),
                          ),
                        ));
                  }).toList())),
          _nextBtn2(btnText: 'Next')
        ],
      ),
    );
  }

  _nextBtn2({String btnText}) {
    return GestureDetector(
      onTap: () async {
        print(controller.selectedSlot.value.length);
        if (controller.selectedSlot.value.isEmpty) {
          Get.snackbar('', 'Please Select a Slot');
        } else {
          Get.back();

          var defaultServices = DefaultServices();

          APIResponse responSe = await defaultServices.getPaymentList();
          if (responSe != null) {
            if (responSe.status == '1') {
              Iterable iterable1 = responSe.list;
              paymentList =
                  iterable1.map((list) => PaymentModel.fromMap(list)).toList();
            } else {
              Get.snackbar('', responSe.message);
            }
          } else {
            print('API response is null');
            Get.snackbar('', 'Oops! Server is Down');
          }

          showModalBottomSheet(
              context: context,
              isDismissible: false,
              enableDrag: false,
              builder: (context) {
                return getPhoneAndPayment();
              });
        }
      },
      child: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: <Color>[
                Color(0xFF69C4F0),
                Color(0xFF00B2EE),
              ],
            ),
            borderRadius: BorderRadius.all(Radius.circular(5.0)),
            border: Border.all(color: Colors.white60)),
        alignment: Alignment.center,
        padding: EdgeInsets.symmetric(vertical: 10),
        child: Text(
          btnText,
          style: TextStyle(color: Colors.white, fontSize: 18),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  getPhoneAndPayment() {
    double h = 7;
    TextStyle s = TextStyle(fontSize: 12);
    return Container(
      padding: EdgeInsets.all(10),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Align(
                alignment: Alignment.centerRight,
                child: Container(
                    padding: EdgeInsets.only(right: 10, top: 10),
                    child: GestureDetector(
                      onTap: () {
                        Get.back();
                        setState(() {
                          processing = false;
                        });
                      },
                      child: Text('Cancel',
                          style: TextStyle(
                              fontSize: 12, color: AppColors.primaryColor)),
                    ))),
            Text('Payment Method', style: s),
            DropdownButtonFormField<PaymentModel>(
              // hint: Text("Select City"),
              isExpanded: true,
              value: selectedPayment,
              // decoration: const InputDecoration(
              //   border: OutlineInputBorder(),
              //   labelText: 'City',
              // ),
              onChanged: paymentList.isNotEmpty
                  ? (value) {
                      // setState(() {
                      selectedPayment = value;
                      // });
                    }
                  : null,
              items: paymentList.map((PaymentModel payment) {
                return DropdownMenuItem<PaymentModel>(
                  value: payment,
                  child: Text(payment.name, style: s),
                );
              }).toList(),
            ),
            SizedBox(
              height: h,
            ),
            Text('Phone', style: s),
            Form(key: _key, child: buildPhoneTextField()),
            SizedBox(
              height: 140,
            ),
            bookApnt()
          ],
        ),
      ),
    );
  }

  Widget buildPhoneTextField() {
    return TextFormField(
      controller: _phoneController,
      maxLength: 10,
      keyboardType: TextInputType.number,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: (value) {
        if (value.length == 10)
          return null;
        else
          return 'Enter valid phone number';
      },
      style: TextStyle(fontSize: 12),
      decoration: InputDecoration(
        // border: OutlineInputBorder(
        //     borderSide: BorderSide(color: Colors.grey, width: 1.0),
        //     borderRadius: BorderRadius.circular(5)),
        // labelText: 'Phone',
        hintText: '343XXXXXXX',
      ),
    );
  }

  bookApnt() {
    return GestureDetector(
      onTap: (){
        if (_key.currentState.validate()) {
          if (selectedPayment == null) {
            Get.snackbar('', 'Please Select Paymnent Method');
          } else {
            Get.back();
            confirmBookAppointment();
          }
        }
      },
      child: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: <Color>[
                Color(0xFF69C4F0),
                Color(0xFF00B2EE),
              ],
            ),
            borderRadius: BorderRadius.all(Radius.circular(5.0)),
            border: Border.all(color: Colors.white60)),
        alignment: Alignment.center,
        padding: EdgeInsets.symmetric(vertical: 10),
        child: Text(
          'Confirm Appointment',
          style: TextStyle(color: Colors.white, fontSize: 18),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  Future<void> confirmBookAppointment() async {
    var doctorServices = DoctorServices();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString(SharedPreVariables.TOKEN);

    APIResponse response = await doctorServices.bookAppointment(
        token: token,
        visit_type: selectedAppointment.id,
        consultation_type: selectedConsultation.id,
        booking_date:
        formatDate(selectedDate, [yyyy, '-', mm, '-', d]).toString(),
        doctor_id: widget.id,
    booking_time: controller.selectedSlot.value.first.start_time,
    payment_method: selectedPayment.id,
    phone: '+92' + _phoneController.text);
    if (response != null) {
      if (response.status == '1') {
        logger.i(response.message);
        print('response.data');

        Get.snackbar('', response.message);

      } else {
        Get.snackbar('', response.message);
      }
    } else {
      print('API response is null');
      Get.snackbar('', 'Oops! Server is Down');
    }
  }
}
