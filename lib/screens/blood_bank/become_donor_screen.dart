import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:paakhealth/models/api_response.dart';
import 'package:paakhealth/models/blood_group_model.dart';
import 'package:paakhealth/models/city_model.dart';
import 'package:paakhealth/services/bloodbank_services.dart';
import 'package:paakhealth/services/default_services.dart';
import 'package:paakhealth/util/colors.dart';
import 'package:paakhealth/util/prefernces.dart';
import 'package:paakhealth/util/text_style.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BecomeDonorScreen extends StatefulWidget {
  const BecomeDonorScreen({Key key}) : super(key: key);

  @override
  _BecomeDonorScreenState createState() => _BecomeDonorScreenState();
}

class _BecomeDonorScreenState extends State<BecomeDonorScreen> {

  bool loading = true;


  GlobalKey<FormState> _key = GlobalKey<FormState>();

  TextEditingController _nameController = new TextEditingController();
  // TextEditingController _emailController = new TextEditingController();
  TextEditingController _addressController = new TextEditingController();
  TextEditingController _phoneController = new TextEditingController();
  TextEditingController _comentController = new TextEditingController();


  CityModel selectedCity;
  List<CityModel> cityList = [];
  BloodGroupModel selectedGroup;
  List<BloodGroupModel> bloodGroupList = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    getCityAndBloodGroup();

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
          'Become a Donor',
          style: AppTextStyle.appTextStyle,
        ),
        centerTitle: true,
        elevation: 2,
        backgroundColor: Colors.white,
      ),
      body: Container(
        padding: EdgeInsets.all(10),
        child: SingleChildScrollView(
          child: Form(
            key: _key,
            child: Column(
              children: [

                SizedBox(height: 15),
                buildNameTextField(),
                SizedBox(height: 14),
                buildAddressTextField(),
                // SizedBox(height: 14),
                // buildEmailTextField(),
                SizedBox(height: 14),
                buildPhoneTextField(),
                SizedBox(height: 14),
                DropdownButtonFormField<CityModel>(
                  isExpanded: true,
                  value: selectedCity,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'City',
                  ),
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
                      child: Text(city.name, style: TextStyle(fontSize: 12)),
                    );
                  }).toList(),
                ),
                SizedBox(height: 14),
                DropdownButtonFormField<BloodGroupModel>(
                  // hint: Text("Select City"),
                  isExpanded: true,
                  value: selectedGroup,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Blood Group',
                  ),
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
                      child: Text(group.name, style: TextStyle(fontSize: 12)),
                    );
                  }).toList(),
                ),
                SizedBox(height: 14),
                buildComentTextField(),

                SizedBox(height: 25),

                primaryBtn(btnText: 'Save')

              ],
            ),
          ),
        ),
      ),
    );
  }


  TextFormField buildNameTextField() {
    return TextFormField(
      controller: _nameController,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: (value) {
        if (value.length > 2)
          return null;
        else
          return 'Name must be at least of 3 characters';
      },
      decoration: InputDecoration(
          border: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey[100], width: 1.0),
              borderRadius: BorderRadius.circular(5)),
          labelText: 'Name', hintText: 'Name'),
    );
  }

  // TextFormField buildEmailTextField() {
  //   return TextFormField(
  //     controller: _emailController,
  //     autovalidateMode: AutovalidateMode.onUserInteraction,
  //     validator: (value) {
  //       if (RegExp(
  //           r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
  //           .hasMatch(value))
  //         return null;
  //       else {
  //         return 'Enter valid email.';
  //       }
  //     },
  //     decoration: InputDecoration(
  //         border: OutlineInputBorder(
  //             borderSide: BorderSide(color: Colors.grey[100], width: 1.0),
  //             borderRadius: BorderRadius.circular(5)),
  //         hintText: 'info@paakhealth.com',
  //     labelText: 'Email'),
  //   );
  // }

  TextFormField buildAddressTextField() {
    return TextFormField(
      controller: _addressController,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      maxLines: 3,
      validator: (value) {
        if (value.isNotEmpty)
          return null;
        else
          return 'Enter your address';
      },
      decoration: InputDecoration(
          border: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey[100], width: 1.0),
              borderRadius: BorderRadius.circular(5)),
          labelText: 'Address',
          hintText: 'Address'),
    );
  }

  TextFormField buildPhoneTextField() {
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
      decoration: InputDecoration(
          border: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey, width: 1.0),
              borderRadius: BorderRadius.circular(5)),
          hintText: '343XXXXXXX',
        labelText: 'Phone',),
    );
  }

  TextFormField buildComentTextField() {
    return TextFormField(
      controller: _comentController,
      maxLines: 5,
      decoration: InputDecoration(
          border: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey[100], width: 1.0),
              borderRadius: BorderRadius.circular(5)),
          hintText: 'Comment if any ...',labelText: 'Comment',),
    );
  }


  Future<void> getCityAndBloodGroup() async {
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

    response = await defaultServices.getBloodGroupList();
    if (response != null) {
      if (response.status == '1') {
        Iterable iterable1 = response.list;
        bloodGroupList = iterable1
            .map((list) => BloodGroupModel.fromMap(list))
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

  primaryBtn({String btnText}) {
    return GestureDetector(
      onTap: () async {
        if (_key.currentState.validate()) {
          if (selectedGroup == null ||selectedCity == null) {
            Get.snackbar('', 'Please Select City and Blood Group');
          } else {
            becomeDonor();
          }
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

  Future<void> becomeDonor() async {

    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    var bloodBankServices = BloodBankServices();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString(SharedPreVariables.TOKEN);

    APIResponse response = await bloodBankServices.donateBlood(
        token: token,
        name: _nameController.text,
        address: _addressController.text,
        phone: _phoneController.text,
        comments: _comentController.text,
        latitude: position.latitude.toString(),
        longitude: position.longitude.toString(),
        city: selectedCity.id,
        blood_group: selectedGroup.name
    );
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
  }

}
