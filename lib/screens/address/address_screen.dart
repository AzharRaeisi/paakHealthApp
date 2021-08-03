import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:paakhealth/controllers/address_screen_controller.dart';
import 'package:paakhealth/models/address_model.dart';
import 'package:paakhealth/models/api_response.dart';
import 'package:paakhealth/models/city_model.dart';
import 'package:paakhealth/services/account_services.dart';
import 'package:paakhealth/services/default_services.dart';
import 'package:paakhealth/util/colors.dart';
import 'package:paakhealth/util/prefernces.dart';
import 'package:paakhealth/util/text_style.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddressScreen extends StatefulWidget {
  final AddressModel addressModel;
  final bool edit;
  final bool add;

  const AddressScreen({Key key, this.addressModel, this.edit, this.add})
      : super(key: key);

  @override
  _AddressScreenState createState() => _AddressScreenState();
}

class _AddressScreenState extends State<AddressScreen> {
  CityModel selectedCity;
  List<CityModel> cityList = [];

  // bool isProcessing = false;

  var logger = Logger();

  GlobalKey<FormState> _key = GlobalKey<FormState>();

  TextEditingController _nameController = new TextEditingController();
  TextEditingController _addressController = new TextEditingController();
  TextEditingController _addTypeController = new TextEditingController();
  TextEditingController _phoneController = new TextEditingController();

  // bool editable = false;

  AddressScreenController controller = Get.put(AddressScreenController());

  @override
  void initState() {
    // TODO: implement initState
    getCityList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    controller.updateEditable(widget.edit);
    // editable = widget.edit;
    if (widget.addressModel != null) {
      _nameController.text = widget.addressModel.name;
      _addressController.text = widget.addressModel.address;
      _addTypeController.text = widget.addressModel.type_name;
      _phoneController.text = widget.addressModel.phone;
      int index = 0;
      cityList.forEach((element) {
        if (element.id == widget.addressModel.city_id) {
          selectedCity = cityList[index];
        }
        index++;
      });
    }
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
          widget.add ? 'Add Address' : 'Address',
          style: AppTextStyle.appbarTextStyle,
        ),
        actions: [
          widget.add
              ? Container()
              : IconButton(
                  onPressed: () {
                    // editable = true;
                    // setState(() {
                    //   print('setState');
                    // });
                    controller.updateEditable(true);
                  },
                  icon: Icon(
                    Icons.edit,
                    color: AppColors.primaryColor,
                  )),
          widget.add
              ? Container()
              : IconButton(
              onPressed: () {
                deleteAddress();
              },
              icon: Icon(
                Icons.delete,
                color: AppColors.primaryColor,
              ))
        ],
        centerTitle: true,
        elevation: 2,
        backgroundColor: Colors.white,
      ),
      body: Container(
        padding: EdgeInsets.all(20),
        child: Form(
          key: _key,
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: 20),
                buildNameTextField(),
                SizedBox(height: 12),
                Obx(() => DropdownButtonFormField<CityModel>(
                      // hint: Text("Select City"),
                      isExpanded: true,
                      value: selectedCity,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'City',
                      ),
                      onChanged: controller.editable.value
                          ? (value) {
                              // setState(() {
                              selectedCity = value;
                              // });
                            }
                          : null,
                      items: cityList.map((CityModel city) {
                        return DropdownMenuItem<CityModel>(
                          value: city,
                          child: Text(city.name),
                        );
                      }).toList(),
                    )),
                SizedBox(height: 12),
                buildAddTypeTextField(),
                SizedBox(height: 12),
                buildAddressTextField(),
                SizedBox(height: 12),
                buildPhoneTextField(),
                SizedBox(
                  height: 40,
                ),
                Obx(() => controller.editable.value
                    ? Obx(() => controller.isProcessing.value
                        ? Center(child: CircularProgressIndicator())
                        : _primaryBtn(btnText: 'Save'))
                    : Container())
                // editable
                //     ? isProcessing
                //     ? Center(
                //   child: CircularProgressIndicator(),
                // )
                //     : _primaryBtn(btnText: 'Save')
                //     : Container()
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildNameTextField() {
    return Obx(() => TextFormField(
          controller: _nameController,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          enabled: controller.editable.value,
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
              labelText: 'Name',
              hintText: 'Name'),
        ));
  }

  Widget buildAddressTextField() {
    return Obx(() => TextFormField(
          controller: _addressController,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          maxLines: 3,
          enabled: controller.editable.value,
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
        ));
  }

  Widget buildAddTypeTextField() {
    return Obx(() => TextFormField(
          controller: _addTypeController,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          enabled: controller.editable.value,
          validator: (value) {
            if (value.isNotEmpty)
              return null;
            else
              return 'Username must be at least of 6 characters';
          },
          decoration: InputDecoration(
              border: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey[100], width: 1.0),
                  borderRadius: BorderRadius.circular(5)),
              labelText: 'Address Type',
              hintText: 'Address Type'),
        ));
  }

  Widget buildPhoneTextField() {
    return Obx(() => TextFormField(
          controller: _phoneController,
          maxLength: controller.editable.value ? 10 : 13,
          enabled: controller.editable.value,
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
            labelText: 'Phone',
            hintText: '343XXXXXXX',
          ),
        ));
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

    setState(() {});
  }

  Future<void> addAddress() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    logger.i(prefs.getString(SharedPreVariables.TOKEN));
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    var accountService = AccountServices();
    APIResponse response = await accountService.addAddress(
      token: prefs.getString(SharedPreVariables.TOKEN),
      name: _nameController.text,
      latitude: position.latitude.toString(),
      longitude: position.longitude.toString(),
      address: _addressController.text,
      type_name: _addTypeController.text,
      phone: '+92' + _phoneController.text,
      city: selectedCity.id,
    );
    if (response != null) {
      if (response.status == '1') {
        Get.snackbar('Address Added', 'Please go back and refresh the screen.');
        // editable = false;
        controller.updateEditable(false);
        controller.updateIsProcessing(false);
        // isProcessing = false;
      } else {
        Get.snackbar('', response.message);
      }
    } else {
      logger.i('API response is null');
      Get.snackbar('', 'Oops! Server is Down');
    }
  }

  Widget _primaryBtn({String btnText}) {
    return GestureDetector(
      onTap: () {
        if (_key.currentState.validate()) {
          if (selectedCity.id == 0) {
            Get.snackbar('', 'Please Select City');
          } else {
            // setState(() {
            // isProcessing = true;
            controller.updateIsProcessing(true);
            // });
            if (widget.add) {
              addAddress();
            } else {
              saveAddressChange();
            }
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
        padding: EdgeInsets.symmetric(vertical: 15),
        child: Text(
          btnText,
          style: TextStyle(color: Colors.white, fontSize: 18),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  Future<void> saveAddressChange() async {
    print('save address called');
    // isProcessing = false;
    controller.updateIsProcessing(false);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    logger.i(prefs.getString(SharedPreVariables.TOKEN));
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    var accountService = AccountServices();
    APIResponse response = await accountService.saveAddressChanges(
      token: prefs.getString(SharedPreVariables.TOKEN),
      address_id: widget.addressModel.id,
      name: _nameController.text,
      latitude: position.latitude.toString(),
      longitude: position.longitude.toString(),
      address: _addressController.text,
      type_name: _addTypeController.text,
      phone: '+92' + _phoneController.text,
      city: selectedCity.id,
    );
    if (response != null) {
      if (response.status == '1') {
        Get.snackbar('Address Changed', 'Please go back and refresh the screen.');
        // editable = false;
        controller.updateEditable(false);
        controller.updateIsProcessing(false);
        // isProcessing = false;
      } else {
        Get.snackbar('', response.message);
      }
    } else {
      logger.i('API response is null');
      Get.snackbar('', 'Oops! Server is Down');
    }
  }

  Future<void> deleteAddress() async {

    SharedPreferences prefs = await SharedPreferences.getInstance();
    logger.i(prefs.getString(SharedPreVariables.TOKEN));
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    var accountService = AccountServices();
    APIResponse response = await accountService.deleteAddress(
      token: prefs.getString(SharedPreVariables.TOKEN),
      address_id: widget.addressModel.id,
    );
    if (response != null) {
      if (response.status == '1') {
        Get.snackbar('Address Deleted', 'Please go back and refresh the screen.');
        // editable = false;
        controller.updateEditable(false);
        controller.updateIsProcessing(false);
        // isProcessing = false;
      } else {
        Get.snackbar('', response.message);
      }
    } else {
      logger.i('API response is null');
      Get.snackbar('', 'Oops! Server is Down');
    }
  }
}
