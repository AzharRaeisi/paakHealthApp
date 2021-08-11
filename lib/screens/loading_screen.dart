import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:logger/logger.dart';
import 'package:paakhealth/screens/home/landing_screen.dart';
import 'package:paakhealth/screens/auth/login_screen.dart';
import 'package:paakhealth/util/colors.dart';
import 'package:paakhealth/util/prefernces.dart';
import 'package:paakhealth/widgets/toast/toast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:get/get.dart';
class LoadingScreen extends StatefulWidget {
  const LoadingScreen({Key key}) : super(key: key);

  @override
  _LoadingScreenState createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  var logger = new Logger();
  String _debugLabelString = '';

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/splash.png"),
          fit: BoxFit.fill,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: Container(
            width: double.infinity,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  margin: EdgeInsets.only(bottom: 110),
                  child: Center(
                    child: SpinKitWave(
                      color: AppColors.primaryColor,
                      size: 50.0,
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    // initOneSignal();
    checkLoginStatus();
    super.initState();

  }

  Future<void> checkLoginStatus() async {
    // todo make a delay
    await Future.delayed(Duration(seconds: 3));
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String token = preferences.getString(SharedPreVariables.TOKEN);
    String expiryDateTimeString =
    preferences.get(SharedPreVariables.EXPRIRY_DATE);
    DateTime today = DateTime.now();
    DateTime expiryDateTime;
    if (expiryDateTimeString != null) {
      expiryDateTime = DateTime.parse(expiryDateTimeString);
    }
    // logger.i(expiryDateTime);
    // logger.i(today);

    if (token != null) {
      if (token.isNotEmpty && today.isBefore(expiryDateTime)) {
        logger.i(token);
        Get.off(() => HomeScreen());
        // Navigator.pushReplacement(
        //     context, MaterialPageRoute(builder: (context) => HomeScreen()));
      } else {
        // ScaffoldMessenger.of(context).showSnackBar(
        //     SnackBar(content: Text('Your Token Expired, please Login Again')));
        // Navigator.pushReplacement(
        //     context, MaterialPageRoute(builder: (context) => WelcomeBackScreen()));
        ShowMessage.message(message: 'Your Token Expired, please Login Again');
        Get.off(() => LoginScreen());
      }
    } else {
      // Navigator.pushReplacement(
      //     context, MaterialPageRoute(builder: (context) => WelcomeScreen()));
      Get.off(() => LoginScreen());
    }
  }

  // Future<void> initOneSignal() async {
  //   await OneSignal.shared.init('4175ccac-b26f-4be2-9749-bb0cc5836b9a');
  //
  //   var status = await OneSignal.shared.getPermissionSubscriptionState();
  //
  //   var playerId = status.subscriptionStatus.userId;
  //
  //   // setPlayerID(playerId);
  //   logger.i(playerId);
  //
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   var ply = await prefs.setString(SharedPreVariables.PLAYER_ID, playerId);
  //
  //   OneSignal.shared
  //       .setInFocusDisplayType(OSNotificationDisplayType.notification);
  //
  //   OneSignal.shared
  //       .setNotificationReceivedHandler((OSNotification notification) {
  //     this.setState(() {
  //       _debugLabelString =
  //       "Received notification: \n${notification.jsonRepresentation().replaceAll("\\n", "\n")}";
  //     });
  //   });
  //
  //   OneSignal.shared
  //       .setNotificationOpenedHandler((OSNotificationOpenedResult result) {
  //     this.setState(() {
  //       _debugLabelString =
  //       "Opened notification: \n${result.notification.jsonRepresentation().replaceAll("\\n", "\n")}";
  //     });
  //   });
  //
  //   checkLoginStatus();
  // }
  //
  // Future<void> setPlayerID(String playerId) async {
  //   var notificationServices = NotificationServices();
  //   APIResponse response =
  //   await notificationServices.sendPlayID(player_id: playerId);
  //   if (response != null) {
  //     if (response.status == '1') {
  //       // ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(response.message + ': setting things ready for you')));
  //
  //       // _setData(response.data);
  //     } else {
  //       // _showError(response.message);
  //     }
  //   } else {
  //     logger.i('API response is null');
  //     // _showError('Oops! Server is Down');
  //   }
  // }
}
