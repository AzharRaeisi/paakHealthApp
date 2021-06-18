import 'package:flutter/material.dart';
class Messages{


  static void _showMsg({String message, BuildContext context}) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }
}