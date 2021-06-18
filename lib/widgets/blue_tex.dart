import 'package:flutter/material.dart';
import 'package:paakhealth/util/colors.dart';

class BlueText extends StatelessWidget {
  final String text;

  const BlueText({Key key, this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        color: AppColors.primaryColor,
        fontWeight: FontWeight.w700,
        fontSize: 18
      ),
    );
  }
}
