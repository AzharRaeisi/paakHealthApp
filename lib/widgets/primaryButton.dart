import 'package:flutter/material.dart';
import 'package:paakhealth/util/colors.dart';
import 'package:paakhealth/util/font.dart';

class AppPrimaryButton extends StatelessWidget {
  final String text;

  const AppPrimaryButton({Key key, @required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.primaryColor,
        borderRadius: BorderRadius.all(Radius.circular(5.0)),
      ),
      alignment: Alignment.center,
      padding: EdgeInsets.symmetric(vertical: 15),
      child: Text(
        text,
        style: TextStyle(
            fontFamily: AppFont.Gotham,
            fontWeight: FontWeight.w500,
            color: Colors.white, fontSize: 18),
        textAlign: TextAlign.center,
      ),
    );
  }
}
