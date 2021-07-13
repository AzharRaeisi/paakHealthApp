import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:paakhealth/models/api_response.dart';
import 'package:paakhealth/models/wallet_history_model.dart';
import 'package:paakhealth/services/account_services.dart';
import 'package:paakhealth/util/colors.dart';
import 'package:paakhealth/util/prefernces.dart';
import 'package:paakhealth/util/text_style.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:date_format/date_format.dart';

class WalletScreen extends StatefulWidget {
  const WalletScreen({Key key}) : super(key: key);

  @override
  _WalletScreenState createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {
  var logger = Logger();
  int walletAmount = 0;

  List<WalletHistoryModel> history = [];


  @override
  void initState() {
    // TODO: implement initState
    getWallet();
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
            Navigator.of(context).pop();
          },
        ),
        iconTheme: IconThemeData(color: AppColors.primaryColor),
        title: Text(
          'My Wallet',
          style: AppTextStyle.appTextStyle,
        ),
        centerTitle: true,
        elevation: 2,
        backgroundColor: Colors.white,
      ),
      body: Container(
        padding: EdgeInsets.all(10),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                height: MediaQuery.of(context).size.height * 0.2,
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                        colors: [
                      Colors.lightBlueAccent[100],
                      AppColors.primaryColor,
                      Colors.blue[400],
                      Colors.blue[500],
                    ])),
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Current Balance',
                                style: TextStyle(
                                    fontWeight: FontWeight.w300,
                                    fontSize: 12.0,
                                    color: Colors.white)),
                            Text(
                              'Rs ' + walletAmount.toString(),
                              style: TextStyle(
                                  fontSize: 38.0,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white),
                            )
                          ]),
                      Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          padding:
                              EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                          child: Text('ADD CASH',
                              style: TextStyle(
                                  color: Colors.blue,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 12))),
                    ]),
              ),
              SizedBox(
                height: 20,
              ),
              Text('Transaction History',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryColor,
                  )),
              SizedBox(
                height: 10,
              ),
              history.length == 0
                  ? Text(
                      ' No details available',
                      style: TextStyle(fontSize: 12),
                    )
                  : Container(),
              history.length != 0
                  ? DataTable(
                      showBottomBorder: true,
                      // headingTextStyle: TextStyle(
                      //     fontSize: 14,
                      //     fontWeight: FontWeight.bold,
                      //     color: Colors.black
                      // ),
                      columns: [
                        DataColumn(
                            label: Text(
                          'Date',
                          style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              color: Colors.black),
                        )),
                        DataColumn(
                            label: Text(
                          'Dr',
                          style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              color: Colors.black),
                        )),
                        DataColumn(
                            label: Text(
                          'Cr',
                          style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              color: Colors.black),
                        )),
                      ],
                      rows: history
                          .map((model) => DataRow(cells: [
                                DataCell(Text(
                                  formatDate( DateTime.parse(model.transaction_date), [d, ' ', M, ' ', yyyy]),
                                  style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.black38),
                                )),
                                DataCell(Text(
                                  model.transaction_type == 2
                                      ? model.add_deduct_amount.toString()
                                      : '',
                                  style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.black54),
                                )),
                                DataCell(Text(
                                  model.transaction_type == 1
                                      ? model.add_deduct_amount.toString()
                                      : '',
                                  style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w700,
                                      color: AppColors.primaryColor),
                                )),
                              ]))
                          .toList(),
                    )
                  : Container(),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> getWallet() async {
    history = [];
    var accountServices = AccountServices();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString(SharedPreVariables.TOKEN);

    APIResponse response = await accountServices.getWallet(token: token, from_date: '', to_date: '');
    if (response != null) {
      if (response.status == '1') {
        logger.i(response.message);
        // print('response.data');

        Iterable iterable = response.list;
        history =
            iterable.map((list) => WalletHistoryModel.fromMap(list)).toList();
        // print('cartItemList.length');
        // print(orders.length);

        walletAmount = response.wallet_amount;

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
