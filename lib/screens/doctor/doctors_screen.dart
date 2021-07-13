import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:paakhealth/controllers/search_doctor_controler.dart';
import 'package:paakhealth/models/api_response.dart';
import 'package:paakhealth/models/city_model.dart';
import 'package:paakhealth/models/consultation_type_model.dart';
import 'package:paakhealth/models/doctor_expertise_model.dart';
import 'package:paakhealth/models/doctor_model.dart';
import 'package:paakhealth/models/gender_model.dart';
import 'package:paakhealth/services/default_services.dart';
import 'package:paakhealth/services/home_services.dart';
import 'package:paakhealth/util/colors.dart';
import 'package:paakhealth/util/font.dart';
import 'package:paakhealth/util/prefernces.dart';
import 'package:paakhealth/util/text_style.dart';
import 'package:paakhealth/widgets/doctor_card.dart';
import 'package:responsive_grid/responsive_grid.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DoctorAppointmentScreen extends StatefulWidget {
  final List<DoctorModel> doctors;

  const DoctorAppointmentScreen({Key key, @required this.doctors})
      : super(key: key);

  @override
  _DoctorAppointmentScreenState createState() =>
      _DoctorAppointmentScreenState();
}

class _DoctorAppointmentScreenState extends State<DoctorAppointmentScreen> {
  CityModel selectedCity;
  List<CityModel> cityList = [];

  ConsultationTypeModel selectConsultationType;
  List<ConsultationTypeModel> consultationList = [
    ConsultationTypeModel(id: 1, type: 'Instant Consultation'),
    ConsultationTypeModel(id: 2, type: 'Appointments Available'),
  ];

  List<DoctorExpertiseModel> expertiseList = [];
  List<DoctorExpertiseModel> selectedExpertise = [];

  GenderModel selectedGender;
  List<GenderModel> genderList = [
    GenderModel(id: 1, name: 'Male'),
    GenderModel(id: 2, name: 'Female'),
  ];

  bool loading = true;

  List<DoctorModel> searchDoctors = [];

  var logger = Logger();

  bool searching = false;
  bool searchingCompleted = false;

  SearchDoctorController controller = Get.put(SearchDoctorController());

  @override
  void initState() {
    // TODO: implement initState
    getCityList();
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
            'Doctor Appointment',
            style: AppTextStyle.appTextStyle,
          ),
          centerTitle: true,
          elevation: 2,
          backgroundColor: Colors.white,
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            showModalBottomSheet(
                context: context,
                builder: (context) {
                  return _findDoctor();
                });
          },
          child: Icon(Icons.search),
        ),
        body: Container(
          child: Column(
            children: [
              Container(
                height: 45,
                margin: EdgeInsets.only(left: 12, top: 10, right: 12),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(50.0)),
                    border: Border.all(color: Color(0xFFE8E8E2))),
                child: TextField(
                  // controller: searchBoxController,
                  // onChanged: (val) {
                  //   if (val.isEmpty) {
                  //     searchList = [];
                  //   }
                  // },
                  style: TextStyle(
                      color: AppColors.textColor, fontFamily: AppFont.Avenirl),
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.all(10),
                    hintText: 'Find a doctor...',
                    hintStyle: TextStyle(
                        color: AppColors.textColor, fontFamily: AppFont.Avenirl),
                    suffixIcon: Container(
                      margin: EdgeInsets.fromLTRB(0, 5, 5, 5),
                      padding: EdgeInsets.symmetric(horizontal: 3),
                      decoration: BoxDecoration(
                        color: Color(0xFF707070),
                        borderRadius: BorderRadius.all(
                          Radius.circular(50.0),
                        ),
                      ),
                      child: IconButton(
                        padding: EdgeInsets.zero,
                        // onPressed: _searchMedicine,
                        icon: Icon(
                          Icons.search,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    border: InputBorder.none,
                  ),
                ),
              ),
              Row(
                children: [
                  Chip(
                    labelStyle: TextStyle(
              fontFamily: AppFont.Gotham,
                  color: Color(0xFF519EC8),
                  fontSize: 10,
                  fontWeight: FontWeight.w400),
                    label: Text(
                      'Male',
                    ),
                    onDeleted: (){},
                    backgroundColor: Colors.transparent,
                    shape: StadiumBorder(side: BorderSide(color: Color(0xFF519EC8))),
                  )
                ],
              ),
              Builder(builder: (context) {
                if (searching) {
                  print('searching ');

                  if (searchingCompleted) {
                    print('searching  complete');

                    return Column(
                      children: [
                        Align(
                            alignment: Alignment.centerRight,
                            child: Container(
                                padding: EdgeInsets.only(right: 10, top: 10),
                                child: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      searching = false;
                                      searchingCompleted = false;
                                    });
                                  },
                                  child: Text('Clear search list',
                                      style: TextStyle(
                                          fontSize: 12,
                                          color: AppColors.primaryColor)),
                                ))),
                        Expanded(
                          child: ResponsiveGridList(
                              desiredItemWidth:
                                  MediaQuery.of(context).size.width / 3,
                              minSpacing: 1,
                              children: searchDoctors.map((i) {
                                return DoctorCard(doctor: i);
                              }).toList()),
                        ),
                      ],
                    );
                  } else {
                    print('searching not complete');
                    return Container();
                  }
                } else {
                  print('not searching ');

                  return Expanded(
                    child: ResponsiveGridList(
                        desiredItemWidth: MediaQuery.of(context).size.width / 3,
                        minSpacing: 1,
                        children: widget.doctors.map((i) {
                          return DoctorCard(doctor: i);
                        }).toList()),
                  );
                }
                return Container();
              }),
            ],
          ),
        ));
  }

  Widget _findDoctor() {
    double h = 7;
    TextStyle s = TextStyle(fontSize: 12);
    if (loading) {
      return Center(
        child: CircularProgressIndicator(),
      );
    } else {
      return Container(
        padding: EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Gender', style: s),
            DropdownButtonFormField<GenderModel>(
              // hint: Text("Select City"),
              isExpanded: true,
              value: selectedGender,
              // decoration: const InputDecoration(
              //   border: OutlineInputBorder(),
              //   labelText: 'City',
              // ),
              onChanged: genderList.isNotEmpty
                  ? (value) {
                      // setState(() {
                      selectedGender = value;
                      // });
                    }
                  : null,
              items: genderList.map((GenderModel gender) {
                return DropdownMenuItem<GenderModel>(
                  value: gender,
                  child: Text(gender.name, style: s),
                );
              }).toList(),
            ),
            SizedBox(
              height: h,
            ),
            Text('City', style: s),
            DropdownButtonFormField<CityModel>(
              // hint: Text("Select City"),
              isExpanded: true,
              value: selectedCity,
              // decoration: const InputDecoration(
              //   border: OutlineInputBorder(),
              //   labelText: 'City',
              // ),
              onChanged: cityList.isNotEmpty
                  ? (value) {
                      // setState(() {
                      selectedCity = value;
                      // });
                    }
                  : null,
              items: cityList.map((CityModel city) {
                return DropdownMenuItem<CityModel>(
                  value: city,
                  child: Text(city.name, style: s),
                );
              }).toList(),
            ),
            SizedBox(
              height: h,
            ),
            Text('Consultation Type', style: s),
            DropdownButtonFormField<ConsultationTypeModel>(
              // hint: Text("Select City"),
              isExpanded: true,
              value: selectConsultationType,
              // decoration: const InputDecoration(
              //   border: OutlineInputBorder(),
              //   labelText: 'Consultation Type',
              // ),
              onChanged: consultationList.isNotEmpty
                  ? (value) {
                      // setState(() {
                      selectConsultationType = value;
                      // });
                    }
                  : null,
              items: consultationList.map((ConsultationTypeModel type) {
                return DropdownMenuItem<ConsultationTypeModel>(
                  value: type,
                  child: Text(type.type, style: s),
                );
              }).toList(),
            ),
            SizedBox(
              height: h,
            ),
            Text('Speciality', style: s),
            Expanded(
              child: ResponsiveGridList(
                  desiredItemWidth: MediaQuery.of(context).size.width / 3,
                  minSpacing: 1,
                  children: expertiseList.map((i) {
                    return Obx(() => CheckboxListTile(
                          title: Text(
                            i.name,
                            style: s,
                          ),
                          value: controller.selectedExpertise.value.contains(i)
                              ? true
                              : false,
                          onChanged: (val) {
                            print('===================================');
                            print(val);
                            if (val) {
                              // selectedExpertise.add(i);
                              controller.addToExpertList(i);
                              print('if');
                            } else {
                              print('else');
                              controller.removeFromExpertList(i);
                              // selectedExpertise.remove(i);
                            }
                            print('===================================');

                            setState(() {});
                          },
                          contentPadding: EdgeInsets.zero,
                          controlAffinity: ListTileControlAffinity.leading,
                          selectedTileColor: AppColors.primaryColor,
                        ));
                  }).toList()),
            ),
            SizedBox(
              height: h,
            ),
            _primaryBtn(btnText: 'Find')
          ],
        ),
      );
    }
  }

  Widget _primaryBtn({String btnText}) {
    return GestureDetector(
      onTap: () async {
        if (selectedGender == null ||
            selectedCity == null ||
            selectConsultationType == null) {
          Get.snackbar('', 'Please Select Gender, City and Consultation Type');
        } else {
          placeOrderPrescribtion();
        }
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

  getCityList() async {
    var defaultServices = DefaultServices();

    APIResponse response = await defaultServices.getCityList();
    if (response != null) {
      if (response.status == '1') {
        Iterable iterable1 = response.list;
        cityList = iterable1.map((list) => CityModel.fromMap(list)).toList();
      } else {
        Get.snackbar('', response.message);
      }
    } else {
      print('API response is null');
      Get.snackbar('', 'Oops! Server is Down');
    }

    response = await defaultServices.getExpertiseList();
    if (response != null) {
      if (response.status == '1') {
        Iterable iterable1 = response.list;
        expertiseList = iterable1
            .map((list) => DoctorExpertiseModel.fromMap(list))
            .toList();
      } else {
        Get.snackbar('', response.message);
      }
    } else {
      print('API response is null');
      Get.snackbar('', 'Oops! Server is Down');
    }
    loading = false;
    setState(() {});
  }

  Future<void> placeOrderPrescribtion() async {
    Navigator.pop(context);

    print('searching');
    print(searching);
    print('searchingCompleted');
    print(searchingCompleted);

    setState(() {
      searching = true;
      searchingCompleted = false;
    });

    print('searching');
    print(searching);
    print('searchingCompleted');
    print(searchingCompleted);

    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    var homeServices = HomeServices();
    // todo change device token
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString(SharedPreVariables.TOKEN);

    print(token);
    print(position.latitude.toString());
    print(position.longitude.toString());

    List<int> speciality = [];
    selectedExpertise.map((e) => speciality.add(e.id));

    APIResponse response = await homeServices.doctorSearch(
        token: token,
        name: '',
        gender: selectedGender.name,
        speciality: speciality,
        city: selectedCity.id,
        type: selectConsultationType.id,
        latitude: position.latitude.toString(),
        longitude: position.longitude.toString());
    if (response != null) {
      if (response.status == '1') {
        // Get.snackbar('', response.message);
        print('response.data');
        print(response);
        print(response.list);
        print(response.list.length);

        Iterable doctorIterable = response.list;
        searchDoctors =
            doctorIterable.map((list) => DoctorModel.fromMap(list)).toList();

        // print(searchList.length);
      } else {
        Get.snackbar('', response.message);
      }
    } else {
      print('API response is null');
      Get.snackbar('', 'Oops! Server is Down');
    }
    // if (mounted) {
    setState(() {
      searchingCompleted = true;
    });
    // }

    // put it at the end of funciton
    selectedGender = null;
    selectConsultationType = null;
    selectedCity = null;
    controller.removeAllExpertise();
  }
}
