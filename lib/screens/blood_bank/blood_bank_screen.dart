import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:paakhealth/models/api_response.dart';
import 'package:paakhealth/models/blood_group_model.dart';
import 'package:paakhealth/models/blood_station_model.dart';
import 'package:paakhealth/models/city_model.dart';
import 'package:paakhealth/models/donar_model.dart';
import 'package:paakhealth/screens/blood_bank/become_donor_screen.dart';
import 'package:paakhealth/screens/blood_bank/blood_bank_detail_screen.dart';
import 'package:paakhealth/screens/blood_bank/blood_station_detail_screen.dart';
import 'package:paakhealth/services/bloodbank_services.dart';
import 'package:paakhealth/services/default_services.dart';
import 'package:paakhealth/util/colors.dart';
import 'package:paakhealth/util/font.dart';
import 'package:paakhealth/util/prefernces.dart';
import 'package:paakhealth/util/text_style.dart';
import 'package:paakhealth/widgets/blood_bnak/donor_item.dart';
import 'package:paakhealth/widgets/primaryButton.dart';
import 'package:paakhealth/widgets/toast/toast.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BloodBankScreen extends StatefulWidget {
  const BloodBankScreen({Key key}) : super(key: key);

  @override
  _BloodBankScreenState createState() => _BloodBankScreenState();
}

class _BloodBankScreenState extends State<BloodBankScreen> {
  List<BloodStationModel> bloodStations = [];

  List<DonarModel> donarList = [];

  bool loading = true;

  var logger = Logger();

  CityModel selectedCity;
  List<CityModel> cityList = [];

  BloodGroupModel selectedGroup;
  List<BloodGroupModel> bloodGroupList = [];

  bool searching = false;
  bool searchingCompleted = false;

  List<BloodStationModel> searchStations = [];

  List<DonarModel> searchDonarList = [];

  @override
  void initState() {
    // TODO: implement initState

    getData();
    getCityAndBloodGroup();
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
          'Blood Bank',
          style: AppTextStyle.appbarTextStyle,
        ),
        centerTitle: true,
        elevation: 2,
        backgroundColor: Colors.white,
        actions: [
          IconButton(
              onPressed: () {
                showModalBottomSheet(
                    context: context,
                    builder: (context) {
                      return findBloodBank();
                    });
              },
              icon: Icon(Icons.search))
        ],
      ),
      body: Container(
        padding: EdgeInsets.all(10),
        child: Builder(builder: (context) {
          if (searching) {
            print('searching ');

            if (searchingCompleted) {
              print('searching  complete');

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Align(
                      alignment: Alignment.centerRight,
                      child: Container(
                          padding: EdgeInsets.only(bottom: 10),
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
                                    fontFamily: AppFont.Avenirl,
                                    fontWeight: FontWeight.w400,
                                    color: AppColors.primaryColor)),
                          ))),
                  Text('Nearby stations',
                      style: TextStyle(
                        color: AppColors.primaryColor,
                        fontFamily: AppFont.Gotham,
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                      )),
                  SizedBox(
                    height: 7,
                  ),
                  nearbyStations(stations: searchStations),

                  SizedBox(
                    height: 20.0,
                  ),
                  // Align(
                  //     alignment: Alignment.centerRight,
                  //     child: Container(
                  //         padding: EdgeInsets.only(right: 10, top: 10),
                  //         child: GestureDetector(
                  //           onTap: () {
                  //             // Get.to(() => OnlinePharmacyScreen(
                  //             //   stores: stores,
                  //             // ));
                  //           },
                  //           child: Text('See More...',
                  //               style: TextStyle(
                  //                 fontSize: 12,
                  //               )),
                  //         ))),
                  Text('Nearby Donors',
                      style: TextStyle(
                        fontFamily: AppFont.Gotham,
                        fontWeight: FontWeight.w500,
                        color: AppColors.primaryColor,
                        fontSize: 14,
                      )),

                  SizedBox(
                    height: 10.0,
                  ),
                  Expanded(
                    child: ListView.builder(
                      shrinkWrap: true,
                      scrollDirection: Axis.vertical,
                      physics: BouncingScrollPhysics(),
                      itemCount: searchDonarList.length,
                      itemBuilder: (BuildContext context, int index) =>
                          buildBloodDonorItem(searchDonarList[index]),
                    ),
                  ),
                  // Align(
                  //     alignment: Alignment.centerRight,
                  //     child: Container(
                  //         padding: EdgeInsets.only(right: 10, top: 10),
                  //         child: GestureDetector(
                  //           onTap: () {
                  //             // Get.to(() => OnlinePharmacyScreen(
                  //             //   stores: stores,
                  //             // ));
                  //           },
                  //           child: Text('See More...',
                  //               style: TextStyle(
                  //                 fontSize: 12,
                  //               )),
                  //         ))),
                ],
              );
            } else {
              print('searching not complete');
              return Container();
            }
          } else {
            print('not searching ');

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Nearby stations',
                    style: TextStyle(
                      fontFamily: AppFont.Gotham,
                      fontWeight: FontWeight.w500,
                      color: AppColors.primaryColor,
                      fontSize: 14,
                    )),
                SizedBox(
                  height: 7,
                ),
                nearbyStations(stations: bloodStations),

                SizedBox(
                  height: 20.0,
                ),
                // Align(
                //     alignment: Alignment.centerRight,
                //     child: Container(
                //         padding: EdgeInsets.only(right: 10, top: 10),
                //         child: GestureDetector(
                //           onTap: () {
                //             // Get.to(() => OnlinePharmacyScreen(
                //             //   stores: stores,
                //             // ));
                //           },
                //           child: Text('See More...',
                //               style: TextStyle(
                //                 fontSize: 12,
                //               )),
                //         ))),
                Text('Nearby Donors',
                    style: TextStyle(
                      color: AppColors.primaryColor,
                      fontFamily: AppFont.Gotham,
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                    )),

                SizedBox(
                  height: 10.0,
                ),
                Expanded(
                  child: ListView.builder(
                      shrinkWrap: true,
                      scrollDirection: Axis.vertical,
                      physics: BouncingScrollPhysics(),
                      itemCount: donarList.length,
                      itemBuilder: (BuildContext context, int index) =>
                          buildBloodDonorItem(donarList[index])),
                ),
                // Align(
                //     alignment: Alignment.centerRight,
                //     child: Container(
                //         padding: EdgeInsets.only(right: 10, top: 10),
                //         child: GestureDetector(
                //           onTap: () {
                //             // Get.to(() => OnlinePharmacyScreen(
                //             //   stores: stores,
                //             // ));
                //           },
                //           child: Text('See More...',
                //               style: TextStyle(
                //                 fontSize: 12,
                //               )),
                //         ))),
                becomeDonor(btnText: 'Become a Donor')
              ],
            );
          }
          return Container();
        }),
      ),

      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {
      //     showModalBottomSheet(
      //         context: context,
      //         builder: (context) {
      //           return findBloodBank();
      //         });
      //   },
      //   child: Icon(Icons.search),
      // ),
    );
  }

  Widget buildBloodDonorItem(DonarModel model) {
    return DonorItem(model: model);
  }

  Widget nearbyStations({List<BloodStationModel> stations}) {
    return Row(
      children: [
        Expanded(
          child: SizedBox(
            height: 100,
            child: ListView.builder(
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                physics: BouncingScrollPhysics(),
                itemCount: stations.length,
                itemBuilder: (BuildContext context, int index) =>
                    GestureDetector(
                      onTap: () {
                        // Get.to(
                        //         () => BloodStationDetailScreen(model: stations[index],));
                        pushNewScreen(
                          context,
                          screen: BloodStationDetailScreen(
                            model: stations[index],
                          ),
                          withNavBar: true, // OPTIONAL VALUE. True by default.
                          pageTransitionAnimation:
                              PageTransitionAnimation.cupertino,
                        );
                      },
                      child: Container(
                        margin: EdgeInsets.symmetric(horizontal: 5),
                        padding:
                            EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                        width: 100.0,
                        height: 100.0,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                                color: AppColors.primaryColor, width: 2)),
                        child: FadeInImage(
                          image: NetworkImage(stations[index].profile_image),
                          placeholder: AssetImage('assets/avatar.png'),
                        ),
                      ),
                    )),
          ),
        ),
        SizedBox(
          width: 5,
        ),
        // GestureDetector(
        //   // onTap: () {
        //   //   Get.to(() => OnlinePharmacyScreen(
        //   //     stores: stores,
        //   //   ));
        //   // },
        //   child: Icon(Icons.arrow_forward_ios),
        // ),
        SizedBox(
          width: 5,
        ),
      ],
    );
  }

  Future<void> getData() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    var bloodBankServices = BloodBankServices();
    // todo change device token
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString(SharedPreVariables.TOKEN);
    print(token);
    print(position.latitude.toString());
    print(position.longitude.toString());
    APIResponse response = await bloodBankServices.nearbyBloodStation(
        token: token,
        lat: position.latitude.toString(),
        long: position.longitude.toString());
    if (response != null) {
      if (response.status == '1') {
        // ShowMessage.message(message: response.message);
        // print("response.data['result']");
        // print(response.data['store']);
        // print(response.data['medicine']);
        // print(response.data['doctors']);
        Iterable bannersIterable = response.data['blood_station'];
        bloodStations = bannersIterable
            .map((list) => BloodStationModel.fromMap(list))
            .toList();

        Iterable storeIterable = response.data['blood_bank'];
        donarList =
            storeIterable.map((list) => DonarModel.fromMap(list)).toList();
        //
        // Iterable medicineIterable = response.data['medicine'];
        // medicines = medicineIterable
        //     .map((list) => MedicineModel.fromMap(list))
        //     .toList();
        //
        // Iterable doctorIterable = response.data['doctors'];
        // doctors =
        //     doctorIterable.map((list) => DoctorModel.fromMap(list)).toList();

        setState(() {});
      } else {
        ShowMessage.message(message: response.message);
      }
    } else {
      print('API response is null');
      ShowMessage.message(message: 'Oops! Server is Down');
    }
  }

  Widget findBloodBank() {
    double h = 7;
    TextStyle s = TextStyle(fontSize: 12);
    if (loading) {
      return Center(
        child: CircularProgressIndicator(),
      );
    } else {
      return Container(
        padding: EdgeInsets.all(10),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('City', style: s),
              DropdownButtonFormField<CityModel>(
                isExpanded: true,
                value: selectedCity,
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
              Text('Blood Group', style: s),
              DropdownButtonFormField<BloodGroupModel>(
                // hint: Text("Select City"),
                isExpanded: true,
                value: selectedGroup,
                // decoration: const InputDecoration(
                //   border: OutlineInputBorder(),
                //   labelText: 'Consultation Type',
                // ),
                onChanged: bloodGroupList.isNotEmpty
                    ? (value) {
                        // setState(() {
                        selectedGroup = value;
                        // });
                      }
                    : null,
                items: bloodGroupList.map((BloodGroupModel group) {
                  return DropdownMenuItem<BloodGroupModel>(
                    value: group,
                    child: Text(group.name, style: s),
                  );
                }).toList(),
              ),
              SizedBox(
                height: h,
              ),
              primaryBtn(btnText: 'Find')
            ],
          ),
        ),
      );
    }
  }

  Future<void> getCityAndBloodGroup() async {
    var defaultServices = DefaultServices();

    APIResponse response = await defaultServices.getCityList();
    if (response != null) {
      if (response.status == '1') {
        Iterable iterable1 = response.list;
        cityList = iterable1.map((list) => CityModel.fromMap(list)).toList();
      } else {
        ShowMessage.message(message: response.message);
      }
    } else {
      print('API response is null');
      ShowMessage.message(message: 'Oops! Server is Down');
    }

    response = await defaultServices.getBloodGroupList();
    if (response != null) {
      if (response.status == '1') {
        Iterable iterable1 = response.list;
        bloodGroupList =
            iterable1.map((list) => BloodGroupModel.fromMap(list)).toList();
      } else {
        ShowMessage.message(message: response.message);
      }
    } else {
      print('API response is null');
      ShowMessage.message(message: 'Oops! Server is Down');
    }
    loading = false;
    setState(() {});
  }

  primaryBtn({String btnText}) {
    return GestureDetector(
      onTap: () async {
        if (selectedGroup == null || selectedCity == null) {
          ShowMessage.message(message: 'Please Select City and Blood Group');
        } else {
          searchDonor();
        }
      },
      child: AppPrimaryButton(text: btnText,),
    );
  }

  becomeDonor({String btnText}) {
    return GestureDetector(
      onTap: () async {
        // Get.to(() => BecomeDonorScreen());
        pushNewScreen(
          context,
          screen: BecomeDonorScreen(),
          withNavBar: true, // OPTIONAL VALUE. True by default.
          pageTransitionAnimation: PageTransitionAnimation.cupertino,
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.primaryColor,
          borderRadius: BorderRadius.all(Radius.circular(5.0)),
        ),
        alignment: Alignment.center,
        padding: EdgeInsets.symmetric(vertical: 10),
        child: Text(
          btnText,
          style: TextStyle(
            fontFamily: AppFont.Gotham,
              fontWeight: FontWeight.w700,
              color: Colors.white, fontSize: 18),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  Future<void> searchDonor() async {
    Navigator.pop(context);

    setState(() {
      searching = true;
      searchingCompleted = false;
    });

    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    var bloodBankServices = BloodBankServices();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString(SharedPreVariables.TOKEN);

    APIResponse response = await bloodBankServices.nearbyBloodStation(
        token: token,
        lat: position.latitude.toString(),
        long: position.longitude.toString(),
        city: selectedCity.id,
        blood_group: selectedGroup.name);
    if (response != null) {
      if (response.status == '1') {
        Iterable bannersIterable = response.data['blood_station'];

        searchStations = bannersIterable
            .map((list) => BloodStationModel.fromMap(list))
            .toList();

        Iterable storeIterable = response.data['blood_bank'];
        searchDonarList =
            storeIterable.map((list) => DonarModel.fromMap(list)).toList();

        setState(() {});
      } else {
        ShowMessage.message(message: response.message);
      }
    } else {
      print('API response is null');
      ShowMessage.message(message: 'Oops! Server is Down');
    }

    setState(() {
      searchingCompleted = true;
    });
  }
}
