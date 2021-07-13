import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:paakhealth/models/api_response.dart';
import 'package:paakhealth/models/medicine_model.dart';
import 'package:paakhealth/services/cart_services.dart';
import 'package:paakhealth/services/home_services.dart';
import 'package:paakhealth/util/colors.dart';
import 'package:paakhealth/util/font.dart';
import 'package:paakhealth/util/prefernces.dart';
import 'package:paakhealth/util/text_style.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProductDetialScreen extends StatefulWidget {
  // final MedicineModel model;
  final int id;

  const ProductDetialScreen({Key key, @required this.id}) : super(key: key);

  @override
  _ProductDetialScreenState createState() => _ProductDetialScreenState();
}

class _ProductDetialScreenState extends State<ProductDetialScreen> {
  int _productQty = 1;
  MedicineModel medicineModel;

  bool loading = true;

  @override
  void initState() {
    // TODO: implement initState
    getMedicine(id: widget.id);
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
          loading ? 'Loading' : medicineModel.name,
          style: AppTextStyle.appTextStyle,
        ),
        centerTitle: true,
        elevation: 2,
        backgroundColor: Colors.white,
      ),
      body: loading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: Column(
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(
                        horizontal: MediaQuery.of(context).size.width / 6),
                    height: MediaQuery.of(context).size.width / 2,
                    child: FadeInImage(
                      image: NetworkImage(medicineModel.image),
                      placeholder: AssetImage('assets/m_ph.png'),
                      fit: BoxFit.cover,
                    ),
                  ),
                  Container(
                    color: Colors.white,
                    padding: EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'DESCRIPTION',
                          style: TextStyle(
                              fontFamily: AppFont.Gotham,
                              fontWeight: FontWeight.w700,
                              color: AppColors.headingColor),
                        ),
                        SizedBox(height: 5),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              medicineModel.weight_quantity,
                              style: TextStyle(
                                  fontFamily: AppFont.Gotham,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.headingColor,
                                  fontSize: 13),
                            ),
                            Text(
                              'GlaxoSmithKline',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey[700],
                                  fontSize: 13),
                            ),
                          ],
                        ),
                        SizedBox(height: 12),
                        Text(
                          medicineModel.description,
                          textAlign: TextAlign.justify,
                          style: TextStyle(
                              fontFamily: AppFont.Avenirl,
                              fontWeight: FontWeight.w400,
                              color: AppColors.textColor,
                              fontSize: 13),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 7,),
                  Container(
                    color: Colors.white,
                    padding: EdgeInsets.all(20),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              flex: 3,
                              child: Column(
                                children: [
                                  Text(
                                    'PRICE',
                                    style: TextStyle(
                                      fontFamily: AppFont.Gotham,
                                        fontWeight: FontWeight.w700,
                                        color: AppColors.headingColor),
                                  ),
                                  SizedBox(height: 7),
                                  Text(
                                    'Rs. ' +
                                        medicineModel.sale_price.toString() +
                                        '.00',
                                    style: TextStyle(
                                        fontFamily: AppFont.Gotham,
                                        fontWeight: FontWeight.w700,
                                        fontSize: 18,
                                        color: AppColors.primaryColor),
                                  ),
                                  // Text(
                                  //   '60 Tablets per pack',
                                  //   style: TextStyle(
                                  //       color: Colors.grey[400], fontSize: 13 ),
                                  // ),
                                ],
                                crossAxisAlignment: CrossAxisAlignment.start,
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: Column(
                                children: [
                                  Text(
                                    'QUANTITY',
                                    style: TextStyle(
                                        fontFamily: AppFont.Gotham,
                                        fontWeight: FontWeight.w700,
                                        color: AppColors.headingColor),
                                  ),
                                  SizedBox(height: 7),
                                  incDecBtn()
                                ],
                                crossAxisAlignment: CrossAxisAlignment.start,
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),


                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 40),
                    child: medicineModel.is_prescribed == 0
                        ? _primaryBtn(btnText: 'Add to Cart')
                        : _primaryBtn(btnText: 'Upload Prescription'),
                  )
                ],
              ),
            ),
    );
  }

  Widget _primaryBtn({String btnText}) {
    return GestureDetector(
      onTap: () {
        if (btnText == 'Add to Cart') {
          addToCard();
        } else {
          // todo handle prescription
        }
      },
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.buttonColor,
          borderRadius: BorderRadius.all(Radius.circular(5.0)),
        ),
        alignment: Alignment.center,
        padding: EdgeInsets.symmetric(vertical: 15),
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

  Row incDecBtn() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(40),
                  bottomLeft: Radius.circular(40)),
              border: Border.all(
                  width: 1,
                  color: AppColors.primaryColor,
                  style: BorderStyle.solid)),
          child: IconButton(
            padding: EdgeInsets.zero,
            splashColor: AppColors.primaryColor,
            icon: Icon(
              Icons.remove,
              size: 10,
              color: AppColors.primaryColor,
            ),
            onPressed: () {
              _decrementQty();
            },
          ),
          width: 24,
          height: 24,
        ),
        Container(
          // padding: EdgeInsets.all(15),
          decoration: BoxDecoration(
              border: Border.symmetric(
            horizontal: BorderSide(
                width: 1,
                color: AppColors.primaryColor,
                style: BorderStyle.solid),
          )),
          child: Center(
              child: Text(
            medicineModel.cart_count == 0
                ? _productQty.toString()
                : medicineModel.cart_count.toString(),
            style: TextStyle(fontSize: 12),
          )),

          width: 24,
          height: 24,
        ),
        Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                  topRight: Radius.circular(40),
                  bottomRight: Radius.circular(40)),
              border: Border.all(
                  width: 1,
                  color: AppColors.primaryColor,
                  style: BorderStyle.solid)),
          child: IconButton(
            padding: EdgeInsets.zero,
            splashColor: AppColors.primaryColor,
            icon: Icon(
              Icons.add,
              size: 12,
              color: AppColors.primaryColor,
            ),
            onPressed: () {
              _incrementQty();
            },
          ),
          width: 24,
          height: 24,
        ),
      ],
    );
  }

  void _decrementQty() {
    if (_productQty > 0) {
      _productQty = _productQty - 1;
      setState(() {});
    }
  }

  //
  void _incrementQty() {
    _productQty = _productQty + 1;
    setState(() {});
  }

  Future<void> addToCard() async {
    var cartServices = CartServices();
    // todo change device token
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString(SharedPreVariables.TOKEN);

    print(token);
    APIResponse response = await cartServices.addToCart(
        token: token,
        store_id: medicineModel.store_id,
        medicine_id: medicineModel.id,
        quantity: _productQty);
    if (response != null) {
      if (response.status == '1') {
        // Get.snackbar('', response.message);
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

  getMedicine({int id}) async {
    var homeServices = HomeServices();
    // todo change device token
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString(SharedPreVariables.TOKEN);

    APIResponse response =
        await homeServices.medicineDetail(token: token, medicine_id: id);
    if (response != null) {
      if (response.status == '1') {
        medicineModel = MedicineModel.fromMap(response.data);
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
}
