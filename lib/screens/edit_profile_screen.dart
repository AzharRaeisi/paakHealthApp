import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:paakhealth/models/api_response.dart';
import 'package:paakhealth/models/gender_model.dart';
import 'package:paakhealth/services/account_services.dart';
import 'package:paakhealth/services/default_services.dart';
import 'package:paakhealth/util/colors.dart';
import 'package:paakhealth/util/prefernces.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EditProfileScreen extends StatefulWidget {
  // final String customer_image;
  // const EditProfileScreen({Key key, @required this.customer_image}) : super(key: key);
  const EditProfileScreen({Key key}) : super(key: key);

  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  File _image;

  GlobalKey<FormState> _key = GlobalKey<FormState>();
  TextEditingController _userNameController = new TextEditingController();

  // TextEditingController _addressController = new TextEditingController();

  TextEditingController _emailController = new TextEditingController();

  TextEditingController _genderController = new TextEditingController();
  TextEditingController _phoneController = new TextEditingController();

  String imageUrl;

  // GenderModel selectedGender;
  // List<GenderModel> genderList = [
  //   GenderModel(id: 1, name: 'Male'),
  //   GenderModel(id: 2, name: 'Female'),
  // ];

  bool loading = true;

  @override
  void initState() {
    super.initState();
    getProfile();
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
          'My Profile',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 2,
        backgroundColor: Colors.white,
      ),
      body: Container(
          padding: EdgeInsets.all(10),
          child: loading
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : SingleChildScrollView(
                  child: Form(
                      key: _key,
                      child: Column(
                        children: [
                          GestureDetector(
                            onTap: () {
                              showModalBottomSheet(
                                context: context,
                                builder: ((builder) => bottomSheet()),
                              );
                            },
                            child: CircleAvatar(
                                radius:
                                    MediaQuery.of(context).size.width / 3.3 + 2,
                                backgroundColor: AppColors.primaryColor,
                                child: CircleAvatar(
                                  radius:
                                      MediaQuery.of(context).size.width / 3.3,
                                  backgroundImage: imageUrl == null
                                      ? AssetImage('assets/avatar.png')
                                      : _image == null
                                          ? NetworkImage(
                                              imageUrl,
                                            )
                                          : FileImage(_image),
                                )),
                          ),
                          SizedBox(height: 25),
                          buildNameTextField(),
                          SizedBox(height: 14),
                          buildGenderTextField(),
                          // DropdownButtonFormField<GenderModel>(
                          //   // hint: Text("Select City"),
                          //   isExpanded: true,
                          //   value: selectedGender,
                          //   decoration: const InputDecoration(
                          //     border: OutlineInputBorder(),
                          //     labelText: 'Gender',
                          //   ),
                          //   onChanged: genderList.isNotEmpty
                          //       ? (value) {
                          //           // setState(() {
                          //           selectedGender = value;
                          //           // });
                          //         }
                          //       : null,
                          //   items: genderList.map((GenderModel gender) {
                          //     return DropdownMenuItem<GenderModel>(
                          //       value: gender,
                          //       child: Text(
                          //         gender.name,
                          //       ),
                          //     );
                          //   }).toList(),
                          // ),
                          SizedBox(height: 14),
                          buildEmailTextField(),
                          SizedBox(height: 14),
                          buildPhoneTextField(),
                          SizedBox(height: 25),
                          // buildAddressTextField(),
                          _primaryBtn(btnText: 'Update Profile')
                        ],
                      )))),
    );
  }

  TextFormField buildNameTextField() {
    return TextFormField(
      controller: _userNameController,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: (value) {
        if (value.length > 2)
          return null;
        else
          return 'Username must be at least of 3 characters';
      },
      decoration: InputDecoration(
        border: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey[100], width: 1.0),
            borderRadius: BorderRadius.circular(5)),
        hintText: 'Name',
        labelText: 'Name',
      ),
    );
  }

  TextFormField buildEmailTextField() {
    return TextFormField(
      controller: _emailController,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: (value) {
        if (RegExp(
                r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
            .hasMatch(value))
          return null;
        else {
          return 'Enter valid email.';
        }
      },
      decoration: InputDecoration(
        border: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey[100], width: 1.0),
            borderRadius: BorderRadius.circular(5)),
        labelText: 'Email',
        hintText: 'info@paakhealth.com',
      ),
    );
  }

  TextFormField buildPhoneTextField() {
    return TextFormField(
      controller: _phoneController,
      keyboardType: TextInputType.number,
      enabled: false,
      decoration: InputDecoration(
        border: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey, width: 1.0),
            borderRadius: BorderRadius.circular(5)),
        hintText: '343XXXXXXX',
        labelText: 'Phone',
      ),
    );
  }

  // TextFormField buildAddressTextField() {
  //   return TextFormField(
  //     controller: _addressController,
  //     autovalidateMode: AutovalidateMode.onUserInteraction,
  //     maxLines: 3,
  //     validator: (value) {
  //       if (value.isNotEmpty)
  //         return null;
  //       else
  //         return 'Enter your address';
  //     },
  //     decoration: InputDecoration(
  //         border: OutlineInputBorder(
  //             borderSide: BorderSide(color: Colors.grey[100], width: 1.0),
  //             borderRadius: BorderRadius.circular(5)),
  //         labelText: 'Address',
  //         hintText: 'Address'),
  //   );
  // }

  Widget bottomSheet() {
    return Container(
      height: 100,
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Choose Profile Photo'),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextButton.icon(
                  onPressed: () {
                    Navigator.pop(context);
                    getImage(ImageSource.camera);
                  },
                  icon: Icon(Icons.camera),
                  label: Text('Camera')),
              TextButton.icon(
                  onPressed: () {
                    Navigator.pop(context);
                    getImage(ImageSource.gallery);
                  },
                  icon: Icon(Icons.image),
                  label: Text('Gallery')),
            ],
          ),
        ],
      ),
    );
  }

  void getImage(ImageSource source) async {
    final pickedFile = await ImagePicker().getImage(source: source);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
        uploadImage();
      } else {
        print('No image selected.');
      }
    });
  }

  Future<void> uploadImage() async {
    var defaultServices = DefaultServices();
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String token = sharedPreferences.getString(SharedPreVariables.TOKEN);
    APIResponse response =
        await defaultServices.uploadImage(token: token, filename: _image.path);

    if (response != null) {
      if (response.status == '1') {
        Get.snackbar('', response.message);
        imageUrl = response.url;
        updateProfile();
        print(imageUrl);
      } else {
        Get.snackbar('', response.message);
      }
    } else {
      print('API response is null');
      Get.snackbar('', 'Oops! Server is Down');
    }
  }

  Widget _primaryBtn({String btnText}) {
    return GestureDetector(
      onTap: () async {
        if (_key.currentState.validate()) {
          updateProfile();
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

  Future<void> updateProfile() async {
    var accountServices = AccountServices();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString(SharedPreVariables.TOKEN);

    print(token);
    APIResponse response = await accountServices.saveProfile(
      token: token,
      name: _userNameController.text,
      email: _emailController.text,
      gender: _genderController.text,
      profile_image: imageUrl,
    );
    if (response != null) {
      if (response.status == '1') {
        Get.snackbar('', response.message);

        await prefs.setString(
            SharedPreVariables.CUSTOMER_NAME, _userNameController.text);
        await prefs.setString(SharedPreVariables.CUSTOMER_IMAGE, '');
        print(prefs.getString(SharedPreVariables.CUSTOMER_NAME));
        print(prefs.getString(SharedPreVariables.CUSTOMER_IMAGE));
        setState(() {});
      } else {
        Get.snackbar('', response.message);
      }
    } else {
      print('API response is null');
      Get.snackbar('', 'Oops! Server is Down');
    }
  }

  Future<void> getProfile() async {
    var accountServices = AccountServices();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString(SharedPreVariables.TOKEN);

    print(token);
    APIResponse response = await accountServices.getProfile(token);
    if (response != null) {
      if (response.status == '1') {
        Get.snackbar('', response.message);

        Map<String, dynamic> map = response.data;
        _userNameController.text = map['name'];
        _emailController.text = map['email'];
        _phoneController.text = map['phone'];
        _genderController.text = map['gender'];
        imageUrl = map['profile_image'];

        await prefs.setString(SharedPreVariables.CUSTOMER_IMAGE, imageUrl);
        // if(map['gender'] == "male" || map['gender'] == "Male"){
        //   selectedGender =
        //       GenderModel(id: 1, name: 'Male');
        // }else{
        //   selectedGender =
        //       GenderModel(id: 2, name: 'Female');
        // }
        setState(() {
          loading = false;
        });
      } else {
        Get.snackbar('', response.message);
      }
    } else {
      print('API response is null');
      Get.snackbar('', 'Oops! Server is Down');
    }
  }

  TextFormField buildGenderTextField() {
    return TextFormField(
      controller: _genderController,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: (value) {
        if (value.length > 3)
          return null;
        else
          return 'Enter correct gender';
      },
      decoration: InputDecoration(
        border: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey[100], width: 1.0),
            borderRadius: BorderRadius.circular(5)),
        hintText: 'male',
        labelText: 'Gender',
      ),
    );
  }
}
